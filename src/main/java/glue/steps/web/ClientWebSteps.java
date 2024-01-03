package glue.steps.web;

import annotations.Frame;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.google.common.util.concurrent.Uninterruptibles;
import com.google.inject.Inject;
import common.glue.steps.api.ClientSteps;
import common.glue.steps.web.pages.clientweb.TwoFactorAuthenticationWebPage;
import common.glue.utilities.Constants;
import common.glue.utilities.GeneralActions;
import common.glue.utilities.Jwt;
import entity.Provider;
import entity.User;
import enums.*;
import enums.data.MessageType;
import extensions.ClientExtension;
import extensions.ResponseExtension;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.vavr.control.Try;
import jakarta.inject.Named;
import lombok.experimental.ExtensionMethod;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.hc.core5.http.HttpStatus;
import org.awaitility.Awaitility;
import org.openqa.selenium.InvalidArgumentException;
import org.openqa.selenium.NotFoundException;
import org.openqa.selenium.devtools.v120.network.model.Response;
import org.openqa.selenium.devtools.v120.network.model.ResponseReceived;
import org.openqa.selenium.html5.WebStorage;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.io.IOException;
import java.net.URISyntaxException;
import java.net.http.HttpResponse;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.time.Duration;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.concurrent.Callable;
import java.util.stream.Stream;

import static enums.FrameTitle.DEFAULT;
import static enums.data.MessageType.*;
import static org.assertj.core.api.Assertions.assertThat;
import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;
import static org.openqa.selenium.support.ui.ExpectedConditions.visibilityOf;

@ExtensionMethod({ClientExtension.class, ResponseExtension.class})
public class ClientWebSteps extends Step {
    @Inject
    @Named("jwt_dev")
    private String devJwt;
    @Inject
    @Named("jwt_canary")
    private String canaryJwt;

    /**
     * This step validates the {@link Provider} in the room.
     * Calling {@link ClientSteps#getRoomsInfoOfUser(User)} first to update the room list with the therapists' type.
     */
    @When("{provider} is the provider in the {optionIndex} room for {user} user")
    public void verifyRoomTherapist(Provider provider, int roomIndex, User user) throws IOException, URISyntaxException {
        clientSteps.getRoomsInfoOfUser(user);
        assertThat(user.getRoomsList().get(roomIndex).getProvider().getId())
                .as("therapist id in room index '%d'", roomIndex)
                .isEqualTo(provider.getId());
    }

    /**
     * This step validates the {@link Provider} is not the room provider.
     * Calling {@link ClientSteps#getRoomsInfoOfUser(User)} first to update the rooms list with the therapists' type.
     */
    @When("{provider} is not the provider in the {optionIndex} room for {user} user")
    public void verifyRoomTherapistChanged(Provider provider, int roomIndex, User user) throws IOException, URISyntaxException {
        clientSteps.getRoomsInfoOfUser(user);
        assertThat(user.getRoomsList().get(roomIndex).getProvider().getId())
                .as("therapist id in room index '%d'", roomIndex)
                .isNotEqualTo(provider.getId());
    }

    @And("Send the following messages as {provider} provider to {user} user in the {optionIndex} room and verify they are present in chat")
    public void sendTheFollowingMessagesAsCtTherapistToPrimaryUserInTheFirstRoomAndVerifyTheyArePresentInChat(Provider provider, User user, int roomIndex, List<ChatMessageType> chatMessageTypeList) throws URISyntaxException {
        for (var chatMessageType : chatMessageTypeList) {
            therapistSteps.apiSendMessageAsTherapist(1, chatMessageType, provider, user, roomIndex);
            roomPage.messageIsInChat();
        }
    }

    /**
     * this step is on the web module because it uses the web driver to retrieve the current room id.
     *
     * @param user      the {@link User} that has chat messages.
     * @param roomIndex the room index in a room list.
     * @throws IOException        if an I/O error occurs
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @And("Client API - Star all room messages of {user} user in the {optionIndex} room")
    public void apiStarAllRoomMessages(User user, int roomIndex) throws IOException, URISyntaxException {
        var allowedMessages = Stream.of(PDF, AUDIO, PHOTO, VIDEO, TEXT)
                .map(MessageType::getType)
                .toList();
        clientSteps.getRoomsInfoOfUser(user);
        var chatMessageResponse = clientSteps.getChatMessages(user, user.getRoomsList().get(roomIndex).getId()).log();
        var chatMessages = objectMapper.readTree(chatMessageResponse.body()).findValue("messages");
        for (var chatMessage : chatMessages) {
            var messageType = chatMessage.get("message_type").intValue();
            var isStarred = chatMessage.get("is_starred").intValue() == 1;
            if (!isStarred && allowedMessages.contains(messageType)) {
                var chatMessageId = chatMessage.get("message_id").intValue();
                var response = clientSteps.starMessage(chatMessageId, user).log();
                assertThat(response)
                        .extracting(HttpResponse::statusCode)
                        .as("Star Message")
                        .withFailMessage(GeneralActions.failMessage(response))
                        .isEqualTo(HttpStatus.SC_CREATED);
            }
        }
    }

    /**
     * access token is regularly stored on session storage,
     * in case login with remember me it is stored on local storage.
     *
     * @return do access token exists?
     */
    private Callable<Boolean> accessTokenExists() {
        return () ->
                ((WebStorage) driver).getSessionStorage().keySet().contains(Constants.ACCESS_TOKEN) || ((WebStorage) driver).getLocalStorage().keySet().contains(Constants.ACCESS_TOKEN);
    }

    /**
     * updating the {@link User} credentials.
     *
     * <p>
     * <ul>
     *     <li>  setting the access token from session storage.
     *     <li>  setting the {@link User} id from session storage in case it is empty.
     *   </ul>
     *
     * @param user the {@link User} whose credentials will be updated.
     * @throws JsonProcessingException if an error occurs while processing the JSON.
     */
    @And("Update {user} user credentials")
    public void setUserCredentials(User user) throws JsonProcessingException {
        Awaitility.await()
                .alias("access token exists")
                .atMost(Duration.ofMinutes(1))
                .until(accessTokenExists());
        // First, we're trying to get the access token from Session Storage
        Optional.ofNullable(((WebStorage) driver).getSessionStorage().getItem(Constants.ACCESS_TOKEN))
                .ifPresentOrElse(user::setLoginToken, () ->
                        //If the access token is not present in Session Storage, we try to get it from Local Storage,
                        // this is not mandatory because there can be a case we are completely logged out.
                        Optional.ofNullable(((WebStorage) driver).getLocalStorage().getItem(Constants.ACCESS_TOKEN))
                                .ifPresent(user::setLoginToken));
        if (user.getId() == null) {
            user.setId(objectMapper.readTree(((WebStorage) driver).getSessionStorage().getItem("userData"))
                    .at("/id")
                    .asInt());
        }
    }

    /**
     * <strong>this steps is only used for login purposes.</strong>
     * <p>
     * we are logging in to the user via API to get the login token to query the 2fa status, this triggers an OTP.
     * in case the user login is empty we retrieve it - this could happen after password update.
     * getting the 2fa status - it could possibly be changed between each new login.
     *
     * @param rememberMe should we check remember me checkbox?
     * @param user       in case the user is primary/partner, the values are taken from scenarioContext.
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2611">disable intro video experiment </a>
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2619">Ignore 10 min intro experiment</a>
     */
    @And("Log in with {user} user, remember me {}")
    public void logInWith(User user, boolean rememberMe) throws IOException, URISyntaxException {
        ((WebStorage) driver).getSessionStorage().setItem("ignore-experiments", BooleanUtils.TRUE);
        wait.until(visibilityOf(loginWebPage.getInputEmail())).sendKeys(user.getEmail());
        loginWebPage.getInputPassword().sendKeys(user.getPassword());
        if (rememberMe) {
            loginWebPage.getRememberMeCheckbox().click();
        }
        wait.until(elementToBeClickable(loginWebPage.getLoginInButton())).click();
        wait.until(ExpectedConditions.invisibilityOf(loginWebPage.getLoginInButton()));
        clientSteps.apiLoginToUser(user);
    }

    /**
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2660"> CLIENT-WEB - direct signup URL should trigger /entrypoint call</a>
     */
    @And("Client Web - Entrypoint response is 200")
    public void verifyEntrypoint() {
        var entrypoint = scenarioContext.getTalkspaceApiResponses()
                .stream()
                .filter(responseReceived -> responseReceived
                        .getResponse()
                        .getUrl()
                        .contains("entrypoint"))
                .findFirst()
                .orElseThrow(() -> new NotFoundException("entrypoint not found"));
        assertThat(entrypoint)
                .extracting(ResponseReceived::getResponse)
                .extracting(Response::getStatus)
                .isEqualTo(HttpStatus.SC_OK);
    }

    /**
     * Verifying the specified user's email address by generating and browsing to the verification link.
     * Will use <a href="https://www.mailinator.com/">mailintor</a> instead when running on production.
     * On success:
     * <ul>
     *    <li> setting the application under test - for iframe handling.
     *    <li>  in case the user has a user id we will skip the api login that fetches the user id (in email edit scenario / create room via API).
     *    <li> disable intro video experiment.
     *    <li> calling {@link TwoFactorAuthenticationWebPage#twoFactorAuthenticationClickOnRemindLaterButton()} to skip 2fa status is not "off/required" if skip2fa is true.
     *  </ul>
     *
     * @param user          the user that will be verified.
     * @param twoFactorData two-factor authentication data.
     * @throws IOException              if an I/O error occurs
     * @throws NoSuchAlgorithmException if the specified algorithm is not available.
     * @throws InvalidKeyException      if the given key is inappropriate for initializing this cipher.
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2611">disable intro video experiment </a>
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2619">Ignore 10 min intro experiment</a>
     */
    @When("Browse to the email verification link for {user} user and")
    public void browseToEmailVerificationLinkForUser(User user, Map<String, String> twoFactorData) throws
            IOException, NoSuchAlgorithmException, InvalidKeyException, URISyntaxException {
        browseToEmailVerificationLinkForUser(user);
        signTwoFactorAuthenticationForUser(user, twoFactorData);
    }

    /**
     * @param twoFactorData two-factor authentication data.
     * @param user          the user that will be verified.
     */
    @When("Sign two factor authentication for {user} user and")
    public void signTwoFactorAuthenticationForUser(User user, Map<String, String> twoFactorData) throws JsonProcessingException {
        handleTwoFactorAuthentication(user, twoFactorData);
    }

    /**
     * calls internally to {@link ClientSteps#loginWithClient(User)} to retrieve the userID
     * which is required for JWT token generation.
     * this is needed when the room is created via the UI - for example, therapist slug / QM.
     * <p>
     * On success:
     * <ul>
     *    <li> set the user credentials and get the 2fa status.
     *    <li> set private feature flags status
     *  </ul>
     *
     * @param user the {@link User} that was created.
     * @throws JsonProcessingException  if an error occurs while processing the JSON.
     * @throws NoSuchAlgorithmException if the specified algorithm is not available.
     * @throws InvalidKeyException      if the given key is inappropriate for initializing this cipher.
     */
    @When("Browse to the email verification link for {user} user")
    public void browseToEmailVerificationLinkForUser(User user) throws NoSuchAlgorithmException, InvalidKeyException, IOException, URISyntaxException {
        if (Objects.isNull(user.getId())) {
            var loginResponse = Awaitility.await()
                    .alias("login successfully via API for user")
                    .atMost(Duration.ofMinutes(2))
                    .pollInterval(Duration.ofSeconds(10))
                    .ignoreExceptions()
                    .failFast("Received unauthorized response - previous steps failed ", () -> clientSteps.loginWithClient(user).statusCode() == HttpStatus.SC_UNAUTHORIZED)
                    .until(() -> clientSteps.loginWithClient(user), response -> {
                        response.log();
                        return response.statusCode() == HttpStatus.SC_OK;
                    });
            user.setId(objectMapper.readTree(loginResponse.body())
                    .at("/data/userID")
                    .asInt());
        }
        if (!GeneralActions.isRunningOnProd()) {
            var jwtToken = Jwt.generateJsonWebToken(user, data.getConfiguration().getDomain().equals(Domain.CANARY.getName()) ? canaryJwt : devJwt);
            Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(5));
            driver.get("https://app.%s.talkspace.com/email-verification#verificationCode=%s".formatted(data.getConfiguration().getDomain(), jwtToken));
        } else {
            mailinatorApiSteps.clickOnGetStartedInsideEmail(user);
        }
        ((WebStorage) driver).getSessionStorage().setItem("ignore-experiments", BooleanUtils.TRUE);
        scenarioContext.setApplicationUnderTest(ApplicationUnderTest.CLIENT_WEB);
        setUserCredentials(user);
        clientSteps.apiGetTwoFactorStatus(user);
        clientSteps.talkspaceAPIGetActiveFeatureFlagsForUser(user);
    }

    /**
     * On success:
     * <ul>
     *    <li> set the user credentials and get the 2fa status.
     *    <li> set private feature flags status
     *  </ul>
     *
     * @param user     in case the user is primary/partner, the values are taken from scenarioContext.
     * @param userData two-factor authentication data + should we check remember me checkbox?
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2611">disable intro video experiment </a>
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2619">Ignore 10 min intro experiment</a>
     */
    @And("Log in with {user} user and")
    public void logInWith(User user, Map<String, String> userData) throws IOException, URISyntaxException {
        logInWith(user, BooleanUtils.toBoolean(userData.get("remember me")));
        handleTwoFactorAuthentication(user, userData);
        if (scenarioContext.getPrivateFeatureFlagTypeMap().isEmpty()) {
            clientSteps.talkspaceAPIGetActiveFeatureFlagsForUser(user);
        }
    }

    /**
     * admin feature flags:
     * <ul>
     *    <li> client_2fa_enabled=1 (ON).
     *    <li> skip_2fa=1 (see validFrom json) -> see validFrom date (for existing customer).
     *  </ul>
     * <p>
     * waiting for access token on the end is used to avoid target frame detached chromedriver errors.
     * in case 2fa is activated for existing users we will enter the 2fa details.
     * in case it is not, then it will force him to activate 2FA (regardless if required or suggested).
     * 2fa status can be suggested for newly created users - It might change.
     * <strong>email verification does not create bypass token</strong>
     *
     * @param user          the user that will be verified.
     * @param twoFactorData two-factor authentication data.
     */
    private void handleTwoFactorAuthentication(User user, Map<String, String> twoFactorData) throws JsonProcessingException {
        if (!user.getTwoFactorStatusType().equals(TwoFactorStatusType.OFF)) {
            if (twoFactorData.containsKey("2fa activated")) {
                // returning user while the 2fa is mandatory.
                if (BooleanUtils.toBoolean(twoFactorData.get("2fa activated")) && user.getTwoFactorStatusType().equals(TwoFactorStatusType.ON) && StringUtils.isBlank(((WebStorage) driver).getSessionStorage().getItem("bypass_two_factor_token"))) {
                    sendTwoFactorCode(user);
                    // returning existing user while the 2fa is not mandatory.
                } else if (!BooleanUtils.toBoolean(twoFactorData.get("2fa activated")) && BooleanUtils.toBoolean(twoFactorData.get("skip 2fa")) && user.getTwoFactorStatusType().equals(TwoFactorStatusType.SUGGESTED)) {
                    twoFactorAuthenticationWebPage.twoFactorAuthenticationClickOnRemindLaterButton();
                }
                // returning new user while the 2fa is not mandatory.
                else if (user.getTwoFactorStatusType().equals(TwoFactorStatusType.SUGGESTED)) {
                    twoFactorAuthenticationWebPage.twoFactorAuthenticationClickOnRemindLaterButton();
                } else {
                    throw new RuntimeException("unknown state - probably need to add this to automation");
                }
            } else {
                // new user while the 2fa is mandatory or suggested.
                if (user.getTwoFactorStatusType().equals(TwoFactorStatusType.REQUIRED) || user.getTwoFactorStatusType().equals(TwoFactorStatusType.SUGGESTED)) {
                    if (BooleanUtils.toBoolean(twoFactorData.get("phone number"))) {
                        twoFactorAuthenticationWebPage.enterPhoneNumber(user);
                    }
                    twoFactorAuthenticationWebPage.twoFactorClickOnContinueButton();
                    sendTwoFactorCode(user);
                    // new user with 2fa status - "ON" this is not possible.
                } else if (user.getTwoFactorStatusType().equals(TwoFactorStatusType.ON)) {
                    throw new RuntimeException("2fa status can not be on after email verification");
                }
            }
        }
        setUserCredentials(user);
    }

    /**
     * in case the user is from <a href="https://www.mailinator.com/">mailintor</a> domain (private or public) any two-factor authentication code will work.
     * in case the user is from another domain (<a href="https://maildrop.cc/">maildrop</a> for example) we will check for a real verification code.
     *
     * @param user the {@link User} that will receive the two-factor code
     */
    @Then("2FA - Send verification code of {user} user")
    public void sendTwoFactorCode(User user) {
        if (!user.getTwoFactorStatusType().equals(TwoFactorStatusType.OFF)) {
            var twoFactorCodeDigits = wait.until(ExpectedConditions.visibilityOfAllElements(twoFactorAuthenticationWebPage.getVerificationCodeInput()));
            if (StringUtils.containsAny(user.getEmail(), "mailinator", "m8r")) {
                Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(2));
                twoFactorCodeDigits.forEach(digit -> digit.sendKeys("1"));
            } else {
                mailinatorApiSteps.getTwoFactorVerificationCodeFromEmail(user);
                for (int i = 0; i < twoFactorCodeDigits.size(); i++) {
                    twoFactorCodeDigits.get(i).sendKeys(Character.toString(user.getOtpCode().charAt(i)));
                }
            }
        }
    }


    @And("2FA - Skip 2FA")
    public void skipTwoFactorAuthentication() {
        twoFactorAuthenticationWebPage.twoFactorAuthenticationClickOnRemindLaterButton();
    }

    /**
     * modality only exists for therapy.<br>
     * inside {@link FrameTitle#DEFAULT} frame
     *
     * @param serviceType   the {@link ServiceType} that is requested (therapy or psychiatry).
     * @param modalityType  the {@link ModalityType} live type that is requested (video, audio, chat).
     * @param planType      the {@link PlanType} in the room - it affect the screens showing in the scheduler modal: BH plans will require extra screen of approving copay payment.
     * @param sessionLength the {@link SessionLength} length of live session (10, 15, 30 45 or 60 mins).
     * @param liveState     the {@link LiveState} in the room - it affects the screens showing in the onboarding scheduler modal: if NO_LIVE_STATE user can choose between Live or Async on first screen)
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2652">CLIENT-WEB - add tests for "meet your provider" screen after every switch to a PT</a>
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2655">CLIENT-WEB - revert the revert of scheduler changes</a>
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2728">CLIENT-WEB - fix tests related to EAP\BH IRS modal</a>
     * @see <a href="https://www.figma.com/file/XRpwiqz4wKDH9TurJtMBwz/Sign-Up-to-Match-(Flow-90-V2)---Q4-2022?node-id=823%3A9866">Sign-Up-to-Match-(Flow-90-V2)</a>
     * @see <a href="https://www.figma.com/file/5tF4kb8IliK9rwXgASMy1p/Collect-1st-session-modality-preference-pre-registration?node-id=0%3A1">session modality preference pre registration</a>
     */
    @Frame(DEFAULT)
    @When("in-room scheduler - Book {} live {} session of {} minutes with {} plan and {} state")
    public void bookLiveSession(ServiceType serviceType, ModalityType modalityType, SessionLength sessionLength, PlanType planType, LiveState liveState) {
        if (LiveState.NON_LIVE.equals(liveState)) {
            roomPage.clickOnBookLiveSessionButton();
        } else if (LiveState.LIVE.equals(liveState)) {
            onboardingWebPage.clickContinueBookFirstSession();
        }
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(2));
        if (serviceType.equals(ServiceType.THERAPY)) {
            switch (modalityType) {
                case MESSAGING -> {
                    roomPage.inRoomSchedulerClickOnContinueButton();
                    Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(1));
                    flowWebPage.clickOnMessagingInformationNextButton();
                    Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(1));
                    flowWebPage.clickOnMessagingInformationNextButton();
                    onboardingWebPage.onboardingClickOnAsyncConfirmSessionButton();
                    if (planType.equals(PlanType.BH_MESSAGING_AND_LIVE) || planType.equals(PlanType.BH_LIVE_ONLY) || planType.equals(PlanType.BH_MESSAGING_ONLY)) {
                        roomPage.clickOnStartSessionNowSessionButton();
                    }
                    return;
                }
                case AUDIO -> roomPage.clickOnAudioModalityRadioButton();
                case LIVE_CHAT -> roomPage.clickOnLiveChatModalityRadioButton();
                case VIDEO -> roomPage.clickOnVideoModalityRadioButton();
                default -> throw new IllegalStateException("Unexpected value: " + modalityType);
            }
            roomPage.inRoomSchedulerClickOnContinueButton();
        }
        if (planType.equals(PlanType.BH_MESSAGING_AND_LIVE) || planType.equals(PlanType.BH_LIVE_ONLY) || planType.equals(PlanType.BH_MESSAGING_ONLY)) {
            switch (serviceType) {
                case THERAPY -> {
                    switch (sessionLength) {
                        case THIRTY -> roomPage.select30MinSessionLength();
                        case FORTY_FIVE -> roomPage.select45MinSessionLength();
                        case SIXTY -> roomPage.select60MinSessionLength();
                        case TEN -> roomPage.select10MinSessionLength();
                        default -> throw new InvalidArgumentException("Unexpected session length: " + sessionLength);
                    }
                    roomPage.inRoomSchedulerClickOnContinueButton();
                    roomPage.clickOnNextAvailableButtonIfPresent();
                    roomPage.inRoomSchedulerClickOnContinueButton();
                    roomPage.clickOnIAgreeButton();
                    roomPage.bookWithPurchase();
                }
                case PSYCHIATRY -> {
                    switch (sessionLength) {
                        case THIRTY -> roomPage.select30MinSessionLength();
                        case FORTY_FIVE -> roomPage.select45MinSessionLength();
                        case SIXTY -> roomPage.select60MinSessionLength();
                        default -> throw new InvalidArgumentException("Unexpected session length: " + sessionLength);
                    }
                    roomPage.inRoomSchedulerClickOnContinueButton();
                    roomPage.clickOnNextAvailableButtonIfPresent();
                    roomPage.inRoomSchedulerClickOnContinueButton();
                    roomPage.clickOnIAgreeButton();
                    roomPage.bookWithPurchase();
                }
                default -> throw new InvalidArgumentException("Unexpected service type: " + serviceType);
            }
        } else {
            switch (serviceType) {
                case THERAPY -> {
                    switch (sessionLength) {
                        case THIRTY -> roomPage.select30MinSessionLength();
                        case FORTY_FIVE -> roomPage.select45MinSessionLength();
                        case SIXTY -> roomPage.select60MinSessionLength();
                        case TEN -> roomPage.select10MinSessionLength();
                        default -> throw new InvalidArgumentException("Unexpected session length: " + sessionLength);
                    }
                    roomPage.inRoomSchedulerClickOnContinueButton();
                    roomPage.clickOnNextAvailableButtonIfPresent();
                    roomPage.inRoomSchedulerClickOnContinueButton();
                    roomPage.clickOnReserveSessionButton();
                }
                case PSYCHIATRY -> {
                    switch (sessionLength) {
                        case THIRTY -> roomPage.select30MinSessionLength();
                        case FORTY_FIVE -> roomPage.select45MinSessionLength();
                        case SIXTY -> roomPage.select60MinSessionLength();
                        default -> throw new InvalidArgumentException("Unexpected session length: " + sessionLength);
                    }
                    roomPage.inRoomSchedulerClickOnContinueButton();
                    roomPage.clickOnNextAvailableButtonIfPresent();
                    roomPage.inRoomSchedulerClickOnContinueButton();
                    roomPage.clickOnReserveSessionButton();
                }
                default -> throw new InvalidArgumentException("Unexpected service type: " + serviceType);
            }
        }
        commonWebPage.profileConfirmationPopupClickOnDoneButton();
    }


    /**
     * @param serviceType    the {@link ServiceType} that is requested.
     * @param modalityType   the {@link ModalityType} type that is requested.
     * @param livePreference the {@link LivePreference} if user selected live as preference during QM or not - if user chose live then the screen of modality will be skipped.
     * @see <a href="https://www.figma.com/file/XRpwiqz4wKDH9TurJtMBwz/Flow-90-%E2%80%93-V2--%7C-Q4-2022?node-id=992%3A16785&t=1Hi3P84X9xhdBwN3-0></a>
     */
    @When("MBA - Book first {} live {} session with {} selection")
    public void bookYourFirstLiveSessionWhileOnboarding(ServiceType serviceType, ModalityType
            modalityType, LivePreference livePreference) {
        if (livePreference.equals(LivePreference.LIVE_PREFERENCE)) {
            switch (serviceType) {
                case THERAPY -> {
                    roomPage.inRoomSchedulerClickOnContinueButton();
                    roomPage.clickOnNextAvailableButtonIfPresent();
                    roomPage.inRoomSchedulerClickOnContinueButton();
                    roomPage.clickOnReserveSessionButton();
                }
                case PSYCHIATRY -> {
                    roomPage.clickOnNextAvailableButtonIfPresent();
                    roomPage.inRoomSchedulerClickOnContinueButton();
                    roomPage.clickOnReserveSessionButton();
                    commonWebPage.profileConfirmationPopupClickOnDoneButton();
                }
                default -> throw new InvalidArgumentException("Unexpected value: " + modalityType);
            }
        } else {
            switch (serviceType) {
                case THERAPY -> {
                    roomPage.inRoomSchedulerClickOnContinueButton();
                    roomPage.inRoomSchedulerClickOnContinueButton();
                    roomPage.clickOnNextAvailableButtonIfPresent();
                    roomPage.inRoomSchedulerClickOnContinueButton();
                    roomPage.clickOnReserveSessionButton();
                }
                case PSYCHIATRY -> {
                    roomPage.inRoomSchedulerClickOnContinueButton();
                    roomPage.clickOnNextAvailableButtonIfPresent();
                    roomPage.inRoomSchedulerClickOnContinueButton();
                    roomPage.clickOnReserveSessionButton();
                }
                default -> throw new InvalidArgumentException("Unexpected value: " + modalityType);
            }
        }
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(2));
    }


    /**
     * @param b2bPlan        the {@link B2bPlan} it affects the screens showing in the onboarding scheduler modal: if plan is B2B_BH then user should approve copay payment.
     * @param livePreference the {@link LivePreference} it affects the screens showing in the onboarding scheduler modal: if MESSAGING_PREFERENCE then user should see only 1 screen of starting the async session.
     */
    @When("Start async messaging session with {} plan and {} selection")
    public void startAsyncMessagingSession(B2bPlan b2bPlan, LivePreference livePreference) {
        if (LivePreference.MESSAGING_PREFERENCE.equals(livePreference)) {
            roomPage.clickOnStartMessagingSessionButton();
            return;
        }
        if (B2bPlan.B2B_EAP.equals(b2bPlan)) {
            roomPage.clickOnStartMessagingSessionButton();
            Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(1));
            flowWebPage.clickOnMessagingInformationNextButton();
            Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(1));
            flowWebPage.clickOnMessagingInformationNextButton();
            onboardingWebPage.onboardingClickOnAsyncConfirmSessionButton();
        } else if (B2bPlan.B2B_BH.equals(b2bPlan)) {
            roomPage.clickOnStartMessagingSessionButton();
            Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(1));
            flowWebPage.clickOnMessagingInformationNextButton();
            Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(1));
            flowWebPage.clickOnMessagingInformationNextButton();
            onboardingWebPage.onboardingClickOnAsyncConfirmSessionButton();
            roomPage.clickOnStartSessionNowSessionButton();
        }
    }


    /**
     * @param serviceType  the {@link ServiceType} that is requested (therapy or psychiatry).
     * @param modalityType the {@link ModalityType} live type that is requested (video, audio, chat).
     * @param liveState    the {@link LiveState} in the room - it affect the screens showing in the onboarding scheduler modal: if NO_LIVE_STATE user can choose between Live or Async on first screen)
     * @see <a href="https://www.figma.com/file/XRpwiqz4wKDH9TurJtMBwz/Sign-Up-to-Match-(Flow-90-V2)---Q4-2022?node-id=823%3A9866">Sign-Up-to-Match-(Flow-90-V2)</a>
     * @see <a href="https://www.figma.com/file/5tF4kb8IliK9rwXgASMy1p/Collect-1st-session-modality-preference-pre-registration?node-id=0%3A1">session modality preference pre registration</a>
     */
    @When("in-room scheduler - Skip book first {} live {} session with {} state")
    public void skipBookYourFirstTherapySessionFromModal(ServiceType serviceType, ModalityType
            modalityType, LiveState liveState) {
        if (LiveState.NON_LIVE.equals(liveState)) {
            roomPage.clickOnBookLiveSessionButton();
        } else if (LiveState.LIVE.equals(liveState)) {
            onboardingWebPage.clickContinueBookFirstSession();
        }
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(2));
        if (serviceType.equals(ServiceType.THERAPY)) {
            switch (modalityType) {
                case AUDIO -> roomPage.clickOnAudioModalityRadioButton();
                case LIVE_CHAT -> roomPage.clickOnLiveChatModalityRadioButton();
                case VIDEO -> roomPage.clickOnVideoModalityRadioButton();
                default -> throw new IllegalStateException("Unexpected value: " + modalityType);
            }
            roomPage.inRoomSchedulerClickOnContinueButton();
        }
        roomPage.inRoomSchedulerClickOnContinueButton();
        roomPage.exitSchedulerForNoAvailability();
    }

    /**
     * this is to select Live modality on QM for Live users
     *
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2769">QM: match based on availability - create step for Live messaging preference</a>
     */
    @When("QM - Select {} as first Live booking modality for {} plan")
    public void selectLiveModalityForFirstBooking(ModalityType modalityType, B2bPlan b2bPlan) {
        if (b2bPlan.equals(B2bPlan.B2B_EAP)) {
            roomPage.clickOnBookLiveSessionButton();
        }
        switch (modalityType) {
            case MESSAGING -> roomPage.clickOnMessagingModalityRadioButton();
            case AUDIO -> roomPage.clickOnAudioModalityRadioButton();
            case LIVE_CHAT -> roomPage.clickOnLiveChatModalityRadioButton();
            case VIDEO -> roomPage.clickOnVideoModalityRadioButton();
            default -> throw new IllegalStateException("Unexpected value: " + modalityType);
        }
        roomPage.inRoomSchedulerClickOnContinueButton();
    }

    /**
     * this is to select Async session on QM for Live+Messaging users
     *
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2768">QM: match based on availability - create step for Live messaging preference</a>
     */
    @When("QM - Select Async messaging as first session")
    public void selectAsyncMessagingForFirstSession() {
        roomPage.clickOnMessagingModalityRadioButton();
        flowWebPage.clickOnSelectModalityContinueButton();
        onboardingWebPage.onboardingClickOnAsyncNextButton();
        onboardingWebPage.onboardingClickOnAsyncConfirmSessionButton();
    }


    /**
     * when booking + purchase when no credit available
     *
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2652">CLIENT-WEB - add tests for "meet your provider" screen after every switch to a PT</a>
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2655">CLIENT-WEB - revert the revert of scheduler changes</a>
     */
    @When("in-room scheduler - Book live session with purchase")
    public void bookLiveSessionWithPurchase() {
        roomPage.inRoomSchedulerClickOnContinueButton();
        roomPage.inRoomSchedulerClickOnContinueButton();
        roomPage.clickOnNextAvailableButtonIfPresent();
        roomPage.inRoomSchedulerClickOnContinueButton();
        roomPage.clickOnReserveSessionButton();
        roomPage.bookWithPurchase();
        commonWebPage.profileConfirmationPopupClickOnDoneButton();
    }

    /**
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2652">CLIENT-WEB - add tests for "meet your provider" screen after every switch to a PT</a>
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2655">CLIENT-WEB - revert the revert of scheduler changes</a>
     */
    @When("in-room scheduler - Reschedule live session with {} plan")
    public void rescheduleLiveSession(PlanType planType) {
        roomPage.clickOnRescheduleSessionRadioButton();
        roomPage.inRoomSchedulerClickOnContinueButton();
        roomPage.clickOnNextAvailableButtonIfPresent();
        roomPage.inRoomSchedulerClickOnContinueButton();
        if (List.of(PlanType.BH_MESSAGING_AND_LIVE, PlanType.BH_LIVE_ONLY, PlanType.BH_MESSAGING_ONLY).contains(planType)) {
            roomPage.clickOnIAgreeButton();
        } else {
            roomPage.clickOnReserveSessionButton();
        }
        commonWebPage.profileConfirmationPopupClickOnDoneButton();
    }

    /**
     * TODO: update after https://talktala.atlassian.net/browse/MEMBER-808
     *
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2652">CLIENT-WEB - add tests for "meet your provider" screen after every switch to a PT</a>
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2655">CLIENT-WEB - revert the revert of scheduler changes</a>
     */
    @When("in-room scheduler - Cancel live session")
    public void cancelLiveSession() {
        roomPage.clickOnCancelSessionRadioButton();
        roomPage.inRoomSchedulerClickOnContinueButton();
        roomPage.inRoomSchedulerClickOnCancelSessionButton();
        commonWebPage.genericQuestionSelectFromList("I can no longer meet at this time");
        roomPage.inRoomSchedulerClickOnCancelSessionButton();
        roomPage.inRoomSchedulerClickOnCancelSessionDoneButton();
    }

    /**
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2805">CLIENT-WEB - add tests to switch provider wizard when cancelling an LVS session</a>
     */
    @When("in-room scheduler - Cancel live session and Switch provider")
    public void cancelLiveSessionAndSwitchProvider() {
        roomPage.clickOnCancelSessionRadioButton();
        roomPage.inRoomSchedulerClickOnContinueButton();
        roomPage.inRoomSchedulerClickOnCancelSessionButton();
        commonWebPage.genericQuestionSelectFromList("I do not think my provider is the right fit");
        roomPage.inRoomSchedulerClickOnCancelSessionButton();
        cancelLiveSessionClickOnSwitchProvider();
        commonWebPage.clickOnBeginButton();
        cancelWebPage.rateTherapistWithStars(2);
        commonWebPage.clickOnNextButton();
        commonWebPage.genericQuestionSelectFromList("I couldn't form a strong connection with my provider");
        commonWebPage.clickOnNextButton();
        commonWebPage.clickOnNextButton();
        if (!driver.findElements(changeTherapistWebPage.getLiveInTheUs()).isEmpty()) {
            driver.findElement(changeTherapistWebPage.getLiveInTheUs()).click();
        }
        commonWebPage.openDropdownAndSelect("Montana");
        commonWebPage.clickOnNextButton();
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(5));
        changeTherapistWebPage.changeTherapistClickOnNoPreferences();
        matchingPage.selectFirstProviderWithoutIframe(1);
        commonWebPage.clickOnConfirmButton();
        flowWebPage.clickOnContinueWithTherapistButton();
    }

    @When("in-room scheduler - Cancel live session - click on switch provider")
    public void cancelLiveSessionClickOnSwitchProvider() {
        wait.until(elementToBeClickable(roomPage.getSwitchProviderButton())).click();
    }

    /**
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2795">CLIENT_WEB - update B2C booking cancelltion tests AND add cancel+re-sched test</a>
     */
    @When("in-room scheduler - Cancel and Reschedule live session with {} plan")
    public void cancelAndRescheduleLiveSession(PlanType planType) {
        roomPage.clickOnCancelSessionRadioButton();
        roomPage.inRoomSchedulerClickOnContinueButton();
        roomPage.inRoomSchedulerClickOnRescheduleSessionButton();
        roomPage.clickOnNextAvailableButtonIfPresent();
        roomPage.inRoomSchedulerClickOnContinueButton();
        if (List.of(PlanType.BH_MESSAGING_AND_LIVE, PlanType.BH_LIVE_ONLY, PlanType.BH_MESSAGING_ONLY).contains(planType)) {
            roomPage.clickOnIAgreeButton();
        }
        roomPage.clickOnReserveSessionButton();
        commonWebPage.profileConfirmationPopupClickOnDoneButton();
    }

    /**
     * this will be skipped when treatment_intake_in_onboarding=0
     * we need this steps for customers that register via API on client-web or created via provider slug to simulate real user behavior.
     * we extract the parent/guardian user from the scenarioContext and use it to fill the parental consent section.
     *
     * @param user the {@link User} user that will register to the room
     */
    @And("Onboarding - Complete treatment intake for {user} user")
    public void onBoardingCompleteTreatmentIntake(User user) throws IOException {
        // clinical information section
        onboardingWebPage.clickContinueButton();
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(5));
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("Good");
        commonWebPage.clickOnNextButton();
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("No");
        commonWebPage.clickOnNextButton();
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("Good");
        commonWebPage.clickOnNextButton();
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("No");
        commonWebPage.clickOnNextButton();
        treatmentIntakePage.previousRelativesMentalHealthIssuesQuestionButton();
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("No");
        commonWebPage.clickOnNextButton();
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("Never");
        commonWebPage.clickOnNextButton();
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("Never");
        commonWebPage.clickOnNextButton();
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("No");
        commonWebPage.clickOnNextButton();
        // Medical Information section
        treatmentIntakePage.skipButtonPreviousRelativesMentalHealthIssuesQuestionButton();
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("No");
        commonWebPage.clickOnNextButton();
        treatmentIntakePage.medicalIntakeMedicationsSecondaryButton();
        treatmentIntakePage.medicalIntakeOtcMedicationsSecondaryButton();
        treatmentIntakePage.medicalIntakePharmacyAddressSecondaryButton();
        treatmentIntakePage.medicalIntakeDrugAllergiesSecondaryButton();
        treatmentIntakePage.medicalIntakeControlledSubstancesSecondaryButton();
        // Emergency contact section
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(2));
        onboardingWebPage.clickContinueButton();
        treatmentIntakePage.treatmentIntakeEmergencyContactEnterFirstName(user);
        treatmentIntakePage.treatmentIntakeEmergencyContactEnterLastName(user);
        commonWebPage.clickOnNextButton();
        treatmentIntakePage.treatmentIntakeEmergencyContactEnterHomeAddress(user);
        commonWebPage.clickOnNextButton();
        treatmentIntakePage.emergencyContactPhoneSecondaryButton();
        treatmentIntakePage.treatmentIntakeEmergencyContactEnterEmergencyContactFullName();
        commonWebPage.clickOnNextButton();
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("Parent");
        commonWebPage.clickOnNextButton();
        commonWebPage.enterPhoneNumber(user);
        commonWebPage.clickOnNextButton();
    }


    /**
     * this will be skipped when treatment_intake_in_onboarding=0
     * we need this steps for customers that register via API on client-web or created via provider slug to simulate real user behavior.
     *
     * @param user                  the {@link User} user that will register to the room
     * @param parentalConsentOption the option for parental consent (parent or guardian)
     */
    @And("Onboarding - Complete treatment intake for teen {user} user with {string} parental consent")
    public void onBoardingCompleteTreatmentIntakeForTeens(User user, String parentalConsentOption) throws IOException {
        var careTaker = data.getUsers().get(parentalConsentOption);
        // Parental consent section
        onboardingWebPage.clickContinueButton();
        if (parentalConsentOption.equals("parent")) {
            treatmentIntakePage.conesnterRadioOptionParent();
        } else if (parentalConsentOption.equals("guardian")) {
            treatmentIntakePage.conesnterRadioOptionGuardian();
        } else {
            throw new InvalidArgumentException("Unexpected parental consent option: " + parentalConsentOption);
        }
        treatmentIntakePage.treatmentIntakeParentalConsentEnterFirstName(careTaker);
        treatmentIntakePage.treatmentIntakeParentalConsentEnterLastName(careTaker);
        treatmentIntakePage.treatmentIntakeParentalConsentEnterEmail(careTaker);
        treatmentIntakePage.treatmentIntakeParentalConsentSendFormButton();
        // Emergency contact section
        treatmentIntakePage.treatmentIntakeTeensContinueDesignateEmergencyContact();
        treatmentIntakePage.treatmentIntakeTeensContinueRelationshipToYou();
        commonWebPage.enterPhoneNumber(user);
        treatmentIntakePage.treatmentIntakeTeensContinueContactPhoneNumber();
        treatmentIntakePage.treatmentIntakeEmergencyContactEnterFirstName(user);
        treatmentIntakePage.treatmentIntakeEmergencyContactEnterLastName(user);
        treatmentIntakePage.treatmentIntakeTeensContinueYourFullName();
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("Prefer not to share");
        treatmentIntakePage.treatmentIntakeTeensContinueWhichRace();
        treatmentIntakePage.treatmentIntakeEmergencyContactEnterHomeAddress(user);
        treatmentIntakePage.treatmentIntakeTeensContinueYourAddress();
        treatmentIntakePage.emergencyContactPhoneSecondaryButton();
        onboardingWebPage.clickContinueButton();
        // mental health section
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("No");
        treatmentIntakePage.treatmentIntakeTeensNextHospitalizedQuestionButton();
        treatmentIntakePage.treatmentIntakeTeensSkipTeensPreviousRelativesMentalHealthIssuesQuestionButton();
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("Never");
        treatmentIntakePage.treatmentIntakeTeensNextSuicideQuestionButton();
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("Never");
        treatmentIntakePage.treatmentIntakeTeensNextHomocideQuestionButton();
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("No");
        treatmentIntakePage.treatmentIntakeTeensNextExcessiveAngerQuestionButton();
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("No");
        treatmentIntakePage.treatmentIntakeTeensNextTraumaticEventQuestionButton();
        treatmentIntakePage.treatmentIntakeTeensSkipUseSubstancesQuestionButton();
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("Good");
        treatmentIntakePage.treatmentIntakeTeensNextSleepQualityQuestionButton();
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("Bullying");
        treatmentIntakePage.treatmentIntakeTeensContinueSchoolIssuesQuestionButton();
        treatmentIntakePage.treatmentIntakeSelectFromListTheOption("Body image issues");
        treatmentIntakePage.treatmentIntakeTeensContinueSocialMediaIssuesQuestionButton();
    }

    /**
     * inside {@link FrameTitle#DEFAULT} frame
     * the onboarding modal pops up always (regardless if the room is a paying one).
     * this will be skipped when treatment_intake_in_onboarding=0
     * <p>
     *
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2735">CLIENT-WEB - new onboarding modal - dismiss treatment intake on all tests it pops us out of dedicated tests</a>
     * @see <a href="https://talktala.atlassian.net/browse/MEMBER-960">As a TS QA member with a mailinator account, I want the ability to dismiss the treatment intake modal </a>
     */
    @And("Onboarding - Dismiss modal")
    @Frame(DEFAULT)
    public void dismissOnboarding() {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(3));
        Try.run(() -> new WebDriverWait(driver, Duration.ofSeconds(15)).until(elementToBeClickable(onboardingWebPage.getDismissOnboardingButton())).click());
    }

    @When("Ask for alternative live session time with {} plan")
    public void askForAlternativeLiveSessionTime(PlanType planType) {
        if (!List.of(PlanType.B2C_MESSAGING_AND_LIVE, PlanType.B2C_LIVE_ONLY, PlanType.B2C_MESSAGING_ONLY).contains(planType)) {
            roomPage.clickOnVideoModalityRadioButton();
        }
        roomPage.inRoomSchedulerClickOnContinueButton();
        roomPage.inRoomSchedulerClickOnContinueButton();
    }
}
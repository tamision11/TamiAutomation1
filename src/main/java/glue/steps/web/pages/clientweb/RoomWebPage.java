package glue.steps.web.pages.clientweb;

import annotations.Frame;
import com.google.common.util.concurrent.Uninterruptibles;
import common.glue.steps.web.pages.WebPage;
import common.glue.utilities.GeneralActions;
import dev.failsafe.Failsafe;
import dev.failsafe.RetryPolicy;
import enums.ChatMessageType;
import enums.ServiceType;
import enums.UserEmailType;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.vavr.control.Try;
import lombok.Getter;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.SystemUtils;
import org.assertj.core.api.Assumptions;
import org.awaitility.Awaitility;
import org.openqa.selenium.*;
import org.openqa.selenium.interactions.WheelInput;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;

import java.nio.file.Paths;
import java.time.Duration;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

import static enums.ChatMessageType.COPY_PASTED_MESSAGE;
import static enums.ChatMessageType.TOO_LONG;
import static enums.FrameTitle.DEFAULT;
import static org.apache.commons.lang3.SystemUtils.USER_DIR;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.openqa.selenium.support.ui.ExpectedConditions.*;

/**
 * Created by emanuela.biro on 3/27/2019.
 * Generic elements for the room
 */
@Getter
public class RoomWebPage extends WebPage {

    // region elements without data-qa
    private final By providerDetailsPanel = By.cssSelector("#ID_PROVIDER_DETAILS_PANEL");
    @FindBy(css = "div[aria-label='Account Menu']")
    private WebElement buttonAccountMenu;
    @FindBy(css = "input#react-switch-new-highContrast + div")
    private WebElement highContrastButton;
    @FindBy(xpath = "//button[contains(text(), 'Revoke Invitation')]")
    private WebElement revokeInvitationButton;
    @FindBy(xpath = "//button[contains(text(), 'Invite Partner')]")
    private WebElement invitePartnerButton;
    @FindBy(xpath = "//*[name()='title' and contains(text(), '3 dots')]/parent::*/parent::div")
    private WebElement buttonEditBooking;
    @FindBy(xpath = "//p[contains(text(), 'Book session')]/parent::button")
    private WebElement buttonBookSessionPurchase;
    @FindBy(xpath = "//p[contains(text(), 'Next available')]/parent::button")
    private WebElement buttonNextAvailable;
    @FindBy(xpath = "//button[contains(text(), 'Got it')]")
    private WebElement buttonGotIt;
    @FindBy(css = "#ID_CHAT_INPUT")
    private WebElement inputMessage;
    @FindBy(css = "div#ID_NEWEST_MESSAGE")
    private WebElement lastChatMessage;
    @FindBy(xpath = "//div/div/p[contains(text(),'Send')]")
    private WebElement buttonSendMessage;
    @FindBy(xpath = "//*[name()='svg' and @aria-label='stop recording']")
    private WebElement buttonStopRecord;
    @FindBy(css = "div[role=button][aria-label=cancel]")
    private WebElement deleteRecordedMessage;
    @FindBy(xpath = "//div[@role='button']/*[name()='svg' and @aria-label='play' or @aria-label='pause']")
    private WebElement playPauseRecordedMessage;
    @FindBy(xpath = "//p[contains(text(),'Maximum length exceeded')]")
    private WebElement errorMaxLength;
    @FindBy(css = "[data-qa=newMessageAlert]")
    private WebElement newMessageButton;
    @FindBy(xpath = "//button[contains(text(), 'Privacy Preferences')]")
    private WebElement buttonPrivacyPreferences;
    @FindBy(xpath = "//div[@role='button']/following-sibling::div/parent::div")
    private WebElement recordedMessage;
    @FindBy(xpath = "//div[@role='button']/following-sibling::div/div/p")
    private List<WebElement> elements;
    @FindBy(css = "[aria-label=play]")
    private WebElement playButton;
    @FindBy(css = "[aria-label=pause]")
    private WebElement pauseButton;
    @FindBy(xpath = "//p[text() = 'Talkspace']")
    private WebElement textElement;
    @FindBy(xpath = "//button[contains(text(), 'Choose your therapist')] | //button[contains(text(), 'Choose your provider')]")
    private List<WebElement> providerButtonList;
    // TODO: Update data-qa after https://talktala.atlassian.net/browse/MEMBER-1629
    @FindBy(css = "#ID_ROOM_DETAILS_BUTTON")
    private WebElement roomDetailsButton;
    @FindBy(css = "[data-qa=panelMyRoomReviewProviderButton]")
    private WebElement reviewYourProviderButton;
    @FindBy(css = "[data-qa=undefinedSubmitButton]")
    private WebElement submitProviderReviewButton;
    // TODO: Update data-qa after https://talktala.atlassian.net/browse/MEMBER-1630
    @FindBy(css = "textarea[placeholder='Leave your review']")
    private WebElement reviewTextBox;
    // TODO: Update data-qa after https://talktala.atlassian.net/browse/MEMBER-1630
    @FindBy(xpath = "//p[contains(text(), 'Thanks for your review')]")
    private WebElement reviewSuccessModal;
    @FindBy(css = "[aria-label='dashboard panel']")
    private WebElement clientDashboard;
    @FindBy(css = "input[placeholder='Enter new email address'], input#email")
    private WebElement inputNewEmail;
    @FindBy(css = "input#confirmEmail, [placeholder='Confirm new email address']")
    private WebElement inputConfirmationNewEmail;
    @FindBy(xpath = "//p[contains(text(),'Go to session room')]")
    private WebElement goToSessionRoomButton;
    @FindBy(xpath = "//p[contains(text(),'Start session now')]")
    private WebElement startSessionNowButton;
    @FindBy(xpath = "//button[contains(text(),'Book a session')]")
    private WebElement BHBookASessionButton;
    @FindBy(css = "a[href^='/eligibility-widget']")
    private WebElement CheckYourEligibilityLink;
    @FindBy(xpath = "//button[contains(text(),'Switch providers')]")
    private WebElement switchProviderButton;
    @FindBy(css = "[aria-label='right arrow']")
    private WebElement schedulerRightArrow;
    @FindBy(css = "div[data-visible=true]  div[role=button][aria-label$='15']")
    private WebElement timeslot;
    @FindBy(xpath = "//p[contains(text(),'Individual Therapy')]")
    private WebElement chooseIndividualTherapyPlanToUpdateButton;
    @FindBy(xpath = "//p[contains(text(),'Psychiatry')]")
    private WebElement choosePsychiatryPlanToUpdateButton;
    @FindBy(xpath = "//p[contains(text(),'Couples')]")
    private WebElement chooseCouplesPlanToUpdateButton;
    //https://talktala.atlassian.net/browse/MEMBER-2349
    @FindBy(xpath = "//p[contains(text(),'30 minute live session')]")
    private WebElement select30MinLiveSession;
    @FindBy(xpath = "//p[contains(text(),'45 minute live session')]")
    private WebElement select45MinLiveSession;
    @FindBy(xpath = "//p[contains(text(),'60 minute live session')]")
    private WebElement select60MinLiveSession;
    @FindBy(xpath = "//p[contains(text(),'10 minute introduction')]")
    private WebElement select10MinLiveSession;
    @FindBy(xpath = "//p[contains(text(),'Insurance coverage expired')]")
    private WebElement insuranceCoverageExpiredTag;
    @FindBy(xpath = "//p[contains(text(),'Room closed')]")
    private WebElement roomClosedTag;
    // TODO: Update data-qa after https://talktala.atlassian.net/browse/MEMBER-1788
    @FindBy(css = "div[role=button]")
    private List<WebElement> roomContainerList;
    // TODO: Update data-qa after https://talktala.atlassian.net/browse/MEMBER-2443
    @FindAll({
            @FindBy(xpath = "//button[contains(text(),'Decline session')]"),
            @FindBy(css = "[data-qa=confirmBookingRecurringClientBookingDecline], [data-qa=checkoutPaymentSummarySecondaryCTA]")
    })
    private WebElement declineSession;
    // TODO: Update data-qa after https://talktala.atlassian.net/browse/MEMBER-2639
    @FindAll({
            @FindBy(xpath = "//*[starts-with(text(),'Confirm or')]"),
            @FindBy(xpath = "//*[starts-with(text(),'Confirm session')]")
    })
    private WebElement confirmSession;
    // TODO: Update data-qa after https://talktala.atlassian.net/browse/MEMBER-2660
    @FindBy(xpath = "//*[starts-with(text(),'Confirm session')]")
    private WebElement confirmSessionsInRoom;
    // TODO: Update data-qa after https://talktala.atlassian.net/browse/MEMBER-2649
    @FindBy(xpath = "//*[contains(text(),'Confirm session')]")
    private List<WebElement> confirmSessionAccountMenu;
    private final By messagingSessionInProgressBanner = By.xpath("//p[contains(text(), 'Messaging Session in progress')]");
    private final By nextLiveSessionBanner = By.xpath("//p[contains(text(), 'session is scheduled for')]");
    private final By youHaveSomePendingTasksBanner = By.xpath("//p[contains(text(), 'pending tasks')]");
    private final By welcomeMessageForCreditStillAvailableonB2CRoom = By.xpath("//p[contains(text(), 'This new room is connected to your updated coverage. This will be where you and your provider continue services after you've finished services in your old room. Before starting services here, please head back to your old room, and use any remaining sessions or credits. The subscription in your old room will cancel automatically after the end of the subscription period. If you need to see any old messages you can find them in your previous room. Both rooms will appear on your dashboard')]");
    private final By welcomeMessageForCreditNotAvailableonB2CRoom = By.xpath("//p[contains(text(), 'This new room is connected to your updated coverage. Use this space to start all new conversations with your provider. The subscription in your old room will automatically cancel after the end of the subscription period. If you need to see any old messages you can find them in your previous room. Both rooms will appear on your dashboard')]");
    private final By welcomeMessageForCreditStillAvailableonB2BRoom = By.xpath("//p[contains(text(), 'Before starting services here, please head back to your old room and use any remaining sessions or credits.')]");
    private final By welcomeMessageForCreditNotAvailableonB2BRoom = By.xpath("//p[contains(text(), 'Use this space to start all new conversations with your provider. If you need to see any old')]");
    private final By welcomeMessageForOldRoomlAvailable = By.xpath("//p[contains(text(), 'You recently updated your coverage')]");
    private final By systemMessageForClosedDueToInsuranceUpdateRoomlAvailable = By.xpath("//p[contains(text(), 'This room was closed due to insurance updates.')]");
    private final By systemMessageForNewDueToInsuranceUpdateRoomlAvailable = By.xpath("//p[contains(text(), 'Welcome to your new Talkspace room!')]");
    private final By bannerRoomIsClosedAvailable = By.xpath("//p[contains(text(), 'This room is closed')]");
    private final By starUnstarButtonList = By.xpath("//div[@role='checkbox' and @aria-checked='true' or @aria-checked='false']");
    //endregion
    @FindBy(css = "[data-qa=uploadFilePress]")
    private WebElement plusIcon;
    @FindBy(css = "[data-qa=recordVoiceMessagePress]")
    private WebElement recordVoiceMessageButton;
    @FindBy(css = "[data-qa=chatBannerPartnerMissing]")
    private WebElement addYourPartnerBanner;
    @FindBy(css = "[data-qa=panelMyRoomAddPartnerButton]")
    private WebElement addYourPartnerButton;
    @FindBy(css = "[data-qa=askAboutAvailability]")
    private WebElement askAboutAvailabilityButton;
    @FindBy(css = "[data-qa=selectTimeslotPreferredTimesAvailableAnyTime]")
    private WebElement availableAnyTimeButton;
    @FindBy(css = "[data-qa=selectTimeslotPreferredTimesSelectCadance]")
    private WebElement selectCadanceDropdown;
    @FindBy(css = "[data-qa=selectTimeslotPreferredTimesTimeRangeMondays12PM-3PM]")
    private WebElement mondays12pmTo3pmButton;
    @FindBy(css = "[data-qa=selectTimeslotPreferredTimesTimeRangeTuesdays7AM-12PM]")
    private WebElement tuesdays7amTo12pmButton;
    @FindBy(css = "[data-qa=selectTimeslotPreferredTimesTimeRangeWednesdays3PM-7PM]")
    private WebElement wednesdays3pmTo7pmButton;
    @FindBy(css = "[data-qa=selectTimeslotPreferredTimesSubmit]")
    private WebElement sendToMyProviderButton;
    @FindBy(css = "[data-qa=inRoomSchedulingIncompatibleTimes]")
    private WebElement buttonRequestAlternativeTimes;
    @FindBy(css = "[data-qa=inRoomSchedulingIncompatibleTimes], [data-qa=askAboutAvailability], [data-qa=selectTimeslotPreferredTimesAvailableAnyTime], [data-qa=handleBookLaterPress], [data-qa=noneOfTheseTimeWorksPress]")
    private WebElement buttonExitSchedulerForNoAvailability;
    @FindBy(css = "[data-qa=account-details]")
    private WebElement buttonLoginAndSecurity;
    @FindBy(css = "[data-qa=personal-information]")
    private WebElement buttonPersonalInformation;
    @FindBy(css = "[data-qa=manage-subscription]")
    private WebElement buttonPaymentAndPlan;
    @FindBy(css = "[data-qa=logout]")
    private WebElement buttonLogout;
    @FindBy(css = "[data-qa=add-new-service]")
    private WebElement buttonAddService;
    @FindBy(css = "[data-qa=change-provider]")
    private WebElement buttonChangeProvider;
    @FindBy(css = "[data-qa=check-coverage]")
    private WebElement buttonUpdateMyCoverage;
    @FindBy(css = "[data-qa=starred-messages]")
    private WebElement buttonStarredMessages;
    @FindBy(css = "[data-qa=roomDetailsBookSession], [data-qa=bookYourFirstSessionButton]")
    private WebElement buttonBookSession;
    @FindBy(css = "[data-qa=inRoomSchedulingConfirmBookingIAgree], [data-qa=inRoomSchedulingConfirmBookingSchedule]")
    private WebElement buttonIAgreeSession;
    @FindBy(css = "[data-qa=inRoomSchedulingConfirmBookingSchedule], [data-qa=inRoomSchedulingConfirmBookingReschedule], [data-qa=inRoomSchedulingOnBoardingConfirmBooking]")
    private WebElement buttonReserveSession;
    @FindBy(css = "[data-qa=inRoomSchedulingSelectTimeslotContinuePress], [data-qa=inRoomSchedulerSelectCreditContinue], [data-qa=inRoomSchedulerSelectModalityContinue], [data-qa=schedulerChangeBookingContinue], [data-qa=qmSelectModalityContinueButton]")
    private WebElement inRoomSchedulingSelectTimeslotContinueButton;
    @FindBy(css = "[data-qa=messagingInformationNextButton]")
    private WebElement nextAsyncButton;
    @FindBy(css = "[data-qa=messagingInformationConfirmSessionButton]")
    private WebElement confirmAsyncSessionButton;
    @FindBy(css = "[data-qa=selectCreditRadioButton_therapy_live_video_credit_30_min30]")
    private WebElement selectCreditRadioButtonTherapyLiveVideoCredit30Min30;
    @FindBy(css = "[data-qa=liveAudioModalityRadioButton]")
    private WebElement audioModalityRadioButton;
    @FindBy(css = "[data-qa=messagingModalityRadioButton]")
    private WebElement messagingModalityRadioButton;
    @FindBy(css = "[data-qa=liveChatModalityRadioButton]")
    private WebElement liveChatModalityRadioButton;
    @FindBy(css = "[data-qa=liveVideoModalityRadioButton]")
    private WebElement videoModalityRadioButton;
    @FindBy(css = "[data-qa=bookALiveSessionButton], [data-qa=recommendMessagingStartWithLiveSessionButton]")
    private WebElement bookLiveSessionAsync;
    @FindBy(css = "[data-qa=startAMessagingSessionButton], [data-qa=bookASessionButton]")
    private WebElement startMessagingSession;
    @FindBy(css = "[data-qa=cancelBookingRescheduleCheckbox]")
    private WebElement checkboxRescheduleSession;
    @FindBy(css = "[data-qa=cancelBookingCancelCheckbox]")
    private WebElement checkboxCancelSession;
    private final By bookSessionButton = By.cssSelector("[data-qa=bookASessionButton]");
    @FindBy(css = "[data-qa=cancelSession]")
    private WebElement inRoomSchedulingCancelSessionButton;
    @FindBy(css = "[data-qa=rescheduleSession]")
    private WebElement inRoomSchedulingRescheduleSessionButton;
    @FindBy(css = "[data-qa=cancellationDoneCTA]")
    private WebElement inRoomSchedulingCancelSessionDoneButton;
    @FindAll({
            @FindBy(css = "[data-qa=inRoomSchedulerSelectModalityContinue]"),
            @FindBy(css = "[data-qa=continueButton]"),
    })
    private WebElement updateMyCoverageContinueButton;
    @FindBy(css = "[data-qa=therapistSelectedConfirmationPrimaryButtonPress], [data-qa=goToNewRoomButton]")
    private WebElement updateMyCoverageGoToMyNewRoomButton;
    @FindBy(css = "[data-qa=findingProviderButtonPress], [data-qa=therapistSelectedConfirmationPrimaryButtonPress]")
    private WebElement updateMyCoverageGoBackToMyRoomButton;
    @FindBy(css = "[data-qa=therapistSelectedConfirmationPrimaryButtonPress]")
    private WebElement updateMyCoverageFinishServicesInOldRoom;
    @FindBy(css = "[data-qa=therapistSelectedConfirmationSecondaryButtonPress]")
    private WebElement updateMyCoverageCheckOutMyNewRoom;
    @FindBy(css = "[data-qa=bookASessionButton]")
    private WebElement bookASessionButton;


    public String getLastAudioMessageTime() {
        return wait.until(visibilityOfAllElements(elements)).get(elements.size() - 1).getText();
    }

    /**
     * When the 'live_chat_active' feature flag is enabled, an overlay and an additional page will be displayed, blocking the flow.
     * We sometime have the “got it” + modality screen and sometime not, it depends on the plan - if it is set for a few modalities, you'll get it, and if not, then no.
     * <p>
     * this step is an optional step: Clicking on 'Got it' to close the overlay and then clicking on Continue to move to the next page.
     */
    @And("In-room scheduler - Click on Got it button and continue if present")
    public void clickOnGotItButtonIfPresent() {
        Try.run(() -> new WebDriverWait(driver, Duration.ofSeconds(10)).until(elementToBeClickable(buttonGotIt)).click());
    }

    @And("In-room scheduler - Click on Book Live Session button")
    public void clickOnBookLiveSessionButton() {
        wait.until(elementToBeClickable(bookLiveSessionAsync)).click();
    }

    @And("In-room scheduler - Click on Start Messaging Session button")
    public void clickOnStartMessagingSessionButton() {
        wait.until(elementToBeClickable(startMessagingSession)).click();
    }

    @And("In-room scheduler - Click on Go to session room button")
    public void clickOnGoToSessionButton() {
        wait.until(elementToBeClickable(goToSessionRoomButton)).click();
    }

    @And("In-room scheduler - Click on Start session now button")
    public void clickOnStartSessionNowSessionButton() {
        wait.until(elementToBeClickable(startSessionNowButton)).click();
    }

    @And("BH next session - Click on Book a session button")
    public void clickOnBHBookASessionButton() {
        wait.until(elementToBeClickable(BHBookASessionButton)).click();
    }

    @And("BH next session - Click on check your eligibility error link")
    public void clickOnCheckYourEligibilityLink() {
        wait.until(elementToBeClickable(CheckYourEligibilityLink)).click();
    }

    @And("Open account menu")
    public void openAccountMenu() {
        wait.until(elementToBeClickable(buttonAccountMenu)).click();
    }

    @Then("System message {string} appears")
    public void verifySystemMessageInChat(String messageText) {
        wait.until(ExpectedConditions.refreshed(ExpectedConditions.visibilityOfElementLocated(
                By.xpath("//div[@id='ID_NEWEST_MESSAGE']//p[contains(text(), \"" + messageText + "\")]"))));
    }

    @Then("“Are you in a Messaging Session?” popup appears")
    public void areYouInMessagingSessionAppear() {
        wait.until(ExpectedConditions.presenceOfAllElementsLocatedBy(bookSessionButton));
    }

    @Then("“Messaging Session in progress“ banner appears")
    public void messagingSessionInProgressBannerAppear() {
        wait.until(ExpectedConditions.elementToBeClickable(messagingSessionInProgressBanner)).click();
    }

    @Then("“Next Live session is scheduled for“ banner appears")
    public void nextLiveSessionBannerAppear() {
        wait.until(ExpectedConditions.presenceOfElementLocated(nextLiveSessionBanner));
    }

    @Then("Click on you have some pending tasks banner")
    public void youHavePendingTasksBanner() {
        wait.until(ExpectedConditions.presenceOfElementLocated(youHaveSomePendingTasksBanner)).click();
    }

    @Then("“Are you in a Messaging Session?” popup does not appear")
    public void areYouInMessagingSessionDoesNotAppear() {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(8));
        assertThat(driver.findElements(bookSessionButton))
                .isEmpty();
    }

    @Then("Update my coverage - Welcome message for old B2C room with no sessions left appears in new room")
    public void welcomeMessageForCreditNotAvailableOnB2CRoomAppear() {
        wait.until(ExpectedConditions.presenceOfElementLocated(welcomeMessageForCreditNotAvailableonB2CRoom));
    }

    @Then("Update my coverage - Welcome message for old B2C room with sessions left appears in new room")
    public void welcomeMessageForCreditStillAvailableOnB2CRoomAppear() {
        wait.until(ExpectedConditions.presenceOfElementLocated(welcomeMessageForCreditStillAvailableonB2CRoom));
    }

    @Then("Update my coverage - Welcome message for old B2B room with no sessions left appears in new room")
    public void welcomeMessageForCreditNotAvailableOnB2BRoomAppear() {
        wait.until(ExpectedConditions.presenceOfElementLocated(welcomeMessageForCreditNotAvailableonB2BRoom));
    }

    @Then("Update my coverage - Welcome message for old B2B room with sessions left appears in new room")
    public void welcomeMessageForCreditStillAvailableOnB2BRoomAppear() {
        wait.until(ExpectedConditions.presenceOfElementLocated(welcomeMessageForCreditStillAvailableonB2BRoom));
    }


    /**
     * inside {@link enums.FrameTitle#DEFAULT} frame
     */
    @Frame(DEFAULT)
    @Then("Update my coverage - System message appears in old room")
    public void welcomeMessageForOldRoomAppear() {
        wait.until(ExpectedConditions.visibilityOfElementLocated(welcomeMessageForOldRoomlAvailable));
    }

    /**
     * inside {@link enums.FrameTitle#DEFAULT} frame
     */
    @Frame(DEFAULT)
    @And("Ineligibility BH - Click on go to my new room")
    public void clickOnGoToMyNewRoomIneligibilityBH() {
        wait.until(elementToBeClickable(updateMyCoverageGoToMyNewRoomButton)).click();
    }

    @Then("Ineligibility BH - System message room is closed appears in old room")
    public void systemMessageRoomWasClosedForOldRoomAppear() {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(3));
        wait.until(ExpectedConditions.presenceOfElementLocated(systemMessageForClosedDueToInsuranceUpdateRoomlAvailable));
    }

    @Then("Ineligibility BH - System message insurance coverage expired appears in old room")
    public void systemMessageInsuranceCoverageExpiredForOldRoomAppear() {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(3));
        wait.until(ExpectedConditions.presenceOfElementLocated(systemMessageForClosedDueToInsuranceUpdateRoomlAvailable));
    }

    @Then("Ineligibility BH - System message appears in new room")
    public void systemMessageForNewRoomAppear() {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(3));
        wait.until(ExpectedConditions.presenceOfElementLocated(systemMessageForNewDueToInsuranceUpdateRoomlAvailable));
    }

    @Then("Ineligibility BH - Room is closed banner appears in old room")
    public void roomIsClosedBannerForOldRoomAppear() {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(3));
        wait.until(ExpectedConditions.presenceOfElementLocated(bannerRoomIsClosedAvailable));
    }

    @Then("Upload PDF")
    public void uploadPdf() {
        wait.until(ExpectedConditions.visibilityOf(plusIcon)).click();
        wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector("input[type=file]")))
                .sendKeys(Paths.get(USER_DIR).getParent() + "/resources/dummy.pdf");
    }

    @Then("PDF message is in the chat")
    public void chatVerifyThePdfMessageIsInChat() {
        wait.until(ExpectedConditions.invisibilityOfElementLocated(By.cssSelector(".bt-spinner")));
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(10));
        wait.until(ExpectedConditions.invisibilityOfElementLocated(By.cssSelector(".bt-spinner")));
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("svg[role=img][aria-label=PDF]")));
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//p[contains(text(), 'dummy')]")));
    }

    /**
     * we need to wait for the audio message to be fully visible in the chat with a buffer of 1 second plus or minus
     */
    @Then("Audio message is in the chat")
    public void chatVerifyTheAudioMessageIsInChat() {
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".bt-spinner")));
        wait.until(ExpectedConditions.invisibilityOfElementLocated(By.cssSelector(".bt-spinner")));
        wait.until(driver -> getLastAudioMessageTime().equals("0:0" + scenarioContext.getMessageLength()) ||
                getLastAudioMessageTime().equals("0:0" + (scenarioContext.getMessageLength() - 1)) ||
                getLastAudioMessageTime().equals("0:0" + (scenarioContext.getMessageLength() + 1)));
    }

    @Then("Message too long error is available")
    public void chatMessageTooLongErrorIsAvailable() {
        assertThat(errorMaxLength)
                .extracting(WebElement::getText)
                .withFailMessage("Message to long error is not available")
                .isEqualTo("Maximum length exceeded");
    }

    /**
     * @param userEmailType in case NEW is selected, the pending email is sent.
     */
    @And("Insert {} email in the email input")
    public void profileInsertFromAccountInNewEmailInput(UserEmailType userEmailType) {
        switch (userEmailType) {
            case INVALID, PRIMARY, PARTNER ->
                    wait.until(elementToBeClickable(inputNewEmail)).sendKeys(GeneralActions.getEmailAddress(userEmailType));
            case NEW ->
                    wait.until(elementToBeClickable(inputNewEmail)).sendKeys(data.getUsers().get("primary").getPendingEmail());
        }
    }

    /**
     * After this step, updating pending email as the users email.
     *
     * @param userEmailType in case NEW is selected, the pending email is sent.
     */
    @And("Insert {} email in email confirmation")
    public void profileInsertFromAccountInConfirmNewEmailInput(UserEmailType userEmailType) {
        switch (userEmailType) {
            case INVALID, PRIMARY, PARTNER ->
                    wait.until(elementToBeClickable(inputConfirmationNewEmail)).sendKeys(GeneralActions.getEmailAddress(userEmailType));
            case NEW ->
                    wait.until(elementToBeClickable(inputConfirmationNewEmail)).sendKeys(data.getUsers().get("primary").getPendingEmail());
        }
    }

    /**
     * this step can be used to:
     * <ul>
     *    <li>validate room presence for cases that the user is not listed in data.users object. example scenario: Lock\Unlock user action.
     *    <li> wait in order to navigate directly to menu item.
     *  </ul>
     * <p>
     */
    @Then("Room is available")
    public void roomAvailable() {
        wait.until(ExpectedConditions.urlMatches(".*/room/\\d+.*"));
    }

    /**
     * @see <a href="https://www.selenium.dev/documentation/webdriver/actions_api/wheel/#scroll-from-an-element-with-an-offset">Scroll from an element with an offset </a>
     */
    @And("Scroll to the top of the chat")
    public void scrollToTop() {
        actions.scrollFromOrigin(WheelInput.ScrollOrigin
                        .fromElement(wait.until(ExpectedConditions.visibilityOf(plusIcon)), 0, -50), 0, -5000)
                .perform();
    }

    @And("Click on new message button")
    public void clickOnNewMessageNotification() {
        wait.until(ExpectedConditions.elementToBeClickable(newMessageButton)).click();
    }

    /**
     * calls {@link #roomAvailable()} before navigation.
     */
    @And("Navigate to payment and plan URL")
    public void navigateToPaymentAndPlanURL() {
        roomAvailable();
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(1));
        driver.get(GeneralActions.isRunningOnProd() ? "https://app.talkspace.com/room/%s/my-account/manage-subscription".formatted(getCurrentRoomId()) : "https://app.%s.talkspace.com/room/%s/my-account/manage-subscription".formatted(data.getConfiguration().getDomain(), getCurrentRoomId()));
    }

    @When("Insert {} text message")
    public void chatInsertTextMessage(ChatMessageType chatMessageType) {
        writeMessage(chatMessageType);
    }

    @Then("Message is available in the chat")
    public void chatMessageIsAvailableInTheChat() {
        messageIsInChat();
    }

    @Then("Talkspace message {string} is available in chat")
    public void chatTalkspaceMessageIsAvailableInChat(String text) {
        Awaitility.await()
                .atMost(Duration.ofMinutes(1))
                .alias("Message" + text + "is available in chat")
                .pollInterval(Duration.ofSeconds(1))
                .ignoreExceptions()
                .untilAsserted(() -> assertThat(driver.findElements(By.xpath("//p[contains(@id, 'ID_MESSAGE_TEXT')]"))
                        .stream()
                        .filter(WebElement::isDisplayed)
                        .map(WebElement::getText)
                        .toList())
                        .withFailMessage("Talkspace message %s is not available in chat", text)
                        .contains(text));
    }

    @And("Click on send")
    public void chatClickOnSend() {
        wait.until(elementToBeClickable(buttonSendMessage)).click();
    }

    /**
     * sending multiple chat messages from client to provider and verify that the messages are present.
     * in case the message is too long we are not validating its presence.
     *
     * @param chatMessages list of chat messages
     */
    @When("Send the following message(s and verify they are present in chat)")
    public void chatInsertTextMessage(List<ChatMessageType> chatMessages) {
        chatMessages.forEach(chatMessageType -> {
            writeMessage(chatMessageType);
            chatClickOnSend();
            if (!chatMessageType.equals(TOO_LONG)) {
                messageIsInChat();
            }
        });
    }

    /**
     * due to a lot of system messages in chat, we needed to click on messages via JS
     */
    @When("Star all messages")
    public void chatStarAllMessages() {
        wait.until(ExpectedConditions.presenceOfAllElementsLocatedBy(starUnstarButtonList))
                .stream()
                .filter(webElement -> webElement.getAttribute("aria-checked").equals(BooleanUtils.FALSE))
                .forEach(element -> ((JavascriptExecutor) driver).executeScript("arguments[0].click();", element));
    }

    /**
     * for accessibility testing
     */
    @Then("Switch to high contrast mode")
    public void switchToHighContrastMode() {
        openAccountMenu();
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(4));
        wait.until(elementToBeClickable(highContrastButton)).click();
        actions.sendKeys(Keys.ESCAPE)
                .build()
                .perform();
    }

    @When("Clear message box")
    public void chatClearMessageBox() {
        wait.until(visibilityOf(inputMessage)).clear();
    }


    /**
     * due to a lot of system messages in chat, we needed to click on messages via JS
     */
    @When("Unstar all messages")
    public void chatUnstarAllMessages() {
        wait.until(ExpectedConditions.presenceOfAllElementsLocatedBy(starUnstarButtonList))
                .stream()
                .filter(webElement -> webElement.getAttribute("aria-checked").equals(BooleanUtils.TRUE))
                .forEach(element -> ((JavascriptExecutor) driver).executeScript("arguments[0].click();", element));
    }

    /**
     * creating two groups of elements - starred and unstarred icons.
     * verifying that the unstarred icons group size is empty.
     */
    @Then("All messages are starred")
    public void chatVerifyAllMessagesAreStarred() {
        var starIcons = wait.until(ExpectedConditions.presenceOfAllElementsLocatedBy(starUnstarButtonList))
                .stream()
                .collect(Collectors.partitioningBy(webElement -> webElement.getAttribute("aria-checked").equals(BooleanUtils.TRUE)));
        assertThat(starIcons.get(false))
                .withFailMessage("found %d unstarred messages and %d starred messages", starIcons.get(false).size(), starIcons.get(true).size())
                .isEmpty();
    }

    @And("Account Menu - Select add a new service")
    public void roomGoToAddNewService() {
        wait.until(elementToBeClickable(buttonAddService)).click();
    }

    @Then("Change provider - Select the {optionIndex} room")
    public void myAccountVerifyVideoCreditsAreAvailable(int roomIndex) {
        wait.until(ExpectedConditions.visibilityOfAllElements(roomContainerList)).get(roomIndex).click();
    }

    @And("Account Menu - Select change provider")
    public void roomGoToChangeProvider() {
        wait.until(elementToBeClickable(buttonChangeProvider)).click();
    }

    @And("Account Menu - Select update my coverage")
    public void roomGoToUpdateMyCoverage() {
        wait.until(elementToBeClickable(buttonUpdateMyCoverage)).click();
    }

    @And("Update my coverage - Select {} plan to update")
    public void selectPlanUpdateMyCoverage(ServiceType serviceType) {
        switch (serviceType) {
            case THERAPY -> wait.until(elementToBeClickable(chooseIndividualTherapyPlanToUpdateButton)).click();
            case PSYCHIATRY -> wait.until(elementToBeClickable(choosePsychiatryPlanToUpdateButton)).click();
            case COUPLES_THERAPY -> wait.until(elementToBeClickable(chooseCouplesPlanToUpdateButton)).click();
        }
    }


    @And("Update my coverage - Click on continue button")
    public void clickOnContinueUpdateMyCoverage() {
        wait.until(elementToBeClickable(updateMyCoverageContinueButton)).click();
    }


    @And("Update my coverage - Click on continue on confirmation")
    @And("Update my coverage - Click on go to my new room")
    public void clickOnGoToMyNewRoomUpdateMyCoverage() {
        wait.until(elementToBeClickable(updateMyCoverageGoToMyNewRoomButton)).click();
    }

    /**
     * inside {@link enums.FrameTitle#DEFAULT} frame
     */
    @Frame(DEFAULT)
    @And("Update my coverage - Click on go back to my room")
    public void clickOnGoBackToMyOldRoomUpdateMyCoverage() {
        wait.until(elementToBeClickable(updateMyCoverageGoBackToMyRoomButton)).click();
    }

    @And("Update my coverage - Click on finish services in my old room")
    public void clickOnFinishServicesInMyOldRoomUpdateMyCoverage() {
        wait.until(elementToBeClickable(updateMyCoverageFinishServicesInOldRoom)).click();
    }

    @And("Update my coverage - Click on check out my new room")
    public void clickOnCheckOutMyNewRoomUpdateMyCoverage() {
        wait.until(elementToBeClickable(updateMyCoverageCheckOutMyNewRoom)).click();
    }

    @And("Ineligibility BH - Click on insurance coverage expired tag")
    public void clickOnInsuranceCoverageExpiredTag() {
        wait.until(elementToBeClickable(insuranceCoverageExpiredTag)).click();
    }

    @And("Ineligibility BH - Click on room closed tag")
    public void clickOnRoomClosedTag() {
        wait.until(elementToBeClickable(roomClosedTag)).click();
    }


    /**
     * inside {@link enums.FrameTitle#DEFAULT} frame
     */
    @Frame(DEFAULT)
    @And("Ineligibility BH - Click on book a session")
    public void clickOnBookASession() {
        wait.until(elementToBeClickable(bookASessionButton)).click();
    }


    /**
     * clicking on the url message via JavascriptExecutor interface.
     *
     * @see <a href="https://stackoverflow.com/a/11956130/4515129">how to click an element in selenium webdriver using javascript</a>
     */
    @When("Access url in last message")
    public void chatAccessUrlInLastMessage() {
        Awaitility.await()
                .alias("Tab count increased to 2")
                .atMost(Duration.ofSeconds(30))
                .pollInterval(Duration.ofSeconds(3))
                .ignoreExceptions()
                .until(() -> {
                    ((JavascriptExecutor) driver).executeScript("arguments[0].click();", driver.findElement(By.xpath("//a[contains(@href,'%s')]".formatted(data.getCharacters().get("url")))));
                    return driver.getWindowHandles().size() == 2;
                });
    }

    /**
     * creating two groups of elements - starred and unstarred icons.
     * verifying that the starred icons are empty.
     */
    @Then("All messages are unstarred")
    public void chatVerifyAllMessagesAreUnstarred() {
        Awaitility
                .await()
                .alias("All messages are unstarred")
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() ->
                {
                    var starIcons = wait.until(ExpectedConditions.presenceOfAllElementsLocatedBy(starUnstarButtonList))
                            .stream()
                            .collect(Collectors.partitioningBy(webElement -> webElement.getAttribute("aria-checked").equals(BooleanUtils.FALSE)));
                    assertThat(starIcons.get(false))
                            .withFailMessage("found %d starred messages and %d unstarred messages", starIcons.get(false).size(), starIcons.get(true).size())
                            .isEmpty();
                });
    }

    /**
     * @see <a href="https://github.com/cucumber/cucumber-expressions#alternative-text">how to use alternative text</a>
     */
    @When("Play/Pause the audio message from chat")
    public void playPauseRecordedMessage() {
        wait.until(ExpectedConditions.elementToBeClickable(playPauseRecordedMessage)).click();
    }

    @Then("Play button is available for audio message from chat")
    public void chatPlayButtonIsAvailableForAudioMessageFromChat() {
        wait.until(ExpectedConditions.elementToBeClickable(playButton));
    }

    /**
     * In case there are no more timeslots available this month, we need to click on the Next available button to select the closest timeslot.
     */
    @And("In-room scheduler - Click on Next available button if present")
    public void clickOnNextAvailableButtonIfPresent() {
        Try.run(() -> new WebDriverWait(driver, Duration.ofSeconds(10)).until(ExpectedConditions.elementToBeClickable(buttonNextAvailable)).click());
    }

    @And("In-room scheduler - Click on continue button")
    public void inRoomSchedulerClickOnContinueButton() {
        wait.until(ExpectedConditions.elementToBeClickable(inRoomSchedulingSelectTimeslotContinueButton)).click();
    }

    /**
     * adding delay to allow the calendar to load.
     */
    @And("In-room scheduler - Click on right arrow")
    public void inRoomSchedulerClickOnRightArrow() {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(5));
        wait.until(ExpectedConditions.elementToBeClickable(schedulerRightArrow)).click();
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(5));
    }

    /**
     * will click on the 15th timeslot in the scheduler 2 months forward.
     */
    @And("In-room scheduler - Reserve a session on a future date")
    public void inRoomSchedulerSelectFutureTimeslot() {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(2));
        wait.until(ExpectedConditions.elementToBeClickable(inRoomSchedulingSelectTimeslotContinueButton)).click();
        wait.until(ExpectedConditions.elementToBeClickable(inRoomSchedulingSelectTimeslotContinueButton)).click();
        wait.until(ExpectedConditions.elementToBeClickable(schedulerRightArrow)).click();
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(2));
        wait.until(ExpectedConditions.elementToBeClickable(schedulerRightArrow)).click();
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(3));
        wait.until(ExpectedConditions.elementToBeClickable(timeslot)).click();
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(2));
        wait.until(ExpectedConditions.elementToBeClickable(inRoomSchedulingSelectTimeslotContinueButton)).click();
        Try.run(() -> wait.until(ExpectedConditions.elementToBeClickable(buttonReserveSession)).click())
                .onFailure(failure -> Assumptions.assumeThat(driver.findElements(By.cssSelector("[data-qa=askAboutAvailabilityButton]")))
                        .withFailMessage("therapist has not availability skipping this scenario")
                        .isEmpty());
        wait.until(elementToBeClickable(commonWebPage.getButtonDone())).click();
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(3));
    }

    /**
     * will click on an available timeslot in the scheduler.
     */
    @And("In-room scheduler - Click on a timeslot")
    public void inRoomSchedulerClickOnTimeSlot() {
        wait.until(ExpectedConditions.elementToBeClickable(timeslot)).click();
    }

    @And("In-room scheduler - Click on cancel session button")
    public void inRoomSchedulerClickOnCancelSessionButton() {
        wait.until(ExpectedConditions.elementToBeClickable(inRoomSchedulingCancelSessionButton)).click();
    }

    @And("In-room scheduler - Click on cancel session done button")
    public void inRoomSchedulerClickOnCancelSessionDoneButton() {
        wait.until(ExpectedConditions.elementToBeClickable(inRoomSchedulingCancelSessionDoneButton)).click();
    }

    @And("In-room scheduler - Click on reschedule session button")
    public void inRoomSchedulerClickOnRescheduleSessionButton() {
        wait.until(ExpectedConditions.elementToBeClickable(inRoomSchedulingRescheduleSessionButton)).click();
    }

    @And("In-room scheduler - Click on Async next button")
    public void inRoomSchedulerClickOnAsyncNextButton() {
        wait.until(ExpectedConditions.elementToBeClickable(nextAsyncButton)).click();
    }

    @And("In-room scheduler - Click on Async confirm session button")
    public void inRoomSchedulerClickOnAsyncConfirmSessionButton() {
        wait.until(ExpectedConditions.elementToBeClickable(confirmAsyncSessionButton)).click();
    }

    @And("In-room scheduler - Select messaging session modality")
    public void clickOnMessagingModalityRadioButton() {
        wait.until(ExpectedConditions.elementToBeClickable(messagingModalityRadioButton)).click();
    }

    @And("In-room scheduler - Select audio modality")
    public void clickOnAudioModalityRadioButton() {
        wait.until(ExpectedConditions.elementToBeClickable(audioModalityRadioButton)).click();
    }

    @And("In-room scheduler - Select live chat modality")
    public void clickOnLiveChatModalityRadioButton() {
        wait.until(ExpectedConditions.elementToBeClickable(liveChatModalityRadioButton)).click();
    }

    @And("In-room scheduler - Select video modality")
    public void clickOnVideoModalityRadioButton() {
        wait.until(ExpectedConditions.elementToBeClickable(videoModalityRadioButton)).click();
    }

    @And("In-room scheduler - Select 30 minute live session")
    public void setInRoomSchedulingSelectCreditRadioButtonTherapyLiveVideoCredit30Min30() {
        wait.until(ExpectedConditions.elementToBeClickable(select30MinLiveSession)).click();
    }

    @And("In-room scheduler - Select 30 minute live session length")
    public void select30MinSessionLength() {
        wait.until(ExpectedConditions.elementToBeClickable(select30MinLiveSession)).click();
    }

    @And("In-room scheduler - Select 45 minute live session length")
    public void select45MinSessionLength() {
        wait.until(ExpectedConditions.elementToBeClickable(select45MinLiveSession)).click();
    }

    @And("In-room scheduler - Select 60 minute live session length")
    public void select60MinSessionLength() {
        wait.until(ExpectedConditions.elementToBeClickable(select60MinLiveSession)).click();
    }

    @And("In-room scheduler - Select 10 minute live session length")
    public void select10MinSessionLength() {
        wait.until(ExpectedConditions.elementToBeClickable(select10MinLiveSession)).click();
    }

    @And("In-room scheduler - Edit existing booking")
    public void editExistingBooking() {
        Failsafe.with(RetryPolicy.builder()
                        .withMaxRetries(2)
                        .withDelay(Duration.ofSeconds(5))
                        .build())
                .run(() ->
                {
                    wait.until(ExpectedConditions.refreshed(ExpectedConditions.elementToBeClickable(buttonBookSession)));
                    wait.until(ExpectedConditions.refreshed(ExpectedConditions.elementToBeClickable(buttonEditBooking))).click();
                });
    }

    /**
     * TODO: update after https://talktala.atlassian.net/browse/MEMBER-808
     */
    @And("In-room scheduler - Book session with purchase")
    public void bookWithPurchase() {
        wait.until(ExpectedConditions.refreshed(ExpectedConditions.elementToBeClickable(buttonBookSessionPurchase))).click();
    }

    @And("No availability - Click on ask about availability")
    public void clickAskAboutAvailabilityButton() {
        wait.until(ExpectedConditions.elementToBeClickable(askAboutAvailabilityButton)).click();
    }

    @And("No availability - Select option {string}")
    public void noAvailabilityClickOnDropdown(String optionText) {
        commonWebPage.selectOptionFromDropdown(() -> wait.until(elementToBeClickable(selectCadanceDropdown)).click(), optionText);
    }

    @And("No availability - Click on im available any time")
    public void clickAvailableAnyTimeButton() {
        wait.until(ExpectedConditions.elementToBeClickable(availableAnyTimeButton)).click();
    }

    @And("No availability - Click 2 timeRange options and submit")
    public void click2TimeRangeButtons() {
        wait.until(ExpectedConditions.elementToBeClickable(mondays12pmTo3pmButton)).click();
        wait.until(ExpectedConditions.elementToBeClickable(tuesdays7amTo12pmButton)).click();
        Assert.assertFalse(sendToMyProviderButton.isEnabled());
    }

    @And("No availability - Click 3 timeRange options and submit")
    public void click3TimeRangeButtons() {
        wait.until(ExpectedConditions.elementToBeClickable(mondays12pmTo3pmButton)).click();
        wait.until(ExpectedConditions.elementToBeClickable(tuesdays7amTo12pmButton)).click();
        wait.until(ExpectedConditions.elementToBeClickable(wednesdays3pmTo7pmButton)).click();
        wait.until(ExpectedConditions.elementToBeClickable(sendToMyProviderButton)).click();
    }

    @And("No availability - Click on send to my provider")
    public void clickSendToMyProviderButton() {
        wait.until(ExpectedConditions.elementToBeClickable(sendToMyProviderButton)).click();
    }

    @And("Click I can't find a time that works for me")
    public void clickRequestAlternativeTimesButton() {
        wait.until(ExpectedConditions.elementToBeClickable(buttonRequestAlternativeTimes)).click();
    }

    /**
     * this is to dismiss booking screen on all situations of no availability (used on onboarding modal)
     */
    public void exitSchedulerForNoAvailability() {
        wait.until(ExpectedConditions.elementToBeClickable(buttonExitSchedulerForNoAvailability)).click();
    }

    /**
     * this is to cancel a booking done via the onbaording modal
     */
    @When("Onboarding - Cancel existing booking")
    public void onboardingCancelExistingBooking() {
        openRoomDetails();
        editExistingBooking();
        wait.until(ExpectedConditions.elementToBeClickable(checkboxCancelSession)).click();
        wait.until(ExpectedConditions.elementToBeClickable(inRoomSchedulingSelectTimeslotContinueButton)).click();
        commonWebPage.profileConfirmationPopupClickOnDoneButton();
    }

    @Then("Click on add your partner to the room banner")
    public void clickOnAddYourPartnerBanner() {
        wait.until(ExpectedConditions.elementToBeClickable(addYourPartnerBanner)).click();
    }

    @Then("Click on decline session button")
    public void clickODeclineSession() {
        wait.until(ExpectedConditions.elementToBeClickable(declineSession)).click();
    }

    @Then("Click on confirm session(s) button")
    @Then("Click on confirm or decline session(s) button")
    public void clickAcceptSession() {
        wait.until(ExpectedConditions.elementToBeClickable(confirmSession)).click();
    }

    @Then("In-room scheduler - Click on confirm session(s) button")
    public void inRoomClickAcceptSession() {
        wait.until(ExpectedConditions.elementToBeClickable(confirmSessionsInRoom)).click();
    }


    @Then("Account menu - Click on the {optionIndex} confirm the session(s) button")
    public void clickAcceptSession(int buttonNumber) {
        wait.until(driver -> confirmSessionAccountMenu.size() >= buttonNumber + 1);
        wait.until(driver -> {
            confirmSessionAccountMenu.get(buttonNumber).click();
            return driver.getCurrentUrl().contains("in-room-scheduling");
        });
    }

    @And("Press keys")
    public void pressKeys(DataTable dataTable) {
        actions.keyDown(Keys.CONTROL)
                .sendKeys(Keys.ENTER)
                .keyUp(Keys.CONTROL)
                .build()
                .perform();
    }

    /**
     * @param buttonNumber the button index
     */
    @And("Chat - Click on the {optionIndex} Get started button")
    public void chatClickOnGetStartedButton(int buttonNumber) {
        var buttonList = wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy((By.xpath("//button[contains(. , 'Get started')]"))));
        wait.until(ExpectedConditions.elementToBeClickable(buttonList.get(buttonNumber))).click();
    }

    @And("Prefilled text {string} appears")
    public void askAboutAvailabilityChatTextValidation(String text) {
        wait.until(ExpectedConditions.textToBePresentInElement(lastChatMessage, text));
    }

    @Then("Verify the accessed URL")
    public void chatVerifyTheAccessedURL() {
        assertThat(driver.getCurrentUrl())
                .as("URL")
                .isEqualTo(data.getCharacters().get("url"));
    }

    @Then("Click on revoke invitation button")
    public void clickOnRevokeInvitation() {
        wait.until(ExpectedConditions.elementToBeClickable(revokeInvitationButton)).click();
        wait.until(ExpectedConditions.invisibilityOfElementLocated(By.cssSelector(".spinner")));
    }

    @And("Click on the invite partner button")
    public void clickOnTheInvitePartnerButton() {
        wait.until(ExpectedConditions.elementToBeClickable(invitePartnerButton)).click();
    }

    @Then("Provider profile is visible")
    public void providerProfileIsVisible() {
        wait.until(ExpectedConditions.visibilityOfElementLocated(providerDetailsPanel));
    }

    @Then("Provider profile is not visible")
    public void providerProfileIsNotVisible() {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(10));
        assertThat(driver.findElements(providerDetailsPanel))
                .isEmpty();
    }

    public void writeMessage(ChatMessageType chatMessageType) {
        switch (chatMessageType) {
            case MAXIMUM -> scenarioContext.setChatMessage("1".repeat(7000));
            case URL -> scenarioContext.setChatMessage(data.getCharacters().get("url"));
            case SPECIAL_CHARACTER -> scenarioContext.setChatMessage(data.getCharacters().get("specialCharacters"));
            case LINE_BREAK ->
                    scenarioContext.setChatMessage(RandomStringUtils.randomAlphabetic(3) + System.lineSeparator() + RandomStringUtils.randomAlphabetic(3));
            case TOO_LONG -> scenarioContext.setChatMessage("1".repeat(7001));
            case COPY_PASTED_MESSAGE -> {
                scenarioContext.setChatMessage(RandomStringUtils.randomAlphabetic(3));
                wait.until(elementToBeClickable(textElement));
                actions.moveToElement(textElement)
                        .doubleClick()
                        .build()
                        .perform();
                if (SystemUtils.IS_OS_MAC) {
                    //Test is running on macOS, therefore, we need to use Command to copy instead of Control
                    driver.switchTo().activeElement().sendKeys(Keys.chord(Keys.COMMAND, "c"));
                } else {
                    driver.switchTo().activeElement().sendKeys(Keys.chord(Keys.CONTROL, "c"));
                }
                inputMessage.sendKeys(scenarioContext.getChatMessage());
                if (SystemUtils.IS_OS_MAC) {
                    //Test is running on macOS, therefore, we need to use Command to paste instead of Control
                    inputMessage.sendKeys(Keys.chord(Keys.COMMAND, "v"));
                } else {
                    inputMessage.sendKeys(Keys.chord(Keys.CONTROL, "v"));
                }
                wait.until(ExpectedConditions.textToBePresentInElementValue(inputMessage, scenarioContext.getChatMessage()));
            }
            case VALID_RANDOM -> scenarioContext.setChatMessage(RandomStringUtils.randomAlphabetic(3));
        }
        if (!chatMessageType.equals(COPY_PASTED_MESSAGE)) {
            wait.until(visibilityOf(inputMessage)).sendKeys(scenarioContext.getChatMessage());
            wait.until(ExpectedConditions.textToBePresentInElementValue(inputMessage, scenarioContext.getChatMessage()));
        }
    }

    public void messageIsInChat() {
        wait.until(ExpectedConditions.textToBePresentInElement(lastChatMessage, scenarioContext.getChatMessage()));
    }

    @And("Log out")
    public void roomLogOut() {
        wait.until(elementToBeClickable(buttonAccountMenu)).click();
        wait.until(elementToBeClickable(buttonLogout)).click();
    }

    @And("Wait until a message is available")
    public void chatWaitUntilMessageIsAvailable() {
        wait.until(ExpectedConditions.visibilityOf(lastChatMessage));
    }

    @And("Account Menu - Select starred messages")
    public void roomGoToStarredMessages() {
        wait.until(elementToBeClickable(buttonStarredMessages)).click();
    }

    @And("Account Menu - Select login and security")
    public void roomAccountMenuSelectLoginAndSecurity() {
        wait.until(elementToBeClickable(buttonLoginAndSecurity)).click();
    }

    @When("Open the Room details menu")
    public void openRoomDetails() {
        wait.until(ExpectedConditions.elementToBeClickable(roomDetailsButton)).click();
    }

    @When("Click on review your provider button")
    public void reviewYourProviderButton() {
        wait.until(ExpectedConditions.elementToBeClickable(reviewYourProviderButton)).click();
    }

    @When("Thanks for your review dialog is displayed")
    public void thankYouForYourReviewDialog() {
        wait.until(ExpectedConditions.visibilityOf(reviewSuccessModal));
    }

    @When("Submit provider review")
    public void submitReview() {
        wait.until(ExpectedConditions.elementToBeClickable(submitProviderReviewButton)).click();
    }

    @When("Enter a provider review")
    public void enterProviderReview() {
        wait.until(ExpectedConditions.visibilityOf(reviewTextBox)).sendKeys(faker.lorem().paragraph());
    }

    /**
     * the scenario will be skipped if the therapist has no availability.
     */
    @And("In-room scheduler - Click on reserve session button")
    public void clickOnReserveSessionButton() {
        Try.run(() -> wait.until(ExpectedConditions.elementToBeClickable(buttonReserveSession)).click())
                .onFailure(failure -> Assumptions.assumeThat(driver.findElements(By.cssSelector("[data-qa=askAboutAvailabilityButton]")))
                        .withFailMessage("therapist has not availability skipping this scenario")
                        .isEmpty());
    }

    @And("In-room scheduler - Click on book session button")
    public void clickOnBookSessionButton() {
        wait.until(ExpectedConditions.refreshed(ExpectedConditions.elementToBeClickable(buttonBookSession))).click();
    }

    @And("In-room scheduler - Click on I agree button")
    public void clickOnIAgreeButton() {
        wait.until(ExpectedConditions.refreshed(ExpectedConditions.elementToBeClickable(buttonIAgreeSession))).click();
    }

    @And("Click on reschedule session radio button")
    public void clickOnRescheduleSessionRadioButton() {
        wait.until(elementToBeClickable(checkboxRescheduleSession)).click();
    }

    @And("Click on cancel session radio button")
    public void clickOnCancelSessionRadioButton() {
        wait.until(elementToBeClickable(checkboxCancelSession)).click();
    }

    /**
     * verifying that looking for the send button produces a no such element exception.
     */
    @Then("Send button should not be available")
    public void chatSendButtonShouldNotBeAvailable() {
        Awaitility
                .await()
                .alias("Send button should not be available")
                .atMost(Duration.ofSeconds(30))
                .untilAsserted(() -> assertThatThrownBy(() -> buttonSendMessage.isDisplayed()).isInstanceOf(NoSuchElementException.class));
    }

    @When("Start audio record")
    public void chatStartAudioRecord() {
        wait.until(elementToBeClickable(plusIcon)).click();
        wait.until(elementToBeClickable(recordVoiceMessageButton)).click();
    }

    @When("Stop audio record after {int} seconds")
    public void chatStopAudioRecord(int seconds) {
        scenarioContext.setMessageLength(seconds);
        Uninterruptibles.sleepUninterruptibly(seconds, TimeUnit.SECONDS);
        wait.until(elementToBeClickable(buttonStopRecord)).click();
    }

    @And("Recorded message is available in input")
    public void chatRecordedMessageIsAvailableInInput() {
        assertThat(recordedMessage)
                .withFailMessage("Recorded message is not available in input")
                .matches(WebElement::isDisplayed);
    }

    @And("Delete recorded message")
    public void chatDeleteRecordedMessage() {
        deleteRecordedMessage.click();
    }

    @And("Account Menu - Select personal Information")
    public void roomAccountMenuSelectPersonInformation() {
        wait.until(elementToBeClickable(buttonPersonalInformation)).click();
    }

    @And("Account Menu - Select payment and plan")
    public void roomAccountMenuSelectPaymentAndPlan() {
        wait.until(elementToBeClickable(buttonPaymentAndPlan)).click();
    }

    @And("Play/Pause recorded message")
    public void chatPlayRecordedMessage() {
        playPauseRecordedMessage.click();
    }

    @Then("Play button for recorded message is available")
    public void chatPlayButtonForRecordedMessageIsAvailable() {
        assertThat(playPauseRecordedMessage)
                .withFailMessage("Play button for recorded message is not available")
                .matches(WebElement::isDisplayed);
    }

    @Then("Click on add your Partner button")
    public void clickOnAddYourPartnerButton() {
        wait.until(ExpectedConditions.refreshed(ExpectedConditions.elementToBeClickable(addYourPartnerButton))).click();
    }
}
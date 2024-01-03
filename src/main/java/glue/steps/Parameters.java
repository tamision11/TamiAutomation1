package glue.steps;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.google.common.base.CharMatcher;
import common.glue.steps.web.Step;
import common.glue.utilities.GeneralActions;
import entity.*;
import enums.ApplicationUnderTest;
import enums.ChatMessageType;
import enums.Domain;
import io.cucumber.java.DataTableType;
import io.cucumber.java.DocStringType;
import io.cucumber.java.ParameterType;
import io.netty.handler.codec.http.HttpScheme;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.hc.core5.net.URIBuilder;
import org.openqa.selenium.By;
import org.openqa.selenium.InvalidArgumentException;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.testng.SkipException;

import java.net.URISyntaxException;
import java.util.List;
import java.util.Objects;

/**
 * User: nirtal
 * Date: 10/02/2021
 * Time: 22:22
 * Created with IntelliJ IDEA
 * <p>
 * this class contains cucumber parameters suitable for all modules.
 */
public class Parameters extends Step {

    /**
     * @param webElement the needed webElement
     * @return webElement from page objects
     */
    @ParameterType(".*")
    public WebElement webElement(String webElement) {
        return switch (webElement) {
            case "enter email to see matches modal" -> matchingPage.getEnterEmailToSeeMatchesModal();
            case "Starred messages panel" ->
                    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("#ID_STARRED_MESSAGES_PANEL")));
            case "dialog" -> wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector("[role=dialog]")));
            case "are you in a messaging session dialog" ->
                    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("[data-qa=keepMessagingModal]")));
            case "form" -> wait.until(ExpectedConditions.visibilityOfElementLocated(commonWebPage.getFormLocator()));
            case "treatment intake chat message" -> treatmentIntakePage.getTreatmentIntakeChatMessage();
            case "My information section" ->
                    wait.until(ExpectedConditions.visibilityOf(personalInformationPage.getMyInformationSection()));
            case "treatment intake modal" -> treatmentIntakePage.getTreatmentIntakeModal();
            case "next renewal dialog" ->
                    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("[data-qa=nextRenewalPaymentDetailsView]")));
            case "home page registration box" ->
                    wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector("#registrationBox")));
            case "Login and security panel" ->
                    wait.until(ExpectedConditions.visibilityOf(loginAndSecurityPage.getLoginInfoPanel()));
            case "Payment and plan panel" ->
                    wait.until(ExpectedConditions.visibilityOf(paymentAndPlanPage.getPlanInfoPanel()));
            case "matches filters button" ->
                    wait.until(ExpectedConditions.visibilityOf(matchingPage.getButtonMatchesFilters()));
            case "client dashboard" -> wait.until(ExpectedConditions.visibilityOf(roomPage.getClientDashboard()));
            case "superbills intro text" ->
                    wait.until(ExpectedConditions.visibilityOf(superBillsWebPage.getSuperbillsIntroText()));
            case "superbills name confirmation intro" ->
                    wait.until(ExpectedConditions.visibilityOf(superBillsWebPage.getSuperbillsNameConfirmationIntro()));
            case "name on superbill intro" ->
                    wait.until(ExpectedConditions.visibilityOf(superBillsWebPage.getNameOnSuperbillText()));
            case "therapist will be notified text" ->
                    wait.until(ExpectedConditions.visibilityOf(paymentAndPlanPage.getTherapistWilleNotifiedText()));
            case "therapist avatar" ->
                    wait.until(ExpectedConditions.visibilityOf(paymentAndPlanPage.getTherapistAvatar()));
            case "therapist name" -> wait.until(ExpectedConditions.visibilityOf(paymentAndPlanPage.getTherapistName()));
            case "provider profile" ->
                    wait.until(ExpectedConditions.visibilityOfElementLocated(roomPage.getProviderDetailsPanel()));
            case "provider profile - license section" ->
                    wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//h2[contains(text(), 'Licenses')]")));
            case "date of birth input" ->
                    wait.until(ExpectedConditions.visibilityOf(commonWebPage.getInputReactDateOfBirth()));
            case "email input" -> wait.until(ExpectedConditions.visibilityOf(loginWebPage.getInputEmail()));
            case "guardian email input" ->
                    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("[placeholder='Guardian email']")));
            case "nickname input" ->
                    wait.until(ExpectedConditions.visibilityOf(loginAndSecurityPage.getInputNickname()));
            case "update email input" ->
                    wait.until(ExpectedConditions.visibilityOf(loginAndSecurityPage.getInputNewEmail()));
            case "confirm update email input" ->
                    wait.until(ExpectedConditions.visibilityOf(loginAndSecurityPage.getInputConfirmationNewEmail()));
            case "email verification" ->
                    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("[data-qa=emailVerificationEmail]")));
            case "requesting alternative times" ->
                    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("[data-qa=inRoomSchedulingIncompatibleTimes]")));
            default -> throw new InvalidArgumentException("Unexpected value: " + webElement);
        };
    }

    /**
     * ignores the element in this list
     *
     * @param elementsToIgnore list of element names to ignore
     * @return list of web elements to ignore
     */
    @DataTableType
    public List<WebElement> ignoreElements(List<String> elementsToIgnore) {
        return elementsToIgnore.stream()
                .map(this::webElement)
                .toList();
    }

    @ParameterType(".*")
    public ValidationForm validationFormType(String formType) {
        return switch (formType) {
            //region BH
            case "shared" -> sharedNewFirstValidationPage;
            case "shared after upfront coverage verification" -> sharedValidationWebPageAfterUpfront;
            case "upfront coverage verification" -> upfrontCoverageVerification;
            //endregion
            //region EAP
            case "eap" -> eapNewFirstValidationPage;
            case "cigna eap" -> cignaEapNewFirstValidationPage;
            case "optum eap" -> optumEapNewFirstValidationPage;
            case "carelon eap" -> carelonEapValidationWebPage;
            case "kga eap" -> kgaEapValidationWebPage;
            //endregion
            //region DTE
            case "google" -> googleFirstValidationPage;
            case "broadway" -> broadwayvValidationWebPage;
            //endregion
            case "out of network" -> outOfNetworkValidationPage;
            default -> throw new InvalidArgumentException("Unexpected value: " + formType);
        };
    }

    /**
     * setting the application under test - for iframe handling.
     *
     * @return navigation url
     * @see <a href="https://stackoverflow.com/a/15111450/4515129">regex to match any number</a>
     */
    @ParameterType("flow[0-9]+|redemption|smb|demo page|client-web|home page|home page without ld parameters|refund wizard|therapist slug" +
            "|client-web sign up|recover-session|Eligibility by email landing page|Eligibility questions landing page" +
            "|psychiatrist slug|talkspace go|Baltimore landing page")
    public String url(String location) throws URISyntaxException {
        //region QM
        if (location.contains("flow")) {
            scenarioContext.setApplicationUnderTest(ApplicationUnderTest.QUICKMATCH);
            return new URIBuilder()
                    .setScheme(HttpScheme.HTTPS.toString())
                    .setHost(GeneralActions.isRunningOnProd() ? "match.talkspace.com" : "match.%s.talkspace.com".formatted(data.getConfiguration().getDomain()))
                    .setParameter("flowId", CharMatcher.inRange('0', '9').retainFrom(location))
                    .setParameter(data.getConfiguration().getLdAutomationParameter(), BooleanUtils.TRUE)
                    .build()
                    .toString();
        }
        //endregion
        else {
            return switch (location) {
                //region QM
                case "recover-session" -> new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(GeneralActions.isRunningOnProd() ? "match.talkspace.com" : "match.%s.talkspace.com".formatted(data.getConfiguration().getDomain()))
                        .setParameter(data.getConfiguration().getLdAutomationParameter(), BooleanUtils.TRUE)
                        .build()
                        .toString();
                case "home page" -> {
                    scenarioContext.setApplicationUnderTest(ApplicationUnderTest.QUICKMATCH);
                    yield new URIBuilder()
                            .setScheme(HttpScheme.HTTPS.toString())
                            .setHost(GeneralActions.isRunningOnProd() ? "www.talkspace.com" : "www.%s.talkspace.com".formatted(data.getConfiguration().getDomain()))
                            .setParameter(data.getConfiguration().getLdAutomationParameter(), BooleanUtils.TRUE)
                            .build()
                            .toString();
                }
                // was added to test SMB redirects
                case "home page without ld parameters" -> {
                    scenarioContext.setApplicationUnderTest(ApplicationUnderTest.QUICKMATCH);
                    yield GeneralActions.isRunningOnProd() ? "https://www.talkspace.com/" : String.format("https://www.%s.talkspace.com/", data.getConfiguration().getDomain());
                }
                case "smb" ->
                        GeneralActions.isRunningOnProd() ? "https://smb.talkspace.com" : String.format("https://smb.%s.talkspace.com", data.getConfiguration().getDomain());
                case "demo page" -> "https://business.talkspace.com/demo";
                case "redemption" -> {
                    scenarioContext.setApplicationUnderTest(ApplicationUnderTest.QUICKMATCH);
                    yield GeneralActions.isRunningOnProd() ? "https://redemption.talkspace.com/redemption/test" : String.format("https://redemption.%s.talkspace.com/redemption/test", data.getConfiguration().getDomain());
                }
                case "Eligibility by email landing page" -> {
                    scenarioContext.setApplicationUnderTest(ApplicationUnderTest.QUICKMATCH);
                    yield GeneralActions.isRunningOnProd() ? "https://redemption.talkspace.com/redemption/kaskaskia" : String.format("https://redemption.%s.talkspace.com/redemption/kaskaskia", data.getConfiguration().getDomain());
                }
                case "talkspace go" -> {
                    if (!data.getConfiguration().getDomain().equals(Domain.DEV.getName()) && !data.getConfiguration().getDomain().equals(Domain.PROD.getName())) {
                        throw new SkipException("Talkspace Go is not supported on %s environment".formatted(data.getConfiguration().getDomain()));
                    }
                    scenarioContext.setApplicationUnderTest(ApplicationUnderTest.QUICKMATCH);
                    yield new URIBuilder()
                            .setScheme(HttpScheme.HTTPS.toString())
                            .setHost(GeneralActions.isRunningOnProd() ? "go.talkspace.com" : "go.%s.talkspace.com".formatted(data.getConfiguration().getDomain()))
                            .setPath("/choose")
                            .setParameter(data.getConfiguration().getLdAutomationParameter(), BooleanUtils.TRUE)
                            .build()
                            .toString();
                }
                case "Eligibility questions landing page" -> {
                    scenarioContext.setApplicationUnderTest(ApplicationUnderTest.QUICKMATCH);
                    yield new URIBuilder()
                            .setScheme(HttpScheme.HTTPS.toString())
                            .setHost(GeneralActions.isRunningOnProd() ? "try.talkspace.com" : "try.%s.talkspace.com".formatted(data.getConfiguration().getDomain()))
                            .setPath("/online-therapy/1")
                            .setParameter(data.getConfiguration().getLdAutomationParameter(), BooleanUtils.TRUE)
                            .build()
                            .toString();
                }
                case "Baltimore landing page" -> {
                    if (!data.getConfiguration().getDomain().equals(Domain.DEV.getName()) && !data.getConfiguration().getDomain().equals(Domain.PROD.getName())) {
                        throw new SkipException("Talkspace Go is not supported on %s environment".formatted(data.getConfiguration().getDomain()));
                    }
                    scenarioContext.setApplicationUnderTest(ApplicationUnderTest.QUICKMATCH);
                    yield GeneralActions.isRunningOnProd() ? "https://redemption.talkspace.com/redemption/bcpsredeem" : String.format("https://redemption.%s.talkspace.com/redemption/bcpsredeem", data.getConfiguration().getDomain());
                }
                //endregion
                //region client-web
                case "client-web sign up" -> {
                    scenarioContext.setApplicationUnderTest(ApplicationUnderTest.CLIENT_WEB);
                    yield GeneralActions.isRunningOnProd() ? "https://app.talkspace.com/signup" : String.format("https://app.%s.talkspace.com/signup", data.getConfiguration().getDomain());
                }
                case "refund wizard" -> {
                    scenarioContext.setApplicationUnderTest(ApplicationUnderTest.CLIENT_WEB);
                    yield GeneralActions.isRunningOnProd() ? "https://publicapi.talkspace.com/v1/redir?link=/dl/?to=/refund-purchase/source/email" : String.format("https://publicapi.%s.talkspace.com/v1/redir?link=/dl/?to=/refund-purchase/source/email", data.getConfiguration().getDomain());
                }
                case "therapist slug" -> {
                    scenarioContext.setApplicationUnderTest(ApplicationUnderTest.CLIENT_WEB);
                    yield GeneralActions.isRunningOnProd() ? "https://app.talkspace.com/signup/autoswitchpt" : String.format("https://app.%s.talkspace.com/signup/autoswitchpt", data.getConfiguration().getDomain());
                }
                case "psychiatrist slug" -> {
                    scenarioContext.setApplicationUnderTest(ApplicationUnderTest.CLIENT_WEB);
                    yield GeneralActions.isRunningOnProd() ? "https://app.talkspace.com/signup/autoswitchPSY" : String.format("https://app.%s.talkspace.com/signup/autoswitchPSY", data.getConfiguration().getDomain());
                }
                case "client-web" -> {
                    scenarioContext.setApplicationUnderTest(ApplicationUnderTest.CLIENT_WEB);
                    yield GeneralActions.isRunningOnProd() ? "https://app.talkspace.com/" : String.format("https://app.%s.talkspace.com/", data.getConfiguration().getDomain());
                }
                //endregion
                default -> throw new InvalidArgumentException("Unexpected value: " + location);
            };
        }
    }

    /**
     * @param providerType provider type
     * @return therapist type
     */
    @ParameterType("therapist|therapist2|therapist3|therapist4|psychiatrist|noAvailabilityTherapist|therapistLanguage|psychiatristLanguage")
    public Provider provider(String providerType) {
        var therapist = data.getProvider().get(data.getConfiguration().getDomain()).get(providerType);
        Objects.requireNonNull(therapist, String.format("Provider '%s' does not exist in '%s' environment", providerType, data.getConfiguration().getDomain()));
        return therapist;
    }

    /**
     * @param chatMessages list of chat messages
     * @return List of chat messages
     */
    @DataTableType
    public List<ChatMessageType> getChatMessages(List<String> chatMessages) {
        return chatMessages
                .stream()
                .map(ChatMessageType::valueOf)
                .toList();
    }

    /**
     * Gets the {@link User} from {@link Data#getUsers()} that is mapped to the JSON object in data.json with the specified key (userType), or returns null if user is not found.
     * Primary and partner users are created before each scenario and manually inserted into the mapping.
     * <p>
     * inPlatformMatching: user for testing expired matches suggested by the CT.
     * canceledRoom: user with a canceled subscription.
     * expiredUser: user with an expired BH plan room.
     * 2faUs: user with a US phone number updated and direct access on <a href="https://www.twilio.com/">twilio</a>.
     *
     * @param userType The type/name of the pre-existing user we want to get the User object of, or "new" for returning null
     * @return User object of the specified pre-existing user, or null
     */
    @ParameterType("inPlatformMatching|expiredUser|pastDueUser|starring|primary|partner|.*Superbills.*|2fa.*|mobileStarring|parent|guardian")
    public User user(String userType) {
        return data.getUsers().get(userType);
    }

    /**
     * transformation of a docstring to json node.
     *
     * @param docString received as a parameter
     * @return json node.
     * @throws JsonProcessingException if an error occurs while processing the JSON.
     */
    @DocStringType
    public ObjectNode json(String docString) throws JsonProcessingException {
        return objectMapper.readValue(docString, ObjectNode.class);
    }

    /**
     * When running on prod, we use the credit card details from the system properties.
     *
     * @param cardType the card type we complete purchase with
     * @return credit card object
     */
    @ParameterType("visa|insufficientFunds|masterCard")
    public CreditCard cardType(String cardType) {
        if (GeneralActions.isRunningOnProd()) {
            // Assuming these properties are set before calling this method
            String cardNumber = System.getProperty("cardNumber");
            String cardHolderName = System.getProperty("cardHolderName");
            String cvv = System.getProperty("cvv");
            String zipCode = System.getProperty("zipcode");
            String expirationDate = System.getProperty("expiration");
            return CreditCard.createCard()
                    .withCardNumber(cardNumber)
                    .withCardHolderName(cardHolderName)
                    .withCvv(cvv)
                    .withZipCode(zipCode)
                    .withExpirationDate(expirationDate)
                    .create();
        } else {
            CreditCard creditCard = data.getCreditCards().get(cardType);
            if (creditCard == null) {
                // Handle the case when the card type is not found in the data
                throw new IllegalArgumentException("Invalid card type: " + cardType);
            }
            return creditCard;
        }
    }

    /**
     * @param indexDescription the desired index in an array of options.
     * @return the given numeric position in the option array.
     */
    @ParameterType("first|second|third|fourth")
    public int optionIndex(String indexDescription) {
        return switch (indexDescription) {
            case "first" -> 0;
            case "second" -> 1;
            case "third" -> 2;
            case "fourth" -> 3;
            default -> throw new InvalidArgumentException("Unexpected value: " + indexDescription);
        };
    }

    @ParameterType("matching|treatment")
    public String intakeType(String type) {
        return type;
    }
}
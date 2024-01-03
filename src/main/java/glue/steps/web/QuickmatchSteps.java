package glue.steps.web;

import annotations.Frame;
import entity.User;
import entity.ValidationForm;
import enums.Us_States;
import enums.data.BhMemberIDType;
import enums.data.Locations;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.qameta.allure.Allure;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.InvalidArgumentException;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.devtools.v120.emulation.Emulation;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static enums.FrameTitle.CHECK_MY_COVERAGE;
import static enums.FrameTitle.REACTIVATION;
import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;
import static org.openqa.selenium.support.ui.ExpectedConditions.visibilityOfElementLocated;

/**
 * User: nirtal
 * Date: 10/02/2021
 * Time: 22:32
 * Created with IntelliJ IDEA
 */
public class QuickmatchSteps extends Step {

    /**
     * @param validationForm type of validation form.
     * @param userDetails    <table>
     *                       <thead>
     *                       <th>the data to be used to create the room</th>
     *                       <thead>
     *                       <tbody>
     *                       <tr><td>state</td><td>the user {@link Us_States}</td></tr>
     *                       <tr><td>birthdate</td><td>predefined birthdate - have priority over age</td></tr>
     *                       <tr><td>age</td><td>the user age</td></tr>
     *                       <tr><td>member id</td><td>optional field {@link BhMemberIDType}</td></tr>
     *                       <tr><td>service type</td><td>optional field {@link enums.ServiceType} - some flows have only therapy service</td></tr>
     *                       <tr><td>employee relation</td><td>{@link enums.EmployeeRelation}</td></tr>
     *                       <tr><td>email</td><td>{@link enums.UserEmailType}</td></tr>
     *                       <tr><td>phone number </td><td> if this field exists we will enter user phone</td></tr>
     *                       <tr><td>authorization code expiration </td><td> <a href="https://talktala.atlassian.net/browse/AUTOMATION-3025">options are: past date / future date / invalid future date - relevant for optum and cigna</a> </td></tr>
     *                       <tr><td>address</td><td>{@link enums.Address} defaults to US unless specified, need to specify {@link Us_States} in case not specified</td></tr>
     *                       <tr><td>school</td><td>for nyc teens only, in case "other" will be selected the scenario start time will be entered</td></tr>
     *                       </tbody>
     *                       </table>
     * @throws InterruptedException if the current thread was interrupted while waiting
     * @see <a href="https://talktala.atlassian.net/wiki/spaces/QA/pages/2781511780/flows">member/keyword/auth/org_name based on flows </a>
     */
    @When("Complete {validationFormType} validation form for {user} user")
    public void completeValidationForm(ValidationForm validationForm, User user, Map<String, String> userDetails) throws InterruptedException {
        validationForm.enterDetails(user, userDetails);
        b2b.clickOnContinueButton();
    }

    @And("Select the option {string}")
    public void selectOption(String optionSelection) {
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//button[contains(text() ,'" + optionSelection + "')]")));
        b2b.selectOption(optionSelection);
    }

    /**
     * this step overrides the geolocation
     */
    @And("Location is set to {}")
    public void setGeoLocation(Locations location) {
        devTools.send(Emulation.setGeolocationOverride(Optional.of(location.getLatitude()), Optional.of(location.getLongitude()), Optional.of(1)));
    }

    @Then("Payment - Click on continue")
    public void paymentClickOnContinue() {
        driver.findElement(By.xpath("//*[text() = 'Continue to checkout']")).click();
    }

    /**
     * inside {@link enums.FrameTitle#REACTIVATION} frame
     */
    @Frame({REACTIVATION})
    @Then("Reactivation payment - Click on continue")
    public void reactivationPaymentClickOnContinue() {
        driver.findElement(By.xpath("//*[text() = 'Continue to checkout']")).click();
    }

    /**
     * Sends the user verification code.
     *
     * @param user the {@link User} that will subscribe to the plan
     */
    @And("Enter verification code for {user} user")
    public void inAppQMEnterTheVerificationCode(User user) {
        wait.until(visibilityOfElementLocated(By.cssSelector("[data-qa=verificationCodeInput0]")));
        for (int i = 0; i < 4; i++) {
            wait.until(elementToBeClickable(By.cssSelector("[data-qa=verificationCodeInput%d]".formatted(i))))
                    .sendKeys(Character.toString(user.getVerificationCode().charAt(i)));
        }
    }

    /**
     * Sends "0000"
     */
    @And("Enter invalid verification code")
    public void inAppQMEnterInvalidVerificationCode() {
        wait.until(visibilityOfElementLocated(By.cssSelector("[data-qa=verificationCodeInput0]")));
        for (int i = 0; i < 4; i++) {
            wait.until(elementToBeClickable(By.cssSelector("[data-qa=verificationCodeInput%d]".formatted(i))))
                    .sendKeys("0");
        }
    }

    /**
     * This method is used to answer a series of questions with specific options on QM.
     * It takes a map of question-answer pairs as input and iterates through the questions,
     * selecting the corresponding options based on the question key. The method supports various
     * question types and handles them accordingly.
     *
     * <table>
     *   <thead>
     *     <th>Question</th>
     *     <th>Description</th>
     *     <th>Answer Type</th>
     *   </thead>
     *   <tbody>
     *     <tr>
     *       <td>age</td>
     *       <td>The user's age.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td>seek help reason</td>
     *       <td>The reason for seeking help.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td>what do you need support with</td>
     *       <td>The specific support needed, comma separated list</td>
     *       <td>Multiple Answers</td>
     *     </tr>
     *     <tr>
     *       <td>why you thought about getting help from a provider</td>
     *       <td>The motivation for seeking help.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td><font color="red">NYC teens only - </font> does your school or city offer talkspace for free</td>
     *       <td>Availability of free Talkspace services.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td>looking for a provider that will</td>
     *       <td>Provider search criteria.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td>goals</td>
     *       <td>The user's therapy goals.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td>why you thought about getting help from a provider - multi select</td>
     *       <td>Motivation for seeking help (multiple options).</td>
     *       <td>Multiple Answers</td>
     *     </tr>
     *     <tr>
     *       <td>state</td>
     *       <td>The user's state.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td><font color="red">NYC teens only - </font> how do you feel about doing therapy</td>
     *       <td>Feelings about therapy, comma separated list</td>
     *       <td>Multiple Answers</td>
     *     </tr>
     * <tr>
     *       <td>provider gender preference</td>
     *       <td>The user's preference for provider gender.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td>type of relationship</td>
     *       <td>The type of relationship the user is seeking therapy for.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td>provider gender</td>
     *       <td>The gender of the preferred provider.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td>domestic violence</td>
     *       <td>Domestic violence-related question.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td>live with your partner</td>
     *       <td>The user's living arrangements with their partner.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td>sleeping habits</td>
     *       <td>The user's sleeping habits.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td>how often do you feel stressed</td>
     *       <td>The frequency of the user's stress levels.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td>have you talked to your parent or guardian about doing therapy</td>
     *       <td>Discussion with a parent or guardian about therapy.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td>your gender</td>
     *       <td>The user's gender.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td>prescribed medication to treat a mental health condition</td>
     *       <td>Prescription of medication for mental health.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td>physical health</td>
     *       <td>The user's physical health condition.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td>Parental consent</td>
     *       <td>Consent from parents.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td>ready</td>
     *       <td>The user's readiness for therapy.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *     <tr>
     *       <td>have you been to a provider before</td>
     *       <td>Prior experience with healthcare providers.</td>
     *       <td>Single Answer</td>
     *     </tr>
     *   </tbody>
     * </table>
     *
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2657/">QM - remove "I'm looking for a provider that will.." question in flow 90 (dispatcher\eligibility widget)</a>
     */
    @And("Complete the matching questions with the following options")
    public void genericQuestionSelectOptions(Map<String, String> table) {
        for (var entry : table.entrySet()) {
            Allure.addAttachment("Question", entry.getKey());
            switch (entry.getKey()) {
                case "age" -> {
                    if (!table.get(entry.getKey()).equals("Continue with prefilled age")) {
                        commonWebSteps.enterAge(NumberUtils.toInt(table.get(entry.getKey())));
                    }
                    wait.until(elementToBeClickable(flowWebPage.getDateOfBirthContinueButton())).click();
                }
                case "seek help reason",
                        "what do you need support with" -> {
                    var elements = wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=presentingProblemsRadioButton]")));
                    if (entry.getKey().equals("what do you need support with")) {
                        List.of(StringUtils.stripAll(entry.getValue().split(","))).forEach(option ->
                                elements.stream()
                                        .filter(element -> element.getText().contains(option))
                                        .findFirst()
                                        .ifPresent(WebElement::click));
                        wait.until(elementToBeClickable(flowWebPage.getButtonGotIt())).click();
                    } else {
                        elements.stream()
                                .filter(element -> element.getText().contains(entry.getValue()))
                                .findFirst()
                                .ifPresent(WebElement::click);
                    }
                }
                case "why you thought about getting help from a provider" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa=presentingProblemsRadioButton0]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "does your school or city offer talkspace for free" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=radioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "looking for a provider that will" -> {
                    commonWebPage.selectFromListTheOptionAndPressEscape(table.get(entry.getKey()));
                    flowWebPage.clickOnContinueButton();
                }
                case "goals" -> {
                    wait.until(ExpectedConditions.visibilityOf(flowWebPage.getTextGoals())).sendKeys(table.get(entry.getKey()));
                    commonWebPage.clickOnContinueButton();
                }
                case "got it" -> {
                    wait.until(elementToBeClickable(flowWebPage.getButtonGotIt())).click();
                }
                case "why you thought about getting help from a provider - multi select" -> {
                    commonWebPage.selectFromListTheOptionAndPressEscape(table.get(entry.getKey()));
                    wait.until(ExpectedConditions.elementToBeClickable(flowWebPage.getButtonSubmit())).click();
                }
                case "state" -> {
                    if (!table.get(entry.getKey()).equals("Continue with prefilled state")) {
                        commonWebPage.openDropdownAndSelect(Us_States.valueOf(table.get(entry.getKey())).getName());
                    }
                    flowWebPage.clickOnContinueButton();
                }
                case "how do you feel about doing therapy" -> {
                    List.of(StringUtils.stripAll(entry.getValue().split(","))).forEach(option ->
                            wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=select1RadioButton]"))).stream()
                                    .filter(element -> element.getText().contains(option))
                                    .filter(element -> element.getText().contains(option))
                                    .findFirst()
                                    .ifPresent(WebElement::click));
                    wait.until(elementToBeClickable(flowWebPage.getButtonGotIt())).click();
                }
                case "provider gender preference",
                        "type of relationship",
                        "provider gender",
                        "domestic violence",
                        "live with your partner",
                        "sleeping habits",
                        "how often do you feel stressed",
                        "have you talked to your parent or guardian about doing therapy",
                        "your gender",
                        "prescribed medication to treat a mental health condition",
                        "physical health",
                        "Parental consent",
                        "ready",
                        "have you been to a provider before" -> {
                    wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=select1RadioButton]")))
                            .stream()
                            .filter(element -> element.getText().contains(table.get(entry.getKey())))
                            .findFirst()
                            .ifPresent(WebElement::click);
                }
                default -> throw new InvalidArgumentException("Unexpected value: " + entry.getKey());
            }
        }
    }

    /**
     * inside {@link enums.FrameTitle#CHECK_MY_COVERAGE} frame
     *
     * @param table list of question and answers.
     */
    @Frame(CHECK_MY_COVERAGE)
    @And("Update my coverage - Complete the matching questions with the following options")
    public void genericQuestionSelectOptionsCheckCOverage(Map<String, String> table) {
        genericQuestionSelectOptions(table);
    }

    /**
     * @param table list of question and answers.
     */
    @And("Complete the assessment questions with the following options")
    public void assessmentQuestionSelectOptions(Map<String, String> table) {
        for (var entry : table.entrySet()) {
            switch (entry.getKey()) {
                case "Feeling nervous, anxious, or on edge" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardFeelingNervousAnxiousOrOnEdgeRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Not being able to stop or control worrying" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardNotBeingAbleToStopOrControlWorryingRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Worrying too much about different things" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardWorryingTooMuchAboutDifferentThingsRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Trouble relaxing" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardTroubleRelaxingRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Being so restless that it's hard to sit still" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardBeingSoRestlessThatItIsHardToSitStillRadioButton], [data-qa^=surveyWizardBeingSoRestlessThatItsHardToSitStillRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Becoming easily annoyed or irritable" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardBecomingEasilyAnnoyedOrIrritableRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Feeling afraid as if something awful might happen" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardFeelingAfraidAsIfSomethingAwfulMightHappenRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Little interest or pleasure in doing things" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardLittleInterestOrPleasureInDoingThingsRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Feeling down, depressed, or hopeless" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardFeelingDownDepressedOrHopelessRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Trouble falling or staying asleep, or sleeping too much" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardTroubleFallingOrStayingAsleepOrSleepingTooMuchRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Feeling tired or having little energy" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardFeelingTiredOrHavingLittleEnergyRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Poor appetite or overeating" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardPoorAppetiteOrOvereatingRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Feeling bad about yourself - or that you are a failure or have let yourself or your family down" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardFeelingBadAboutYourselfOrThatYouAreAFailureOrHaveLetYourselfOrYourFamilyDownRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Trouble concentrating on things, such as reading the newspaper or watching television" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardTroubleConcentratingOnThingsSuchAsReadingTheNewspaperOrWatchingTelevisionRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Moving or speaking so slowly that other people could have noticed. Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardMovingOrSpeakingSoSlowlyThatOtherPeopleCouldHaveNoticedOrTheOppositeBeingSoFidgetyOrRestlessThatYouHaveBeenMovingAroundALotMoreThanUsualRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Thoughts that you would be better off dead, or of hurting yourself" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardThoughtsThatYouWouldBeBetterOffDeadOrOfHurtingYourselfRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Please rate the current (i.e., last 2 weeks) SEVERITY of your insomnia problem - difficulty falling asleep" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardPleaseRateTheCurrentIELast2WeeksSeverityOfYourInsomniaProblemDifficultyFallingAsleepRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Please rate the current (i.e., last 2 weeks) SEVERITY of your insomnia problem - difficulty staying asleep" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardPleaseRateTheCurrentIELast2WeeksSeverityOfYourInsomniaProblemDifficultyStayingAsleepRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Please rate the current (i.e., last 2 weeks) SEVERITY of your insomnia problem - problem waking up too early" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardPleaseRateTheCurrentIELast2WeeksSeverityOfYourInsomniaProblemProblemWakingUpTooEarlyRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "How satisfied/dissatisfied are you with your current sleep pattern?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardHowSatisfiedDissatisfiedAreYouWithYourCurrentSleepPatternRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "To what extent do you consider your sleep problem to INTERFERE with your daily functioning (e.g., daytime fatigue, ability to function at work/daily chores, concentration, memory, mood, etc.)" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardToWhatExtentDoYouConsiderYourSleepProblemToInterfereWithYourDailyFunctioningEGDaytimeFatigueAbilityToFunctionAtWorkDailyChoresConcentrationMemoryMoodEtcRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "How NOTICEABLE to others do you think your sleeping problem is in terms of impairing the quality of your life?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardHowNoticeableToOthersDoYouThinkYourSleepingProblemIsInTermsOfImpairingTheQualityOfYourLifeRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "How WORRIED/distressed are you about your current sleep problem?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardHowWorriedDistressedAreYouAboutYourCurrentSleepProblemRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Felt moments of sudden terror, fear, or fright in social situations" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardFeltMomentsOfSuddenTerrorFearOrFrightInSocialSituationsRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Felt anxious, worried, or nervous about social situations" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardFeltAnxiousWorriedOrNervousAboutSocialSituationsRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Had thoughts of being rejected, humiliated, embarrassed, ridiculed, or offending others" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardHadThoughtsOfBeingRejectedHumiliatedEmbarrassedRidiculedOrOffendingOthersRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Felt a racing heart, sweaty, trouble breathing, faint, or shaky in social situations" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardFeltARacingHeartSweatyTroubleBreathingFaintOrShakyInSocialSituationsRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Felt tense muscles, felt on edge or restless, or had trouble relaxing in social situations" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardFeltTenseMusclesFeltOnEdgeOrRestlessOrHadTroubleRelaxingInSocialSituationsRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Avoided, or did not approach or enter, social situations" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardAvoidedOrDidNotApproachOrEnterSocialSituationsRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Left social situations early or participated only minimally (e.g., said little, avoided eye contact)" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardLeftSocialSituationsEarlyOrParticipatedOnlyMinimallyEGSaidLittleAvoidedEyeContactRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Spend a lot of time preparing what to say or how to act in social situations" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardSpendALotOfTimePreparingWhatToSayOrHowToActInSocialSituationsRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Distracted myself to avoid thinking about social situations" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardDistractedMyselfToAvoidThinkingAboutSocialSituationsRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Needed help to cope with social situations (e.g., alcohol or medications, superstitious objects)" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardNeededHelpToCopeWithSocialSituationsEGAlcoholOrMedicationsSuperstitiousObjectsRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "In the past week, I felt happier or more cheerful than usual" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardInThePastWeekIFeltHappierOrMoreCheerfulThanUsualRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "In the past week, I felt more self-confident than usual" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardInThePastWeekIFeltMoreSelfConfidentThanUsualRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "In the past week, I needed less sleep than usual" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardInThePastWeekINeededLessSleepThanUsualRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "In the past week, I talked more than usual" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardInThePastWeekITalkedMoreThanUsualRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "In the past week, I have been more active than usual (either socially, sexually, at work, home or school)" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardInThePastWeekIHaveBeenMoreActiveThanUsualEitherSociallySexuallyAtWorkHomeOrSchoolRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "I have saved up so many things that they get in the way" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardIHaveSavedUpSoManyThingsThatTheyGetInTheWayRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "I check things more often than necessary" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardICheckThingsMoreOftenThanNecessaryRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "I get upset if objects are not arranged properly" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardIGetUpsetIfObjectsAreNotArrangedProperlyRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "I feel compelled to count while I am doing things" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardIFeelCompelledToCountWhileIAmDoingThingsRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "I find it difficult to touch an object when I know it has been touched by strangers or certain people" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardIFindItDifficultToTouchAnObjectWhenIKnowItHasBeenTouchedByStrangersOrCertainPeopleRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "I find it difficult to control my own thoughts" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardIFindItDifficultToControlMyOwnThoughtsRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "I collect things I don't need" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardICollectThingsIDontNeedRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "I repeatedly check doors, windows, drawers, etc" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardIRepeatedlyCheckDoorsWindowsDrawersEtcRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "I get upset if others change the way I have arranged things" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardIGetUpsetIfOthersChangeTheWayIHaveArrangedThingsRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "I feel I have to repeat certain numbers" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardIFeelIHaveToRepeatCertainNumbersRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "I sometimes have to wash or clean myself simply because I feel contaminated" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardISometimesHaveToWashOrCleanMyselfSimplyBecauseIFeelContaminatedRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "I am upset by unpleasant thoughts that come into my mind against my will" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardIAmUpsetByUnpleasantThoughtsThatComeIntoMyMindAgainstMyWillRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "I avoid throwing things away because I am afraid I might need them later" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardIAvoidThrowingThingsAwayBecauseIAmAfraidIMightNeedThemLaterRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "I repeatedly check gas and water taps and light switches after turning them off" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardIRepeatedlyCheckGasAndWaterTapsAndLightSwitchesAfterTurningThemOffRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "I need things to be arranged in a particular way" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardINeedThingsToBeArrangedInAParticularWayRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "I feel that there are good and bad numbers" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardIFeelThatThereAreGoodAndBadNumbersRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "I wash my hands more often and longer than necessary" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardIWashMyHandsMoreOftenAndLongerThanNecessaryRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "I frequently get nasty thoughts and have difficulty in getting rid of them" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardIFrequentlyGetNastyThoughtsAndHaveDifficultyInGettingRidOfThemRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Have any of your closest relationships been troubled by a lot of arguments or repeated breakups?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardHaveAnyOfYourClosestRelationshipsBeenTroubledByALotOfArgumentsOrRepeatedBreakupsRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Have you deliberately hurt yourself physically (e.g., punched yourself, cut yourself, burned yourself)? How about made a suicide attempt?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardHaveYouDeliberatelyHurtYourselfPhysicallyEGPunchedYourselfCutYourselfBurnedYourselfHowAboutMadeASuicideAttemptRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Have you had at least two other problems with impulsivity (e.g., eating binges and spending sprees, drinking too much and verbal outbursts)?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardHaveYouHadAtLeastTwoOtherProblemsWithImpulsivityEGEatingBingesAndSpendingSpreesDrinkingTooMuchAndVerbalOutburstsRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Have you been extremely moody?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardHaveYouBeenExtremelyMoodyRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Have you felt very angry a lot of the time? How about often acted in an angry or sarcastic manner?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardHaveYouFeltVeryAngryALotOfTheTimeHowAboutOftenActedInAnAngryOrSarcasticMannerRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Have you often been distrustful of other people?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardHaveYouOftenBeenDistrustfulOfOtherPeopleRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Have you frequently felt unreal or as if things around you were unreal?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardHaveYouFrequentlyFeltUnrealOrAsIfThingsAroundYouWereUnrealRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Have you chronically felt empty?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardHaveYouChronicallyFeltEmptyRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Have you often felt that you had no idea of who you are or that you have no identity?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardHaveYouOftenFeltThatYouHadNoIdeaOfWhoYouAreOrThatYouHaveNoIdentityRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Have you made desperate efforts to avoid feeling abandoned or being abandoned (e.g., repeatedly called someone to reassure yourself that he or she still cared, begged them not to leave you, clung to them physically)?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardHaveYouMadeDesperateEffortsToAvoidFeelingAbandonedOrBeingAbandonedEGRepeatedlyCalledSomeoneToReassureYourselfThatHeOrSheStillCaredBeggedThemNotToLeaveYouClungToThemPhysicallyRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Repeated, disturbing, and unwanted memories of the stressful experience?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardRepeatedDisturbingAndUnwantedMemoriesOfTheStressfulExperienceRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Repeated, disturbing dreams of the stressful experience?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardRepeatedDisturbingDreamsOfTheStressfulExperienceRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Suddenly feeling or acting as if the stressful experience were actually happening again (as if you were actually back there reliving it)?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardSuddenlyFeelingOrActingAsIfTheStressfulExperienceWereActuallyHappeningAgainAsIfYouWereActuallyBackThereRelivingItRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Feeling very upset when something reminded you of the stressful experience?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardFeelingVeryUpsetWhenSomethingRemindedYouOfTheStressfulExperienceRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Having strong physical reactions when something reminded you of the stressful experience (for example, heart pounding, trouble breathing, sweating)?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardHavingStrongPhysicalReactionsWhenSomethingRemindedYouOfTheStressfulExperienceForExampleHeartPoundingTroubleBreathingSweatingRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Avoiding memories, thoughts, or feelings related to the stressful experience?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardAvoidingMemoriesThoughtsOrFeelingsRelatedToTheStressfulExperienceRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Avoiding external reminders of the stressful experience (for example, people, places, conversations, activities, objects, or situations)?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardAvoidingExternalRemindersOfTheStressfulExperienceForExamplePeoplePlacesConversationsActivitiesObjectsOrSituationsRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Trouble remembering important parts of the stressful experience?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardTroubleRememberingImportantPartsOfTheStressfulExperienceRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Having strong negative beliefs about yourself, other people, or the world (for example, having thoughts such as: I am bad, there is something seriously wrong with me, no one can be trusted, the world is completely dangerous)?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardHavingStrongNegativeBeliefsAboutYourselfOtherPeopleOrTheWorldForExampleHavingThoughtsSuchAsIAmBadThereIsSomethingSeriouslyWrongWithMeNoOneCanBeTrustedTheWorldIsCompletelyDangerousRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Blaming yourself or someone else for the stressful experience or what happened after it?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardBlamingYourselfOrSomeoneElseForTheStressfulExperienceOrWhatHappenedAfterItRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Having strong negative feelings such as fear, horror, anger, guilt, or shame?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardHavingStrongNegativeFeelingsSuchAsFearHorrorAngerGuiltOrShameRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Loss of interest in activities that you used to enjoy?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardLossOfInterestInActivitiesThatYouUsedToEnjoyRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Feeling distant or cut off from other people?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardFeelingDistantOrCutOffFromOtherPeopleRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Trouble experiencing positive feelings (for example, being unable to feel happiness or have loving feelings for people close to you)?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardTroubleExperiencingPositiveFeelingsForExampleBeingUnableToFeelHappinessOrHaveLovingFeelingsForPeopleCloseToYouRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Irritable behavior, angry outbursts, or acting aggressively?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardIrritableBehaviorAngryOutburstsOrActingAggressivelyRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Taking too many risks or doing things that could cause you harm?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardTakingTooManyRisksOrDoingThingsThatCouldCauseYouHarmRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Being \"superalert\" or watchful or on guard?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardBeingSuperalertOrWatchfulOrOnGuardRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Feeling jumpy or easily startled?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardFeelingJumpyOrEasilyStartledRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Having difficulty concentrating?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardHavingDifficultyConcentratingRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                case "Trouble falling or staying asleep?" ->
                        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=surveyWizardTroubleFallingOrStayingAsleepRadioButton]")))
                                .stream()
                                .filter(element -> element.getText().contains(table.get(entry.getKey())))
                                .findFirst()
                                .ifPresent(WebElement::click);
                default -> throw new IllegalStateException("Unexpected value: " + entry.getKey());
            }
        }
    }
}
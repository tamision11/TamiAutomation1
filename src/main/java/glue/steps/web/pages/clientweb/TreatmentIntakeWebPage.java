package glue.steps.web.pages.clientweb;

import common.glue.steps.web.pages.WebPage;
import entity.User;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import lombok.Getter;
import org.apache.commons.lang3.BooleanUtils;
import org.awaitility.Awaitility;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.NotFoundException;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.time.Duration;
import java.util.Objects;

import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;
import static org.openqa.selenium.support.ui.ExpectedConditions.visibilityOf;

@Getter
public class TreatmentIntakeWebPage extends WebPage {

    // region elements without data-qa
    @FindBy(xpath = "//button[contains(text(), 'Treatment Intake')]")
    private WebElement buttonTreatmentIntake;
    @FindAll({
            @FindBy(xpath = "//button[contains(text(), 'Emergency Resources')]"),
            @FindBy(css = "[data-qa=viewEmergencyResourcesButton]")
    })
    private WebElement emergencyResourcesLink;
    @FindBy(xpath = "//button[contains(text(), 'Treatment Intake')]/parent::div/parent::div/parent::div")
    private WebElement treatmentIntakeChatMessage;
    @FindBy(css = "div#react-aria-modal-dialog > div > div > div")
    private WebElement treatmentIntakeModal;
    @FindBy(css = "input[placeholder='First Name']")
    private WebElement inputFirstName;
    @FindBy(css = "input[placeholder='Last Name']")
    private WebElement inputLastName;
    @FindBy(css = "input[placeholder='Middle Name']")
    private WebElement inputMiddleName;
    @FindBy(css = "input[placeholder='Full name']")
    private WebElement inputFullName;
    @FindBy(css = "div[role=option]")
    private WebElement inputHomeAddressDropdownOption;
    @FindBy(css = "input[type=text]")
    private WebElement inputEmergencyContactFullName;
    @FindBy(css = "input#address")
    private WebElement inputHomeAddress;
    //endregion
    @FindBy(css = "[data-qa=medicalIntakeOtcMedicationsMultiLineTextArea]")
    private WebElement overTheCounterMedicationTextArea;
    @FindBy(css = "[data-qa=consenterFirstNameInput]")
    private WebElement consenterFirstNameInput;
    @FindBy(css = "[data-qa=consenterLastNameInput]")
    private WebElement consenterLastNameInput;
    @FindBy(css = "[data-qa=acceptTermsCheckbox]")
    private WebElement acceptTermsCheckbox;
    @FindBy(css = "[data-qa=submitParentalConsentFormButton]")
    private WebElement submitParentalConsentFormButton;
    @FindBy(css = "[data-qa=medicalIntakeDrugAllergiesMultiLineTextArea]")
    private WebElement drugAndAllergiesTextArea;
    @FindBy(css = "[data-qa=medicalIntakeControlledSubstancesPrimaryButton]")
    private WebElement submitButton;
    @FindBy(css = "[data-qa=consenterAlsoEmergencyContactCheckbox]")
    private WebElement consenterAlsoEmergencyContactCheckbox;
    @FindBy(css = "[data-qa=conesnterRadioOptionParent]")
    private WebElement consenterRadioOptionParent;
    @FindBy(css = "[data-qa=conesnterRadioOptionGuardian]")
    private WebElement consenterRadioOptionGuardian;
    @FindBy(css = "[data-qa=conesnterRadioOptionExemption]")
    private WebElement consenterRadioOptionExemption;
    @FindBy(css = "[data-qa=mentalIntakePreviousRelativesMentalHealthIssuesSecondaryButton]")
    private WebElement previousRelativesMentalHealthIssuesQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakeHospitalizationHistoryPrimaryButton]")
    private WebElement previousTeensHospitalizationQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakePreviousMentalHealthIssuesSecondaryButton]")
    private WebElement skipPreviousTeensRelativesMentalHealthIssuesQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakePreviousMentalHealthIssuesPrimaryButton]")
    private WebElement continuePreviousTeensRelativesMentalHealthIssuesQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakeControlledSubstancesSecondaryButton]")
    private WebElement skipPreviousTeensUseSubstancesQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakeExperiencingSchoolCommunitySecondaryButton]")
    private WebElement skipSchoolIssuesQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakeExperiencingSchoolCommunityPrimaryButton]")
    private WebElement continueSchoolIssuesQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakeExperiencingSocialMediaSecondaryButton]")
    private WebElement skipSocialMediaIssuesQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakeExperiencingSocialMediaPrimaryButton]")
    private WebElement continueSocialMediaIssuesQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakeSuicideIdeationPrimaryButton]")
    private WebElement teensSuicideIdeationQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakeSuicidePlanningPrimaryButton]")
    private WebElement teensSuicidePlanningQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakeHomicidalIdeationPrimaryButton]")
    private WebElement teensHomocideIdeationQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakeHomicidalPlanningPlanningPrimaryButton]")
    private WebElement teensHomocidePlanningQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakeTraumaticExperiencePrimaryButton]")
    private WebElement teensTraumaticeEventQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakeTraumaticFlashbacksPrimaryButton]")
    private WebElement teensDreamsQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakeGuiltPrimaryButton]")
    private WebElement teensGuiltQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakeIsolationPrimaryButton]")
    private WebElement teensDistantQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakeControlledSubstancesPrimaryButton]")
    private WebElement teensSubstancesQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakeSleepQualityPrimaryButton]")
    private WebElement teensSleepQualityQuestionButton;
    @FindBy(css = "[data-qa=mentalIntakeAngerAggressionPrimaryButton]")
    private WebElement teensExcesssiveAngerQuestionButton;
    @FindBy(css = "[data-qa=medicalIntakeMedicalIssuesSecondaryButton]")
    private WebElement medicalIntakeMedicalIssuesSecondaryButton;
    @FindBy(css = "[data-qa=medicalIntakeMedicationsSecondaryButton]")
    private WebElement medicalIntakeMedicationsSecondaryButton;
    @FindBy(css = "[data-qa=emergencyContactPhoneSecondaryButton]")
    private WebElement emergencyContactPhoneSecondaryButton;
    @FindBy(css = "[data-qa=medicalIntakeOtcMedicationsSecondaryButton]")
    private WebElement medicalIntakeOtcMedicationsSecondaryButton;
    @FindBy(css = "[data-qa=medicalIntakePharmacyAddressSecondaryButton]")
    private WebElement medicalIntakePharmacyAddressSecondaryButton;
    @FindBy(css = "[data-qa=medicalIntakeDrugAllergiesSecondaryButton]")
    private WebElement medicalIntakeDrugAllergiesSecondaryButton;
    @FindBy(css = "[data-qa=medicalIntakeControlledSubstancesSecondaryButton]")
    private WebElement medicalIntakeControlledSubstancesSecondaryButton;
    @FindBy(css = "[data-qa=continueToMedicalHistoryButton]")
    private WebElement continueToMedicalHistoryButton;
    @FindBy(css = "[data-qa=mentalIntakeEmergencyResourcesSecondaryButton]")
    private WebElement nextTreatmentIntakeButton;
    @FindBy(css = "[data-qa=emailInput]")
    private WebElement emailInput;
    @FindBy(css = "[data-qa=emergencyContactContactNamePrimaryButton]")
    private WebElement teensIntakeContinueDesignateEmergencyContactButton;
    @FindBy(css = "[data-qa=emergencyContactRelationshipPrimaryButton]")
    private WebElement teensIntakeContinueRelationshipToYouButton;
    @FindBy(css = "[data-qa=emergencyContactContactPhonePrimaryButton]")
    private WebElement teensIntakeContinueContactPhoneNumberButton;
    @FindBy(css = "[data-qa=emergencyContactNamePrimaryButton]")
    private WebElement teensIntakeContinueYourFullNameButton;
    @FindBy(css = "[data-qa=emergencyContactRaceOrEthnicityPrimaryButton]")
    private WebElement teensIntakeContinueWhichRaceButton;
    @FindBy(css = "[data-qa=emergencyContactAddressPrimaryButton]")
    private WebElement teensIntakeContinueYourAddressButton;
    @FindBy(css = "[data-qa=emergencyContactPhonePrimaryButton]")
    private WebElement teensIntakeContinueYourPhoneNumberButton;
    @FindBy(css = "[data-qa=intakeTeensNextHospitilized]")
    private WebElement mentalIntakeTeensHospitalizationHistoryPrimaryButton;
    @FindBy(css = "[data-qa=parentalConsentFormHasAlreadyBeenSignedLabel]")
    private WebElement parentalConsentFormHasAlreadyBeenSignedLabel;
    @FindBy(css = "[data-qa=parentalConsentFormHasBeenReceivedLabel]")
    private WebElement parentalConsentFormHasBeenReceivedLabel;
    private final By parentalConsentFirstName = By.cssSelector("[data-qa=firstNameInput], [data-qa=consenterFirstNameInput]");
    private final By parentalConsentLastName = By.cssSelector("[data-qa=lastNameInput], [data-qa=consenterLastNameInput]");
    private final By parentalConsentEmail = By.cssSelector("[data-qa=emailInput]");


    @And("Treatment Intake - Parental consent - Form has already been signed")
    public void parentalConsentFormHasAlreadyBeenSigned() {
        wait.until(visibilityOf(parentalConsentFormHasAlreadyBeenSignedLabel));
    }

    @And("Treatment Intake - Parental consent - Form has been received")
    public void submitted() {
        wait.until(visibilityOf(parentalConsentFormHasBeenReceivedLabel));
    }

    @When("Open treatment intake")
    public void openTreatmentIntake() {
        wait.until(elementToBeClickable(buttonTreatmentIntake)).click();
    }

    @And("Treatment Intake - Emergency contact - Enter emergency contact full name")
    public void treatmentIntakeEmergencyContactEnterEmergencyContactFullName() {
        wait.until(visibilityOf(inputEmergencyContactFullName)).sendKeys(data.getUserDetails().getEmergencyContact().get("fullName"));
    }

    @And("Treatment Intake - Medical History - enter over the counter medications")
    public void treatmentIntakeEnterOverTheCounterMedications() {
        overTheCounterMedicationTextArea.sendKeys("None");
    }

    @And("Treatment Intake - Medical History - enter drug allergies")
    public void treatmentIntakeEnterDrugAllergies() {
        drugAndAllergiesTextArea.sendKeys("None");
    }

    @And("Treatment Intake - Emergency contact - Enter {user} user first name")
    public void treatmentIntakeEmergencyContactEnterFirstName(User user) {
        wait.until(visibilityOf(inputFirstName)).sendKeys(user.getFirstName());
    }

    @And("Treatment Intake - Emergency contact - Enter {user} user last name")
    public void treatmentIntakeEmergencyContactEnterLastName(User user) {
        wait.until(visibilityOf(inputLastName)).sendKeys(data.getUserDetails().getLastName());
    }

    @And("Treatment Intake - Emergency contact - Enter {user} user middle name")
    public void treatmentIntakeEmergencyContactEnterMiddleName(User user) {
        wait.until(visibilityOf(inputMiddleName)).sendKeys(data.getUserDetails().getMiddleName());
    }

    @And("Treatment Intake - Emergency contact - Enter {user} user full name")
    public void treatmentIntakeEmergencyContactEnterFullName(User user) {
        wait.until(visibilityOf(inputFullName)).sendKeys(user.getFirstName() + user.getLastName());
    }

    @And("Treatment Intake - Parental consent - Select parent option")
    public void conesnterRadioOptionParent() {
        wait.until(elementToBeClickable(consenterRadioOptionParent)).click();
    }

    @And("Treatment Intake - Parental consent - Select guardian option")
    public void conesnterRadioOptionGuardian() {
        wait.until(elementToBeClickable(consenterRadioOptionGuardian)).click();
    }

    @And("Treatment Intake - Parental consent - Select I'm exempt from consent")
    public void consenterRadioOptionExemption() {
        wait.until(elementToBeClickable(consenterRadioOptionExemption)).click();
    }

    @And("Treatment Intake - Parental consent - check consent also emergency contact checkbox {}")
    public void consenterAlsoEmergencyContactCheckbox(boolean checked) {
        wait.until(elementToBeClickable(consenterAlsoEmergencyContactCheckbox)).click();
        wait.until(ExpectedConditions.attributeToBe(consenterAlsoEmergencyContactCheckbox, "aria-checked", BooleanUtils.toStringTrueFalse(checked)));
    }

    @And("Treatment Intake - Emergency contact - Enter home address of {user} user")
    @And("Treatment Intake - Medical history - Enter pharmacy address of {user} user")
    public void treatmentIntakeEmergencyContactEnterHomeAddress(User user) {
        if (inputHomeAddress.getAttribute("value").isEmpty()) {
            wait.until(visibilityOf(inputHomeAddress)).sendKeys(user.getAddress().getHomeAddress());
            wait.until(elementToBeClickable(inputHomeAddressDropdownOption)).click();
        }
    }

    @And("Treatment Intake - Clinical Information - Click on continue to medical history button")
    public void continueToMedicalHistoryButton() {
        wait.until(elementToBeClickable(continueToMedicalHistoryButton)).click();
    }

    @And("Treatment Intake - Click on next button")
    public void treatmentIntakeClickOnNextButton() {
        wait.until(elementToBeClickable(nextTreatmentIntakeButton)).click();
    }

    @And("Treatment Intake - Click on submit button")
    public void treatmentIntakeClickOnSubmitButton() {
        wait.until(elementToBeClickable(submitButton)).click();
    }

    @And("Treatment Intake - Skip Have any immediate relatives been diagnosed with or treated for any of the following mental health conditions question")
    public void previousRelativesMentalHealthIssuesQuestionButton() {
        wait.until(elementToBeClickable(previousRelativesMentalHealthIssuesQuestionButton)).click();
    }

    @And("Treatment Intake - Skip Are you currently being treated or have you ever been treated for any of the following medical issues question")
    public void skipButtonPreviousRelativesMentalHealthIssuesQuestionButton() {
        wait.until(elementToBeClickable(medicalIntakeMedicalIssuesSecondaryButton)).click();
    }

    @And("Treatment Intake - Skip Are you currently taking any of the following psychiatric medications question")
    public void medicalIntakeMedicationsSecondaryButton() {
        wait.until(elementToBeClickable(medicalIntakeMedicationsSecondaryButton)).click();
    }

    @And("Treatment Intake - Skip over-the-counter medications question")
    public void medicalIntakeOtcMedicationsSecondaryButton() {
        wait.until(elementToBeClickable(medicalIntakeOtcMedicationsSecondaryButton)).click();
    }

    @And("Treatment Intake - Skip what is your number question")
    public void emergencyContactPhoneSecondaryButton() {
        wait.until(elementToBeClickable(emergencyContactPhoneSecondaryButton)).click();
    }


    @And("Treatment Intake - Skip preferred pharmacy address question")
    public void medicalIntakePharmacyAddressSecondaryButton() {
        wait.until(elementToBeClickable(medicalIntakePharmacyAddressSecondaryButton)).click();
    }

    @And("Treatment Intake - Skip controlled substances question")
    public void medicalIntakeControlledSubstancesSecondaryButton() {
        wait.until(elementToBeClickable(medicalIntakeControlledSubstancesSecondaryButton)).click();
    }

    @And("Treatment Intake - Skip drug allergies question")
    public void medicalIntakeDrugAllergiesSecondaryButton() {
        wait.until(elementToBeClickable(medicalIntakeDrugAllergiesSecondaryButton)).click();
    }

    @Then("Click on emergency resource link")
    public void clickOnEmergencyResourceLink() {
        wait.until(elementToBeClickable(emergencyResourcesLink)).click();
    }

    /**
     * @param optionText the desired option text to select.
     */
    @And("Treatment Intake - Select from list the option {string}")
    public void treatmentIntakeSelectFromListTheOption(String optionText) {
        commonWebPage.openDropdown(0);
        commonWebPage.getDropdownOptions()
                .stream()
                .filter(webElement -> webElement.getText().equals(optionText))
                .findFirst()
                .orElseThrow(() -> new NotFoundException("The option '%s' is not found".formatted(optionText)))
                .click();
    }

    @And("Treatment Intake - Parental consent - Enter {user} first name")
    public void treatmentIntakeParentalConsentEnterFirstName(User user) {
        Awaitility
                .await()
                .atMost(Duration.ofSeconds(30))
                .ignoreExceptions()
                .until(() -> driver.findElements(parentalConsentFirstName)
                        .stream()
                        .filter(WebElement::isDisplayed)
                        .findFirst()
                        .orElseThrow(), Objects::nonNull)
                .sendKeys(user.getFirstName());
    }

    @And("Treatment Intake - Parental consent - Clear parent/guardian first name")
    public void clearFirstName() {
        Awaitility
                .await()
                .atMost(Duration.ofSeconds(30))
                .ignoreExceptions()
                .until(() -> driver.findElements(parentalConsentFirstName)
                        .stream()
                        .filter(WebElement::isDisplayed)
                        .findFirst()
                        .orElseThrow(), Objects::nonNull)
                .clear();
    }

    @And("Treatment Intake - Parental consent - Clear parent/guardian last name")
    public void clearLastName() {
        Awaitility
                .await()
                .atMost(Duration.ofSeconds(30))
                .ignoreExceptions()
                .until(() -> driver.findElements(parentalConsentLastName)
                        .stream()
                        .filter(WebElement::isDisplayed)
                        .findFirst()
                        .orElseThrow(), Objects::nonNull)
                .clear();
    }

    @And("Treatment Intake - Parental consent - Click on accept terms checkbox")
    public void setAcceptTermsCheckbox() {
        wait.until(visibilityOf(acceptTermsCheckbox)).click();
    }

    @And("Treatment Intake - Parental consent - Submit form")
    public void submitForm() {
        setAcceptTermsCheckbox();
        wait.until(visibilityOf(submitParentalConsentFormButton)).click();
    }

    @And("Treatment Intake - Parental consent - Enter {user} last name")
    public void treatmentIntakeParentalConsentEnterLastName(User user) {
        Awaitility
                .await()
                .atMost(Duration.ofSeconds(30))
                .ignoreExceptions()
                .until(() -> driver.findElements(parentalConsentLastName)
                        .stream()
                        .filter(WebElement::isDisplayed)
                        .findFirst()
                        .orElseThrow(), Objects::nonNull)
                .sendKeys(user.getLastName());
    }

    @And("Treatment Intake - Parental consent - Enter {user} email")
    @And("Treatment Intake - Parental consent - Enter {user} user email")
    public void treatmentIntakeParentalConsentEnterEmail(User user) {
        wait.until(ExpectedConditions.numberOfElementsToBe(parentalConsentEmail, 2))
                .stream()
                .filter(WebElement::isDisplayed)
                .findFirst()
                .orElseThrow()
                .sendKeys(user.getEmail());
    }

    @And("Treatment Intake - Parental consent - Click on submit consent button")
    @And("Treatment Intake - Parental consent - Click on continue button")
    public void treatmentIntakeParentalConsentSendFormButton() {
        wait.until(elementToBeClickable(submitParentalConsentFormButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on continue for Who would you like to designate as your emergency contact?")
    public void treatmentIntakeTeensContinueDesignateEmergencyContact() {
        wait.until(elementToBeClickable(teensIntakeContinueDesignateEmergencyContactButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on continue for What is their relationship to you?")
    public void treatmentIntakeTeensContinueRelationshipToYou() {
        wait.until(elementToBeClickable(teensIntakeContinueRelationshipToYouButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on continue for What is your emergency contact’s phone number?")
    public void treatmentIntakeTeensContinueContactPhoneNumber() {
        wait.until(elementToBeClickable(teensIntakeContinueContactPhoneNumberButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on continue for What is your full name?")
    public void treatmentIntakeTeensContinueYourFullName() {
        wait.until(elementToBeClickable(teensIntakeContinueYourFullNameButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on continue for Which race or ethnicity do you identify with?")
    public void treatmentIntakeTeensContinueWhichRace() {
        wait.until(elementToBeClickable(teensIntakeContinueWhichRaceButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on continue for What is your address?")
    public void treatmentIntakeTeensContinueYourAddress() {
        wait.until(elementToBeClickable(teensIntakeContinueYourAddressButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on continue for What is your phone number?")
    public void treatmentIntakeTeensContinueYourPhoneNumber() {
        wait.until(elementToBeClickable(teensIntakeContinueYourPhoneNumberButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on continue for Have you ever been hospitalized for psychiatric care?")
    public void treatmentIntakeTeensNextHospitalizedQuestionButton() {
        wait.until(elementToBeClickable(previousTeensHospitalizationQuestionButton)).click();
    }

    @And("Treatment Intake - Teens intake - Skip Which of the following mental health conditions have you been diagnosed with? question")
    public void treatmentIntakeTeensSkipTeensPreviousRelativesMentalHealthIssuesQuestionButton() {
        wait.until(elementToBeClickable(skipPreviousTeensRelativesMentalHealthIssuesQuestionButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on continue for Which of the following mental health conditions have you been diagnosed with?")
    public void treatmentIntakeTeensContinueTeensPreviousRelativesMentalHealthIssuesQuestionButton() {
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", continuePreviousTeensRelativesMentalHealthIssuesQuestionButton);
    }

    @And("Treatment Intake - Teens intake - Click on next for Have you ever had specific thoughts of killing yourself? question")
    public void treatmentIntakeTeensNextSuicideQuestionButton() {
        wait.until(elementToBeClickable(teensSuicideIdeationQuestionButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on continue for Have you ever thought about how you might do this? suicide question")
    public void treatmentIntakeTeensNextSuicidePlanningQuestionButton() {
        wait.until(elementToBeClickable(teensSuicidePlanningQuestionButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on next for Have you ever had thoughts about harming or killing others? question")
    public void treatmentIntakeTeensNextHomocideQuestionButton() {
        wait.until(elementToBeClickable(teensHomocideIdeationQuestionButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on continue for Have you ever thought about how you might do this? homicide question")
    public void treatmentIntakeTeensNextHomicidePlanningQuestionButton() {
        wait.until(elementToBeClickable(teensHomocidePlanningQuestionButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on next for Do you have excessive anger behaviors? question")
    public void treatmentIntakeTeensNextExcessiveAngerQuestionButton() {
        wait.until(elementToBeClickable(teensExcesssiveAngerQuestionButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on next for Have you experienced an especially frightening, horrible, or traumatic event? question")
    public void treatmentIntakeTeensNextTraumaticEventQuestionButton() {
        wait.until(elementToBeClickable(teensTraumaticeEventQuestionButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on next for In the past 30 days, have you struggled with thoughts or dreams of the event? question")
    public void treatmentIntakeTeensNextDreamsQuestionButton() {
        wait.until(elementToBeClickable(teensDreamsQuestionButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on next for In the past 30 days, have you felt guilty or blamed yourself for what happened? question")
    public void treatmentIntakeTeensNextGuiltQuestionButton() {
        wait.until(elementToBeClickable(teensGuiltQuestionButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on next for In the past 30 days, have you felt distant from others or stopped enjoying your usual activities? question")
    public void treatmentIntakeTeensNextDistantQuestionButton() {
        wait.until(elementToBeClickable(teensDistantQuestionButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on next for Do you currently use or have you used any of the following substances? question")
    public void treatmentIntakeTeensNextSubstancesQuestionButton() {
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", teensSubstancesQuestionButton);
    }

    @And("Treatment Intake - Teens intake - Click on next for How would you describe your sleep quality? question")
    public void treatmentIntakeTeensNextSleepQualityQuestionButton() {
        wait.until(elementToBeClickable(teensSleepQualityQuestionButton)).click();
    }

    @And("Treatment Intake - Teens intake - Skip Do you currently use or have you used any of the following substances? question")
    public void treatmentIntakeTeensSkipUseSubstancesQuestionButton() {
        wait.until(elementToBeClickable(skipPreviousTeensUseSubstancesQuestionButton)).click();
    }

    @And("Treatment Intake - Teens intake - Skip Which of the following are you experiencing at school or in your community? question")
    public void treatmentIntakeTeensSkipSchoolIssuesQuestionButton() {
        wait.until(elementToBeClickable(skipSchoolIssuesQuestionButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on continue on Which of the following are you experiencing at school or in your community? question")
    public void treatmentIntakeTeensContinueSchoolIssuesQuestionButton() {
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", continueSchoolIssuesQuestionButton);
    }

    @And("Treatment Intake - Teens intake - Skip Which of the following have you experienced through social media? question")
    public void treatmentIntakeTeensSkipSocialMediaIssuesQuestionButton() {
        wait.until(elementToBeClickable(skipSocialMediaIssuesQuestionButton)).click();
    }

    @And("Treatment Intake - Teens intake - Click on continue Which of the following have you experienced through social media? question")
    public void treatmentIntakeTeensContinueSocialMediaIssuesQuestionButton() {
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", continueSocialMediaIssuesQuestionButton);
    }
}
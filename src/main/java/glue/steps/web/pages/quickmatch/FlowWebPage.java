package glue.steps.web.pages.quickmatch;

import annotations.Frame;
import common.glue.steps.web.pages.WebPage;
import enums.ServiceType;
import enums.data.AuthCode;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import lombok.Getter;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;

import static enums.FrameTitle.CHECK_MY_COVERAGE;
import static enums.FrameTitle.REACTIVATION;
import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;

@Getter
public class FlowWebPage extends WebPage {

    @FindBy(css = "[data-qa=returnButton]")
    private WebElement returnButton;
    @FindBy(css = "[data-qa=multiselectSubmit]")
    private WebElement buttonSubmit;
    @FindBy(css = "[data-qa=continueButton],[data-qa=inPlatformMatchContinueWithTherapist], [data-qa=dateOfBirthContinueButton]")
    private WebElement buttonContinueWithTherapist;
    @FindBy(css = "[data-qa=recommendMessagingStartWithMessagingButton]")
    private WebElement recommendMessagingStartWithMessagingButton;
    @FindBy(css = "[data-qa=messagingInformationNextButton]")
    private WebElement messagingInformationNextButton;
    @FindBy(css = "[data-qa=messagingInformationConfirmSessionButton]")
    private WebElement messagingInformationConfirmSessionButton;
    @FindBy(css = "[data-qa=recommendMessagingStartWithLiveSessionButton]")
    private WebElement recommendMessagingStartWithLiveSessionButton;
    @FindBy(css = "[data-qa=qmSelectModalityContinueButton]")
    private WebElement qmSelectModalityContinueButton;
    @FindBy(css = "[data-qa=organizationInput]")
    private WebElement inputOrganization;
    @FindBy(css = "[data-qa=hasKeywordButton]")
    private WebElement buttonIHaveKeywordAccessCode;
    @FindBy(css = "[data-qa=continueWithoutCodeButton]")
    private WebElement buttonContinueWithoutCode;
    @FindBy(css = "input[placeholder^=Enter]")
    private WebElement inputAccessCode;
    @FindBy(css = "[data-qa=onlineTherapy]")
    private WebElement onlineTherapyService;
    @FindBy(css = "[data-qa=psychiatry]")
    private WebElement psychiatryService;
    @FindBy(css = "[data-qa=couplesTherapy]")
    private WebElement couplesTherapyService;
    @FindBy(css = "[data-qa=teenTherapy]")
    private WebElement teenTherapyservice;
    @FindBy(css = "[data-qa=b2bForkAlternativeButton]")
    private WebElement buttonIhaveTalkspaceThroughOrganization;
    @FindBy(css = "[data-qa=b2bForkDropdown]")
    private WebElement b2bForkDropdown;
    @FindBy(css = "[data-qa=b2bForkContinueButton]")
    private WebElement b2bForkContinueButton;
    @FindBy(css = "[data-qa=BaseReviewPlanContinueButton], [data-qa=continueWithInsurance]")
    private WebElement coverageVerificationContinueButton;
    @FindBy(css = "[data-qa=introduction1Button]")
    private WebElement buttonLetsStart;
    @FindBy(css = "[data-qa=describeGoalsTextArea]")
    private WebElement textGoals;
    @FindBy(css = "[data-qa=explanationContinue], [data-qa=presentingProblemsButtonsMultiContinueButton], [data-qa=select1ButtonsMultiContinueButton]")
    private WebElement buttonGotIt;
    @FindBy(css = "[data-qa=dateOfBirthContinueButton]")
    private WebElement dateOfBirthContinueButton;
    @FindBy(css = "[data-qa=dropdownContinueButton]")
    private WebElement continueButton;
    @FindBy(css = "[data-qa=oneFormEligibilitySkipOption]")
    private WebElement buttonSkip;
    @FindBy(css = "[data-qa=nextBackButton]")
    private WebElement buttonNext;
    private final By insuranceCheckQuestion = By.cssSelector("[data-qa=insuranceCheckQuestion]");
    @FindBy(css = "[data-qa=seeConsentExceptionsLink], [data-qa=teenConsentExceptionArticleLink]")
    private WebElement seeConsentExceptionsButton;

    /**
     * inside {@link enums.FrameTitle#CHECK_MY_COVERAGE} frame
     */
    @Frame({CHECK_MY_COVERAGE})
    @When("Select {} service")
    public void selectService(ServiceType serviceType) {
        selectServiceCucumber(serviceType);
    }

    private void selectServiceCucumber(ServiceType serviceType) {
        switch (serviceType) {
            case THERAPY -> wait.until(elementToBeClickable(onlineTherapyService)).click();
            case PSYCHIATRY -> wait.until(elementToBeClickable(psychiatryService)).click();
            case COUPLES_THERAPY -> wait.until(elementToBeClickable(couplesTherapyService)).click();
            case TEEN_THERAPY -> wait.until(elementToBeClickable(teenTherapyservice)).click();
        }
    }

    @And("Select to pay out of pocket")
    public void selectToPayOutOfPocket() {
        wait.until(ExpectedConditions.numberOfElementsToBe(insuranceCheckQuestion, 3))
                .get(1).click();
    }

    @And("Select to pay through insurance provider")
    public void selectThroughInsurance() {
        wait.until(ExpectedConditions.numberOfElementsToBe(insuranceCheckQuestion, 3))
                .get(0).click();
    }

    @And("Select to pay through an organization")
    public void selectThroughOrganization() {
        wait.until(ExpectedConditions.numberOfElementsToBe(insuranceCheckQuestion, 3))
                .get(2).click();
    }

    /**
     * inside {@link enums.FrameTitle#CHECK_MY_COVERAGE} frame
     */
    @Frame(CHECK_MY_COVERAGE)
    @And("Update my coverage - Select to pay out of pocket")
    public void updateCoverageSelectToPayOutOfPocket() {
        wait.until(ExpectedConditions.numberOfElementsToBe(insuranceCheckQuestion, 3))
                .get(1).click();
    }

    /**
     * inside {@link enums.FrameTitle#CHECK_MY_COVERAGE} frame
     */
    @Frame(CHECK_MY_COVERAGE)
    @And("Update my coverage - Select to pay through insurance provider")
    public void updateCoverageSelectThroughInsurance() {
        wait.until(ExpectedConditions.numberOfElementsToBe(insuranceCheckQuestion, 3))
                .get(0).click();
    }

    /**
     * inside {@link enums.FrameTitle#CHECK_MY_COVERAGE} frame
     */
    @Frame(CHECK_MY_COVERAGE)
    @And("Update my coverage - Select to pay through an organization")
    public void updateCoverageSelectThroughOrganization() {
        wait.until(ExpectedConditions.numberOfElementsToBe(insuranceCheckQuestion, 3))
                .get(2).click();
    }

    /**
     * inside {@link enums.FrameTitle#REACTIVATION} frame
     */
    @Frame(REACTIVATION)
    @When("Reactivation - Select {} service")
    public void selectReactivationService(ServiceType serviceType) {
        selectServiceCucumber(serviceType);
    }

    /**
     * inside {@link enums.FrameTitle#CHECK_MY_COVERAGE} frame
     */
    @Frame(CHECK_MY_COVERAGE)
    @When("Write {string} in organization name")
    public void inAppQMWriteInOrganizationName(String organization) {
        wait.until(ExpectedConditions.visibilityOf(inputOrganization)).sendKeys(data.getUserDetails().getOrganizationName().get(organization));
    }

    /**
     * inside {@link enums.FrameTitle#REACTIVATION} frame
     */
    @Frame(REACTIVATION)
    @When("Reactivation - Write {string} in organization name")
    public void reactivationInAppQMWriteInOrganizationName(String organization) {
        wait.until(ExpectedConditions.visibilityOf(inputOrganization)).sendKeys(data.getUserDetails().getOrganizationName().get(organization));
    }

    @And("Click on I have talkspace through an organization")
    public void dispatcherClickOnIhaveTalkspaceThroughOrganization() {
        wait.until(elementToBeClickable(buttonIhaveTalkspaceThroughOrganization)).click();
    }

    @And("Continue without insurance provider after selecting {string}")
    @And("Continue with {string} insurance provider")
    public void genericQuestionSelectFromList(String optionText) {
        wait.until(ExpectedConditions.elementToBeClickable(b2bForkDropdown)).click();
        wait.until(ExpectedConditions.numberOfElementsToBeMoreThan(By.cssSelector("[id^=react-select]"), 30));
        actions.sendKeys(optionText)
                .sendKeys(Keys.ENTER)
                .build()
                .perform();
        b2bForkContinueButton.click();
    }

    @And("Continue with pre selected {string} insurance provider")
    public void continueWithInsuranceProvider(String insuranceProvider) {
        wait.until(ExpectedConditions.textToBePresentInElement(b2bForkDropdown, insuranceProvider));
        b2bForkContinueButton.click();
    }


    @Then("QM - Click on continue button")
    public void clickOnContinueButton() {
        wait.until(elementToBeClickable(continueButton)).click();
    }

    @Then("Click on Let's start button")
    public void questionClickOnLetSStartButton() {
        wait.until(elementToBeClickable(buttonLetsStart)).click();
    }

    @And("Click on next button to approve you are ready to begin")
    public void approveReadyToBegin() {
        wait.until(elementToBeClickable(buttonNext)).click();
    }

    /**
     * Click on the button for skipping the flow without insurance
     */
    @When("Click on Continue without insurance button")
    public void genericInputClickOnSkipButton() {
        wait.until(ExpectedConditions.elementToBeClickable(buttonSkip)).click();
    }

    @And("Click on GOT IT!")
    public void flowClickOnGOTIT() {
        wait.until(elementToBeClickable(buttonGotIt)).click();
    }

    @And("Click on continue on coverage verification")
    public void continueOnCoverageVerification() {
        wait.until(elementToBeClickable(coverageVerificationContinueButton)).click();
    }

    @And("Click on I have a keyword or access code button")
    public void inAppQMClickOnButtonIHaveAKeywordOrAccessCodeIsAvailable() {
        wait.until(elementToBeClickable(buttonIHaveKeywordAccessCode)).click();
    }

    @And("Click on continue without code")
    public void inAppQMClickOnButtonContinueWithoutCodeIsAvailable() {
        wait.until(elementToBeClickable(buttonContinueWithoutCode)).click();
    }

    @When("Enter {} authorization code")
    public void enterAccessCode(AuthCode authCode) {
        wait.until(ExpectedConditions.visibilityOf(inputAccessCode)).sendKeys(authCode.getCode());
    }

    @When("Enter {string} access code")
    public void enterAccessCode(String accessCode) {
        wait.until(ExpectedConditions.visibilityOf(inputAccessCode)).sendKeys(data.getUserDetails().getOrganizationName().get(accessCode));
    }

    @Then("Click on continue with therapist button")
    @Then("Teens NYC - Click on continue button")
    public void clickOnContinueWithTherapistButton() {
        wait.until(elementToBeClickable(buttonContinueWithTherapist)).click();
    }

    @Then("Teens NYC - Click on See consent exceptions")
    public void clickOnSeeConsentExceptions() {
        wait.until(elementToBeClickable(seeConsentExceptionsButton)).click();
    }

    @Then("QM - Modality preference - Click on start with messaging button")
    public void clickOnRecommendMessagingStartWithMessagingButton() {
        wait.until(elementToBeClickable(recommendMessagingStartWithMessagingButton)).click();
    }

    @Then("QM - Modality preference - Click on start with live session button")
    public void clickOnRecommendMessagingStartWithLiveSessionButton() {
        wait.until(elementToBeClickable(recommendMessagingStartWithLiveSessionButton)).click();
    }

    @Then("QM - Modality preference - Click on continue button")
    public void clickOnSelectModalityContinueButton() {
        wait.until(elementToBeClickable(qmSelectModalityContinueButton)).click();
    }

    @Then("QM - Modality preference - Click on messaging information next button")
    public void clickOnMessagingInformationNextButton() {
        wait.until(elementToBeClickable(messagingInformationNextButton)).click();
    }

    @Then("QM - Modality preference - Click on messaging information confirm session button")
    public void clickOnMessagingInformationConfirmSessionButton() {
        wait.until(elementToBeClickable(messagingInformationConfirmSessionButton)).click();
    }

    @Then("Not eligible error page is displayed")
    public void notEligibleErrorPageIsDisplayed() {
        wait.until(elementToBeClickable(returnButton));
    }
}

package glue.steps.web.pages.quickmatch.b2b;

import com.google.common.util.concurrent.Uninterruptibles;
import common.glue.steps.web.pages.WebPage;
import common.glue.utilities.Constants;
import common.glue.utilities.GeneralActions;
import entity.User;
import enums.EmployeeRelation;
import enums.ServiceType;
import enums.UserEmailType;
import enums.data.AuthCode;
import enums.data.BhMemberIDType;
import io.cucumber.java.en.And;
import io.cucumber.java.en.When;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.nio.file.Paths;
import java.util.concurrent.TimeUnit;

import static org.apache.commons.lang3.SystemUtils.USER_DIR;
import static org.assertj.core.api.Assertions.assertThat;


/**
 * Created by emanuela.biro on 2/15/2019.
 * <p>
 * contains the generic methods applicable to all the B2B pages
 */
public class B2B_Web_Page extends WebPage {

    @FindBy(css = "[data-qa=retryCheckCoverage]")
    private WebElement retryButton;
    @FindBy(css = "[data-qa=okButton]")
    private WebElement okButton;
    private final By uploadFrontOfCard = By.cssSelector("[data-qa=uploadFrontOfCard]");
    @FindBy(css = "[data-qa=memberIDInput]")
    private WebElement memberIDInput;
    @FindBy(xpath = "//a[@data-qa='helpResourcesLink']/parent::p")
    private WebElement underAgeValidation;
    @FindBy(xpath = "//div[@data-qa='serviceTypeDropdown']/../following-sibling::p")
    private WebElement psychiatryUnderAgeValidation;
    @FindBy(css = "[data-qa=helpResourcesLink]")
    private WebElement helpResourcesLink;
    @FindBy(css = "[data-qa=serviceTypeDropdown]")
    private WebElement selectServiceDropdown;
    @FindBy(css = "[data-qa=verificationCheckboxCheckbox]")
    private WebElement verificationCheckbox;
    @FindBy(css = "[data-qa=zipCodeInput]")
    private WebElement inputZipCode;
    @FindBy(css = "[data-qa=memberAuthorizationCode], [data-qa=authorizationCodeInput], input[placeholder='Enter authorization code']")
    private WebElement inputAuthorizationCode;
    @FindBy(css = "[data-qa=emailInput], [data-qa=memberEmail], [name=email]")
    private WebElement inputEmail;
    @FindBy(css = "[data-qa=checkIfHaveCoveragePress]")
    private WebElement continueWithEapButton;
    @FindBy(css = "[data-qa=checkInformationCorrectAndResubmitPress]")
    private WebElement checkMyCoverageIsCorrectButton;
    @FindBy(css = "[data-qa=deleteFrontOfCard]")
    private WebElement deleteFrontOfCard;
    @FindBy(css = "[data-qa=continueWithoutInsurancePress]")
    private WebElement continueWithoutInsuranceButton;
    @FindBy(css = "[data-qa=surePlanCoversTalkspacePress]")
    private WebElement surePlanCoversTalkspaceButton;
    private final By uploadBackOfCard = By.cssSelector("[data-qa=uploadBackOfCard]");
    @FindBy(css = "[data-qa=oneFormEligibilityContinueButton], [data-qa=continueButton], [data-qa=shortEligibilityCTA]")
    private WebElement continueButton;
    @FindBy(css = "[data-qa=submitButton]")
    private WebElement submitButton;
    @FindBy(css = "[data-qa=titleText]")
    private WebElement weReceivedYourRequestHeader;
    @FindBy(css = "[data-qa=returnToMyAccountButton]")
    private WebElement returnToMyAccountButton;
    @FindBy(css = "[data-qa=employeeRelationDropdown]")
    private WebElement employeeRelationField;
    @FindBy(css = "[data-qa=employeeIDInput]")
    private WebElement inputEmployeeId;
    @FindBy(css = "[data-qa=heardAboutDropdown]")
    private WebElement referralDropdown;
    @FindBy(css = "[data-qa=dobInput-error]")
    private WebElement dobInputError;

    @When("Upfront coverage - under age message is displayed")
    public void dobInputError() {
        wait.until(ExpectedConditions.visibilityOf(dobInputError));
    }


    @When("Unified eligibility page - Enter {} employ relation")
    public void enterEmployeeRelation(EmployeeRelation employeeRelation) {
        commonWebPage.selectOptionFromDropdown(employeeRelationField::click, employeeRelation.getValue());
    }

    @And("Unified eligibility page - Enter zip code of {user} user")
    public void enterZipCode(User user) {
        inputZipCode.clear();
        inputZipCode.sendKeys(user.getAddress().getZipCode());
    }

    @When("Unified eligibility page - Enter employ id")
    public void enterEmployeeId() {
        inputEmployeeId.sendKeys(data.getUserDetails().getEmployeeId());
    }

    @And("Unified eligibility page - Enter referral")
    public void enterReferral() {
        commonWebPage.selectOptionFromDropdown(referralDropdown::click, data.getUserDetails().getReferral());
    }

    @When("Unified eligibility page - Click on continue button")
    public void clickOnContinueButton() {
        wait.until(ExpectedConditions.elementToBeClickable(continueButton)).click();
    }

    @When("Unified eligibility page - Click on retry button {int} time(s)")
    public void clickOnRetryButton(int times) {
        for (int i = 0; i < times; i++) {
            wait.until(ExpectedConditions.elementToBeClickable(retryButton)).click();
        }
    }

    @When("Unified eligibility page - Continue button is disabled")
    public void continueButtonIsDisabled() {
        wait.until(driver -> !continueButton.isEnabled());
    }

    @When("BH no insurance - User is redirected to the “Let's help you figure this out” page")
    public void userIsOnTheLetsFigureItOutPage() {
        wait.until(ExpectedConditions.presenceOfElementLocated(uploadFrontOfCard));
    }

    /**
     * will upload back and front image of insurance card
     */
    @When("BH no insurance - upload insurance card image")
    @When("BH no insurance - upload id card image")
    public void uploadInsuranceCard() {
        userIsOnTheLetsFigureItOutPage();
        uploadCardFront();
        driver.findElement(uploadBackOfCard).sendKeys(Paths.get(USER_DIR).getParent() + Constants.IMAGE_PATH);
    }

    @When("BH no insurance - Upload front of the card")
    public void uploadCardFront() {
        driver.findElement(uploadFrontOfCard).sendKeys(Paths.get(USER_DIR).getParent() + Constants.IMAGE_PATH);
    }

    @When("BH no insurance - Delete front of the card")
    public void deleteBackOfTheCard() {
        wait.until(ExpectedConditions.elementToBeClickable(deleteFrontOfCard)).click();
    }

    @And("BH no insurance - Click on continue with EAP button")
    public void clickOnContinueWithEapButton() {
        wait.until(ExpectedConditions.elementToBeClickable(continueWithEapButton)).click();
    }

    @And("BH no insurance - Click on I’m sure my plan covers Talkspace")
    public void clickOnSurePlanCoversTalkspaceButton() {
        wait.until(ExpectedConditions.elementToBeClickable(surePlanCoversTalkspaceButton)).click();
    }

    @And("BH no insurance - Click on check my coverage is correct button")
    public void clickOnCheckMyCoverageIsCorrectButton() {
        wait.until(ExpectedConditions.elementToBeClickable(checkMyCoverageIsCorrectButton)).click();
    }

    @And("BH no insurance - Click on continue without insurance")
    public void clickOnContinueWithoutInsuranceButton() {
        wait.until(ExpectedConditions.elementToBeClickable(continueWithoutInsuranceButton)).click();
    }

    @When("Unified eligibility page - Enter {} email")
    public void clickOnContinueButton(UserEmailType userEmailType) {
        inputEmail.clear();
        inputEmail.sendKeys(GeneralActions.getEmailAddress(userEmailType));
    }

    @When("Unified eligibility page - enter {} authorization code")
    public void enterAuthorizationCode(AuthCode authCode) {
        wait.until(ExpectedConditions.visibilityOf(inputAuthorizationCode)).sendKeys(authCode.getCode());
    }

    @When("Unified eligibility page - Click on verification checkbox")
    public void clickOnHelpResourcesLink() {
        wait.until(ExpectedConditions.elementToBeClickable(verificationCheckbox)).click();
    }

    @When("Unified eligibility page - Enter {} member id")
    public void enterMemberId(BhMemberIDType bhMemberIDType) {
        wait.until(ExpectedConditions.visibilityOf(memberIDInput)).clear();
        memberIDInput.sendKeys(bhMemberIDType.getMemberID());
    }

    @When("Unified eligibility page - Select {} service")
    public void clickOnContinueButton(ServiceType serviceType) {
        commonWebPage.selectOptionFromDropdown(selectServiceDropdown::click, serviceType.getName());
    }

    @And("Unified eligibility page - Click on submit button")
    public void clickOnSubmitButton() {
        wait.until(ExpectedConditions.elementToBeClickable(submitButton)).click();
    }

    @And("Unified eligibility page - Click on OK button")
    public void clickOnOkButton() {
        wait.until(ExpectedConditions.elementToBeClickable(okButton)).click();
    }

    @And("Unified eligibility page - Psychiatry under age message is displayed")
    public void newCheckUnderAgeError() {
        wait.until(ExpectedConditions.visibilityOf(psychiatryUnderAgeValidation));
        assertThat(psychiatryUnderAgeValidation)
                .extracting(WebElement::getText)
                .as("Under 18 validation")
                .isEqualTo("Talkspace does not offer psychiatry to individuals under 18.");
    }

    /**
     * @param age can be below 13 or below 18 to get the validation error.
     */
    @And("Unified eligibility page - Error Verification - Check for under {int} error message")
    public void newCheckUnderAgeError(int age) {
        if (age < 13) {
            assertThat(underAgeValidation)
                    .extracting(WebElement::getText)
                    .as("Under 13 validation")
                    .isEqualTo("Talkspace cannot provide service to individuals under the age of 13 at this time. If you or anyone you know are in a crisis or may be in danger, please use the following resources to get immediate help.");
        } else {
            assertThat(underAgeValidation)
                    .extracting(WebElement::getText)
                    .as("Under 18 validation")
                    .isEqualTo("Talkspace cannot provide service to individuals under the age of 18 at this time. If you or anyone you know are in a crisis or may be in danger, please use the following resources to get immediate help.");
        }
    }

    @When("Unified eligibility page - Click on the help resource")
    public void clickOnHelpResource() {
        helpResourcesLink.click();
    }

    public void selectOption(String optionName) {
        wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//button[contains(text() ,\"" + optionName + "\")]"))).click();
        Uninterruptibles.sleepUninterruptibly(500, TimeUnit.MILLISECONDS);
    }

    @And("BH no insurance - We’ve received your request text is displayed")
    public void bhNoInsuranceWeVeReceivedYourRequestTextIsDisplayed() {
        wait.until(ExpectedConditions.visibilityOf(weReceivedYourRequestHeader));
    }

    @And("BH no insurance - Click on return to my account")
    public void bhNoInsuranceClickOnReturnToMyAccount() {
        wait.until(ExpectedConditions.elementToBeClickable(returnToMyAccountButton)).click();
    }
}

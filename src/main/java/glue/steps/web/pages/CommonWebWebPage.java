package glue.steps.web.pages;

import annotations.Frame;
import com.google.common.util.concurrent.Uninterruptibles;
import dev.failsafe.Failsafe;
import dev.failsafe.RetryPolicy;
import entity.User;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import lombok.AccessLevel;
import lombok.Getter;
import org.apache.commons.lang3.StringUtils;
import org.awaitility.Awaitility;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NotFoundException;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.time.Duration;
import java.util.List;

import static enums.FrameTitle.REACTIVATION;
import static org.assertj.core.api.Assertions.assertThat;
import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;

@Getter
public class CommonWebWebPage extends WebPage {

    private static final String LIST_DROPDOWN_LOCATOR = "div[contains(@class, 'indicatorContainer')]";
    final By continueButtonsLocator = By.xpath("//input[@value = 'Continue'] | //button[contains(text(), 'Continue')] | //button/p[contains(text(), 'Continue')]");
    final By buttonSelectPlan = By.xpath("div/p[contains(text(), 'Select plan')]");
    final By planWrapper = By.cssSelector("div#ID_PAYMENT_CARD_WRAPPER");
    private final By formLocator = By.cssSelector("form");
    @Getter(value = AccessLevel.NONE)
    @FindBy(css = "[data-qa=offerID]")
    private WebElement hiddenOfferID;
    @FindAll({
            @FindBy(xpath = "//button[@id = 'paymentSubmitBtn' or contains(text(),'Next')]"),
            @FindBy(xpath = "//p[contains(text(), 'Next')]/parent::button"),
            @FindBy(css = "[data-qa=switchTherapistTherapistReviewSubmitButton], [data-qa=refundSelectRefundPrimaryButton], [data-qa=idealMatchSummaryNextButton], [data-qa=showMatchesButton]")
    })
    private WebElement buttonNext;
    @FindBy(css = "input[focusedplaceholder='mm/dd/yyyy'], [data-qa=dateOfBirthDateInput], [data-qa=dateOfBirthInput], [data-qa=memberDOB], [data-qa=DOBInput], [data-qa=matchingIntakeDateOfBirthDateInput]")
    private WebElement inputReactDateOfBirth;
    @FindBy(css = ("[id^=react-select]"))
    private List<WebElement> dropdownOptions;
    @FindBy(css = "[data-qa=SelectPlanContinueButton]")
    private List<WebElement> selectPlanContinueButton;
    @FindBy(xpath = "//button[contains(text(), 'Begin')]")
    private WebElement buttonBegin;
    @FindAll({
            @FindBy(xpath = "//button[contains(text(), 'Confirm')]"),
            @FindBy(css = "[data-qa=refundSubscriptionRefundEligiblePrimaryButton]"),
            @FindBy(css = "[data-qa=refundGoToSupportWhenOfferedRefundPrimaryButton]"),
            @FindBy(css = "[data-qa=refundLvsRefundEligiblePrimaryButton]"),
            @FindBy(css = "[data-qa=refundCopayRefundEligiblePrimaryButton]"),
    })
    private WebElement buttonConfirm;
    @FindBy(css = "div#ID_PAYMENT_CARD_WRAPPER")
    private List<WebElement> listOfPlans;
    @FindBy(css = "div[role=radio][aria-checked=false]")
    private WebElement buttonRadioUnchecked;
    @FindAll({
            @FindBy(xpath = "//button[contains(text() ,'I live in the US')]"),
            @FindBy(xpath = "//button[contains(text(), 'I live in a US Territory or outside of the US')]"),
            @FindBy(xpath = "//p[contains(text(), 'Live outside of the US?')]/parent::button"),
            @FindBy(xpath = "//p[contains(text(), 'Live in the US?')]/parent::button")
    })
    private WebElement buttonLocation;
    @FindBy(xpath = "//button[contains(@class, 'qa-submit-button') or contains(text(), 'Start Treatment') or contains(text(), 'Start Therapy')]")
    private WebElement buttonStartTreatment;
    @FindBy(xpath = "//*[contains(text(),'Done')]")
    private WebElement buttonDone;
    @FindBy(css = "input[type=tel]")
    private WebElement inputPhoneNumber;
    // region elements without data-qa

    @And("Select from list the option {string}")
    public void genericQuestionSelectFromList(String optionText) {
        openDropdownAndSelect(optionText);
    }

    @And("Refund wizard - Select from list the option {string}")
    public void refundWizardSelectFromList(String optionText) {
        Failsafe.with(RetryPolicy.builder()
                        .withMaxRetries(2)
                        .withDelay(Duration.ofSeconds(5)).build())
                .run(() -> genericQuestionSelectFromList(optionText));
    }

    /**
     * @return all dropdown options - used to validate them.
     */
    public List<String> openDropdownAndCollectOptions(int dropdownPosition) {
        openDropdown(dropdownPosition);
        var optionList = dropdownOptions
                .stream()
                .map(WebElement::getText)
                .filter(StringUtils::isNotBlank)
                .toList();
        openDropdown(dropdownPosition);
        return optionList;
    }

    /**
     * @param runnable - the action to open and close the dropdown
     * @return all dropdown options - used to validate them.
     */
    public List<String> openDropdownAndCollectOptions(Runnable runnable) {
        runnable.run();
        var optionList = dropdownOptions
                .stream()
                .map(WebElement::getText)
                .filter(StringUtils::isNotBlank)
                .toList();
        runnable.run();
        return optionList;
    }

    @And("Select multiple focus")
    public void selectMultipleFocus(List<String> values) {
        values.forEach(this::openDropdownAndSelectThenCloseDropdown);
    }


    /**
     * @param user the {@link User}.
     */
    @And("Treatment Intake - Emergency contact - Enter phone number of {user} user")
    @And("Treatment Intake - Emergency contact - Enter emergency contact phone number of {user} user")
    public void enterPhoneNumber(User user) {
        wait.until(ExpectedConditions.visibilityOf(inputPhoneNumber)).sendKeys(user.getPhoneNumber().substring(2));
    }

    @When("Click on confirm button")
    public void clickOnConfirmButton() {
        wait.until(elementToBeClickable(getButtonConfirm())).click();
    }

    @When("Click on the I live outside of the US button")
    @When("Click on I live in the US button")
    public void clickOnLiveInTheUSButton() {
        wait.until(elementToBeClickable(getButtonLocation())).click();
    }

    @Then("Click on next button")
    public void clickOnNextButton() {
        wait.until(ExpectedConditions.refreshed(elementToBeClickable(getButtonNext()))).click();
    }

    /**
     * this step also stores the offer id found in scenario context for later usage.
     *
     * @param planPosition based on the plan name
     */
    @When("Select the {optionIndex} plan")
    public void chooseSubscriptionSelectPlan(int planPosition) {
        commonWebPage.selectPlan(planPosition);
    }

    @And("Click on continue")
    public void clickOnContinueButton() {
        wait.until(ExpectedConditions.presenceOfElementLocated(getContinueButtonsLocator()));
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(5));
        var continueButtons = driver.findElements(getContinueButtonsLocator());
        wait.until(elementToBeClickable(continueButtons.stream()
                        .filter(WebElement::isDisplayed)
                        .findFirst()
                        .orElseThrow()))
                .click();
    }

    /**
     * inside {@link enums.FrameTitle#REACTIVATION} frame
     */
    @Frame(REACTIVATION)
    @And("Reactivation - Click on continue")
    public void reactivationClickOnContinueButton() {
        wait.until(ExpectedConditions.presenceOfElementLocated(getContinueButtonsLocator()));
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(5));
        var continueButtons = driver.findElements(getContinueButtonsLocator());
        wait.until(elementToBeClickable(continueButtons.stream()
                        .filter(WebElement::isDisplayed)
                        .findFirst()
                        .orElseThrow()))
                .click();
    }

    @And("Select from list the option {string} and press Escape")
    public void selectFromListTheOptionAndPressEscape(String optionText) {
        openDropdownAndSelectThenPressEscape(optionText);
    }

    public void openDropdownAndSelectThenPressEscape(String optionText) {
        openDropdownAndSelect(optionText);
        actions.sendKeys(Keys.ESCAPE)
                .build()
                .perform();
    }

    @When("Click on begin button")
    public void clickOnBeginButton() {
        wait.until(elementToBeClickable(buttonBegin)).click();
    }

    @And("Click on unchecked radio button")
    public void clickOnUncheckedRadioButton() {
        wait.until(elementToBeClickable(buttonRadioUnchecked)).click();
    }

    /**
     * using {@link #openDropdown(int)} selecting to close the dropdown.
     *
     * @param optionText the desired option text to select.
     */
    public void openDropdownAndSelectThenCloseDropdown(String optionText) {
        openDropdownAndSelect(optionText);
        openDropdown(0);
    }

    @Then("The error {string} is displayed")
    public void logInIShouldSeeTheError(String error) {
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//p[contains(text(), \"" + error + "\")]")));
        assertThat(driver.findElement(By.xpath("//p[contains(text(), \"" + error + "\")]")))
                .withFailMessage("The error message: %s was not found", error)
                .matches(WebElement::isDisplayed);
    }

    /**
     * @param optionText the desired option text to select.
     */
    public void openDropdownAndSelect(String optionText) {
        openDropdown(0).findElement(By.xpath("//div[contains(text(), \"" + optionText + "\")]")).click();
    }

    /**
     * @param dropdownPosition position/index of the dropdown from the top of the page (0 for the first dropdown)
     * @return the clicked element for opening the dropdown
     */
    public WebElement openDropdown(int dropdownPosition) {
        var dropdownLocator = "//".concat(LIST_DROPDOWN_LOCATOR);
        for (int i = 0; i < dropdownPosition; i++) {
            dropdownLocator = dropdownLocator.concat("/following::").concat(LIST_DROPDOWN_LOCATOR);
        }
        wait.until(elementToBeClickable(By.xpath(dropdownLocator))).click();
        return driver.findElement(By.xpath(dropdownLocator));
    }

    @When("Click on done button")
    public void profileConfirmationPopupClickOnDoneButton() {
        wait.until(elementToBeClickable(buttonDone)).click();
    }

    /**
     * @param openDropdown code that opens the dropdown
     * @param optionText   the desired option text to select.
     */
    public void selectOptionFromDropdown(Runnable openDropdown, String optionText) {
        openDropdown.run();
        dropdownOptions
                .stream()
                .filter(webElement -> webElement.getText().contains(optionText))
                .findFirst()
                .orElseThrow(() -> new NotFoundException("The option '%s' is not found".formatted(optionText)))
                .click();
    }

    /**
     * @param planPosition the plan position in the plan list.
     * @see <a href="https://talktala.atlassian.net/browse/CVR-928"> Develop new plans + pricing</a>
     */
    public void selectPlan(int planPosition) {
        Awaitility.await()
                .alias("Waiting for offer id to be displayed")
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(10))
                .ignoreExceptions()
                .until(() -> StringUtils.isNotBlank(hiddenOfferID.getAttribute("value")));
        wait.until(ExpectedConditions.visibilityOfElementLocated(planWrapper));
        wait.until(ExpectedConditions.visibilityOf(listOfPlans.get(planPosition))).findElement(buttonSelectPlan).click();
    }

    public void selectTime(String time) {
        By billingTimeText = By.xpath("//div[@id = 'ID_PAYMENT_CARD_WRAPPER' and @aria-checked = 'true']//span[contains(text(), \"" + time + "\")]");
        wait.until(elementToBeClickable(billingTimeText));
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(5));
        wait.until(ExpectedConditions.refreshed(elementToBeClickable(billingTimeText))).click();
    }
}
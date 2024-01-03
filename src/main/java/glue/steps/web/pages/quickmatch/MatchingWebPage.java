package glue.steps.web.pages.quickmatch;

import common.glue.steps.web.pages.WebPage;
import common.glue.utilities.GeneralActions;
import enums.UserEmailType;
import io.cucumber.java.en.And;
import io.cucumber.java.en.When;
import io.vavr.control.Try;
import lombok.Getter;
import org.assertj.core.api.Assumptions;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.util.List;

import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;
import static org.openqa.selenium.support.ui.ExpectedConditions.visibilityOf;

@Getter
public class MatchingWebPage extends WebPage {

    // region elements without data-qa
    @FindBy(xpath = "//button/p[contains(text(), 'Not now')]/parent::button")
    private WebElement buttonNotNow;
    @FindBy(xpath = "//button[contains(text(), 'Okay')]")
    private WebElement confirmHolidayButton;
    @FindBy(xpath = "//p[contains(text(), 'Skip')]/parent::button")
    private WebElement buttonDontShareEmail;
    @FindBy(css = "#react-aria-modal-dialog>div")
    private WebElement enterEmailToSeeMatchesModal;
    //endregion
    @FindBy(css = "input[data-qa=matchUpdateEmailEntry]")
    private WebElement inputEmail;
    @FindBy(css = "[data-qa=customerExpectationsSubmitButton]")
    private WebElement buttonImReady;
    @FindBy(css = "[data-qa^=customerExpectationsQuestion]")
    private List<WebElement> answers;
    @FindBy(css = "[data-qa=showMatchesButton]")
    private WebElement buttonShowMatches;
    @FindBy(css = "[data-qa=matches1Filters]")
    private WebElement buttonMatchesFilters;
    @FindBy(css = "[data-qa=cancelFiltersButton]")
    private WebElement buttonCancel;
    @FindBy(css = "[data-qa=qmDescribeIdealMatch]")
    private WebElement buttonDescribeIdealMatch;
    @FindBy(css = "[data-qa=selectDynamicRadioButton1], [data-qa=switchTherapistTherapistLanguageFilterTypeSecondaryButton]")
    private WebElement optionNonEnglishLanguage;
    @FindBy(css = "[data-qa=selectDynamicRadioButton0], [data-qa=switchTherapistTherapistLanguageFilterTypePrimaryButton]")
    private WebElement optionNonEnglishLanguageHardFilter;
    @FindBy(css = "[data-qa=detailedSummaryTextArea]")
    private WebElement inputTellUsMoreAboutYourPerfectMatch;
    @FindBy(css = "[data-qa=returnToResultsButton], [data-qa=takeMeBackToTheResultsPageButton]")
    private WebElement buttonTakeMeBackToResultsPage;
    @FindBy(css = "[data-qa=noMatchesSecureYourMatchButton]")
    private WebElement buttonSecureYourMatch;
    @FindAll({
            @FindBy(css = "[data-qa=webSelectProviderButton]"),
            @FindBy(xpath = "//button[contains(text(), 'Select')]"),
            @FindBy(xpath = "//button[contains(text(), 'SELECT')]"),
    })
    private List<WebElement> selectFirstProviderButton;

    @And("Click on secure your match button")
    public void clickOnSecureYouMatchButton() {
        wait.until(elementToBeClickable(buttonSecureYourMatch)).click();
    }

    @And("Select non-english as preferred language")
    @And("Select non-english as soft filter")
    public void selectNonEnglishLanguage() {
        wait.until(elementToBeClickable(optionNonEnglishLanguage)).click();
    }


    @And("Select english as preferred language")
    @And("Select non-english as hard filter")
    public void selectNonEnglishLanguageSoftFilter() {
        wait.until(elementToBeClickable(optionNonEnglishLanguageHardFilter)).click();
    }

    /**
     * email wall should only appear on QM where matches/no matches are found (should not appear on client-web eligibility).
     *
     * @param userEmailType the type of email to generate or to retrieve.
     */
    @And("Email wall - Click on continue after Inserting {} email")
    public void emailWallInsertEmail(UserEmailType userEmailType) {
        wait.until(visibilityOf(inputEmail)).sendKeys(GeneralActions.getEmailAddress(userEmailType));
        emailWallContinue();
    }

    /**
     * email wall should only appear on B2C flows on QM where matches/no matches are found (should not appear on client-web eligibility).
     */
    @And("Email wall - Click on continue button")
    public void emailWallContinue() {
        wait.until(elementToBeClickable(buttonShowMatches)).click();
    }

    /**
     * skips flow in case no matches found - on b2c happens on email wall and in b2b on provider selection.
     *
     * @param runnable code that continues the flow as usual
     */
    public void skipOnNoMatches(Runnable runnable) {
        Try.run(runnable::run)
                .onFailure(failure -> Assumptions.assumeThat(driver.findElements(By.cssSelector("[data-qa=noMatchesSecureYourMatchButton]")))
                        .withFailMessage("No matches Found - Skipping this scenario - Please verify no errors on matching algorithm found!")
                        .isEmpty());
    }

    /**
     * If the provider element is not found, we will check if the "no matches" page appears and skips the tests if so.
     * <p>
     * all the following cases do not contain an iframe.
     *
     * @param providerIndex the index of the provider in the list.
     */
    @When("Client Web - Select the {optionIndex} provider from the list")
    public void selectFirstProviderWithoutIframe(int providerIndex) {
        skipOnNoMatches(() -> wait.until(ExpectedConditions.visibilityOfAllElements(selectFirstProviderButton)).get(providerIndex).click());
    }
}

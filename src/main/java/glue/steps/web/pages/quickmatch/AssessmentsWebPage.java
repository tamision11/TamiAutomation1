package glue.steps.web.pages.quickmatch;

import common.glue.steps.web.pages.WebPage;
import common.glue.utilities.GeneralActions;
import enums.UserEmailType;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.awaitility.Awaitility;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.time.Duration;

import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;
import static org.openqa.selenium.support.ui.ExpectedConditions.visibilityOf;

public class AssessmentsWebPage extends WebPage {

    @FindBy(css = "[data-qa=surveyResultsShowResultsButton], [data-qa=showMatchesButton]")
    private WebElement buttonShowResults;
    @FindBy(css = "[data-qa=surveyResultsCTA]")
    private WebElement buttonGetMatchedWithProvider;
    @FindBy(css = "[data-qa=surveyResultsEmailTextInput], [data-qa=matchUpdateEmailEntry]")
    private WebElement inputEnterYourEmail;
    @FindBy(css = "button[data-qa^=surveyWizardThankYouForTakingTheTimeToCompleteYourPersonalAssessment]")
    private WebElement buttonSubmitAssessment;


    @And("Click on Submit assessment")
    public void assessmentClickOnSubmitAssessment() {
        wait.until(elementToBeClickable(buttonSubmitAssessment)).click();
    }

    /**
     * @param userEmailType the type of email to generate or to retrieve.
     */
    @When("Click on show results after Inserting {} email")
    public void assessmentShowResults(UserEmailType userEmailType) {
        wait.until(visibilityOf(inputEnterYourEmail)).sendKeys(GeneralActions.getEmailAddress(userEmailType));
        wait.until(visibilityOf(buttonShowResults)).click();
    }


    /**
     * @see <a href="https://talktala.atlassian.net/browse/CVR-814">As a user coming in through Assessments, I have a 75% chance of seeing a different CTA on the Results screen instead of "Match with a provider"</a>
     */
    @Then("Click on Get matched with a provider")
    public void assessmentClickOnGetMatchedWithAProvider() {
        Awaitility.await()
                .atMost(Duration.ofSeconds(5))
                .pollInterval(Duration.ofSeconds(1))
                .ignoreExceptions()
                .until(() -> {
                    buttonGetMatchedWithProvider.click();
                    return driver.findElements(By.cssSelector("[data-qa=surveyResultsCTA]")).isEmpty();
                });
    }
}
package glue.steps.web.pages.clientweb;

import annotations.Frame;
import com.google.common.util.concurrent.Uninterruptibles;
import common.glue.steps.web.pages.WebPage;
import io.cucumber.java.en.When;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.time.Duration;

import static enums.FrameTitle.CHECK_MY_COVERAGE;
import static enums.FrameTitle.REACTIVATION;
import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;

public class EligibilityWebPage extends WebPage {

    // region elements without data-qa
    @FindBy(xpath = "//button[contains(. , 'Continue to room')]")
    private WebElement buttonContinueToRoom;
    @FindBy(xpath = "//button[contains(. , 'Start Treatment') or contains(text(), 'Start therapy')]")
    private WebElement buttonStartTreatment;
    //endregion

    @When("Eligibility Widget - Click on start treatment button")
    public void eligibilityClickOnStartTreatmentButton() {
        wait.until(elementToBeClickable(buttonStartTreatment)).click();
    }

    /**
     * inside {@link enums.FrameTitle#CHECK_MY_COVERAGE} frame
     */
    @Frame(CHECK_MY_COVERAGE)
    @When("Click on continue to room button")
    public void eligibilityClickOnContinueToRoomButton() {
        wait.until(elementToBeClickable(buttonContinueToRoom)).click();
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(2));
    }

    /**
     * inside {@link enums.FrameTitle#REACTIVATION} frame
     */
    @Frame(REACTIVATION)
    @When("Reactivation - Click on continue to room button")
    public void reactivationClickOnContinueToRoomButton() {
        wait.until(elementToBeClickable(buttonContinueToRoom)).click();
    }
}
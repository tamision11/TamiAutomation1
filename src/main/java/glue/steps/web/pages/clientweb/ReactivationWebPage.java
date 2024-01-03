package glue.steps.web.pages.clientweb;

import com.google.common.util.concurrent.Uninterruptibles;
import common.glue.steps.web.pages.WebPage;
import io.cucumber.java.en.And;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.time.Duration;

import static org.openqa.selenium.support.ui.ExpectedConditions.*;

/**
 * Created by emanuela.biro on 2/27/2020.
 */
public class ReactivationWebPage extends WebPage {

    // region elements without data-qa
    @FindBy(xpath = "//p[contains(text(), 'Resubscribe to continue therapy')]")
    private WebElement buttonResubscribeToContinueTherapy;
    @FindBy(xpath = "//p[contains(text(), 'Resubscribe to continue therapy')]")
    private WebElement resubscribeBannerText;
    //endregion
    @FindBy(css = "[data-qa=panelHeaderPaymentAndPlanCloseButton]")
    private WebElement buttonClose;
    @FindAll({
            @FindBy(xpath = "//button[contains(text(), 'Match with a new therapist')]"),
            @FindBy(css = "[data-qa=currentProviderNewProviderButton]")
    })
    private WebElement buttonMatchWithNewProvider;
    @FindBy(css = "[data-qa=currentProviderContinueButton]")
    private WebElement buttonMatchWithSameProvider;

    @And("Click on Continue with same provider")
    public void reactivationClickOnContinueWithSameTherapist() {
        wait.until(elementToBeClickable(buttonMatchWithSameProvider)).click();
    }

    @And("Click on Match with a new provider")
    public void reactivationClickOnMatchWithNewTherapist() {
        wait.until(elementToBeClickable(buttonMatchWithNewProvider)).click();
    }

    @And("Click on Resubscribe to continue therapy")
    public void reactivationClickOnResubscribeToContinueTherapy() {
        wait.until(ExpectedConditions.refreshed(ExpectedConditions.elementToBeClickable(buttonResubscribeToContinueTherapy)));
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(5));
        wait.until(ExpectedConditions.refreshed(ExpectedConditions.elementToBeClickable(buttonResubscribeToContinueTherapy))).click();
    }

    /**
     * step that verify resubscribe banner text for regular registration.
     */
    @And("Resubscribe banner text appears")
    public void verifyResubscribeBannerText() {
        wait.until(refreshed(visibilityOf(resubscribeBannerText)));
    }

    @And("No Matches - Click on close button")
    public void noMatchesClose() {
        wait.until(elementToBeClickable(buttonClose)).click();
    }
}
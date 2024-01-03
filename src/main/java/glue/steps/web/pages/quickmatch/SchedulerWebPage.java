package glue.steps.web.pages.quickmatch;

import common.glue.steps.web.pages.WebPage;
import io.cucumber.java.en.And;
import io.vavr.control.Try;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;

/**
 * Created by emanuela.biro on 2/8/2019.
 * <p>
 * contain scheduler page methods and objects
 */
public class SchedulerWebPage extends WebPage {

    @FindBy(css = "[data-qa=schedulerLaterButton2], [data-qa=inRoomSchedulingSelectTimeslotReserveSessionLater]")
    private WebElement buttonScheduleLater;

    /**
     * We try to click on the Schedule later button in case the scheduler is displayed.
     * If the scheduler is skipped, we expect it to be because the provider is not available for live video sessions and that shouldn't fail our test.
     */
    @And("Click on schedule later button if present")
    @And("In-room scheduler - Click on schedule later button if present")
    public void clickOnScheduleLaterButton() {
        Try.run(() -> new WebDriverWait(driver, Duration.ofSeconds(10)).until(elementToBeClickable(buttonScheduleLater)).click());
    }
}

package glue.steps.web.pages.clientweb;

import common.glue.steps.web.pages.WebPage;
import io.cucumber.java.en.And;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;
import static org.openqa.selenium.support.ui.ExpectedConditions.visibilityOf;

/**
 * User: nirtal
 * Date: 15/09/2021
 * Time: 13:41
 * Created with IntelliJ IDEA
 */
public class RefundWebPage extends WebPage {

    @FindBy(css = "[data-qa=refundOtherLvsRefundReasonMultiLineTextArea]")
    private WebElement textArea;
    @FindBy(css = "[data-qa=refundSubscriptionRefundEligibleSecondaryButton]")
    private WebElement contactSupport;

    @And("Click on contact Support")
    public void clickOnContactSupport() {
        wait.until(elementToBeClickable(contactSupport)).click();
    }

    @And("Refund Wizard - Enter refund reason")
    public void refundWizardEnterRefundReason() {
        wait.until(visibilityOf(textArea)).sendKeys("Other");
    }
}

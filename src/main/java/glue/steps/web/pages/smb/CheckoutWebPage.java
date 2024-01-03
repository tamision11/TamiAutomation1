package glue.steps.web.pages.smb;

import annotations.Frame;
import common.glue.steps.web.pages.WebPage;
import io.cucumber.java.en.And;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static enums.FrameTitle.DEFAULT;
import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;

/**
 * User: nirtal
 * Date: 11/01/2022
 * Time: 9:54
 * Created with IntelliJ IDEA
 */
public class CheckoutWebPage extends WebPage {

    @FindBy(css = "[data-qa=smbCompletePurchaseButton]")
    private WebElement smbCompletePurchaseButton;

    /**
     * inside {@link enums.FrameTitle#DEFAULT} frame
     */
    @Frame(DEFAULT)
    @And("SMB - Partner clicks on complete purchase button")
    public void userClicksOnCompletePurchaseButton() {
        wait.until(elementToBeClickable(smbCompletePurchaseButton)).click();
    }
}
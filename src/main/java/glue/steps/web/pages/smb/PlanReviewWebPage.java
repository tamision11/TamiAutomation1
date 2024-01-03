package glue.steps.web.pages.smb;

import common.glue.steps.web.pages.WebPage;
import io.cucumber.java.en.And;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;

/**
 * User: nirtal
 * Date: 11/01/2022
 * Time: 9:56
 * Created with IntelliJ IDEA
 */
public class PlanReviewWebPage extends WebPage {

    @FindBy(css = "[data-qa=smbContinueToCheckoutButton]")
    private WebElement smbContinueToCheckoutButton;
    @FindBy(css = "[data-qa=changePlanLink]")
    private WebElement changePlanLink;

    @And("SMB - Partner clicks on Continue to checkout button")
    public void clickOnContinueToCheckoutButton() {
        wait.until(elementToBeClickable(smbContinueToCheckoutButton)).click();
    }
}
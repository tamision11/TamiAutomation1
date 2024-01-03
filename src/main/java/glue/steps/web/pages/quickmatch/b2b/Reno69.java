package glue.steps.web.pages.quickmatch.b2b;

import common.glue.steps.web.pages.WebPage;
import io.cucumber.java.en.And;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * User: nirtal
 * Date: 11/03/2021
 * Time: 11:32
 * Created with IntelliJ IDEA
 * <p>
 * B2B Reno page - Flow 69.
 */
public class Reno69 extends WebPage {

    // region elements without data-qa
    @FindBy(xpath = "//button[contains(text(), 'Check eligibility')]")
    private WebElement checkEligibilityButton;
    //endregion

    @And("Click on check eligibility button")
    public void clickOnCheckEligibilityButton() {
        checkEligibilityButton.click();
    }
}

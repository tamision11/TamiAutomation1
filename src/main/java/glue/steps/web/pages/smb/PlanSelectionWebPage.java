package glue.steps.web.pages.smb;

import common.glue.steps.web.pages.WebPage;
import io.cucumber.java.en.And;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;

/**
 * User: nirtal
 * Date: 11/01/2022
 * Time: 9:58
 * Created with IntelliJ IDEA
 */
public class PlanSelectionWebPage extends WebPage {

    @FindBy(css = "[data-qa=closeModalButton]")
    private WebElement closeModalButton;
    @FindBy(css = "[data-qa=selectPlanButton]")
    private WebElement selectPlanButton;
    @FindBy(css = "[data-qa=viewPricingDetailsButton]")
    private WebElement viewPricingDetailsButton;
    @FindBy(css = "[data-qa=planSelect]")
    private WebElement planSelect;

    @And("SMB - Partner view pricing details")
    public void viewPricingDetails() {
        wait.until(elementToBeClickable(closeModalButton));
    }

    @And("SMB - Partner clicks on View pricing details button")
    public void clickOnViewPricingDetailsButton() {
        wait.until(elementToBeClickable(viewPricingDetailsButton)).click();
    }

    /**
     * @param optionText the desired option text to select.
     */
    @And("SMB - Select from list the option {string}")
    public void userOpenPlansDropdown(String optionText) {
        commonWebPage.openDropdown(0).findElement(By.xpath("//*[contains(text(), \"" + optionText + "\")]")).click();
    }

    @And("SMB - Partner open plans dropdown")
    public void userOpenPlansDropdown() {
        wait.until(elementToBeClickable(planSelect)).click();
    }

    @And("SMB - Partner close pricing details popup")
    public void closePricingDetailsPopup() {
        wait.until(elementToBeClickable(closeModalButton)).click();
    }

    @And("SMB - Partner clicks on select plan button")
    public void clickOnSelectPlanButton() {
        wait.until(elementToBeClickable(selectPlanButton)).click();
    }
}
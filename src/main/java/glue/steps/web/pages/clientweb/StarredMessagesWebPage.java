package glue.steps.web.pages.clientweb;

import common.glue.steps.web.pages.WebPage;
import io.cucumber.java.en.And;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;

public class StarredMessagesWebPage extends WebPage {

    // region elements without data-qa
    @FindBy(xpath = "//div[@role='button']/p[contains(text(), 'Edit')]")
    private WebElement buttonEdit;
    @FindBy(xpath = "//div[@role='button']/p[contains(text(), 'Done')]")
    private WebElement buttonDone;
    //endregion

    @And("Starred Messages - Click on the edit button")
    public void starredMessagesClickOnTheEditButton() {
        wait.until(elementToBeClickable(buttonEdit)).click();
    }

    @And("Starred Messages - Click on the done button")
    public void starredMessagesClickOnTheDoneButton() {
        wait.until(elementToBeClickable(buttonDone)).click();
    }
}
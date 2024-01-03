package glue.steps.web.pages.smb;

import common.glue.steps.web.pages.WebPage;
import entity.User;
import io.cucumber.java.en.And;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.awt.*;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.io.IOException;

import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;
import static org.openqa.selenium.support.ui.ExpectedConditions.visibilityOf;

/**
 * User: nirtal
 * Date: 11/01/2022
 * Time: 10:01
 * Created with IntelliJ IDEA
 */
public class RedemptionWebPage extends WebPage {

    @FindBy(css = "[data-name=email]")
    private WebElement email;
    @FindBy(css = "[data-name=employer]")
    private WebElement employer;
    @FindBy(css = "button[class='button green voucher-btn w-button']")
    private WebElement getStartedButton;

    @And("SMB - User landing page - clicks on get started button")
    public void userClicksOnGetStartedButton() {
        wait.until(elementToBeClickable(getStartedButton)).click();
    }

    @And("SMB - User landing page - enter keyword")
    public void userEnterEndUserKeyword() throws IOException, UnsupportedFlavorException {
        var keyword = Toolkit.getDefaultToolkit().getSystemClipboard().getData(DataFlavor.stringFlavor).toString();
        wait.until(visibilityOf(employer)).sendKeys(keyword);
    }

    @And("SMB - User landing page - enter {user} email")
    public void userEnterEndUserEmail(User user) {
        wait.until(visibilityOf(email)).sendKeys(user.getEmail());
    }
}
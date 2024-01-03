package glue.steps.web.pages.smb;

import common.glue.steps.web.pages.WebPage;
import io.cucumber.java.en.And;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.awt.*;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.io.IOException;

import static org.assertj.core.api.Assertions.assertThat;
import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;

/**
 * User: nirtal
 * Date: 11/01/2022
 * Time: 9:55
 * Created with IntelliJ IDEA
 */
public class ConfirmationWebPage extends WebPage {

    @FindBy(css = "[data-qa=copyKeywordButton]")
    private WebElement copyKeywordButton;
    @FindBy(css = "[data-qa=smbRedemptionPageLink]")
    private WebElement smbRedemptionPageLink;
    @FindBy(css = "[data-qa=keywordText]")
    private WebElement keywordText;

    @And("SMB - Partner clicks on this page button")
    public void userClicksOnThisPageButton() {
        wait.until(elementToBeClickable(smbRedemptionPageLink)).click();
    }

    /**
     * Verify the displayed keyword contains the company name.
     * <p>
     * Verify the copied clipboard keyword contains the displayed keyword.
     *
     * @throws IOException                if an I/O error occurs
     * @throws UnsupportedFlavorException if the requested data flavor is not supported.
     */
    @And("SMB - Partner clicks on copy Keyword button")
    public void clickOnTheCopyKeywordButtonButton() throws IOException, UnsupportedFlavorException {
        wait.until(elementToBeClickable(copyKeywordButton)).click();
        //get text from clipboard
        var copiedText = (String) Toolkit.getDefaultToolkit().getSystemClipboard().getData(DataFlavor.stringFlavor);
        var keyword = keywordText.getText();
        var sanitizedCompanyName = scenarioContext.getCompanyName().toLowerCase().replaceAll("[^a-zA-Z0-9]", "");
        assertThat(copiedText).contains(sanitizedCompanyName);
        assertThat(keyword).contains(sanitizedCompanyName);
    }
}
package glue.steps.web.pages.clientweb;

import common.glue.steps.web.pages.WebPage;
import common.glue.utilities.Constants;
import common.glue.utilities.GeneralActions;
import io.cucumber.java.en.And;
import lombok.Getter;
import org.awaitility.Awaitility;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.time.Duration;

import static org.assertj.core.api.Assertions.assertThat;
import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;

@Getter
public class SuperBillsWebPage extends WebPage {

    @FindBy(css = "[data-qa=superbillIndex1Id4]")
    private WebElement firstSuperbillButton;
    @FindBy(css = "[data-qa=confirmName]")
    private WebElement confirmNameButton;
    @FindBy(css = "[data-qa=superBillsCloseButton]")
    private WebElement closeButton;
    @FindBy(css = "[title=pdf-viewer]")
    private WebElement pdfViewer;
    @FindBy(css = "[data-qa=superbillsListDescription]")
    private WebElement superbillsIntroText;
    @FindBy(css = "[data-qa=superbillsVerifyNameDescription]")
    private WebElement superbillsNameConfirmationIntro;
    @FindBy(css = "[data-qa=superbillsVerifyNamePrompt]")
    private WebElement nameOnSuperbillText;

    @And("Superbills - Click on the {optionIndex} superbill in list")
    public void clickOnFirstSuperbill(int optionIndex) {
        wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=superbillIndex]"))).get(optionIndex).click();
    }

    @And("Superbills - Click on confirm name button")
    public void clickOnConfirmName() {
        wait.until(elementToBeClickable(confirmNameButton)).click();
    }

    @And("Superbills - Click on close button")
    public void clickOnClose() {
        wait.until(elementToBeClickable(closeButton)).click();
    }

    @And("Superbills - Verify pdf generated and showing")
    public void verifyPdf() {
        wait.until(elementToBeClickable(pdfViewer));
    }

    @And("Superbills - Verify at least {int} superbills are displayed")
    public void verifySuperbillsAmount(int superbillsAmmount) {
        var superbills = wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("[data-qa^=superbillIndex]"))).size();
        assertThat(superbills)
                .withFailMessage("Found is %d superbill", superbills)
                .isGreaterThanOrEqualTo(superbillsAmmount);
    }

    @And("Superbills - Download PDF and verify file existence")
    public void clickOnDownload() {
        var itemsInFolderBefore = GeneralActions.listFilesInDirectory(Constants.CHROME_DOWNLOAD_DIRECTORY);
        wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector("[aria-label=download]"))).click();
        Awaitility
                .await()
                .alias("Downloaded file should exist")
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() ->
                {
                    var itemInFolderAfter = GeneralActions.listFilesInDirectory(Constants.CHROME_DOWNLOAD_DIRECTORY);
                    assertThat(itemInFolderAfter).size().isEqualTo(itemsInFolderBefore.size() + 1);
                    assertThat(GeneralActions.findLastModifiedFile(Constants.CHROME_DOWNLOAD_DIRECTORY))
                            .hasExtension("pdf");
                });
    }
}
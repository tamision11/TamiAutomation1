package glue.steps.web.pages.clientweb;

import common.glue.steps.web.pages.WebPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.openqa.selenium.By;
import org.openqa.selenium.support.ui.ExpectedConditions;

import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;

/**
 * Created by emanuela.biro on 8/7/2019.
 * Objects and methods regarding the offers sent from therapist
 */
public class OffersWebPage extends WebPage {

    // region elements without data-qa
    // TODO: update after: https://talktala.atlassian.net/browse/PLATFORM-1888
    private final By buttonSelectPlan = By.xpath("//p[contains(text(), 'Select plan')]");
    //endregion

    @When("Click on the {string} offer button")
    public void offersClickOnTheOfferButton(String buttonName) {
        var offersInChat = wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.xpath("//button[contains(text(), \"" + buttonName + "\")]")));
        wait.until(elementToBeClickable(offersInChat.get(offersInChat.size() - 1)));
        offersInChat.get(offersInChat.size() - 1).click();
    }

    /**
     * @see <a href="https://talktala.atlassian.net/browse/CVR-889">The delay has been set to 400ms and remain unchanged</a>
     */
    @Then("Click on select plan button")
    public void offersClickOnTheOfferButtonModal() {
        wait.until(driver -> {
            driver.findElement(buttonSelectPlan).click();
            return driver.findElements(buttonSelectPlan).isEmpty();
        });
    }
}
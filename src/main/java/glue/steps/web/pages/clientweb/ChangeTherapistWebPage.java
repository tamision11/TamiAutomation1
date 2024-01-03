package glue.steps.web.pages.clientweb;

import common.glue.steps.web.pages.WebPage;
import enums.Us_States;
import io.cucumber.java.en.And;
import io.cucumber.java.en.When;
import lombok.Getter;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;

@Getter
public class ChangeTherapistWebPage extends WebPage {

    // region elements without data-qa
    private final By liveInTheUs = By.xpath("//*[text() = 'Live in the US?']");
    @FindBy(xpath = "//p[contains(text(), 'No preference')]/parent::button")
    private WebElement linkNoPreferenceGender;
    @FindBy(xpath = "//*[text() = 'Find your match']")
    private WebElement noMatchesScreen;
    @FindBy(xpath = "//p[contains(text(), 'Live outside of the US?') or contains(text(), 'Live in the US?')]/parent::button")
    private WebElement linkSwitchInOutUS;
    //endregion

    @And("Change provider - No matches screen shows")
    public void changeTherapistNoMatchesScreen() {
        wait.until(elementToBeClickable(noMatchesScreen)).click();
    }

    @And("Change provider - Click on No preferences")
    public void changeTherapistClickOnNoPreferences() {
        wait.until(elementToBeClickable(linkNoPreferenceGender)).click();
    }

    /**
     * @param state {@link Us_States} to select
     */
    @And("Change provider - Select {} state")
    public void changeTherapistSelectState(Us_States state) {
        //region if we are outside the US then switch to US states
        if (!driver.findElements(liveInTheUs).isEmpty()) {
            driver.findElement(liveInTheUs).click();
        }
        //endregion
        commonWebPage.openDropdownAndSelect(state.getName());
    }

    @When("Change provider - Click on Live in or outside US")
    public void changeTherapistClickOnLiveOutsideUS() {
        linkSwitchInOutUS.click();
    }
}
package glue.steps.web.pages.smb;

import common.glue.steps.web.pages.WebPage;
import entity.User;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;

/**
 * User: nirtal
 * Date: 11/01/2022
 * Time: 9:55
 * Created with IntelliJ IDEA
 */
public class GetStartedWebPage extends WebPage {

    @FindBy(css = "[data-qa=firstNameInput]")
    private WebElement firstNameInput;
    @FindBy(css = "[data-qa=lastNameInput]")
    private WebElement lastNameInput;
    @FindBy(css = "[data-qa=emailInput]")
    private WebElement emailInput;
    @FindBy(css = "[data-qa=approximateOrgSizeInput]")
    private WebElement approximateOrgSizeInput;
    @FindBy(css = "[data-qa=smbViewPlansButton]")
    private WebElement smbViewPlansButton;
    @FindBy(css = "[data-qa=visitOurHomepageButton]")
    private WebElement visitOurHomepageButton;
    @FindBy(css = "[data-qa=requestDemoButton]")
    private WebElement requestDemoButton;
    @FindBy(css = "[data-qa=closeModalButton]")
    private WebElement closeModalButton;

    @Given("SMB - Partner enter first name")
    public void enterFirstName() {
        wait.until(elementToBeClickable(smbViewPlansButton));
        firstNameInput.sendKeys(data.getUserDetails().getFirstName());
    }

    @Given("SMB - Partner clicks on request demo")
    public void clickOnRequestDemo() {
        wait.until(elementToBeClickable(requestDemoButton)).click();
    }


    @And("SMB - Partner enter last name")
    public void enterLastName() {
        lastNameInput.sendKeys(data.getUserDetails().getLastName());
    }

    @And("SMB - Partner enter {user} email")
    public void enterEmail(User user) {
        emailInput.sendKeys(user.getEmail());
    }

    @And("SMB - Partner clicks on visit our homepage button")
    public void partnerClicksOnVisitOurHomepageButton() {
        wait.until(elementToBeClickable(visitOurHomepageButton)).click();
    }

    @And("SMB - Partner enter {int} people on organization")
    public void enterPeopleOnOrganization(int numberOfPeople) {
        approximateOrgSizeInput.sendKeys(String.valueOf(numberOfPeople));
    }

    @And("SMB - Partner clicks on view plans button")
    public void clickOnViewPlansBtn() {
        smbViewPlansButton.click();
    }
}
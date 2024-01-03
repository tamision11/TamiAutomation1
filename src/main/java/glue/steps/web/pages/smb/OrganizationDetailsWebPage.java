package glue.steps.web.pages.smb;

import common.glue.steps.web.pages.WebPage;
import io.cucumber.java.en.And;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;
import static org.openqa.selenium.support.ui.ExpectedConditions.visibilityOf;

/**
 * User: nirtal
 * Date: 11/01/2022
 * Time: 9:56
 * Created with IntelliJ IDEA
 */
public class OrganizationDetailsWebPage extends WebPage {

    @FindBy(css = "[data-qa=orgNameInput]")
    private WebElement orgNameInput;
    @FindBy(css = "[data-qa=exactOrgSizeInput]")
    private WebElement exactOrgSizeInput;
    @FindBy(css = "[data-qa=roleDropdown]")
    private WebElement roleDropdown;
    @FindBy(css = "[data-qa=industryDropdown]")
    private WebElement industryDropdown;
    @FindBy(css = "[data-qa=hasAttestedCheckbox]")
    private WebElement hasAttestedCheckbox;
    @FindBy(css = "[data-qa=orgDetailsFormContinueButton]")
    private WebElement orgDetailsFormContinueButton;
    @FindBy(css = "[data-qa=smbFullFAQLink]")
    private WebElement smbFullFAQLink;

    @And("SMB - Partner enter organization name")
    public void enterMyOrganizationName() {
        wait.until(elementToBeClickable(orgDetailsFormContinueButton));
        scenarioContext.setCompanyName(scenarioContext.getScenarioStartTime().toString());
        orgNameInput.sendKeys(scenarioContext.getCompanyName());
    }

    @And("SMB - Partner confirm {int} people in the organization")
    public void confirmNumberOfPeopleInMyOrganizationIs(int organizationSize) {
        exactOrgSizeInput.clear();
        exactOrgSizeInput.sendKeys(String.valueOf(organizationSize));
    }

    @And("SMB - Partner clicks on Continue button")
    public void clickOnContinueButton() {
        orgDetailsFormContinueButton.click();
    }

    @And("SMB - Partner select my role {string}")
    public void selectMyRole(String myRole) {
        roleDropdown.sendKeys(myRole);
    }

    @And("SMB - Partner select my industry {string}")
    public void selectMyIndustry(String organizationIndustry) {
        industryDropdown.sendKeys(organizationIndustry);
    }

    @And("SMB - Partner checks the confirmation checkbox")
    public void checkTheConfirmationCheckbox() {
        hasAttestedCheckbox.click();
    }

    @And("SMB - Partner select {string} from Roles dropdown")
    public void selectFromRolesDropdown(String role) {
        commonWebPage.selectOptionFromDropdown(() -> driver.findElement(By.cssSelector("[data-qa=roleDropdown]")).click(), role);
    }

    @And("SMB - Partner select {string} from Industry dropdown")
    public void selectFromIndustryDropdown(String industry) {
        commonWebPage.selectOptionFromDropdown(() -> driver.findElement(By.cssSelector("[data-qa=industryDropdown]")).click(), industry);
    }

    @And("SMB - Partner clear number of people on organization")
    public void userEnterClearNumberOfPeopleOnOrganization() {
        wait.until(visibilityOf(exactOrgSizeInput)).clear();
    }
}
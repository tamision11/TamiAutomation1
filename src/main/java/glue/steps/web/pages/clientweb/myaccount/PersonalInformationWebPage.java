package glue.steps.web.pages.clientweb.myaccount;

import com.google.common.util.concurrent.Uninterruptibles;
import common.glue.steps.web.pages.WebPage;
import entity.User;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import lombok.Getter;
import org.assertj.core.api.SoftAssertions;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import static org.assertj.core.api.Assertions.assertThat;
import static org.openqa.selenium.support.ui.ExpectedConditions.*;

/**
 * User: nirtal
 * Date: 09/11/2021
 * Time: 17:38
 * Created with IntelliJ IDEA
 */

@Getter
public class PersonalInformationWebPage extends WebPage {

    // region elements without data-qa
    @FindBy(xpath = "//*[contains(text(), 'My information')]/parent::div")
    private WebElement myInformationSection;
    @FindBy(css = "[role=option]")
    private WebElement inputAddressLine1DropdownOption;
    //endregion

    @FindBy(css = "[data-qa=nameValue]")
    private List<WebElement> nameValues;
    @FindBy(css = "[data-qa=dateOfBirthValue]")
    private WebElement dateOfBirthValue;
    @FindBy(css = "[data-qa=homeAddressValue]")
    private WebElement homeAddressValue;
    @FindBy(css = "[data-qa=phoneNumberValue]")
    private WebElement phoneNumberValue;
    @FindBy(css = "[data-qa=relationshipWithEmergencyContactValue]")
    private WebElement relationshipWithEmergencyContactValue;
    @FindBy(css = "[data-qa=changeEmergencyContact]")
    private WebElement changeEmergencyContactButton;
    @FindBy(css = "[name=contactName]")
    private WebElement contactName;
    @FindBy(css = "[data-qa=phoneInput]")
    private WebElement contactPhone;
    @FindBy(css = "[data-qa=relationshipDropdown]")
    private WebElement relationshipDropdown;
    @FindBy(css = "[data-qa=changeMyInformation]")
    private WebElement buttonChangeMyDetails;
    @FindBy(css = "[data-qa=firstNameInput]")
    private WebElement inputFirstName;
    @FindBy(css = "[data-qa=saveButton]")
    private WebElement saveButton;
    @FindBy(css = "[data-qa=lastNameInput]")
    private WebElement inputLastName;
    @FindBy(css = "[data-qa=dateOfBirthInput]")
    private WebElement inputDateOfBirth;
    @FindBy(css = "[data-qa=addressLine1Input]")
    private WebElement inputAddressLine1;
    @FindBy(css = "[data-qa=addressLine2Input]")
    private WebElement inputAddressLine2;
    @FindBy(css = "[data-qa=cityInput]")
    private WebElement inputCity;
    @FindBy(css = "[data-qa=zipCodeInput]")
    private WebElement inputZipCode;
    @FindBy(css = "[data-qa=countryDropdown]")
    private WebElement dropdownCountry;

    @And("Update personal Information")
    public void updatePersonalInformation() {
        Uninterruptibles.sleepUninterruptibly(500, TimeUnit.MILLISECONDS);
        wait.until(visibilityOf(inputDateOfBirth)).sendKeys("11/11/2000");
    }

    /**
     * phone number is also validated.
     *
     * @param user                    the user
     * @param emergencyContactDetails emergency contact details
     */
    @Then("{user} user Emergency contact details are")
    public void emergencyContactDetailsAre(User user, Map<String, String> emergencyContactDetails) {
        wait.until(visibilityOfAllElements(nameValues));
        wait.until(ExpectedConditions.textToBePresentInElement(nameValues.get(1), emergencyContactDetails.get("Name")));
        SoftAssertions.assertSoftly(softAssertions -> {
            assertThat(phoneNumberValue.getText()).isEqualTo(user.getPhoneNumber());
            assertThat(relationshipWithEmergencyContactValue.getText()).isEqualTo(emergencyContactDetails.get("Relationship with emergency contact"));
        });
    }

    @And("Click on the change emergency contact button")
    public void clickOnTheChangeEmergencyContactButton() {
        wait.until(ExpectedConditions.elementToBeClickable(changeEmergencyContactButton)).click();
    }

    @And("Personal information - Click on change my details button")
    public void personalInformationClickOnChangeMyDetails() {
        wait.until(elementToBeClickable(buttonChangeMyDetails)).click();
    }

    @And("Personal information - Click on save button")
    public void personalInformationClickOnSaveButton() {
        wait.until(elementToBeClickable(saveButton)).click();
    }

    @And("Update emergency contact details of {user} user")
    public void updateEmergencyContactDetails(User user) {
        wait.until(ExpectedConditions.visibilityOf(contactName)).sendKeys(data.getUserDetails().getEmergencyContact().get("fullName"));
        contactPhone.sendKeys(user.getPhoneNumber().substring(2));
        commonWebPage.selectOptionFromDropdown(relationshipDropdown::click, "Parent");
    }

    @Then("Personal information details are")
    public void personalInformationDetailsAre(Map<String, String> personalInformationDetails) {
        wait.until(visibilityOfAllElements(nameValues));
        wait.until(ExpectedConditions.textToBePresentInElement(nameValues.get(0), personalInformationDetails.get("Name")));
        SoftAssertions.assertSoftly(softAssertions -> {
            assertThat(dateOfBirthValue.getText()).isEqualTo(personalInformationDetails.get("Birthdate"));
            assertThat(homeAddressValue.getText()).isEqualTo(personalInformationDetails.get("Home Address"));
        });
    }
}
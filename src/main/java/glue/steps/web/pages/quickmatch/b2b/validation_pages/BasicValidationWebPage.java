package glue.steps.web.pages.quickmatch.b2b.validation_pages;

import com.google.inject.Inject;
import common.glue.steps.web.pages.WebPage;
import common.glue.steps.web.pages.quickmatch.b2b.B2B_Web_Page;
import common.glue.utilities.GeneralActions;
import entity.User;
import entity.ValidationForm;
import enums.ServiceType;
import enums.UserEmailType;
import enums.data.BhMemberIDType;
import lombok.Getter;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

/**
 * User: nirtal
 * Date: 19/04/2021
 * Time: 12:33
 * Created with IntelliJ IDEA
 * this form contains the elements of all forms.
 */
@Getter
public abstract class BasicValidationWebPage extends WebPage implements ValidationForm {

    @Inject
    protected B2B_Web_Page b2b;

    @FindBy(css = "[id*=option]")
    private List<WebElement> sessionNumbers;
    @FindBy(css = "[data-qa=serviceTypeDropdown]")
    private WebElement selectServiceDropdown;
    @FindBy(css = "[data-qa=memberIDInput]")
    private WebElement memberIDInput;
    @FindBy(css = "[data-qa=emailInput], [data-qa=memberEmail], [name=email]")
    private WebElement inputEmail;
    @FindBy(css = "[data-qa=firstNameInput]")
    private WebElement inputFirstName;
    @FindBy(css = "[data-qa=lastNameInput]")
    private WebElement inputLastName;
    @FindBy(css = "[data-qa=heardAboutDropdown]")
    private WebElement referralDropdown;
    @FindBy(css = "[data-qa=authorizationCodeExpirationInput]")
    private WebElement inputAuthorizationCodeExpiration;
    @FindBy(css = "[data-qa=phoneInput]")
    private WebElement inputPhoneNumber;
    @FindBy(css = "[data-qa=memberDOB], [data-qa=dateOfBirthInput], [data-qa=dobInput]")
    private WebElement inputBirthDate;
    @FindBy(css = "[data-qa=memberOrganization], [data-qa=organizationNameInput]")
    private WebElement inputOrganization;
    @FindBy(css = "[data-qa=employeeIDInput]")
    private WebElement inputEmployeeId;
    @FindBy(css = "[data-qa=verificationCheckboxCheckbox]")
    private WebElement verificationCheckbox;
    @FindBy(css = "[data-qa=addressLine2Input]")
    private WebElement inputUnitAddress;
    @FindBy(css = "[data-qa=cityInput]")
    private WebElement inputCity;
    @FindBy(css = "[data-qa=countryDropdown]")
    private WebElement countryDropDown;
    @FindBy(css = "[data-qa=stateDropdown], [data-qa=clientStateDropdown], [data-qa=stateInput]")
    private WebElement state;
    @FindBy(css = "[data-qa=zipCodeInput]")
    private WebElement inputZipCode;
    @FindBy(css = "[data-qa=attendedSchoolDropdown]")
    private WebElement attendedSchoolDropdown;
    @FindBy(css = "[data-qa=addressLine1Input]")
    private WebElement inputHomeAddress;
    @FindBy(css = "[data-qa=memberAuthorizationCode], [data-qa=authorizationCodeInput]")
    private WebElement inputAuthorizationCode;
    @FindBy(css = "[data-qa=memberNumberOfEligibleSessions], [data-qa=numberOfSessionsDropdown]")
    private WebElement sessionDiv;
    @FindBy(css = "[data-qa=employeeRelationDropdown]")
    private WebElement employeeRelation;

    /**
     * In case we are on the eligibility widget, and the 2fa feature flag is "off" we will enter the user's phone
     * although not specified in the data table, because 2fa adds the phone in the process.
     * Therapy is the default service option, so in cases of therapy, we don't select this option.
     * If a special birthdate is present to use it, else use an age.
     * If email is not empty, complete it.
     * If the first and last name is empty complete them - this happens on QM.
     *
     * @param userDetails the user details.
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    @Override
    public void enterDetails(User user, Map<String, String> userDetails) throws InterruptedException {
        // shared validation after upfront eligibility form don't have these fields
        if (!getClass().equals(SharedValidationWebPageAfterUpfront.class)) {
            var firstName = wait.until(ExpectedConditions.visibilityOf(inputFirstName));
            if (StringUtils.isBlank(firstName.getAttribute("value"))) {
                firstName.sendKeys(user.getFirstName());
                if (!getClass().equals(BroadwayvValidationWebPage.class)) {
                    inputLastName.sendKeys(user.getLastName());
                }
            }
            if (userDetails.containsKey("birthdate")) {
                inputBirthDate.sendKeys(data.getUserDetails().getBirthDate().get(userDetails.get("birthdate")));
            } else {
                inputBirthDate.sendKeys(GeneralActions.generateDate(0, 0, Integer.parseInt(userDetails.get("age"))));
            }
        }
        if (userDetails.containsKey("organization")) {
            getInputOrganization().sendKeys(data.getUserDetails().getOrganizationName().get(userDetails.get("organization")));
        }
        if (userDetails.containsKey("Member ID")) {
            getMemberIDInput().sendKeys(BhMemberIDType.valueOf(userDetails.get("Member ID")).getMemberID());
        }
        if (userDetails.containsKey("service type")) {
            var serviceType = ServiceType.valueOf(userDetails.get("service type")).getName();
            if (!serviceType.equals("Therapy")) {
                commonWebPage.selectOptionFromDropdown(selectServiceDropdown::click, serviceType);
            }
        }
        // upfront eligibility + Broadway forms don't have a verification checkbox
        if (Stream.of(UpfrontCoverageVerification.class, BroadwayvValidationWebPage.class).noneMatch(c -> c.equals(getClass()))) {
            wait.until(ExpectedConditions.elementToBeClickable(verificationCheckbox)).click();
        }
        if (userDetails.containsKey("Email")) {
            getInputEmail().clear();
            getInputEmail().sendKeys(GeneralActions.getEmailAddress(UserEmailType.valueOf(userDetails.get("Email"))));
        }
    }

    /**
     * this method will enter the phone number in the following cases:
     * <ul>
     *    <li>We are not in the eligibility widget / add new service - we always fill the phone in 2fa so it should always be prefilled .
     *    we will enter the users phone, although not specified in the data table, because 2fa adds the phone in the process.
     *    <li>We specify the phone number explicitly in the data table we will use it.
     *  </ul>
     * <p>
     *
     * @param user        the user.
     * @param userDetails the user details.
     */
    protected void fillPhoneDetails(User user, Map<String, String> userDetails) {
        if (userDetails.containsKey("phone number") || !StringUtils.containsAny(driver.getCurrentUrl(), "add-new-service", "eligibility-widget", "room-reactivation", "modal")) {
            getInputPhoneNumber().sendKeys(user.getPhoneNumber().substring(2));
        }
    }
}

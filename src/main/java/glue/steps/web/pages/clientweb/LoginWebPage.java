package glue.steps.web.pages.clientweb;

import common.glue.steps.web.pages.WebPage;
import common.glue.utilities.GeneralActions;
import entity.User;
import enums.Us_States;
import enums.UserEmailType;
import enums.data.NicknameType;
import enums.data.PasswordType;
import io.cucumber.java.en.And;
import io.cucumber.java.en.When;
import lombok.Getter;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.util.Map;

import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;
import static org.openqa.selenium.support.ui.ExpectedConditions.visibilityOf;

/**
 * Created by emanuela.biro on 3/20/2019.
 * <p>
 * contains the elements in the login page
 */
@Getter
public class LoginWebPage extends WebPage {

    // region elements without data-qa
    @FindBy(css = "a[href^='/login']")
    private WebElement linkLogIn;
    @FindAll({
            @FindBy(xpath = "//p[contains(text(),'Save')]"),
            @FindBy(xpath = "//button[contains(text(),'Save')]"),
            @FindBy(css = "[data-qa=saveButton]")
    })
    private WebElement buttonSave;
    @FindBy(xpath = "//button[contains(text(), 'Request password reset')]")
    private WebElement requestResetButton;
    @FindBy(css = "[placeholder='Enter new password']")
    private WebElement inputNewPassword;
    @FindBy(css = "[placeholder='Confirm new password']")
    private WebElement inputConfirmPassword;
    //endregion
    @FindBy(css = "[data-qa=referralSourceInput]")
    private WebElement referralSourceInput;
    @FindBy(css = "[data-qa=emailInput],[data-qa=followUpEmail], [data-qa=createAccountEmailInput], [name=username], [placeholder='Enter email address']")
    private WebElement inputEmail;
    @FindBy(css = "[data-qa=createAccountPhoneInput], [data-qa=phoneInput]")
    private WebElement inputPhoneNumber;
    @FindBy(css = "[data-qa=forgotPasswordLink]")
    private WebElement forgetPasswordLink;
    @FindBy(css = "[data-qa=rememberMeCheckbox]")
    private WebElement rememberMeCheckbox;
    @FindBy(css = "[data-qa=signInButton]")
    private WebElement loginInButton;
    @FindBy(css = "[data-qa=emailInput-error]")
    private WebElement invalidEmailOrPassword;
    @FindBy(css = "[data-qa=insuranceErrorInfo], [data-qa=authorizationCodeInput-error], [data-qa=generalErrorInfo], [data-qa=authorizationCodeExpirationInput-error]")
    private WebElement authCodeError;
    @FindBy(xpath = "//a[@data-qa='signUpLink']/parent::div")
    private WebElement linkSignUp;
    @FindBy(css = "[data-qa=createAccountPasswordInput], [type=password], [name=password]")
    private WebElement inputPassword;
    @FindBy(css = "[data-qa=nicknameInput], [data-qa=createAccountNicknameInput]")
    private WebElement inputRegisterNickname;
    @FindBy(css = "[data-qa=createAccountSubmitButton]")
    private WebElement buttonCreateYourAccount;
    @FindBy(css = "[data-qa=countryDropdown]")
    private WebElement countryDropdown;
    @FindBy(css = "[data-qa=stateDropdown]")
    private WebElement stateDropdown;
    @FindBy(css = "[data-qa=smsAgreementCheckbox]")
    private WebElement checkbox;
    @FindBy(css = "[data-qa=telemedicineLink]")
    private WebElement informedConsentLink;
    @FindBy(css = "[data-qa=createAccountTermsLink]")
    private WebElement termsOfUseLink;
    @FindBy(css = "[data-qa=createAccountPrivacyLink]")
    private WebElement privacyPolicyLink;
    @FindBy(css = ("[data-qa=referralSourceDropdown], [data-qa=heardAboutDropdown]"))
    private WebElement referralSourceDropdown;

    /**
     * @param user the {@link User}.
     */
    @And("Client Web - Signup - Enter {user} user phone number")
    public void loginPageEnterPhoneNumber(User user) {
        enterPhoneNumber(user.getPhoneNumber().substring(2));
    }

    @And("Invalid auth code message is displayed")
    @And("Invalid auth code expiration message is displayed")
    public void invalidAuthCode() {
        wait.until(ExpectedConditions.visibilityOf(authCodeError));
    }

    @When("Click on sign up")
    public void logInClickOnCreateAccount() {
        wait.until(ExpectedConditions.elementToBeClickable(linkSignUp)).click();
    }

    @And("Click on informed consent link")
    public void clickOnInformedConsentLink() {
        wait.until(elementToBeClickable(informedConsentLink)).click();
    }

    @And("Click on terms of use link")
    public void clickOnTermsOfUseLink() {
        wait.until(elementToBeClickable(termsOfUseLink)).click();
    }

    @And("Click on privacy policy link")
    public void clickOnPrivacyPolicyLink() {
        wait.until(elementToBeClickable(privacyPolicyLink)).click();
    }

    @And("Click on reset password button")
    public void clickOnResetPasswordButton() {
        wait.until(elementToBeClickable(requestResetButton)).click();
    }

    /**
     * could be promotion checkbox or over 13 checkbox.
     */
    @When("Check checkbox")
    public void checkCheckbox() {
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", checkbox);
    }

    @And("Insert {} nickname")
    public void registrationInsertNickname(NicknameType nicknameType) {
        wait.until(ExpectedConditions.visibilityOf(inputRegisterNickname)).sendKeys(nicknameType.getValue());
    }

    /**
     * @param userEmailType the type of email to generate or to retrieve.
     */
    @When("Sign in - Enter {} email")
    @When("Enter {} email")
    public void logInEnterEmailRegisteredEmail(UserEmailType userEmailType) {
        wait.until(visibilityOf(inputEmail)).sendKeys(GeneralActions.getEmailAddress(userEmailType));
    }

    /**
     * this step can set a new strong password.
     * in case the type is STRONG we add the current password to the old password list and update a new password for the user object.
     */
    @When("Forgot password - Write {} password in the new password field for {user} user")
    public void profileWriteInTheNewPasswordField(PasswordType passwordType, User user) {
        user.setPassword(passwordType.getValue());
        wait.until(visibilityOf(inputNewPassword)).sendKeys(user.getPassword());
    }

    /**
     * @param passwordType the type of password to send.
     */
    @When("Forgot password - Write {} password in the confirm new password field")
    public void profileWriteInTheConfirmNewPasswordField(PasswordType passwordType) {
        wait.until(visibilityOf(inputConfirmPassword)).sendKeys(passwordType.getValue());
    }

    /**
     * this step can set a new strong password.
     * in case the type is STRONG we add the current password to the old password list and update a new password for the user object.
     * removing the current login token since it is no longer valid.
     */
    @And("Forgot password - Update the password of {user} user")
    public void updatePassword(User user) {
        user.setOldPassword(user.getPassword());
        user.setPassword(faker.internet().password(12, 15, true, true));
        wait.until(visibilityOf(inputNewPassword)).sendKeys(user.getPassword());
        wait.until(visibilityOf(inputConfirmPassword)).sendKeys(user.getPassword());
        user.setLoginToken(StringUtils.EMPTY);
    }

    /**
     * @param passwordType the {@link PasswordType}
     */
    @And("Insert {} password")
    public void registerEnterPassword(PasswordType passwordType) {
        wait.until(ExpectedConditions.visibilityOf(inputPassword)).sendKeys(passwordType.getValue());
    }

    @When("Click on save button")
    public void clickOnSaveButton() {
        wait.until(elementToBeClickable(buttonSave)).click();
    }

    /**
     * entering the initial password.
     */
    @And("Enter initial password of {user} user")
    public void enterInitialPassword(User user) {
        wait.until(visibilityOf(inputPassword)).sendKeys(user.getOldPassword());
    }

    @And("Registration Page - Create your account button is displayed")
    public void createYourAccountButtonIsDisplayed() {
        wait.until(elementToBeClickable(buttonCreateYourAccount));
    }

    @And("Registration Page - Click on Create your account button")
    public void registrationClickOnCreateYourAccount() {
        wait.until(elementToBeClickable(buttonCreateYourAccount)).click();
        wait.until(ExpectedConditions.invisibilityOfElementLocated(By.cssSelector(".bt-spinner")));
    }

    /**
     * this step was written to log in with a user that chaged his email during the registration process.
     *
     * @param user in case the user is primary/partner the values are taken from scenarioContext.
     */
    @And("Log in with {user} user old email")
    public void logInWith(User user) {
        wait.until(visibilityOf(getInputEmail())).sendKeys(user.getOldEmail());
        getInputPassword().sendKeys(user.getPassword());
        wait.until(elementToBeClickable(getLoginInButton())).click();
    }


    @And("Log in error message is displayed")
    public void setInvalidEmailOrPassword() {
        wait.until(ExpectedConditions.visibilityOf(invalidEmailOrPassword));
    }


    /**
     * @param user        the {@link User}
     * @param userDetails <table>
     *                    <thead>
     *                    <th>the data to be used to create the room</th>
     *                    <thead>
     *                    <tbody>
     *                    <tr><td>password</td><td>the user {@link PasswordType}</td></tr>
     *                    <tr><td>email</td><td>The user {@link UserEmailType}</td></tr>
     *                    <tr><td>phone number</td><td>The user phone number - if exists in the flow</td></tr>
     *                    <tr><td>nickname</td><td>The user {@link NicknameType}</td></tr>
     *                    <tr><td>referral</td><td>a referral taken from data.json</td></tr>
     *                    <tr><td>country</td><td>country of the user - optional field</td></tr>
     *                    <tr><td>state</td><td>the user {@link Us_States} - optional field</td></tr>
     *                    </tbody>
     *                    </table>
     */
    @And("Create account for {user} user with")
    public void createAccount(User user, Map<String, String> userDetails) {
        registerEnterPassword(PasswordType.valueOf(userDetails.get("password")));
        if (userDetails.containsKey("email")) {
            logInEnterEmailRegisteredEmail(UserEmailType.valueOf(userDetails.get("email")));
        }
        if (userDetails.containsKey("phone number")) {
            enterPhoneNumber(user.getPhoneNumber().substring(2));
        }
        if (userDetails.containsKey("referral")) {
            commonWebPage.selectOptionFromDropdown(referralSourceDropdown::click, data.getUserDetails().getReferral());
        }
        if (userDetails.containsKey("country")) {
            registrationSelectCountry(userDetails.get("country"));
        }
        if (userDetails.containsKey("state")) {
            registrationSelectState(Us_States.valueOf(userDetails.get("state")));
        }
        registrationInsertNickname(NicknameType.valueOf(userDetails.get("nickname")));
        if (userDetails.containsKey("checkbox")) {
            checkCheckbox();
        }
        registrationClickOnCreateYourAccount();
    }

    private void enterPhoneNumber(String phoneNumber) {
        inputPhoneNumber.sendKeys(phoneNumber);
    }

    /**
     * this step selects a US state
     *
     * @param state the state to select
     */
    @And("Select {} state")
    public void registrationSelectState(Us_States state) {
        commonWebPage.selectOptionFromDropdown(stateDropdown::click, state.getName());
    }

    /**
     * @param country the country to select
     */
    @And("Select {string} country")
    public void registrationSelectCountry(String country) {
        commonWebPage.selectOptionFromDropdown(countryDropdown::click, country);
    }

    @When("Click on the forgot password link")
    public void logInClickOnTheForgotPasswordLink() {
        wait.until(elementToBeClickable(forgetPasswordLink)).click();
    }

    @And("Click on login button")
    public void logInClickOnLoginButton() {
        wait.until(elementToBeClickable(loginInButton)).click();
    }

    @And("Registration Page - Click on Login link")
    public void registrationPageClickOnLoginLink() {
        wait.until(elementToBeClickable(linkLogIn)).click();
    }
}
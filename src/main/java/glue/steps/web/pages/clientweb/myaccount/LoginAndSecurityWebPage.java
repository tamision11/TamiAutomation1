package glue.steps.web.pages.clientweb.myaccount;

import common.glue.steps.web.pages.WebPage;
import common.glue.utilities.GeneralActions;
import entity.User;
import enums.UserEmailType;
import enums.data.NicknameType;
import enums.data.PasswordType;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import lombok.Getter;
import org.apache.commons.lang3.StringUtils;
import org.awaitility.Awaitility;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.time.Duration;

import static org.assertj.core.api.Assertions.assertThat;
import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;
import static org.openqa.selenium.support.ui.ExpectedConditions.visibilityOf;

@Getter
public class LoginAndSecurityWebPage extends WebPage {

    // region elements without data-qa
    @FindBy(css = "svg ~ p ~ p")
    private WebElement newEmail;
    @FindBy(css = "[role=tabpanel]")
    private WebElement loginInfoPanel;
    //endregion
    @FindBy(css = "[data-qa=myAccountConfirmNewPasswordInput]")
    private WebElement inputConfirmPassword;
    @FindBy(css = "[data-qa=myAccountChangeNicknameInput]")
    private WebElement inputNickname;
    @FindBy(css = "[data-qa=myAccountPasswordRequiredSaveButton]")
    private WebElement buttonContinuePasswordVerification;
    @FindBy(css = "[data-qa=myAccountChangeNicknameSaveButton],[data-qa=myAccountChangeEmailSaveButton],[data-qa=saveAndResendEmailButton], " +
            "[data-qa=myAccountChangePasswordSaveButton]," +
            "[data-qa=myAccountChangeNumberSaveButton] ")
    private WebElement myAccountSaveButton;
    @FindBy(css = "[data-qa=myAccountPasswordRequiredPasswordInput]")
    private WebElement inputVerifyPassword;
    @FindBy(css = "[data-qa=myAccountNewEmailInput], [data-qa=newEmailInput]")
    private WebElement inputNewEmail;
    @FindBy(css = "[data-qa=myAccountConfirmNewEmailInput],[data-qa=confirmNewEmailInput]")
    private WebElement inputConfirmationNewEmail;
    @FindBy(css = "[data-qa=myAccountNewPasswordInput]")
    private WebElement inputNewPassword;
    @FindBy(css = "[data-qa=myAccountEmail]")
    private WebElement accountEmail;
    @FindBy(css = "[data-qa=myAccountVerifiedOrUnverified]")
    private WebElement verificationStatus;
    @FindBy(css = "[data-qa=myAccountChangeNicknameButton]")
    private WebElement buttonChangeNickname;
    @FindBy(css = "[data-qa=myAccountChangeEmailButton], [data-qa=update-email-link]")
    private WebElement buttonChangeEmail;
    @FindBy(css = "[data-qa=myAccountChangePhoneNumberButton]")
    private WebElement buttonChangePhone;
    @FindBy(css = "[data-qa=myAccountChangePasswordeButton]")
    private WebElement buttonChangePassword;
    @FindBy(css = "[data-qa=myAccountPhoneNumber]")
    private WebElement phoneNumberField;

    /**
     * Verifying the text on the Login and security page shows the newly verified email by making sure:
     * <ul>
     *     <li>The text doesn't contain the old email</li>
     *     <li>The text contains the word "Verified"</li>
     *     <li>The text contains the new (pending) email</li>
     * </ul>
     * <p>
     * After verification is successful, we update the user's email accordingly and reset the user's pending email (since it's no longer pending)
     * </p>
     */
    @Then("New email is verified for {user} user")
    public void loginAndSecurityNewEmailIsVerified(User user) {
        Awaitility
                .await()
                .alias("new email verified on UI")
                .atMost(Duration.ofMinutes(1))
                .ignoreExceptions()
                .untilAsserted(() ->
                        {
                            assertThat(accountEmail
                                    .getText())
                                    .withFailMessage("account page does not contain Verified")
                                    .isEqualTo(user.getEmail());
                            assertThat(verificationStatus
                                    .getText())
                                    .withFailMessage("account page does not contain the new email address %s", user.getEmail())
                                    .isEqualTo("Verified");
                        }
                );
    }

    /**
     * clearing the input field until it's blank
     */
    @Then("Clear input Nickname")
    public void profileClearInputNickName() {
        Awaitility.await()
                .alias("nickname field is empty")
                .atMost(Duration.ofSeconds(30))
                .ignoreExceptions()
                .until(() -> {
                    inputNickname.sendKeys(Keys.BACK_SPACE);
                    return StringUtils.isBlank(inputNickname.getAttribute("value"));
                });
    }

    /**
     * this step can set a new nickname.
     * in case the type is {@link NicknameType#RANDOM_VALID} we add the current nickname to the old nicknames list
     * and update a new nickname for the user object.
     */
    @And("Insert {} in nickname input for {user} user")
    public void profileInsertInNicknameInput(NicknameType nicknameType, User user) {
        if (nicknameType.equals(NicknameType.RANDOM_VALID)) {
            user.setOldNickName(user.getNickName());
        }
        user.setNickName(nicknameType.getValue());
        inputNickname.sendKeys(user.getNickName());
    }

    @Then("Nickname is updated for {user} user")
    public void profileValueForSectionIsSet(User user) {
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//p[contains(text(),\"" + user.getNickName() + "\")]")));
    }

    @When("Click on change nickname")
    public void profileClickOnChangeNickname() {
        wait.until(elementToBeClickable(buttonChangeNickname)).click();
    }

    /**
     * @param userEmailType in case NEW is selected, the pending email is sent.
     */
    @And("Registration - Email update - Insert {} email in the email input")
    @And("My account - Insert {} email in the email input")
    public void profileInsertFromAccountInNewEmailInput(UserEmailType userEmailType) {
        switch (userEmailType) {
            case INVALID, PRIMARY, PARTNER ->
                    wait.until(visibilityOf(inputNewEmail)).sendKeys(GeneralActions.getEmailAddress(userEmailType));
            case NEW ->
                    wait.until(visibilityOf(inputNewEmail)).sendKeys(data.getUsers().get("primary").getPendingEmail());
        }
    }

    @And("Registration - Email update - Update email of {user} user")
    @And("My account - Update email of {user} user")
    public void myAccountUpdateEmail(User user) {
        profileInsertFromAccountInNewEmailInput(UserEmailType.NEW);
        profileInsertFromAccountInConfirmNewEmailInput(UserEmailType.NEW);
        user.setOldEmail(user.getEmail());
        user.setEmail(user.getPendingEmail());
        user.setPendingEmail(StringUtils.EMPTY);
    }

    /**
     * After this step, updating pending email as the users email.
     *
     * @param userEmailType in case {@link UserEmailType#NEW} is selected the pending email is sent.
     */
    @And("Registration - Email update - Insert {} email in email confirmation")
    @And("My account - Insert {} email in email confirmation")
    @And("BH no insurance - Insert {} email in email confirmation")
    public void profileInsertFromAccountInConfirmNewEmailInput(UserEmailType userEmailType) {
        switch (userEmailType) {
            case INVALID, PRIMARY, PARTNER ->
                    wait.until(visibilityOf(inputConfirmationNewEmail)).sendKeys(GeneralActions.getEmailAddress(userEmailType));
            case NEW ->
                    wait.until(visibilityOf(inputConfirmationNewEmail)).sendKeys(data.getUsers().get("primary").getPendingEmail());
        }
    }

    /**
     * we are verifying a static number - due to other numbers will send a real 2fa sms.
     *
     * @param phoneNumber the phone to verify
     */
    @Then("Phone {string} is updated")
    public void phoneNumberIsUpdated(String phoneNumber) {
        wait.until(ExpectedConditions.textToBePresentInElement(phoneNumberField, phoneNumber));
    }

    /**
     * this step can set a new strong password.
     * in case the type is STRONG,
     * we add the current password to the old password list and update a new password for the user object.
     * removing the current login token since it is no longer valid.
     */
    @And("My account - Update the password of {user} user")
    public void updatePassword(User user) {
        user.setOldPassword(user.getPassword());
        user.setPassword(faker.internet().password(12, 15, true, true));
        wait.until(visibilityOf(inputNewPassword)).sendKeys(user.getPassword());
        wait.until(visibilityOf(inputConfirmPassword)).sendKeys(user.getPassword());
        user.setLoginToken(StringUtils.EMPTY);
    }

    /**
     * this step can set a new strong password.
     * in case the type is STRONG, we add the current password to the old password list and update a new password for the user object.
     */
    @When("My account - Write {} password in the new password field for {user} user")
    public void profileWriteInTheNewPasswordField(PasswordType passwordType, User user) {
        user.setPassword(passwordType.getValue());
        wait.until(visibilityOf(inputNewPassword)).sendKeys(user.getPassword());
    }

    @When("Click on change password")
    public void profileClickOnChangePassword() {
        wait.until(elementToBeClickable(buttonChangePassword)).click();
    }

    /**
     * extracting the updated (pending) email from confirmation pop up
     * verifying it email stored in a user object.
     */
    @When("extract email")
    public void profileConfirmationPopupExtractEmail() {
        assertThat(wait.until(visibilityOf(newEmail)).getText())
                .as("new email address")
                .isEqualTo(data.getUsers().get("primary").getEmail());
    }

    /**
     * @param passwordType the type of password to send.
     */
    @When("My account - Write {} password in the confirm new password field")
    public void profileWriteInTheConfirmNewPasswordField(PasswordType passwordType) {
        wait.until(visibilityOf(inputConfirmPassword)).sendKeys(passwordType.getValue());
    }

    @When("Click on change email")
    public void profileClickOnChangeEmail() {
        wait.until(elementToBeClickable(buttonChangeEmail)).click();
    }

    @When("Click on change phone number")
    public void clickOnChangePhoneNumber() {
        wait.until(elementToBeClickable(buttonChangePhone)).click();
    }

    @Then("Enter the current password of {user} user")
    public void myAccountInsertConfirmationPassword(User user) {
        wait.until(visibilityOf(inputVerifyPassword)).sendKeys(user.getPassword());
    }

    @And("My account - Click on continue on verify password button")
    public void myAccountClickOnTheVerifyPassword() {
        wait.until(elementToBeClickable(buttonContinuePasswordVerification)).click();
    }

    @When("Registration - Email update - Click on save button")
    @When("My account - Click on save button")
    public void myAccountClickOnSave() {
        wait.until(elementToBeClickable(myAccountSaveButton)).click();
    }
}
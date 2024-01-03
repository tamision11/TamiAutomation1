package glue.steps.web.pages.clientweb;

import com.google.common.util.concurrent.Uninterruptibles;
import common.glue.steps.web.pages.WebPage;
import entity.User;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import lombok.Getter;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.time.Duration;
import java.util.List;

/**
 * User: nirtal
 * Date: 30/12/2021
 * Time: 13:54
 * Created with IntelliJ IDEA
 */
@Getter
public class TwoFactorAuthenticationWebPage extends WebPage {

    @FindBy(css = "[data-qa='2faReminderLaterButton']")
    private WebElement reminderLaterButton;
    @FindBy(css = "[data-qa='2faVerifyResendCodeButton'], [data-qa='2faVerifyResendCodeButton2'], [data-qa=myAccountChange2faResendCodeButton]")
    private WebElement resendVerificationCodeButton;
    @FindBy(css = "[data-qa='2faVerifySendToEmailButton']")
    private WebElement sendToEmailButton;
    @FindBy(css = "[data-qa='2faVerifySendToPhoneButton'], [data-qa=myAccountChange2faChangePhoneButton]")
    private WebElement sendToPhoneButton;
    @FindBy(css = "[data-qa='2faChangePhoneButton'], [data-qa=myAccountChange2faChangePhoneButton]")
    private WebElement changePhoneNumber;
    @FindBy(css = "[data-qa='2faReminderPhoneInput'], [data-qa=myAccountChangeNumberInput]")
    private WebElement reminderPhoneInput;
    @FindBy(css = "[data-qa^=verificationCodeInput]")
    private List<WebElement> verificationCodeInput;
    @FindBy(css = "[data-qa='2faReminderContinueButton'], [data-qa='2faVerifyContinueButton'], [data-qa=myAccountChange2faContinue2faButton]")
    private WebElement continueButton;

    /**
     * The automation uses a new incognito session for every scenario.
     * 2fa is stored in local storage or session storage existing users will receive 2fa reminder every time they use a new window.
     */
    @When("2FA - Click on remind Later button")
    public void twoFactorAuthenticationClickOnRemindLaterButton() {
        wait.until(ExpectedConditions.elementToBeClickable(reminderLaterButton)).click();
    }

    @When("2FA - Click on continue button")
    public void twoFactorClickOnContinueButton() {
        wait.until(ExpectedConditions.elementToBeClickable(continueButton)).click();
    }

    @When("2FA - Click on change phone number button")
    public void twoFactorClickOnChangePhoneNumber() {
        wait.until(ExpectedConditions.elementToBeClickable(changePhoneNumber)).click();
    }

    /**
     * last iteration does not require click on the continue button.
     *
     * @param times number of times to send the verification code.
     */
    @Then("2FA - Send dummy verification code {int} time(s)")
    public void continueAfterDummyVerificationCode(int times) {
        for (int i = 1; i <= times; i++) {
            wait.until(ExpectedConditions.visibilityOfAllElements(verificationCodeInput))
                    .forEach(input -> input.sendKeys("1"));
            Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(3));
            if (i != times) {
                continueButton.click();
            }
        }
    }

    /**
     * first time will need to click the email button explicitly, then we will click the resend code button to continue
     * to use the email method.
     *
     * @param times number of times to resend the email verification code.
     */
    @Then("2FA - Resend verification code {int} time(s) to email")
    public void resendVerificationCodeToEmail(int times) {
        for (int time = 1; time <= times; time++) {
            Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(3));
            if (time == 1) {
                sendToEmailButton.click();
            } else {
                resendVerificationCodeButton.click();
            }
        }
    }

    /**
     * resend verification code to phone is the default method.
     * to use the email method.
     *
     * @param times number of times to resend the email verification code.
     */
    @Then("2FA - Resend verification code {int} time(s) to phone")
    public void resendVerificationCodeToPhone(int times) {
        for (int time = 1; time <= times; time++) {
            Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(3));
            resendVerificationCodeButton.click();
        }
    }

    @When("2FA - Fill phone number of {user} user")
    public void enterPhoneNumber(User user) {
        wait.until(ExpectedConditions.visibilityOf(reminderPhoneInput)).sendKeys(user.getPhoneNumber().substring(2));
    }
}

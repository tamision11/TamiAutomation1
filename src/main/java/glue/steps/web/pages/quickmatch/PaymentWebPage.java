package glue.steps.web.pages.quickmatch;

import annotations.Frame;
import com.google.common.util.concurrent.Uninterruptibles;
import common.glue.steps.web.pages.WebPage;
import entity.CreditCard;
import entity.User;
import io.cucumber.java.en.And;
import io.cucumber.java.en.When;
import io.qameta.allure.Allure;
import org.apache.commons.lang3.SystemUtils;
import org.awaitility.Awaitility;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;

import java.time.Duration;

import static enums.FrameTitle.*;
import static org.openqa.selenium.support.ui.ExpectedConditions.*;

public class PaymentWebPage extends WebPage {

    // region elements without data-qa
    @FindBy(css = "input[name=cardnumber],input[placeholder='Card number'], input[name=number]")
    private WebElement inputCardNumber;
    @FindBy(css = "#Field-countryInput")
    private WebElement countryDropDown;
    @FindBy(css = "input[type=checkbox]")
    private WebElement stripeLinkCheckbox;
    @FindBy(css = "input[name=linkMobilePhone]")
    private WebElement stripeLinkPhoneNumber;
    @FindBy(css = "input[placeholder='MM / YY'], input[name=exp-date], input[name=expiry]")
    private WebElement inputExpiration;
    @FindBy(css = "input[name=cvc]")
    private WebElement inputCVV;
    @FindBy(css = "input[name^=postal]")
    private WebElement inputZipCode;
    @FindAll({
            @FindBy(xpath = "//p[contains(text(), 'Continue to checkout')]/parent::button"),
            @FindBy(css = "[data-qa=registerWithBhCopayReviewPlanButton]"),
    })
    private WebElement buttonContinueToCheckout;
    @FindBy(css = "input[name=codeControllingInput]")
    private WebElement stripeLinkCode;
    @FindBy(css = "input[name=linkLegalName]")
    private WebElement stripeLinkLegalName;
    @FindBy(xpath = "//p[contains(text(), 'Provider')]/following-sibling::button/p[contains(text(), 'Change')]")
    private WebElement changeProviderButton;
    //endregion
    @FindBy(css = "[data-qa=submitNewCCButton]")
    private WebElement buttonCompletePurchase;
    @FindBy(css = "[data-qa=paymentFullNameInput]")
    private WebElement inputCardholder;

    @FindBy(css = "[data-qa=paymentTestEmailField]")
    private WebElement inputEmail;
    private final By buttonTestVisa = By.cssSelector("[data-qa=handleSubmitTestVisa]");
    private final By buttonTestMasterCard = By.cssSelector("[data-qa=handleSubmitTestMastercard]");
    private final By buttonTestInsufficientFunds = By.cssSelector("[data-qa=handleSubmitTestInsufficientFunds]");

    /**
     * inside {@link enums.FrameTitle#SECURE_PAYMENT_INPUT_FRAME} frame
     */
    @Frame(SECURE_PAYMENT_INPUT_FRAME)
    public void usingTheFollowingPaymentDetailsWithStripeLink(CreditCard creditCard, boolean checkStripeLinkCheckbox) {
        insertCardInfoToStripeLink(creditCard, checkStripeLinkCheckbox);
    }

    /**
     * step to support fallback to original stripe credit card payment.
     * internally calls {@link #usingTheFollowingPaymentDetailsWithStripeLink(CreditCard, boolean)}
     * and {@link #paymentPageClickOnCompletePurchase()}
     *
     * @param creditCard the {@link CreditCard} to purchase with
     */
    @When("Complete purchase using {cardType} card with stripe link {}")
    public void usingTheFollowingPaymentDetailsCucumber(CreditCard creditCard, boolean checkStripeLinkCheckbox) {
        insertCardHolderNameToStripeLink(creditCard);
        usingTheFollowingPaymentDetailsWithStripeLink(creditCard, checkStripeLinkCheckbox);
        Allure.step("switching to default frame", () -> driver.switchTo().defaultContent());
        clickOnCompletePurchase();
    }

    /**
     * inside {@link enums.FrameTitle#REACTIVATION} frame
     */
    @Frame({REACTIVATION})
    @And("Reactivation - Click on continue to checkout button")
    public void reactivationPaymentPageClickOnContinueToCheckoutButton() {
        wait.until(elementToBeClickable(buttonContinueToCheckout)).click();
    }

    public void clickOnCompletePurchase() {
        Awaitility.await()
                .alias("waiting for complete purchase button to be clicked")
                .atMost(Duration.ofSeconds(20))
                .pollInterval(Duration.ofSeconds(2))
                .ignoreExceptions()
                .until(() -> {
                    ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView();", buttonCompletePurchase);
                    wait.until(elementToBeClickable(buttonCompletePurchase)).click();
                    driver.findElement(By.cssSelector(".spinner"));
                    return true;
                });
        wait.until(ExpectedConditions.invisibilityOfElementLocated(By.cssSelector(".spinner")));
    }

    /**
     * internally calls {@link #paymentB2CInsertCardNumberWithStripe(CreditCard, boolean)}
     * and {@link #paymentPageClickOnCompletePurchase()}
     *
     * @param creditCard              the {@link CreditCard} to purchase with
     * @param checkStripeLinkCheckbox should we check stripe link checkbox?
     */
    @When("B2C Payment - Complete purchase using {cardType} card with stripe link {}")
    public void b2cCompletePurchase(CreditCard creditCard, boolean checkStripeLinkCheckbox) {
        insertCardHolderNameToStripeLink(creditCard);
        paymentB2CInsertCardNumberWithStripe(creditCard, checkStripeLinkCheckbox);
        paymentPageClickOnCompletePurchase();
    }

    /**
     * @param cardType the card type
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3054">Payment - skip Stripe payment except from dedicated tests</a>
     */
    @When("Payment - Complete purchase using {string} card for {user} user")
    public void completePayment(String cardType, User user) {
        wait.until(driver -> inputEmail.getAttribute("value").equals(user.getEmail()));
        switch (cardType) {
            case "visa" ->
                    ((JavascriptExecutor) driver).executeScript("arguments[0].click();", wait.until(presenceOfElementLocated(buttonTestVisa)));
            case "masterCard" ->
                    ((JavascriptExecutor) driver).executeScript("arguments[0].click();", wait.until(presenceOfElementLocated(buttonTestMasterCard)));
            case "insufficientFunds" ->
                    ((JavascriptExecutor) driver).executeScript("arguments[0].click();", wait.until(presenceOfElementLocated(buttonTestInsufficientFunds)));
            default -> throw new IllegalArgumentException("card type not supported");
        }
    }

    /**
     * internally calls {@link #paymentB2CInsertCardNumberWithStripe(CreditCard, boolean)}
     * and {@link #paymentPageClickOnCompletePurchase()}
     *
     * @param creditCard              the {@link CreditCard} to purchase with
     * @param checkStripeLinkCheckbox should we check stripe link checkbox?
     */
    @When("Eligibility B2C Payment - Complete purchase using {cardType} card with stripe link {}")
    public void eligibilityB2cCompletePurchase(CreditCard creditCard, boolean checkStripeLinkCheckbox) {
        insertCardHolderNameToStripeLink(creditCard);
        eligibilityPaymentB2CInsertCardNumberWithStripe(creditCard, checkStripeLinkCheckbox);
        eligibilityPaymentPageClickOnCompletePurchase();
    }

    /**
     * internally calls {@link #paymentB2CInsertCardNumberWithStripe(CreditCard, boolean)}
     * and {@link #paymentPageClickOnCompletePurchase()}
     *
     * @param creditCard              the {@link CreditCard} to purchase with
     * @param checkStripeLinkCheckbox should we check stripe link checkbox?
     */
    @When("Reactivation B2C Payment - Complete purchase using {cardType} card with stripe link {}")
    public void reactivationB2cCompletePurchase(CreditCard creditCard, boolean checkStripeLinkCheckbox) {
        insertCardHolderNameToStripeLink(creditCard);
        reactivationPaymentB2CInsertCardNumberWithStripe(creditCard, checkStripeLinkCheckbox);
        reactivationPaymentPageClickOnCompletePurchase();
    }

    /**
     * internally calls {@link #paymentB2CInsertCardNumberWithStripe(CreditCard, boolean)}
     * and {@link #paymentPageClickOnCompletePurchase()}
     *
     * @param creditCard the {@link CreditCard} to purchase with
     */
    @When("B2C Payment - Complete purchase with {cardType} card using stripe link")
    public void b2cCompletePurchase(CreditCard creditCard) {
        insertCardHolderNameToStripeLink(creditCard);
        insertStripeLinkCodeB2C();
        eligibilityPaymentPageClickOnCompletePurchase();
    }

    /**
     * inside {@link enums.FrameTitle#SECURE_CARD_PAYMENT_INPUT_FRAME} frame
     */
    @Frame(SECURE_CARD_PAYMENT_INPUT_FRAME)
    @When("SMB - Insert {cardType} card")
    public void smbInsertPaymentDetails(CreditCard creditCard) {
        insertCardDetails(creditCard);
    }

    /**
     * @param creditCard the credit card to purchase with
     */
    public void insertCardDetails(CreditCard creditCard) {
        inputCardNumber.sendKeys(creditCard.cardNumber());
        inputCVV.sendKeys(creditCard.cvv());
        wait.until(visibilityOf(inputZipCode)).sendKeys(creditCard.zipCode());
        inputExpiration.sendKeys(creditCard.expirationDate());
    }

    /**
     * inside {@link enums.FrameTitle#CHECK_MY_COVERAGE} and then  {@link enums.FrameTitle#SECURE_EMAIL_INPUT_FRAME} frame
     */
    @Frame({CHECK_MY_COVERAGE, SECURE_EMAIL_INPUT_FRAME})
    public void insertStripeLinkCodeB2C() {
        paymentInsertStripeLinkCode();
    }

    /**
     * inside {@link enums.FrameTitle#SECURE_EMAIL_INPUT_FRAME} frame
     */
    @Frame({SECURE_EMAIL_INPUT_FRAME})
    @When("Payment and Plan - Insert stripe link code")
    public void insertStripeLinkCodeClientWeb() {
        paymentInsertStripeLinkCode();
    }

    /**
     * internally calls {@link #paymentB2BWithStripeLink(CreditCard, boolean)}
     * and {@link #paymentPageClickOnCompletePurchaseB2b()}
     *
     * @param creditCard              the {@link CreditCard} to purchase with
     * @param checkStripeLinkCheckbox should we check stripe link checkbox?
     */
    @When("B2B Payment - Complete purchase using {cardType} card with stripe link {}")
    public void b2bCompletePurchase(CreditCard creditCard, boolean checkStripeLinkCheckbox) {
        insertCardHolderNameToStripeLink(creditCard);
        paymentB2BWithStripeLink(creditCard, checkStripeLinkCheckbox);
        paymentPageClickOnCompletePurchaseB2b();
    }

    /**
     * inside {@link enums.FrameTitle#REACTIVATION} frame
     */
    @Frame({REACTIVATION})
    @When("Reactivation B2B Payment - Complete purchase using {cardType} card with stripe link {}")
    public void reactivationB2bCompletePurchase(CreditCard creditCard, boolean checkStripeLinkCheckbox) {
        insertCardHolderNameToStripeLink(creditCard);
        reactivationPaymentB2BWithStripeLink(creditCard, checkStripeLinkCheckbox);
        reactivationPaymentPageClickOnCompletePurchaseB2b();
    }

    /**
     * inside {@link enums.FrameTitle#SECURE_PAYMENT_INPUT_FRAME} frame
     */
    @Frame(SECURE_PAYMENT_INPUT_FRAME)
    public void insertPaymentDetailsWithStripeLink(CreditCard creditCard, boolean checkStripeLinkCheckbox) {
        insertCardInfoToStripeLink(creditCard, checkStripeLinkCheckbox);
    }

    /**
     * inside {@link enums.FrameTitle#DEFAULT} frame
     */
    @Frame(DEFAULT)
    @When("Update payment details to {cardType} card with stripe link {}")
    public void insertPaymentDetailsCucumber(CreditCard creditCard, boolean checkStripeLinkCheckbox) {
        insertCardHolderNameToStripeLink(creditCard);
        insertPaymentDetailsWithStripeLink(creditCard, checkStripeLinkCheckbox);
    }

    /**
     * inside {@link enums.FrameTitle#CHECK_MY_COVERAGE} and then  {@link enums.FrameTitle#SECURE_PAYMENT_INPUT_FRAME} frame
     */
    @Frame({CHECK_MY_COVERAGE, SECURE_PAYMENT_INPUT_FRAME})
    public void paymentB2BWithStripeLink(CreditCard creditCard, boolean checkStripeLinkCheckbox) {
        insertCardInfoToStripeLink(creditCard, checkStripeLinkCheckbox);
    }

    /**
     * inside {@link enums.FrameTitle#REACTIVATION} and then  {@link enums.FrameTitle#SECURE_PAYMENT_INPUT_FRAME} frame
     */
    @Frame({REACTIVATION, SECURE_PAYMENT_INPUT_FRAME})
    public void reactivationPaymentB2BWithStripeLink(CreditCard creditCard, boolean checkStripeLinkCheckbox) {
        insertCardInfoToStripeLink(creditCard, checkStripeLinkCheckbox);
    }


    /**
     * inside {@link enums.FrameTitle#CHECK_MY_COVERAGE} frame
     */
    @Frame(CHECK_MY_COVERAGE)
    @When("B2B - Click on complete purchase")
    public void paymentPageClickOnCompletePurchaseB2b() {
        clickOnCompletePurchase();
    }

    /**
     * inside {@link enums.FrameTitle#REACTIVATION} frame
     */
    @Frame(REACTIVATION)
    public void reactivationPaymentPageClickOnCompletePurchaseB2b() {
        clickOnCompletePurchase();
    }


    /**
     * inside {@link enums.FrameTitle#DEFAULT} frame
     */
    @Frame(DEFAULT)
    public void paymentPageClickOnCompletePurchase() {
        clickOnCompletePurchase();
    }

    /**
     * inside {@link enums.FrameTitle#CHECK_MY_COVERAGE} frame
     */
    @Frame(CHECK_MY_COVERAGE)
    public void eligibilityPaymentPageClickOnCompletePurchase() {
        clickOnCompletePurchase();
    }

    /**
     * inside {@link enums.FrameTitle#REACTIVATION} frame
     */
    @Frame(REACTIVATION)
    public void reactivationPaymentPageClickOnCompletePurchase() {
        clickOnCompletePurchase();
    }

    @And("Click on continue to checkout button")
    public void paymentPageClickOnContinueToCheckoutButton() {
        wait.until(elementToBeClickable(buttonContinueToCheckout)).click();
    }

    @And("Complete purchase is displayed")
    public void completePurchaseButtonIsDisplayed() {
        wait.until(elementToBeClickable(buttonCompletePurchase));
    }

    /**
     * inside {@link enums.FrameTitle#SECURE_PAYMENT_INPUT_FRAME} frame
     */
    @Frame({SECURE_PAYMENT_INPUT_FRAME})
    public void paymentB2CInsertCardNumberWithStripe(CreditCard creditCard, boolean checkStripeLinkCheckbox) {
        insertCardInfoToStripeLink(creditCard, checkStripeLinkCheckbox);
    }

    /**
     * inside {@link enums.FrameTitle#CHECK_MY_COVERAGE} and then  {@link enums.FrameTitle#SECURE_PAYMENT_INPUT_FRAME} frame
     */
    @Frame({CHECK_MY_COVERAGE, SECURE_PAYMENT_INPUT_FRAME})
    public void eligibilityPaymentB2CInsertCardNumberWithStripe(CreditCard creditCard, boolean checkStripeLinkCheckbox) {
        insertCardInfoToStripeLink(creditCard, checkStripeLinkCheckbox);
    }

    /**
     * inside {@link enums.FrameTitle#REACTIVATION} and then  {@link enums.FrameTitle#SECURE_PAYMENT_INPUT_FRAME} frame
     */
    @Frame({REACTIVATION, SECURE_PAYMENT_INPUT_FRAME})
    public void reactivationPaymentB2CInsertCardNumberWithStripe(CreditCard creditCard, boolean checkStripeLinkCheckbox) {
        insertCardInfoToStripeLink(creditCard, checkStripeLinkCheckbox);
    }

    public void paymentInsertStripeLinkCode() {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(8));
        driver.findElement(By.cssSelector("div.p-AccordionButtonContent")).click();
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(8));
        for (int i = 0; i < 6; i++) {
            actions
                    .click(stripeLinkCode)
                    .sendKeys("1")
                    .perform();
        }
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(8));
    }

    /**
     * inside {@link enums.FrameTitle#REACTIVATION} and then  {@link enums.FrameTitle#OFFERS_PAGE} frame
     */
    @Frame({REACTIVATION, OFFERS_PAGE})
    @When("Reactivation Payment - Click on change provider")
    public void reactivationPaymentClickOnChangeProvider() {
        changeProviderButton.click();
    }

    /**
     * in case running on circle ci country is the United States and need to enter zipcode
     * we may need to uncheck stripe link checkbox if it is already checked by default
     * <p>
     * legal name only appears for local testing
     *
     * @param creditCard              the {@link CreditCard} to purchase with
     * @param checkStripeLinkCheckbox should we check stripe link checkbox?
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2649">Adjust our tests to Stripe LINK changes</a>
     */
    public void insertCardInfoToStripeLink(CreditCard creditCard, boolean checkStripeLinkCheckbox) {
        wait.until(visibilityOf(inputCardNumber)).sendKeys(creditCard.cardNumber());
        inputCVV.sendKeys(creditCard.cvv());
        inputExpiration.sendKeys(creditCard.expirationDate());
        new Select(countryDropDown).selectByValue("US");
        wait.until(visibilityOf(inputZipCode)).sendKeys(creditCard.zipCode());
        if (checkStripeLinkCheckbox) {
            ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView();", stripeLinkCheckbox);
            if (!stripeLinkCheckbox.isSelected()) {
                stripeLinkCheckbox.click();
            }
            new Select(driver.findElement(By.cssSelector("#Field-linkMobilePhoneCountryInput"))).selectByValue("US");
            stripeLinkPhoneNumber.sendKeys("2025550126");
            if (SystemUtils.IS_OS_MAC) {
                stripeLinkLegalName.sendKeys(creditCard.cardHolderName());
            }
        } else if (!driver.findElements(By.cssSelector("input[type=checkbox]")).isEmpty()) {
            if (stripeLinkCheckbox.isSelected()) {
                ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView();", stripeLinkCheckbox);
                stripeLinkCheckbox.click();
            }
        }
    }

    /**
     * inside {@link enums.FrameTitle#DEFAULT} frame
     */
    @Frame(DEFAULT)
    @And("Update payment details - Insert {cardType} card holder name")
    public void updatePaymentDetailsInsertCardHolderName(CreditCard creditCard) {
        wait.until(visibilityOf(inputCardholder)).sendKeys(creditCard.cardHolderName());
    }

    @And("Payment - Enter cardholder name of {cardType} card")
    public void insertCardHolderNameToStripeLink(CreditCard creditCard) {
        wait.until(visibilityOf(inputCardholder)).sendKeys(creditCard.cardHolderName());
    }
}

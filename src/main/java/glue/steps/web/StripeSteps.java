package glue.steps.web;

import annotations.Frame;
import com.google.inject.Inject;
import common.glue.steps.web.pages.quickmatch.PaymentWebPage;
import entity.CreditCard;
import enums.Domain;
import io.cucumber.java.en.And;
import io.qameta.allure.Allure;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.support.ui.ExpectedConditions;

import static enums.FrameTitle.DEFAULT;

/**
 * User: nirtal
 * Date: 31/05/2023
 * Time: 10:50
 * Created with IntelliJ IDEA
 */
public class StripeSteps extends Step {

    @Inject
    private PaymentWebPage paymentWebPage;

    private final By paymentButton = By.cssSelector(".SubmitButton-IconContainer");

    @And("Stripe - Open payment link")
    public void navigateToPayment() {
        Allure.addAttachment("Payment URL", scenarioContext.getSqlAndApiResults().get("payment_url"));
        driver.get(scenarioContext.getSqlAndApiResults().get("payment_url"));
    }

    /**
     * Insert credit card details.
     * Will be used only in dev environment, on canary env the credit card details are already pre-filled
     *
     * @param creditCard              credit card details
     * @param checkStripeLinkCheckbox check stripe link checkbox
     */
    @And("Stripe - Insert {cardType} card with stripe link {}")
    public void stripeInsertCardDetails(CreditCard creditCard, boolean checkStripeLinkCheckbox) {
        if (data.getConfiguration().getDomain().equals(Domain.CANARY.getName())) {
            paymentWebPage.usingTheFollowingPaymentDetailsWithStripeLink(creditCard, checkStripeLinkCheckbox);
        }
    }

    /**
     * inside {@link enums.FrameTitle#DEFAULT} frame
     */
    @And("Stripe - Click on complete payment")
    @Frame(DEFAULT)
    public void payInvoice() {
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", wait.until(ExpectedConditions.visibilityOfElementLocated(paymentButton)));
        wait.until(ExpectedConditions.invisibilityOfElementLocated(paymentButton));
    }
}
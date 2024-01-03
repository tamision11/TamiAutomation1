package glue.steps.web.pages.clientweb;

import common.glue.steps.web.pages.WebPage;
import common.glue.utilities.GeneralActions;
import enums.data.CouponType;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import lombok.Getter;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.testng.Assert;

import static org.assertj.core.api.Assertions.assertThat;
import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;
import static org.openqa.selenium.support.ui.ExpectedConditions.visibilityOf;

@Getter
public class CheckOutWebPage extends WebPage {

    // region elements without data-qa
    private final By totalValue = By.xpath("//p[contains(text(), 'Summary')]/following-sibling::div/p[2]");
    @FindBy(css = "button > p")
    private WebElement buttonCompletePurchase;
    @FindBy(xpath = "//button/p[contains(text(), 'Confirm plan change')]")
    private WebElement buttonReviewYourNewPlan;
    @FindBy(xpath = "//button[contains(text(), 'Close')]")
    private WebElement buttonClose;
    @FindBy(xpath = "//p[contains(text(), 'Subscription plan')]/following-sibling::button/p[contains(text(),'Change')]")
    private WebElement buttonChangePlan;
    @FindBy(xpath = "//button[contains(text(), 'Apply Coupon')]")
    private WebElement buttonApplyExitIntentPromoCode;
    @FindBy(xpath = "//header[@id='header']")
    private WebElement qmPageHeader;
    @FindBy(xpath = "//p[contains(text(), 'Payment details')]/following-sibling::button/p[contains(text(),'Change')]")
    private WebElement buttonChangePayment;
    @FindBy(css = "[placeholder='Enter code']")
    private WebElement inputCoupon;
    @FindBy(css = "div ~ button")
    private WebElement buttonApplyCoupon;
    //endregion

    @FindBy(css = "[data-qa=couponSuccessTitle]")
    private WebElement redeemedCouponText;
    @FindBy(css = "[data-qa=couponSuccessVoucherType]")
    private WebElement redeemedCouponVoucherText;
    @FindBy(css = "[data-qa=couponSuccessDetails]")
    private WebElement redeemedCouponDetailsText;
    @FindBy(css = "[data-qa=couponError]")
    private WebElement redeemedCouponNotValid;


    private String calculateTotalFixCoupon(String value) {
        var sTotalValue = driver.findElement(totalValue).getText().substring(1);
        if (sTotalValue.length() > 4) {
            sTotalValue = sTotalValue.replace(",", StringUtils.EMPTY);
        }
        var totalValue = Integer.parseInt(sTotalValue);
        var couponValue = Integer.parseInt(value.substring(1));
        return String.valueOf(totalValue - couponValue);
    }

    private String calculatePercentCoupon(String value) {
        var sTotalValue = driver.findElement(totalValue).getText().substring(1);
        if (sTotalValue.length() > 4) {
            sTotalValue = sTotalValue.replace(",", StringUtils.EMPTY);
        }
        var totalValue = Integer.parseInt(sTotalValue);
        var couponValue = Integer.parseInt(value);
        var returnValue = (couponValue * totalValue) / 100;
        return String.valueOf(returnValue);
    }

    @When("Click on Confirm plan change button")
    public void checkoutPageClickOnConfirmPlanChangeButton() {
        wait.until(elementToBeClickable(buttonReviewYourNewPlan)).click();
    }

    @When("Click on Close button")
    public void checkoutPageClickOnCloseButton() {
        wait.until(elementToBeClickable(buttonClose)).click();
    }

    /**
     * @param couponType the coupon to be applied
     * @param withSpace  do we want to append spaces to the applied coupon to check if the trimming works.
     */
    @And("Apply {} coupon with space {}")
    public void checkoutPageCouponInputCoupon(CouponType couponType, boolean withSpace) {
        if (withSpace) {
            wait.until(visibilityOf(inputCoupon)).sendKeys(Keys.SPACE + couponType.getCode() + Keys.SPACE);
        } else {
            wait.until(visibilityOf(inputCoupon)).sendKeys(couponType.getCode());
        }
        buttonApplyCoupon.click();
    }

    @When("Click on Change button for plan")
    public void checkoutPageClickOnChangeButtonForPlan() {
        wait.until(elementToBeClickable(buttonChangePlan)).click();
    }

    @When("Click on change button for payment")
    public void checkoutPageClickOnChangeButtonForPayment() {
        wait.until(elementToBeClickable(buttonChangePayment)).click();
    }

    @When("Hover on top of the screen")
    public void hoverOnTopOfScreen() {
        actions.moveByOffset(1, 1).perform();
    }

    @When("Apply Exit Intent promo code")
    public void applyExitIntentPromoCode() {
        wait.until(elementToBeClickable(buttonApplyExitIntentPromoCode)).click();
    }

    private String calculateTotalForPercentCoupon(String value) {
        var sTotalValue = driver.findElement(totalValue).getText().substring(1);
        if (sTotalValue.length() > 4) {
            sTotalValue = sTotalValue.replace(",", StringUtils.EMPTY);
        }
        var totalValue = Integer.parseInt(sTotalValue);
        var couponValue = Integer.parseInt(calculatePercentCoupon(value));
        return String.valueOf(totalValue - couponValue);
    }

    /**
     * will only apply prod coupon when running on prod
     */
    @And("Apply free coupon if running on prod")
    public void checkoutPageCouponInputCoupon() {
        if (GeneralActions.isRunningOnProd()) {
            inputCoupon.sendKeys(CouponType.PROD.getCode());
            buttonApplyCoupon.click();
        }
    }

    /**
     * will apply prod coupon when running on prod
     * on test environment, will use other coupons that not always gives 100% discount e.g WALMART (150$)
     *
     * @param couponType the coupon to be applied
     */
    @And("Apply {} coupon")
    public void checkoutPageCouponInputCoupon(CouponType couponType) {
        if (GeneralActions.isRunningOnProd()) {
            inputCoupon.sendKeys(CouponType.PROD.getCode());
            buttonApplyCoupon.click();
        } else {
            inputCoupon.sendKeys(couponType.getCode());
            buttonApplyCoupon.click();
        }
    }

    /**
     * @param couponType     the coupon to be applied
     * @param ifFixOrPercent is fix or percent
     */
    @Then("Coupon - Coupon {} {string} applied")
    public void checkoutPageCouponCouponApplied(CouponType couponType, String ifFixOrPercent) {
        Assert.assertTrue(verifyCouponApplied(couponType, ifFixOrPercent.toLowerCase().contains("percent")));
    }

    public boolean verifyCouponApplied(CouponType couponType, boolean percent) {
        WebElement text = wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//p[contains(text(), \"First charge promo " +
                couponType.getCode() + "\")]")));
        WebElement value;
        if (percent) {
            value = wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//p[contains(text(), \"-$" +
                    calculatePercentCoupon(couponType.getValue()) + "\")]")));
        } else {
            value = wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//p[contains(text(), \"-" +
                    couponType.getValue() + "\")]")));
        }
        return text.isDisplayed() && value.isDisplayed();
    }

    @When("Payment - page - Click on complete purchase")
    public void paymentPageClickOnCompletePurchase() {
        wait.until(elementToBeClickable(buttonCompletePurchase)).click();
    }

    /**
     * @param couponType     the coupon to be applied
     * @param ifFixOrPercent is fix or percent
     */
    @And("Coupon - Savings for coupon {} {string} are available")
    public void checkoutPageCouponSavingsForCouponAreAvailable(CouponType couponType, String ifFixOrPercent) {
        Assert.assertTrue(verifySavings(couponType.getValue(), ifFixOrPercent.toLowerCase().contains("percent")));
    }

    public boolean verifySavings(String couponValue, boolean percent) {
        var text = driver.findElement(By.xpath("//p[contains(text(), 'Your savings')]"));
        WebElement value;
        WebElement totalValue;
        if (percent) {
            value = driver.findElement(By.xpath("//p[contains(text(), \"$" +
                    calculatePercentCoupon(couponValue) + "\")]"));
            totalValue = driver.findElement(By.xpath("//p[contains(text(), \"$" +
                    calculateTotalForPercentCoupon(couponValue) + "\")]"));
        } else {
            value = driver.findElement(By.xpath("//p[contains(text(), \"" +
                    couponValue + "\")]"));
            totalValue = driver.findElement(By.xpath("//p[contains(text(), \"" +
                    calculateTotalFixCoupon(couponValue) + "\")]"));
        }
        return text.isDisplayed() && value.isDisplayed() && totalValue.isDisplayed();
    }

    @And("Apply coupon on renewal - fixed")
    public void couponOnRenewalFixed() {
        driver.get(GeneralActions.isRunningOnProd() ? "https://app.talkspace.com/room/%s?action=apply-coupon&code=CA0D45161BC76BCB06173F5BA7325ACB".formatted(getCurrentRoomId()) : "https://app.%s.talkspace.com/room/%s?action=apply-coupon&code=CA0D45161BC76BCB06173F5BA7325ACB".formatted(data.getConfiguration().getDomain(), getCurrentRoomId()));
    }

    @And("Apply coupon on renewal - percentage")
    public void couponOnRenewalPercentage() {
        driver.get(GeneralActions.isRunningOnProd() ? "https://app.talkspace.com/room/%s?action=apply-coupon&code=E6B74148F4603A0AD8D255A2438EC580".formatted(getCurrentRoomId()) : "https://app.%s.talkspace.com/room/%s?action=apply-coupon&code=E6B74148F4603A0AD8D255A2438EC580".formatted(data.getConfiguration().getDomain(), getCurrentRoomId()));
    }

    @And("Redeemed coupon text appears")
    public void redeemedCouponTextValidation() {
        assertThat(wait.until(ExpectedConditions.visibilityOf(redeemedCouponText)).getText())
                .contains("Coupon redeemed!");
        assertThat(wait.until(ExpectedConditions.visibilityOf(redeemedCouponVoucherText)).getText())
                .contains("$45 off your next payment");
        assertThat(wait.until(ExpectedConditions.visibilityOf(redeemedCouponDetailsText)).getText())
                .contains("Your coupon will be applied to your next payment on");
    }

    @And("Redeemed coupon appears")
    public void redeemedCouponPercentageValidation() {
        assertThat(wait.until(ExpectedConditions.visibilityOf(redeemedCouponText)).getText())
                .contains("Coupon redeemed!");
        assertThat(wait.until(ExpectedConditions.visibilityOf(redeemedCouponVoucherText)).getText())
                .contains("25% off your next payment");
    }

    @And("Redeemed coupon not valid")
    public void redeemedCouponNotValid() {
        assertThat(wait.until(ExpectedConditions.visibilityOf(redeemedCouponNotValid)).getText())
                .contains("The coupon you tried is not valid");
    }
}
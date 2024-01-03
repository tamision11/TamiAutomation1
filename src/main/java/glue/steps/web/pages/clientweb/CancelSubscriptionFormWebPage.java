package glue.steps.web.pages.clientweb;

import com.google.common.util.concurrent.Uninterruptibles;
import common.glue.steps.web.pages.WebPage;
import common.glue.utilities.GeneralActions;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.time.Duration;
import java.util.List;

import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;

public class CancelSubscriptionFormWebPage extends WebPage {

    // region elements without data-qa
    @FindBy(xpath = "//p[contains(text(), 'Done')]/parent::button")
    private WebElement buttonDone;
    @FindBy(xpath = "//p[contains(text(), 'Pause therapy')]/parent::button")
    private WebElement buttonPauseTherapy;
    @FindBy(xpath = "//p[contains(text(), 'Close')]/parent::button")
    private WebElement buttonClose;
    //endregion
    @FindBy(css = "[data-qa=cancellationTherapistReviewSubmitButton], [data-qa=b2bCancellationTherapistReviewSubmitButton]")
    private WebElement buttonSubmitReview;
    @FindBy(css = "[data-qa=cancellationReasonForCancellingPrimaryButton], [data-qa=b2bCancellationReasonForCancellingPrimaryButton], [data-qa=noMatchesCancellationReasonForCancellingPrimaryButton]")
    private WebElement buttonNextReasonForCancelling;
    @FindBy(css = "[data-qa=cancellationSureYouWantToCancelPrimaryButton]")
    private WebElement buttonCancelSubscriptionRenewal;
    @FindBy(css = "[data-qa=keepSessions]")
    private WebElement keepSessionsButton;
    @FindBy(css = "[data-qa=cancelSessions]")
    private WebElement continueWithCancelationButton;
    @FindBy(css = "[data-qa=goBackToRoom]")
    private WebElement goBackToRoomButton;
    @FindBy(css = "[data-qa=cancellationApplyDiscountPrimaryButton]")
    private WebElement buttonApplyDiscount;
    @FindBy(css = "[data-qa=cancellationApplyDiscountSecondaryButton]")
    private WebElement buttonNoApplyDiscount;
    @FindBy(css = "[data-qa=cancellationPauseSubscriptionPrimaryButton]")
    private WebElement buttonPauseSubscription;
    @FindBy(css = "[data-qa=cancellationPauseSubscriptionSecondaryButton]")
    private WebElement buttonNoPauseSubscription;
    @FindBy(css = "[data-qa=cancellationSwitchProviderPrimaryButton],[data-qa=b2bCancellationSwitchProviderPrimaryButton]")
    private WebElement buttonNewProvider;
    @FindBy(css = "[data-qa=cancellationSwitchProviderSecondaryButton],[data-qa=b2bCancellationSwitchProviderSecondaryButton]")
    private WebElement buttonNoNewProvider;
    @FindBy(css = "[data-qa=cancellationSwitchToMaintenancePlanPrimaryButton]")
    private WebElement buttonMaintenancePlan;
    @FindBy(css = "[data-qa=cancellationSwitchToMaintenancePlanSecondaryButton]")
    private WebElement buttonNoMaintenancePlan;
    @FindBy(css = "[data-qa=b2bCancellationSureYouWantToCancelPrimaryButton]")
    private WebElement buttonCancelMyPlan;
    @FindBy(css = "label[id^=uniqLabelID]")
    private List<WebElement> stars;
    @FindBy(css = "[data-qa=switchTherapistTherapistReviewSecondaryButton]")
    private WebElement skipRateTherapist;
    @FindBy(css = "[data-qa=cancellationSwitchToFinancialAidPrimaryButton]")
    private WebElement buttonApplyFinancialAid;
    @FindBy(css = "[data-qa=cancellationSwitchToFinancialAidSecondaryButton]")
    private WebElement buttonNoFinancialAid;
    @FindBy(css = "[data-qa=noMatchesCancellationSureYouWantToCancelPrimaryButton]")
    private WebElement noMatchesCancelMyPlanButton;
    @FindBy(css = "[data-qa=cancelSubscriptionButton]")
    private WebElement noMatchesCancelSubscriptionRenewalButton;

    /**
     * first we are waiting for the stars count to increase then we click on the desired amount
     *
     * @param star amount of stars to rate
     */
    @And("Rate provider with {int} stars")
    public void rateTherapistWithStars(int star) {
        wait.until(driver -> stars.size() > 2);
        wait.until(elementToBeClickable(stars.get(star - 1))).click();
    }

    @And("Skip rate provider question")
    public void skipRateTherapist() {
        wait.until(elementToBeClickable(skipRateTherapist)).click();
    }

    /**
     * When the wizard opens, a request is sent to the server to verify if the customer is eligible for a discount coupon.
     * The default is that the customer is not eligible unless the answer is received from the server that he is eligible.
     * Without a delay, the customer finishes the first step too quickly and gets to the second step before the answer is received from the server regarding eligibility.
     * In this case, the customer is not eligible and the wizard skips to the next step.
     * Canary might need extra delay to get the response from the server.
     * The delay was added in a delay step in the feature file to avoid adding it to all scenarios.
     */
    @Then("Cancel Subscription - Click on submit review button")
    public void cancelSubscriptionClickOnNextButton() {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(5));
        wait.until(elementToBeClickable(buttonSubmitReview)).click();
    }

    @Then("Cancel Subscription - Click on next button to select reason")
    public void selectReason() {
        wait.until(elementToBeClickable(buttonNextReasonForCancelling)).click();
    }

    @Then("Cancel Subscription - Click on keep my sessions button")
    public void keepMySessionsButton() {
        wait.until(elementToBeClickable(keepSessionsButton)).click();
    }

    @Then("Cancel Subscription - Click on continue with cancellation button")
    public void continueWithCancellationButton() {
        wait.until(elementToBeClickable(continueWithCancelationButton)).click();
    }

    @Then("Cancel Subscription - Click on go back to room button")
    public void goBackToRoomButton() {
        wait.until(elementToBeClickable(goBackToRoomButton)).click();
    }

    @Then("Cancel Subscription - Click on cancel my plan")
    public void noMatchesCancelPlanButton() {
        wait.until(elementToBeClickable(noMatchesCancelMyPlanButton)).click();
    }

    @When("Cancel Subscription - Click on cancel subscription renewal")
    public void paymentAndPlanClickOnCancelSubscriptionRenewal() {
        wait.until(elementToBeClickable(noMatchesCancelSubscriptionRenewalButton)).click();
    }

    /**
     * We changed the prod discount from a line item to a regular coupon.
     * When using a regular coupon, the system does not show the discount screen on the wizard, to prevent doubling the discounts.
     * We will skip this question when running on prod.
     */
    @When("Cancel Subscription - Click on no thanks button")
    public void cancelSubscriptionClickOnNoThanksButton() {
        if (!GeneralActions.isRunningOnProd()) {
            wait.until(elementToBeClickable(buttonNoApplyDiscount)).click();
        }
    }

    @When("Cancel Subscription - Click on not interested in financial aid button")
    public void cancelSubscriptionClickOnNotInterestedInFaButton() {
        buttonNoFinancialAid.click();
    }

    @When("Cancel Subscription - Click on apply financial aid button")
    public void cancelSubscriptionClickOnApplyFaButton() {
        buttonApplyFinancialAid.click();
    }

    @When("Cancel Subscription - Click on pause subscription button")
    public void cancelSubscriptionClickOnPauseSubscriptionButton() {
        buttonPauseSubscription.click();
    }

    @And("Cancel Subscription - Click on button don't pause Subscription")
    public void cancelSubscriptionClickOnButtonDonTPauseSubscription() {
        wait.until(elementToBeClickable(buttonNoPauseSubscription)).click();
    }

    @And("Cancel Subscription - Click on not interested in new provider button")
    public void cancelSubscriptionClickOnNotInterestedInNewProviderButton() {
        wait.until(elementToBeClickable(buttonNoNewProvider)).click();
    }

    @And("Cancel Subscription - Click on not interested in plan button")
    public void cancelSubscriptionClickOnNotInterestedButton() {
        buttonNoMaintenancePlan.click();
    }

    @Then("Cancel Subscription - Click on cancel renewal button")
    public void cancelSubscriptionClickOnCancelRenewalButton() {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(3));
        wait.until(elementToBeClickable(buttonCancelSubscriptionRenewal)).click();
    }

    @And("Cancel Subscription - Click on Cancel my plan")
    public void cancelSubscriptionClickOnCancelMyPlan() {
        wait.until(elementToBeClickable(buttonCancelMyPlan)).click();
    }

    @When("Cancel Subscription - Click on Close button")
    public void cancelSubscriptionClickOnCloseButton() {
        wait.until(elementToBeClickable(buttonClose)).click();
    }

    @When("Cancel Subscription - Click Done button")
    public void cancelSubscriptionClickDoneButton() {
        wait.until(elementToBeClickable(buttonDone)).click();
    }

    @And("Cancel Subscription - Click on button Apply discount")
    public void cancelSubscriptionClickOnButtonApplyDiscount() {
        wait.until(elementToBeClickable(buttonApplyDiscount)).click();
    }

    @When("Cancel Subscription - Click on pause Therapy button")
    public void cancelSubscriptionClickOnPauseTherapyButton() {
        wait.until(elementToBeClickable(buttonPauseTherapy)).click();
    }

    @When("Cancel Subscription - Click on Switch to maintenance plan button")
    public void cancelSubscriptionClickOnSwitchToMaintenancePlanButton() {
        wait.until(elementToBeClickable(buttonMaintenancePlan)).click();
    }

    @When("Cancel Subscription - Click on new provider button")
    public void cancelSubscriptionClickOnNewProviderButton() {
        wait.until(elementToBeClickable(buttonNewProvider)).click();
    }

    @When("Cancel Subscription - Cancel plan button not available")
    public void cancelButtonNotAvailable() {
        wait.until(ExpectedConditions.invisibilityOf(noMatchesCancelSubscriptionRenewalButton));
    }
}
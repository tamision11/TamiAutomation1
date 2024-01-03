package glue.steps.web.pages.clientweb.myaccount;

import annotations.Frame;
import com.google.common.util.concurrent.Uninterruptibles;
import common.glue.steps.web.pages.WebPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import lombok.Getter;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.SoftAssertions;
import org.awaitility.Awaitility;
import org.openqa.selenium.By;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.time.Duration;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

import static enums.FrameTitle.DEFAULT;
import static enums.FrameTitle.SECURE_PAYMENT_INPUT_FRAME;
import static org.assertj.core.api.Assertions.assertThat;
import static org.openqa.selenium.support.ui.ExpectedConditions.*;

@Getter
public class PaymentAndPlanWebPage extends WebPage {

    // region elements without data-qa
    private final By waitingToBeMatchedLocator = By.xpath("//h3[contains(text(), 'Waiting to be matched')]");
    private final By notYetMatchedLocator = By.xpath("//h3[contains(text(), 'Not yet matched')]");
    @FindBy(css = "button[aria-label=close]")
    private WebElement closeButton;
    @FindBy(xpath = "//button[contains(text(), 'Change')]")
    private WebElement changeStripeLinkCard;
    @FindBy(xpath = "//div[contains(text(), 'New payment method')]")
    private WebElement addNewPaymentMethod;
    @FindBy(xpath = "//button[contains(text(), 'Subscribe')]")
    private WebElement buttonSubscribe;
    @FindBy(xpath = "//p[contains(text(), 'Stop subscription renewal')]")
    private WebElement buttonStopSubscriptionRenewal;
    @FindBy(xpath = "//button[contains(text(),'Undo cancellation')]")
    private WebElement buttonUndoCancel;
    @FindBy(xpath = "//button[contains(text(),'Resume therapy')]")
    private WebElement buttonResumeTherapy;
    @FindBy(css = "h3")
    private WebElement therapistName;
    @FindBy(xpath = "//p[contains(text(), 'Save')]")
    private WebElement buttonSave;
    /**
     * the button that opens the pause model
     */
    @FindBy(xpath = "//p[contains(text(),'Pause therapy')]")
    private WebElement buttonPauseTherapy;
    @FindBy(xpath = "//p[contains(text(),'Change plan')]")
    private WebElement buttonChangePlan;
    @FindBy(xpath = "//p[contains(text(),'Paused')]")
    private WebElement titlePaused;
    @FindBy(xpath = "//p[contains(text(),'Your subscription is paused')]")
    private WebElement descriptionPaused;
    @FindBy(xpath = "//button[contains(text(),'Cancel')]")
    private WebElement buttonCancelResumeTherapy;
    @FindBy(xpath = "//p[contains(text(), 'Cancel my plan')]")
    private WebElement buttonCancelMyPlan;
    @FindBy(css = "[role=tabpanel]")
    private WebElement planInfoPanel;
    @FindBy(css = "[alt=avatar]")
    private WebElement therapistAvatar;
    @FindBy(css = "[id^=subTitle]")
    private WebElement therapistWilleNotifiedText;
    //endregion
    @FindBy(css = "[data-qa=nextRenewalViewDetailsButton]")
    private WebElement buttonViewRenewalDetails;
    private final By creditsList = By.cssSelector("[data-qa^=paymentAndPlanSession]");
    @FindBy(css = "[data-qa=closeInRoomScheduler]")
    private WebElement closeInRoomSchedulerButton;
    @FindBy(css = "[data-qa=needMoreHelp]")
    private WebElement needMoreHelpButton;
    @FindBy(css = "[data-qa=viewSuperbills]")
    private WebElement buttonViewSuperbills;
    @FindBy(css = "[data-qa=cancel]")
    private WebElement buttonCancel;
    @FindBy(css = "[data-qa=myAccountPaymentLinkWithStripePayment]")
    private WebElement stripePaymentMethod;
    @FindBy(css = "[data-qa=myAccountPaymentCreditCardDetails]")
    private WebElement nonStripePaymentMethod;
    @FindBy(css = "[data-qa=updateCoverage]")
    private WebElement buttonUpdateMyCoverage;
    @FindBy(css = "[data-qa=changeProvider]")
    private WebElement buttonChangeTherapist;

    /**
     * the button that pauses the subscription in the pause model.
     */
    @FindBy(css = "[data-qa=pause-therapy]")
    private WebElement pauseButton;
    /**
     * value in the first card in the list of rooms at Payment and plan page.
     */
    @FindBy(css = "[data-qa^=offerID]")
    private WebElement offerId;
    @FindBy(css = "[data-qa^=paymentAndPlanContainer]")
    private List<WebElement> roomContainerList;
    @FindBy(css = "[data-qa=myAccountPaymentUpdateOrAddButton]")
    private WebElement buttonUpdatePayment;

    @Then("Description above the resume therapy button appears")
    public void paymentAndPlanVerifyTextDescriptionAboveTheResumeTherapyButton() {
        wait.until(ExpectedConditions.visibilityOf(titlePaused));
        wait.until(ExpectedConditions.visibilityOf(descriptionPaused));
    }

    @Then("Click on pause Therapy")
    public void paymentAndPlanClickOnPauseTherapy() {
        wait.until(elementToBeClickable(buttonPauseTherapy)).click();
    }

    /**
     * @param roomIndex the room index in a room list.
     * @param dataTable the first column is reserved for plan name - the loop performs verification of video credits after purchase.
     *                  <p>
     *                  3 validation are performed:
     *                                     <ul>
     *                                        <li>plan name is equal to the name in the table
     *                                        <li>credit for each plan is equal to expected credit in the table
     *                                        <li>sum amount of credits is equal to table sum.
     *                                      </ul>
     *                  mismatches on credits between prod to dev/canary can occur if updates were done on prod without running DEVEK,
     *                  in that case it needs to fix on ous side and ask Yaeer to run DEVEK.
     *                  in case no credits are expected,
     *                  the table should contain only the plan name and the validation will be performed only on the plan name.
     * @see <a href="https://talktala.atlassian.net/browse/MEMBER-539">[EAP] As an EAP member on a live session plan*, I will not have a complimentary 10 minute introductory session in my account when I sign up </a>
     * @see <a href="https://talktala.atlassian.net/browse/CVR-931">Create 30-min video plans and a new offer </a>
     * @see <a href="https://talktala.atlassian.net/browse/CVR-928">Develop new plans + pricing </a>
     */
    @Then("Plan details for the {optionIndex} room are")
    public void myAccountVerifyVideoCreditsAreAvailable(int roomIndex, DataTable dataTable) {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(3));
        Awaitility.await()
                .atMost(Duration.ofSeconds(30))
                .pollInterval(Duration.ofSeconds(1))
                .ignoreExceptions()
                .until(() ->
                        StringUtils.isNotBlank(offerId.getAttribute("value")));
        SoftAssertions.assertSoftly(softAssertions -> {
            softAssertions.assertThat(roomContainerList.get(roomIndex).findElement(By.cssSelector("[data-qa=paymentAndPlanHeading]")).getText())
                    .as("plan name")
                    .isEqualToIgnoringWhitespace(dataTable.cell(0, 1));
            if (dataTable.cells().size() > 1) {
                var expectedCreditList = dataTable.rows(2)
                        .asMap(String.class, Long.class)
                        .entrySet()
                        .stream()
                        .filter(entry -> entry.getValue() > 0)
                        .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
                var delimiter = "- expires";
                var creditList = roomContainerList.get(roomIndex).findElements(creditsList)
                        .stream()
                        .map(WebElement::getText)
                        .map(credit -> credit.contains(delimiter) ? StringUtils.substringBefore(credit, delimiter).concat(delimiter) : credit)
                        .collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));
                softAssertions.assertThat(creditList)
                        .as("credit list")
                        .containsExactlyInAnyOrderEntriesOf(expectedCreditList);
            }
        });
    }

    @Then("Paused therapy button is available")
    public void paymentAndPlanVerifyPausedTherapyButtonIsAvailable() {
        wait.until(visibilityOf(buttonPauseTherapy));
    }

    @Then("Click on pause therapy button modal")
    public void paymentAndPlanClickOnPauseTherapyButtonModal() {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(3));
        wait.until(elementToBeClickable(pauseButton)).click();
    }

    @Then("Click on resume therapy")
    public void paymentAndPlanClickOnResumeTherapy() {
        wait.until(refreshed(elementToBeClickable(buttonResumeTherapy)));
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(5));
        wait.until(refreshed(elementToBeClickable(buttonResumeTherapy))).click();
    }

    @Then("Click on cancel until resume button is displayed")
    public void paymentAndPlanClickOnCancel() {
        wait.ignoring(StaleElementReferenceException.class).until(elementToBeClickable(buttonCancelResumeTherapy)).click();
        wait.until(visibilityOf(buttonResumeTherapy));
    }

    @Then("Payment and Plan - add new payment method")
    public void addAnotherPaymentMethod() {
        changePaymentMethod();
        wait.until(ExpectedConditions.elementToBeClickable(addNewPaymentMethod)).click();
    }

    /**
     * inside {@link enums.FrameTitle#SECURE_PAYMENT_INPUT_FRAME} frame
     */
    @Frame(SECURE_PAYMENT_INPUT_FRAME)
    @Given("Payment and Plan - Credit card list has {int} cards")
    public void creditCardListHas(int cardCount) {
        wait.until(ExpectedConditions.numberOfElementsToBe(By.cssSelector("div[role^=menuitem]"), cardCount));
    }

    /**
     * inside {@link enums.FrameTitle#SECURE_PAYMENT_INPUT_FRAME} frame
     */
    @Frame(SECURE_PAYMENT_INPUT_FRAME)
    @Then("Payment and Plan - change payment method")
    public void changePaymentMethod() {
        wait.until(ExpectedConditions.elementToBeClickable(changeStripeLinkCard)).click();
    }

    @Then("Payment and Plan - Waiting to be matched text is displayed for the {optionIndex} room")
    public void paymentAndPlanWaitingToBeMatchedTextDisplayed(int roomIndex) {
        Awaitility.await()
                .atMost(Duration.ofSeconds(30))
                .pollInterval(Duration.ofSeconds(1))
                .ignoreExceptions()
                .until(() -> roomContainerList.get(roomIndex).isDisplayed());
        assertThat(roomContainerList.get(roomIndex).findElement(waitingToBeMatchedLocator))
                .matches(WebElement::isDisplayed);
    }

    @Then("Payment and Plan - Not yet matched text is displayed for the {optionIndex} room")
    public void paymentAndPlanNotMatchedYetTextDisplayed(int roomIndex) {
        Awaitility.await()
                .alias("Room container is displayed")
                .atMost(Duration.ofSeconds(30))
                .pollInterval(Duration.ofSeconds(1))
                .ignoreExceptions()
                .until(() -> roomContainerList.get(roomIndex).isDisplayed());
        assertThat(roomContainerList.get(roomIndex).findElement(notYetMatchedLocator))
                .matches(WebElement::isDisplayed);
    }

    /**
     * @param roomIndex the room index in a room list.
     *                  this method is used to verify to no credits exists by trying to get when of the credit list element and expecting to fail with an exception.
     *                  can be used for CT exit/refund wizard flows.
     */
    @Then("No credits exist in the {optionIndex} room")
    public void verifyNoCredits(int roomIndex) {
        Awaitility.await()
                .alias("No credits exist in the" + roomIndex + "room")
                .atMost(Duration.ofSeconds(30))
                .pollInterval(Duration.ofSeconds(1))
                .ignoreExceptions()
                .until(() ->
                        StringUtils.isNotBlank(offerId.getAttribute("value")));
        assertThat(driver.findElements(creditsList))
                .as("Credit amount")
                .isEmpty();
    }

    @And("Undo Cancel button is available")
    public void paymentAndPlanUndoCancel() {
        wait.until(elementToBeClickable(buttonUndoCancel));
    }

    @Then("Pause Therapy - Click on cancel button")
    public void pauseClickOnCancelButton() {
        wait.until(ExpectedConditions.elementToBeClickable(buttonCancel)).click();
    }

    @And("Click on Undo cancellation")
    public void clickOnUndoCancellation() {
        wait.until(elementToBeClickable(buttonUndoCancel)).click();
    }

    @And("Click on need more help button")
    public void clickOnNeedMoreHelp() {
        wait.until(elementToBeClickable(needMoreHelpButton)).click();
    }

    @Then("Click on Change provider button")
    public void clickOnChangeTherapistButton() {
        wait.until(elementToBeClickable(buttonChangeTherapist)).click();
    }

    @Then("Click on view superbills button")
    public void paymentAndPlanClickOnViewSuperbillsButton() {
        wait.until(elementToBeClickable(buttonViewSuperbills)).click();
    }

    @When("Click on Cancel subscription")
    public void clickOnCancelSubscription() {
        wait.until(elementToBeClickable(buttonStopSubscriptionRenewal)).click();
    }

    @When("Click on Cancel my plan")
    public void clickOnCancelMyPlan() {
        wait.until(elementToBeClickable(buttonCancelMyPlan)).click();
    }

    @When("Payment and Plan - Click on the update button")
    public void paymentInformationClickOnTheUpdateButton() {
        wait.until(elementToBeClickable(buttonUpdatePayment)).click();
    }

    @When("Payment and Plan - Click on the update my coverage button")
    public void paymentAndPlanClickOnUpdateMyCoverageButton() {
        wait.until(elementToBeClickable(buttonUpdateMyCoverage)).click();
    }


    /**
     * inside {@link enums.FrameTitle#DEFAULT} frame
     */
    @Frame(DEFAULT)
    @When("Payment and Plan - Click on save button")
    public void paymentAndPlanClickOnSaveButton() {
        wait.until(ExpectedConditions.elementToBeClickable(buttonSave)).click();
    }

    @Then("Click on Subscribe button")
    public void clickOnSubscribeButton() {
        wait.until(elementToBeClickable(buttonSubscribe)).click();
    }

    @And("Click on view details button")
    public void clickOnViewDetailsButton() {
        wait.until(elementToBeClickable(buttonViewRenewalDetails)).click();
    }

    @When("Click on change plan")
    public void clickOnChangeSubscription() {
        wait.until(elementToBeClickable(buttonChangePlan)).click();
    }

    @Then("Resume therapy button is available")
    public void paymentAndPlanVerifyIfResumeTherapyButtonIsAvailable() {
        wait.until(visibilityOf(buttonResumeTherapy));
    }

    @Then("Need more help button is available")
    public void verifyNeedMoreHelpButtonIsAvailable() {
        wait.until(visibilityOf(needMoreHelpButton));
    }

    /**
     * we will verify elements according to the selected payment method.
     *
     * @param isStripeLink the payment method is stripe link?
     */
    @And("Payment and Plan - Payment method is stripe link {}")
    public void paymentAndPlanPaymentMethodIsStripeLink(boolean isStripeLink) {
        if (isStripeLink) {
            wait.until(ExpectedConditions.textToBePresentInElement(stripePaymentMethod, "“Link with Stripe” payment"));
        } else {
            wait.until(ExpectedConditions.visibilityOf(nonStripePaymentMethod));
        }
    }
}
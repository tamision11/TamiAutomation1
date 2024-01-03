package glue.steps.web.pages.clientweb;

import annotations.Frame;
import com.google.common.util.concurrent.Uninterruptibles;
import common.glue.steps.web.pages.WebPage;
import dev.failsafe.Failsafe;
import dev.failsafe.RetryPolicy;
import io.cucumber.java.en.And;
import io.cucumber.java.en.When;
import io.vavr.control.Try;
import lombok.Getter;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

import static enums.FrameTitle.DEFAULT;
import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;
import static org.openqa.selenium.support.ui.ExpectedConditions.refreshed;

/**
 * User: nirtal
 * Date: 07/08/2022
 * Time: 9:48
 * Created with IntelliJ IDEA
 */
@Getter
public class OnboardingWebPage extends WebPage {

    // region elements without data-qa
    @FindBy(xpath = "//button[contains(text(), 'Scroll to bottom')]")
    private WebElement buttonScroll;
    @FindBy(xpath = "//button[contains(text(), 'Agree')]")
    private WebElement buttonAgree;
    // endregion
    @FindBy(css = "[data-qa=dismissOnboarding]")
    private WebElement dismissOnboardingButton;
    @FindBy(css = "[data-qa=primaryButton]")
    private WebElement startOnboardingButton;
    @FindBy(css = "[data-qa=therapistCardMainButtonPress]")
    private WebElement meetYourProvider;
    @FindBy(css = "[data-qa=primaryButton]")
    private WebElement bookFirstSessionContinueBtn;
    @FindBy(css = "[data-qa=inRoomSchedulerSelectModalityContinue]")
    private WebElement modalitySelectionContinueBtn;
    @FindBy(css = "[data-qa=inRoomSchedulerSelectCreditContinue]")
    private WebElement durationSelectionContinueBtn;
    @FindBy(css = "[data-qa=inRoomSchedulingSelectTimeslotContinuePress]")
    private WebElement globalCalenderContinueBtn;
    @FindBy(css = "[data-qa=bookLaterPress]")
    private WebElement illBookLaterBtn;
    @FindBy(css = "[data-qa=noneOfTheseTimeWorksPress]")
    private WebElement noneOfTheseTimeWorksBtn;
    @FindBy(css = "[data-qa=goBackToBooking]")
    private WebElement goBackToBookingBtn;
    @FindBy(css = "[data-qa=matchQueueContinuePress]")
    private WebElement youreAllDoneContinueBtn;
    @FindBy(css = "[data-qa=messagingInformationNextButton]")
    private WebElement nextAsyncButton;
    @FindBy(css = "[data-qa=messagingInformationConfirmSessionButton], [data-qa=messagingInformationAgreeButton]")
    private WebElement confirmAsyncSessionButton;
    @FindBy(css = "[data-qa=recommendMessagingStartWithMessagingButton], [data-qa=bookASessionButton]")
    private WebElement startMessagingSession;
    @FindBy(css = "[data-qa=recommendMessagingStartWithLiveSessionButton]")
    private WebElement confirmLiveSessionButton;
    @FindBy(css = "[data-qa=qmSelectModalityContinueButton]")
    private WebElement modalityContinueButton;


    /**
     * inside {@link enums.FrameTitle#DEFAULT} frame
     */
    @Frame(DEFAULT)
    @When("Onboarding - Click on meet your provider button")
    public void clickMeetYourProviderButton() {
        wait.until(refreshed(ExpectedConditions.elementToBeClickable(meetYourProvider))).click();
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(3));
    }

    @When("Onboarding - Click on continue button")
    @When("Onboarding - Click on start onboarding button")
    @When("Onboarding - Click on close button")
    public void clickContinueButton() {
        wait.until(ExpectedConditions.elementToBeClickable(startOnboardingButton)).click();
    }

    /**
     * inside {@link enums.FrameTitle#DEFAULT} frame
     * Adding retry to avoid "org.openqa.selenium.InvalidArgumentException: invalid argument: uniqueContextId not found" error in Onboarding - Update my coverage - Book live first session - BH - Live + Messaging plan - Live state scenario
     */
    @Frame(DEFAULT)
    @When("Onboarding - Click continue on book first session")
    public void clickContinueBookFirstSession() {
        Failsafe.with(RetryPolicy.builder()
                        .withMaxRetries(3)
                        .withDelay(Duration.ofSeconds(5))
                        .build())
                .run(() -> bookFirstSessionContinueBtn.click());
    }

    @When("Onboarding - Click continue on modality selection")
    public void clickContinueModalitySelection() {
        wait.until(refreshed(ExpectedConditions.elementToBeClickable(modalitySelectionContinueBtn))).click();
    }

    @When("Onboarding - Click continue on duration selection")
    public void clickContinueDurationSelection() {
        wait.until(refreshed(ExpectedConditions.elementToBeClickable(durationSelectionContinueBtn))).click();
    }

    @When("Onboarding - Click continue on slot selection")
    public void clickContinueSlotSelection() {
        wait.until(refreshed(ExpectedConditions.elementToBeClickable(globalCalenderContinueBtn))).click();
    }

    @When("Onboarding - Click i'll book later")
    public void clickIllBookLaterBtn() {
        wait.until(refreshed(ExpectedConditions.elementToBeClickable(illBookLaterBtn))).click();
    }

    @When("Onboarding - Click None of these times work for me")
    public void clickNoneOfTimeWorksBtn() {
        wait.until(refreshed(ExpectedConditions.elementToBeClickable(noneOfTheseTimeWorksBtn))).click();
    }

    @When("Onboarding - Click go back to booking")
    public void clickGoBackToBookingBtn() {
        wait.until(refreshed(ExpectedConditions.elementToBeClickable(goBackToBookingBtn))).click();
    }

    @When("Onboarding - Click continue on your all done screen")
    public void clickContinueYourAllDone() {
        wait.until(refreshed(ExpectedConditions.elementToBeClickable(youreAllDoneContinueBtn))).click();
    }

    @And("Onboarding - Click on Start Messaging Session button")
    public void onboardingClickOnStartMessagingSessionButtonIfPresent() {
        Try.run(() -> new WebDriverWait(driver, Duration.ofSeconds(15)).until(elementToBeClickable(startMessagingSession)).click());
    }

    @And("Onboarding - Click on Async next button")
    public void onboardingClickOnAsyncNextButton() {
        wait.until(ExpectedConditions.elementToBeClickable(nextAsyncButton)).click();
    }

    @And("Onboarding - Click on Async confirm session button")
    public void onboardingClickOnAsyncConfirmSessionButton() {
        wait.until(ExpectedConditions.elementToBeClickable(confirmAsyncSessionButton)).click();
    }

    @And("Onboarding - Click on live confirm session button")
    public void onboardingClickOnLiveConfirmSessionButton() {
        wait.until(ExpectedConditions.elementToBeClickable(confirmLiveSessionButton)).click();
    }

    @And("Onboarding - Click on modality continue button")
    public void onboardingClickOnModalityContinueButton() {
        wait.until(ExpectedConditions.elementToBeClickable(modalityContinueButton)).click();
    }
}
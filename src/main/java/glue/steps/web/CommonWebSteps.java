package glue.steps.web;

import annotations.Frame;
import com.google.common.util.concurrent.Uninterruptibles;
import common.glue.utilities.GeneralActions;
import dev.failsafe.Failsafe;
import dev.failsafe.RetryPolicy;
import entity.User;
import enums.TwoFactorStatusType;
import enums.feature_flag.PrivateFeatureFlagType;
import extensions.ClientExtension;
import extensions.ResponseExtension;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.qameta.allure.Allure;
import lombok.experimental.ExtensionMethod;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assumptions;
import org.awaitility.Awaitility;
import org.openqa.selenium.*;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

import static enums.FrameTitle.REACTIVATION;
import static org.openqa.selenium.support.ui.ExpectedConditions.*;

/**
 * User: nirtal
 * Date: 03/05/2021
 * Time: 15:34
 * Created with IntelliJ IDEA
 * <p>
 * Steps that are common for all apps.
 */
@ExtensionMethod({ClientExtension.class, ResponseExtension.class})
public class CommonWebSteps extends Step {

    /**
     * this might fail in case we are trying to edit a cookie that does not exist.
     * this step also refreshes the screen in order for the new cookie to be effective.
     * <p>
     * the refresh action might trigger a "Reload site?" pop-up - we run some js before to prevent the pop-up from appearing.
     *
     * @param cookieKey   cookie key
     * @param cookieValue cookie value
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2700">QM - disable new b2b/b2c fork page design experiment </a>
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2702">QM - disabled new experiment screens on assessment flows </a>
     * @see <a href="https://stackoverflow.com/a/28015204/4515129">edit-cookies-in-selenium-webdriver</a>
     * @see <a href="https://stackoverflow.com/a/55590017/4515129">How to disable a "Reload site? Changes you made may not be saved" popup</a>
     */
    @And("Edit cookie: {string} with new value: {string}")
    public void addCookie(String cookieKey, String cookieValue) {
        ((JavascriptExecutor) driver).executeScript("window.onbeforeunload = function() {};");
        var cookie =
                Awaitility.await()
                        .alias(cookieKey.concat(StringUtils.SPACE).concat("exists"))
                        .atMost(Duration.ofSeconds(30))
                        .pollInterval(Duration.ofSeconds(1))
                        .ignoreExceptions()
                        .until(() -> driver.manage().getCookieNamed(cookieKey), Objects::nonNull);
        driver.manage().deleteCookie(cookie);
        driver.manage().addCookie(
                new Cookie.Builder(cookie.getName(), cookieValue)
                        .domain(cookie.getDomain())
                        .expiresOn(cookie.getExpiry())
                        .path(cookie.getPath())
                        .isSecure(cookie.isSecure())
                        .build());
        refreshPage();
    }

    @When("Refresh the page")
    public void refreshPage() {
        driver.navigate().refresh();
        Uninterruptibles.sleepUninterruptibly(2, TimeUnit.SECONDS);
    }

    @Then("Current url should match {url} url")
    @Then("Current url should match {string}")
    public void currentUrlShouldBe(String expectedUrl) {
        wait.until(urlToBe(expectedUrl));
    }

    @Then("Current url should not contain {string}")
    public void currentUrlShouldNotBe(String expectedUrl) {
        Assumptions.assumeThat(driver.getCurrentUrl()).doesNotContain(expectedUrl);
    }


    /**
     * @param age the age of the user
     */
    @And("Unified eligibility page - Enter age of {int} years old")
    public void enterAge(int age) {
        wait.until(visibilityOf(commonWebPage.getInputReactDateOfBirth())).sendKeys(GeneralActions.generateDate(0, 0, age));
    }

    /**
     * @param partialUrl the partial url that we want to check if it is present in the current url
     */
    @Then("Current url should contain {string}")
    public void currentUrlShouldContain(String partialUrl) {
        wait.until(urlContains(partialUrl));
    }

    /**
     * adding some retries to avoid {@link java.util.concurrent.TimeoutException} seen in headless mode
     *
     * @param url to navigate to
     */
    @Given("Navigate to {url}")
    public void navigateTo(String url) {
        Allure.addAttachment("URL", "text/uri-list", url);
        Failsafe.with(RetryPolicy.builder()
                        .withMaxRetries(3)
                        .withDelay(Duration.ofSeconds(5))
                        .build())
                .run(() -> driver.get(url));
    }

    @And("Switch to a new window")
    public void openNewTab() {
        driver.switchTo().newWindow(WindowType.WINDOW);
    }

    @And("Switch to a new tab")
    public void switchToNewTab() {
        driver.switchTo().newWindow(WindowType.TAB);
    }

    @And("close current tab")
    public void closeCurrentTab() {
        driver.close();
    }

    /**
     * changes the focus tab to the tab number given as parameter
     * NOTE: tab count starts from 0
     *
     * @param tabNumber the tab number to switch to
     **/
    @And("Switch focus to the {optionIndex} tab")
    public void switchTab(int tabNumber) {
        var tabs = new ArrayList<>(driver.getWindowHandles());
        if (tabNumber < tabs.size()) {
            driver.switchTo().window(tabs.get(tabNumber));
        }
    }

    /**
     * @param dropdownPosition position/index of the dropdown from the top of the page (0 for the first dropdown).
     * @param dropdownOptions  list of dropdown options.
     * @see <a href="https://tableconvert.com/markdown-to-markdown">table convert</a>
     */
    @And("Options of the {optionIndex} dropdown are")
    public void verifyDropDownOptions(int dropdownPosition, List<String> dropdownOptions) {
        scenarioContext.getSoftAssertions()
                .assertThat(commonWebPage.openDropdownAndCollectOptions(dropdownPosition))
                .as("Dropdown options")
                .containsExactlyInAnyOrderElementsOf(dropdownOptions);
    }

    /**
     * @param dropdownOptions list of dropdown options.
     * @see <a href="https://tableconvert.com/markdown-to-markdown">table convert</a>
     */
    @And("Options of referral dropdown are")
    public void verifyDropDownOptions(List<String> dropdownOptions) {
        scenarioContext.getSoftAssertions()
                .assertThat(commonWebPage.openDropdownAndCollectOptions(wait.until(ExpectedConditions.elementToBeClickable(loginWebPage.getReferralSourceDropdown()))::click))
                .as("Dropdown options")
                .containsExactlyInAnyOrderElementsOf(dropdownOptions);
    }

    @And("Click on {string} button")
    public void clickOnButtonWithText(String buttonText) {
        wait.until(refreshed(elementToBeClickable(By.xpath("//button[contains(text(), \"" + buttonText + "\")]")))).click();
    }

    @And("Enter adult customer's date of birth")
    public void enterCustomerDOB() {
        commonWebSteps.enterAge(18);
        wait.until(elementToBeClickable(flowWebPage.getDateOfBirthContinueButton())).click();
    }

    /**
     * inside {@link enums.FrameTitle#REACTIVATION} frame
     *
     * @param planPosition the plan position in the plan list.
     */
    @Frame({REACTIVATION})
    @When("Reactivation - Select the {optionIndex} plan")
    public void reactivationWidgetSelectPlan(int planPosition) {
        commonWebPage.selectPlan(planPosition);
    }

    @And("Continue with {string} billing period")
    public void continueWithBillingPeriod(String time) {
        commonWebPage.selectTime(time);
        Awaitility
                .await()
                .atMost(Duration.ofSeconds(30))
                .alias("Waiting for continue button")
                .pollInterval(Duration.ofSeconds(1))
                .until(() -> commonWebPage.getSelectPlanContinueButton()
                        .stream()
                        .filter(WebElement::isDisplayed)
                        .findFirst()
                        .orElseThrow(), Objects::nonNull)
                .click();
    }

    @When("Click on the escape keyboard button")
    public void clickOnEscapeKeyboardButton() {
        actions.sendKeys(Keys.ESCAPE)
                .build()
                .perform();
    }

    @Then("Scroll into view of {webElement} element")
    public void scrollIntoView(WebElement element) {
        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView();", element);
    }
    //region Skip a scenario based on feature flag status

    /**
     * This step used to check {@link PrivateFeatureFlagType} is enabled or not - and skip the scenario when a feature flag is not in the required state
     *
     * @param featureFlagType  private feature flag
     * @param activationStatus true if feature is enabled, false if feature is disabled.
     */
    @Then("{} private feature flag activation status is {}")
    public void featureFlagStatus(PrivateFeatureFlagType featureFlagType, boolean activationStatus) {
        Assumptions.assumeThat(scenarioContext.getPrivateFeatureFlagTypeMap().get(featureFlagType))
                .withFailMessage("'%s' is not in '%b' activation status - skipping this scenario", featureFlagType.getName(), activationStatus)
                .isEqualTo(activationStatus);
    }

    /**
     * @param user the {@link User}.
     */
    @And("Skip scenario if 2fa is disabled for {user} user")
    public void skipScenarioIfTwoFactorIsOff(User user) {
        Assumptions.assumeThat(user.getTwoFactorStatusType())
                .withFailMessage("Skipping scenario 2fa is disabled")
                .isNotEqualTo(TwoFactorStatusType.OFF);
    }
    //endregion
}
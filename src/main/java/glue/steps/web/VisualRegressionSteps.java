package glue.steps.web;

import com.assertthat.selenium_shutterbug.core.Capture;
import com.assertthat.selenium_shutterbug.core.Shutterbug;
import com.google.common.util.concurrent.Uninterruptibles;
import com.google.inject.Inject;
import common.glue.utilities.Constants;
import common.glue.utilities.VrtHelpers;
import di.providers.ScenarioContext;
import io.cucumber.java.en.Then;
import io.visual_regression_tracker.sdk_java.TestRunOptions;
import io.visual_regression_tracker.sdk_java.TestRunStatus;
import io.visual_regression_tracker.sdk_java.VisualRegressionTracker;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.io.IOException;
import java.time.Duration;
import java.util.Base64;
import java.util.List;
import java.util.stream.Stream;

/**
 * User: nirtal
 * Date: 26/07/2021
 * Time: 0:12
 * Created with IntelliJ IDEA
 * <p>
 * Examples: <a href="https://github.com/Visual-Regression-Tracker/examples-java">https://github.com/Visual-Regression-Tracker/examples-java</a>
 */
public class VisualRegressionSteps {

    @Inject
    private WebDriver driver;
    @Inject
    private ScenarioContext scenarioContext;
    @Inject
    private VisualRegressionTracker visualRegressionTracker;
    @Inject
    private VrtHelpers vrtHelpers;
    //region Shoot page/Element without ignoring elements.

    /**
     * shoots an element without ignoring any page elements.
     * <p>
     * the name of the baseline is defined passed in this step as an argument - useful for data driven tests.
     *
     * @param element      element to track on visual regression tracker.
     * @param baselineName the baseline name on visual regression tracker.
     * @throws IOException          if an I/O error occurs
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    @Then("Shoot {webElement} element as {string} baseline")
    public void trackWebElement(WebElement element, String baselineName) throws IOException, InterruptedException {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(8));
        vrtHelpers.censorAllDatesAndTimes();
        scenarioContext.getSoftAssertions()
                .assertThat(visualRegressionTracker.track(
                                baselineName,
                                element.getScreenshotAs(OutputType.BASE64),
                                TestRunOptions.builder()
                                        .diffTollerancePercent(Constants.DIFF_TOLERANCE_PERCENT).
                                        ignoreAreas(vrtHelpers.getAreasOfElementsWithEmail(element))
                                        .build())
                        .getTestRunResponse()
                        .getStatus())
                .as(baselineName)
                .isEqualTo(TestRunStatus.OK);
    }

    /**
     * shoots an element without ignoring any page elements.
     * <p>
     * the name of the baseline is the scenario name.
     *
     * @param element element to track on visual regression tracker.
     * @throws IOException          if an I/O error occurs
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    @Then("Shoot {webElement} element with scenario name as baseline")
    public void trackWebElement(WebElement element) throws IOException, InterruptedException {
        trackWebElement(element, scenarioContext.getScenarioName());
    }
    //endregion
    //region Shoot page/Element and ignoring elements.

    /**
     * shoots the page and ignores elements passed to method.
     * <p>
     * the name of the baseline is the scenario name.
     *
     * @throws IOException          if an I/O error occurs
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    @Then("Shoot baseline and ignore")
    public void trackPageIgnoreElements(List<WebElement> webElementListToIgnore) throws IOException, InterruptedException {
        trackPageIgnoreElements(scenarioContext.getScenarioName(), webElementListToIgnore);
    }

    /**
     * shoots the page and ignores elements passed to method.
     * <p>
     * the name of the baseline is defined passed in this step as an argument - useful for data-driven tests.
     *
     * @throws IOException          if an I/O error occurs
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    @Then("Shoot baseline {string} and ignore")
    public void trackPageIgnoreElements(String baselineName, List<WebElement> webElementListToIgnore) throws IOException, InterruptedException {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(8));
        vrtHelpers.censorAllDatesAndTimes();
        scenarioContext.getSoftAssertions()
                .assertThat(visualRegressionTracker.track(
                                baselineName,
                                Base64.getEncoder().encodeToString(Shutterbug.shootPage(driver, Capture.FULL, true).getBytes()),
                                TestRunOptions.builder()
                                        .diffTollerancePercent(Constants.DIFF_TOLERANCE_PERCENT)
                                        .ignoreAreas(
                                                Stream.concat(
                                                                vrtHelpers.getAreaOfWebElements(webElementListToIgnore).stream(),
                                                                vrtHelpers.getAreasOfElementsWithEmail().stream())
                                                        .toList())
                                        .build())
                        .getTestRunResponse()
                        .getStatus())
                .as(scenarioContext.getScenarioName())
                .isEqualTo(TestRunStatus.OK);
    }

    /**
     * Shoots the page and ignores elements which have the user's email as the text or value (because the email is dynamically generated)
     * <p>
     * The name of the baseline is the scenario name.
     *
     * @throws IOException          if an I/O error occurs
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    @Then("Shoot baseline")
    public void trackPageIgnoreUserEmail() throws IOException, InterruptedException {
        trackWebPageWithName(scenarioContext.getScenarioName());
    }

    /**
     * shoots an element and ignores elements passed to method.
     * <p>
     * the name of the baseline is the scenario name.
     *
     * @throws IOException          if an I/O error occurs
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    @Then("Shoot {webElement} element and ignore")
    public void trackElementIgnoreElements(WebElement element, List<WebElement> webElementListToIgnore) throws IOException, InterruptedException {
        trackElementIgnoreElements(element, scenarioContext.getScenarioName(), webElementListToIgnore);
    }

    /**
     * shoots an element and ignores elements passed to method.
     * <p>
     * the name of the baseline is defined passed in this step as an argument - useful for data driven tests.
     *
     * @param element      element to track on visual regression tracker.
     * @param baselineName the baseline name on visual regression tracker.
     * @throws IOException          if an I/O error occurs
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    @Then("Shoot {webElement} element as {string} baseline and ignore")
    public void trackElementIgnoreElements(WebElement element, String baselineName, List<WebElement> webElementListToIgnore) throws IOException, InterruptedException {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(8));
        vrtHelpers.censorAllDatesAndTimes();
        scenarioContext.getSoftAssertions()
                .assertThat(visualRegressionTracker.track(
                                baselineName,
                                element.getScreenshotAs(OutputType.BASE64),
                                TestRunOptions.builder()
                                        .diffTollerancePercent(Constants.DIFF_TOLERANCE_PERCENT)
                                        .ignoreAreas(
                                                Stream.concat(
                                                                vrtHelpers.getAreaOfWebElements(webElementListToIgnore, element).stream(),
                                                                vrtHelpers.getAreasOfElementsWithEmail().stream())
                                                        .toList())
                                        .build())
                        .getTestRunResponse()
                        .getStatus())
                .as(baselineName)
                .isEqualTo(TestRunStatus.OK);
    }

    /**
     * shoots a web page ignoring dynamic emails and censoring dates and times.
     * <p>
     * the name of the baseline is defined passed in this step as an argument - useful for data driven tests.
     *
     * @param baselineName the baseline name on visual regression tracker.
     * @throws IOException          if an I/O error occurs
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    @Then("Shoot baseline {string}")
    public void trackWebPageWithName(String baselineName) throws IOException, InterruptedException {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(8));
        vrtHelpers.censorAllDatesAndTimes();
        scenarioContext.getSoftAssertions()
                .assertThat(visualRegressionTracker.track(
                                baselineName,
                                Base64.getEncoder().encodeToString(Shutterbug.shootPage(driver, Capture.FULL, true).getBytes()),
                                TestRunOptions.builder()
                                        .diffTollerancePercent(Constants.DIFF_TOLERANCE_PERCENT)
                                        .ignoreAreas(vrtHelpers.getAreasOfElementsWithEmail())
                                        .build())
                        .getTestRunResponse()
                        .getStatus())
                .as(baselineName)
                .isEqualTo(TestRunStatus.OK);
    }

    /**
     * shoots a web page without ignoring anything.
     * <p>
     * the name of the baseline is defined passed in this step as an argument - useful for data-driven tests.
     *
     * @param baselineName the baseline name on visual regression tracker.
     * @throws IOException          if an I/O error occurs
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    @Then("Shoot baseline {string} Without ignoring elements")
    public void trackWebPageWithNameWithoutIgnoringElements(String baselineName) throws IOException, InterruptedException {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(8));
        scenarioContext.getSoftAssertions()
                .assertThat(visualRegressionTracker.track(
                                baselineName,
                                Base64.getEncoder().encodeToString(Shutterbug.shootPage(driver, Capture.FULL, true).getBytes()), TestRunOptions.builder()
                                        .diffTollerancePercent(Constants.DIFF_TOLERANCE_PERCENT)
                                        .build())
                        .getTestRunResponse()
                        .getStatus())
                .as(baselineName)
                .isEqualTo(TestRunStatus.OK);
    }
    //endregion
}

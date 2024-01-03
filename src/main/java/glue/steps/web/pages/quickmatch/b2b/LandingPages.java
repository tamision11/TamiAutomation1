package glue.steps.web.pages.quickmatch.b2b;

import common.glue.steps.web.pages.WebPage;
import common.glue.utilities.GeneralActions;
import dev.failsafe.Failsafe;
import dev.failsafe.RetryPolicy;
import entity.User;
import enums.ServiceType;
import enums.Us_States;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.qameta.allure.Allure;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;

import java.time.Duration;

/**
 * User: nirtal
 * Date: 18/03/2021
 * Time: 15:03
 * Created with IntelliJ IDEA
 * <p>
 * This class represents the landing page leading to the quickmatch flows
 *
 * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2347">QM - add Psychiatry DTE flow</a>
 * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2347">QM - add test for eligibility by email via landing page</a>
 */
public class LandingPages extends WebPage {

    // region elements without data-qa.
    @FindBy(css = "input#email-field-psychdte")
    private WebElement emailField;
    @FindBy(css = "input#employer-field-psychdte")
    private WebElement keywordField;
    @FindBy(css = "select#select-field, [data-qa=staticSelectService]")
    private WebElement selectServices;
    @FindBy(css = "[data-qa=staticGetStartedButton], [data-qa=voucherGeneratorButton], button[data-qa=validateByEmailField]")
    private WebElement getStartedButton;
    //endregion
    @FindBy(css = "input[data-qa=validateByEmailField]")
    private WebElement landingPageEmailField;
    @FindBy(css = "input[data-qa=voucherGeneratorEmail]")
    private WebElement baltimoreLandingPageEmailField;
    @FindBy(css = "input[data-qa=voucherGeneratorKeyword]")
    private WebElement baltimoreLandingPageKeywordField;
    @FindBy(css = "[data-qa=staticSelectState]")
    private WebElement selectState;
    @FindBy(css = "[data-qa=staticSelectInsurance]")
    private WebElement selectInsurance;
    @FindBy(css = "button#onetrust-accept-btn-handler")
    private WebElement acceptCookies;

    /**
     * @param user the  {@link User}
     */
    @And("Landing page - Click getting started after entering {user} user email")
    public void submiLandingPageFormWithEmail(User user) {
        wait.until(ExpectedConditions.visibilityOf(landingPageEmailField)).sendKeys(user.getEmail());
        driver.findElements(By.cssSelector("[data-qa=validateByEmailField]")).get(1).click();
    }

    @And("Landing page Baltimore - Click getting started after entering {user} user email and keyword {}")
    public void submiLandingPageFormWithEmailAndKeyword(User user, String keyword) {
        wait.until(ExpectedConditions.elementToBeClickable(acceptCookies)).click();
        wait.until(ExpectedConditions.visibilityOf(baltimoreLandingPageKeywordField)).sendKeys(keyword);
        wait.until(ExpectedConditions.visibilityOf(baltimoreLandingPageEmailField)).sendKeys(user.getEmail());
        getStartedButton.click();
    }

    @And("Landing page - Click getting started button")
    public void clickOnGettingStarted() {
        getStartedButton.click();
    }

    @And("Landing page - Select {} service")
    public void setSelectServices(ServiceType serviceType) {
        switch (serviceType) {
            case PSYCHIATRY ->
                    commonWebPage.selectOptionFromDropdown(wait.until(ExpectedConditions.elementToBeClickable(selectServices))::click, "Psychiatry");
            case THERAPY ->
                    commonWebPage.selectOptionFromDropdown(wait.until(ExpectedConditions.elementToBeClickable(selectServices))::click, "Individual Therapy");
            case TEEN_THERAPY ->
                    commonWebPage.selectOptionFromDropdown(wait.until(ExpectedConditions.elementToBeClickable(selectServices))::click, "Teen Therapy");
            case COUPLES_THERAPY ->
                    commonWebPage.selectOptionFromDropdown(wait.until(ExpectedConditions.elementToBeClickable(selectServices))::click, "Couples Therapy");
            default -> throw new IllegalArgumentException("Service type " + serviceType + " not supported");
        }
    }

    /**
     * adding some retries to avoid {@link java.util.concurrent.TimeoutException} seen in headless mode
     *
     * @param url to navigate to
     */
    @Given("Navigate to {string} landing page")
    public void navigateToLandingPage(String url) {
        var landingPageUrl = GeneralActions.isRunningOnProd() ? "https://www." : "https://www.%s.".formatted(data.getConfiguration().getDomain()) + url;
        Allure.addAttachment("URL", "text/uri-list", landingPageUrl);
        Failsafe.with(RetryPolicy.builder()
                        .withMaxRetries(3)
                        .withDelay(Duration.ofSeconds(5))
                        .build())
                .run(() -> driver.get(landingPageUrl));
    }


    /**
     * adding some retries to avoid {@link java.util.concurrent.TimeoutException} seen in headless mode
     *
     * @param url to navigate to
     */
    @Given("Navigate to try Talkspace {string} landing page")
    public void navigateToTryTalkspaceLandingPage(String url) {
        Allure.addAttachment("URL", "text/uri-list", GeneralActions.isRunningOnProd() ? "https://try." : "https://try.%s.".formatted(data.getConfiguration().getDomain()) + url);
        Failsafe.with(RetryPolicy.builder()
                        .withMaxRetries(3)
                        .withDelay(Duration.ofSeconds(5))
                        .build())
                .run(() -> driver.get(GeneralActions.isRunningOnProd() ? "https://try." : "https://try.%s.".formatted(data.getConfiguration().getDomain()) + url));
    }

    /**
     * clicking via js to avoid {@link org.openqa.selenium.ElementClickInterceptedException} from cookie banner
     *
     * @param ctaDataQA the data-qa attribute of the CTA we want to click
     */
    @Given("Landing page - Click on {string} CTA")
    public void clickOnCta(String ctaDataQA) {
        var ctaElement = wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector("[data-qa=" + ctaDataQA + "]")));
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", ctaElement);
    }


    @And("Landing page - Select {string}")
    @And("Landing page - Select {string} insurance provider")
    public void setSelectServices(String insuranceProvider) {
        selectInsurance.click();
        wait.until(ExpectedConditions.numberOfElementsToBeMoreThan(By.cssSelector("[id^=react-select]"), 30));
        actions.sendKeys(insuranceProvider)
                .sendKeys(Keys.ENTER)
                .build()
                .perform();
    }

    @And("Landing page - Select {} state")
    public void setSelectServices(Us_States state) {
        actions.click(selectState)
                .sendKeys(state.getName())
                .sendKeys(Keys.ENTER)
                .build()
                .perform();
    }

    /**
     * submit a Psychiatry DTE form
     *
     * @param serviceType service type we want to select
     */
    @And("Landing page - Submit DTE form with {} service type for {user} user")
    public void submitDteForm(ServiceType serviceType, User user) {
        emailField.sendKeys(user.getEmail());
        keywordField.sendKeys("dtetest");
        new Select(selectServices).selectByVisibleText(serviceType.getName());
        driver.findElements(By.cssSelector("div.button-text")).get(1).click();
    }
}

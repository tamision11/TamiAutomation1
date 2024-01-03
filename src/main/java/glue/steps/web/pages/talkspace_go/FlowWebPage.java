package glue.steps.web.pages.talkspace_go;

import com.google.common.util.concurrent.Uninterruptibles;
import common.glue.steps.web.pages.WebPage;
import common.glue.utilities.GeneralActions;
import entity.User;
import enums.Address;
import enums.Us_States;
import enums.UserEmailType;
import enums.data.PasswordType;
import io.cucumber.java.en.And;
import lombok.Getter;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.time.Duration;
import java.util.Locale;
import java.util.Map;

import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;
import static org.openqa.selenium.support.ui.ExpectedConditions.visibilityOf;

@Getter
public class FlowWebPage extends WebPage {

    @FindBy(xpath = "//h2[contains(text(), 'Get matched with a therapist')]")
    private WebElement getMatchedWithTherapist;
    @FindBy(xpath = "//h2[contains(text(), 'Learn the fundamentals first')]")
    private WebElement learnTheFundamentalsFirst;
    @FindBy(css = "input[name=dateOfBirth]")
    private WebElement dateOfBirth;
    @FindBy(css = "input[name=address1]")
    private WebElement address1;
    @FindBy(css = "input[name=address2]")
    private WebElement address2;
    @FindBy(css = "input[name=city]")
    private WebElement city;
    @FindBy(css = "input[name=state]")
    private WebElement state;
    @FindBy(css = "input[name=zipCode]")
    private WebElement zipCode;
    @FindBy(css = "input[name=country]")
    private WebElement country;
    @FindBy(css = "input[name=phone]")
    private WebElement phone;
    @FindBy(css = "button#onetrust-accept-btn-handler")
    private WebElement acceptCookies;
    @FindAll({
            @FindBy(css = "button[type=submit]"),
            @FindBy(xpath = "//button[contains(text(), 'Continue')]"),
            @FindBy(xpath = "//button[contains(text(), 'Create Account')]"),
            @FindBy(xpath = "//a[contains(text(), 'Continue')]")
    })
    private WebElement continueButton;
    @FindBy(xpath = "//span[contains(text(), 'Continue without coverage')]")
    private WebElement continueWithoutCoverage;
    @FindBy(css = "[id=keyword]")
    private WebElement inputKeyword;
    @FindBy(css = "[id=dateOfBirth]")
    private WebElement inputDOB;
    @FindBy(xpath = "//span[contains(text(), 'Check that my information is correct and resubmit')]")
    private WebElement checkThatMyInformationIsCorrectAndResubmit;
    //@FindBy(xpath = "//p[contains(text(), 'We don't recognize this keyword. Try again, or contact your school or organization for assistance.')]")
    @FindBy(css = "div[aria-roledescription='helper-text']")
    private WebElement keywordError;
    @FindBy(xpath = "//h2[contains(text(), 'No, I')]")
    private WebElement iWasntGivenKeyword;
    @FindBy(xpath = "//h2[contains(text(), 'Yes, I')]")
    private WebElement iWasGivenKeyword;
    @FindBy(css = "input[name=email]")
    private WebElement email;
    @FindBy(css = "input[name=password]")
    private WebElement password;

    @And("Talkslace Go - Click on Continue")
    public void GOclickOnContinue() {
        wait.until(elementToBeClickable(continueButton)).click();
    }

    @And("Talkslace Go - Enter {string} as keyword")
    public void GOEnterKeyword(String keyword) {
        wait.until(ExpectedConditions.visibilityOf(inputKeyword)).sendKeys(keyword);
    }

    @And("Talkslace Go - Invalid keyword message is displayed")
    public void invalidKeyword() {
        wait.until(ExpectedConditions.visibilityOf(keywordError));
    }

    @And("Talkslace Go - Enter {string} date of birth")
    public void GOEnterTeensDOB(String dob) {
        if ("teen".equals(dob)) {
            inputDOB.sendKeys(GeneralActions.generateDate(0, 0, 13));
        } else {
            inputDOB.sendKeys(GeneralActions.generateDate(0, 0, 18));
        }
    }

    @And("Talkslace Go - Create account")
    public void GOcreateAccount(Map<String, String> userDetails) {
        wait.until(visibilityOf(email)).sendKeys(GeneralActions.getEmailAddress(UserEmailType.valueOf(userDetails.get("Email"))));
        wait.until(visibilityOf(password)).sendKeys(PasswordType.valueOf(userDetails.get("password")).getValue());
        continueButton.click();
//        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", continueButton);


    }

    @And("Talkslace Go - Click on Continue without coverage")
    public void clickOnContinueWithoutCoverage() {
        wait.until(elementToBeClickable(continueWithoutCoverage)).click();
    }

    @And("Talkslace Go - Complete the matching questions")
    public void completeMatchingQuestions() {
        wait.until(elementToBeClickable(By.xpath("//span[contains(text(), 'Calm')]"))).click();
        wait.until(elementToBeClickable(By.xpath("//span[contains(text(), 'Asian')]"))).click();
        wait.until(elementToBeClickable(By.xpath("//span[contains(text(), 'Female')]"))).click();
        wait.until(elementToBeClickable(By.xpath("//span[contains(text(), 'Anxiety or worrying')]"))).click();
        GOclickOnContinue();
        for (int i = 0; i < 15; i++) {
            wait.until(elementToBeClickable(By.xpath("//span[contains(text(), 'Not at all')]"))).click();
            Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(2));
        }
        wait.until(elementToBeClickable(By.xpath("//span[contains(text(), 'Understand myself better')]"))).click();
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(2));
        GOclickOnContinue();
    }

    @And("Talkslace Go - Click on Check that my information is correct and resubmit")
    public void clickOnCheckThatMyInformationIsCorrectAndResubmit() {
        wait.until(elementToBeClickable(checkThatMyInformationIsCorrectAndResubmit)).click();
    }

    @And("Talkslace Go - Click on I wasn't given a keyword")
    public void clickOnIWasntGivenKeyword() {
        wait.until(elementToBeClickable(iWasntGivenKeyword)).click();
    }

    @And("Talkslace Go - Click on I was given a keyword")
    public void clickOnIWasGivenKeyword() {
        wait.until(elementToBeClickable(iWasGivenKeyword)).click();
    }

    @And("Talkslace Go - Click on Learn the fundamentals first")
    public void clickOnLearnTheFundamentalsFirst() {
        wait.until(ExpectedConditions.elementToBeClickable(acceptCookies)).click();
        wait.until(elementToBeClickable(learnTheFundamentalsFirst)).click();
    }

    @And("Talkslace Go - Complete validation form for {user} user")
    public void completeValidationForm(User user, Map<String, String> userDetails) {
        if (userDetails.containsKey("address")) {
            user.setAddress(Address.valueOf(userDetails.get("address")));
        } else {
            user.setAddress(Address.US);
        }
        wait.until(visibilityOf(dateOfBirth)).clear();
        dateOfBirth.sendKeys(GeneralActions.generateDate(0, 0, Integer.parseInt(userDetails.get("age"))));
        address1.clear();
        address1.sendKeys(user.getAddress().getUnitAddress());
        city.clear();
        city.sendKeys(user.getAddress().getCity());
        address2.clear();
        address2.sendKeys(user.getAddress().getHomeAddress());
        zipCode.clear();
        zipCode.sendKeys(user.getAddress().getZipCode());
        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView();", country);
        if (user.getAddress().equals(Address.US)) {
            country.clear();
            actions.click(country)
                    .sendKeys(new Locale("", "US").getDisplayCountry())
                    .sendKeys(Keys.ENTER)
                    .build()
                    .perform();
            state.clear();
            actions.click(state)
                    .sendKeys(Us_States.valueOf(userDetails.get("state")).getName())
                    .sendKeys(Keys.ENTER)
                    .build()
                    .perform();
        } else {
            user.setAddress(Address.valueOf(userDetails.get("address")));
            country.clear();
            actions.click(country)
                    .sendKeys(user.getAddress().getCountry())
                    .sendKeys(Keys.ENTER)
                    .build()
                    .perform();
            state.clear();
            actions.click(state)
                    .sendKeys(user.getAddress().getState())
                    .sendKeys(Keys.ENTER)
                    .build()
                    .perform();
        }
        continueButton.click();
    }

    @And("Talkslace Go - Click on Get matched with a therapist")
    public void clickOnGetMatchedWithTherapist() {
        wait.until(elementToBeClickable(getMatchedWithTherapist)).click();
    }
}

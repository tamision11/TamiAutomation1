package glue.steps.web.pages.clientweb;

import common.glue.steps.web.pages.WebPage;
import io.cucumber.java.en.When;
import org.openqa.selenium.By;
import org.openqa.selenium.support.ui.ExpectedConditions;

/**
 * Created by emanuela.biro on 7/17/2019.
 * <p>
 * This class contains the elements on the home page
 */
public class HomeRegistrationWebPage extends WebPage {

    private final By buttonGetStarted = By.cssSelector("[data-qa=navCTA]");


    /**
     * the dom location of the buttons is different on prod and on dev/canary
     */
    @When("Registration Home Page - Click on get started button")
    public void registrationHomePageClickOnGetStartedButton() {
        wait.until(ExpectedConditions.elementToBeClickable(buttonGetStarted)).click();
    }
}
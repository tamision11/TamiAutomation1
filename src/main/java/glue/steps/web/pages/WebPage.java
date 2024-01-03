package glue.steps.web.pages;

import com.google.inject.Inject;
import di.providers.ScenarioContext;
import entity.Data;
import net.datafaker.Faker;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.WebDriverWait;

import javax.annotation.PostConstruct;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by emanuela.biro on 3/20/2019.
 * common base class for all web pages
 */
public abstract class WebPage {

    @Inject
    protected WebDriver driver;
    @Inject
    protected WebDriverWait wait;
    @Inject
    protected ScenarioContext scenarioContext;
    @Inject
    protected Actions actions;
    @Inject
    protected Data data;
    @Inject
    protected CommonWebWebPage commonWebPage;
    @Inject
    protected Faker faker;

    /**
     * @return current room id
     */
    public int getCurrentRoomId() {
        Matcher matcher = Pattern.compile("\\d+").matcher(driver.getCurrentUrl());
        matcher.find();
        return Integer.parseInt(matcher.group());
    }

    @PostConstruct
    public void initPage() {
        PageFactory.initElements(driver, this);
    }
}

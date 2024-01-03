package di.providers.web;

import com.google.inject.Inject;
import com.google.inject.Provider;
import entity.Data;
import io.github.bonigarcia.wdm.WebDriverManager;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.events.EventFiringDecorator;

/**
 * User: nirtal
 * Date: 13/06/2021
 * Time: 11:53
 * Created with IntelliJ IDEA
 */
public class WebDriverProvider implements Provider<WebDriver> {
    @Inject
    private ChromeOptions chromeOptions;
    @Inject
    private EventFiringDecorator<WebDriver> eventFiringDecorator;
    @Inject
    private Data data;

    @Override
    public WebDriver get() {
        if (data.getConfiguration().isDecorateDriver() && !StringUtils.equalsAny(System.getProperty("job_name"), "clientweb_accessibility_tests", "visual_tests")) {
            return eventFiringDecorator.decorate(WebDriverManager.chromedriver().capabilities(chromeOptions).create());
        }
        return WebDriverManager.chromedriver().capabilities((chromeOptions)).create();
    }
}

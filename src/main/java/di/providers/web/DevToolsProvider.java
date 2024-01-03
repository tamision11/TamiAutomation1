package di.providers.web;

import com.google.inject.Inject;
import com.google.inject.Provider;
import entity.Data;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.devtools.DevTools;
import org.openqa.selenium.support.events.EventFiringDecorator;

/**
 * User: nirtal
 * Date: 13/06/2021
 * Time: 11:53
 * Created with IntelliJ IDEA
 */
public class DevToolsProvider implements Provider<DevTools> {
    @Inject
    private EventFiringDecorator<WebDriver> eventFiringDecorator;
    @Inject
    private Data data;
    @Inject
    private WebDriver driver;

    @Override
    public DevTools get() {
        if (data.getConfiguration().isDecorateDriver() && !StringUtils.equalsAny(System.getProperty("job_name"), "clientweb_accessibility_tests", "visual_tests")) {
            return ((ChromeDriver) eventFiringDecorator.getDecoratedDriver().getOriginal()).getDevTools();
        }
        return ((ChromeDriver) driver).getDevTools();
    }
}

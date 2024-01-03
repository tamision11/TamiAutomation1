package di.providers.web;

import com.google.inject.Inject;
import com.google.inject.Provider;
import entity.Data;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

/**
 * User: nirtal
 * Date: 13/06/2021
 * Time: 11:53
 * Created with IntelliJ IDEA
 */
public class WebDriverWaitProvider implements Provider<WebDriverWait> {
    @Inject
    private WebDriver driver;
    @Inject
    private Data data;

    @Override
    public WebDriverWait get() {
        return new WebDriverWait(driver, Duration.ofSeconds(data.getConfiguration().getWait()));
    }
}

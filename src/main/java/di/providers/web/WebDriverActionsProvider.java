package di.providers.web;

import com.google.inject.Inject;
import com.google.inject.Provider;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.interactions.Actions;

/**
 * User: nirtal
 * Date: 13/06/2021
 * Time: 11:53
 * Created with IntelliJ IDEA
 */
public class WebDriverActionsProvider implements Provider<Actions> {
    @Inject
    private WebDriver driver;

    @Override
    public Actions get() {
        return new Actions(driver);
    }
}

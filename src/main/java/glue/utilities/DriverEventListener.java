package glue.utilities;

import io.vavr.control.Try;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.events.WebDriverListener;

import java.util.List;
import java.util.Objects;

/**
 * User: nirtal
 * Date: 26/10/2021
 * Time: 10:27
 * Created with IntelliJ IDEA
 * <p>
 *
 * @see <a href="https://github.com/ConvergentThinker/auto_test_ui/blob/main/src/main/java/org/autotestui/utilities/PageAction.java">highlight elements</a>
 */
public class DriverEventListener implements WebDriverListener {

    @Override
    public void afterFindElements(WebDriver driver, By locator, List<WebElement> result) {
        Try.run(() -> result.forEach(webElement -> {
            if (Objects.nonNull(webElement.getAttribute("style"))) {
                if (!webElement.getAttribute("style").contains("visibility: hidden")) {
                    ((JavascriptExecutor) driver).executeScript("arguments[0].setAttribute('style', 'border: 2px solid red;');", webElement);
                }
            }
        }));
    }

    @Override
    public void afterFindElement(WebDriver driver, By locator, WebElement result) {
        Try.run(() ->
        {
            if (Objects.nonNull(result.getAttribute("style"))) {
                if (!result.getAttribute("style").contains("visibility: hidden")) {
                    ((JavascriptExecutor) driver).executeScript("arguments[0].setAttribute('style', 'border: 2px solid red;');", result);
                }
            }
        });
    }
}
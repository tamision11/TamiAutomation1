package glue.utilities;

import com.google.inject.Inject;
import entity.Data;
import io.qameta.allure.Allure;
import io.vavr.control.Try;
import io.visual_regression_tracker.sdk_java.IgnoreAreas;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.ArrayList;
import java.util.List;

/**
 * User: nirtal
 * Date: 15/10/2021
 * Time: 12:15
 * Created with IntelliJ IDEA
 * <p>
 * Visual regression tracker helper class.
 */
public class VrtHelpers {

    @Inject
    private Data data;
    @Inject
    private WebDriver driver;

    /**
     * @return all elements with the user's email.
     */
    private List<WebElement> findElementsWithEmailToIgnore() {
        return driver.findElements(By.xpath("//*[contains(text(),'" + data.getUsers().get("primary").getEmail() + "') or " +
                "contains(text(),'" + data.getUsers().get("partner").getEmail() + "') or " +
                "contains(@value,'" + data.getUsers().get("primary").getEmail() + "') or " +
                "contains(@value,'" + data.getUsers().get("partner").getEmail() + "') or " +
                "contains(text(),'" + data.getUsers().get("primary").getPendingEmail() + "') or " +
                "contains(@value,'" + data.getUsers().get("primary").getPendingEmail() + "')]"));
    }

    /**
     * Censors all dates and times on the page (or in the current frame) to enable visual testing
     */
    public void censorAllDatesAndTimes() {
        Try.run(this::censorAllDates);
        Try.run(this::censorAllTimes);
        Try.run(this::censorCreditCardExpiration);
    }

    /**
     * Replaces the dates in the text of all elements with "placeholder" characters
     */
    private void censorAllDates() {
        String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
        var dayAndYearRegex = " [0-3]?[0-9], [0-9]{4}";
        var dayRegex = " [0-3]?[0-9]";
        for (var month : months) {
            var elementsWithMonth = driver.findElements(By.xpath("//p[contains(. , '%s')]".formatted(month)));
            elementsWithMonth.addAll(driver.findElements(By.xpath("//*[contains(text(), '%s')]".formatted(month))));
            if (!elementsWithMonth.isEmpty()) {
                for (var elementWithMonth : elementsWithMonth) {
                    var elementText = elementWithMonth.getText();
                    elementText = elementText.replaceAll(month.concat(dayAndYearRegex), "mmm dd, yyyy")
                            .replaceAll(month.concat(dayRegex), "mmm dd");
                    ((JavascriptExecutor) driver).executeScript("arguments[0].innerHTML='%s';".formatted(elementText), elementWithMonth);
                }
            }
        }
    }


    /**
     * <a href="https://stackoverflow.com/a/10260227/4515129">Java - Regex - Months</a>
     * <a href="https://mkyong.com/regular-expressions/how-to-validate-date-with-regular-expression/">how to validate date with regular expression</a>
     * Replaces the dates of credit card expiration with "placeholder" characters
     */
    private void censorCreditCardExpiration() {
        var creditCardExpirationElement = driver.findElements(By.xpath("//p[contains(. , 'Expires')]"));
        if (!creditCardExpirationElement.isEmpty()) {
            var elementText = "Expires mm/dddd";
            ((JavascriptExecutor) driver).executeScript("arguments[0].innerHTML='%s';".formatted(elementText), creditCardExpirationElement.get(0));
        }
    }

    /**
     * Replaces the times (hours:minutes AM/PM) in the text of all elements with "placeholder" characters
     */
    private void censorAllTimes() {
        var timeRegex = "[0-9]{1,2}:[0-9]{1,2} (AM|PM)";
        var elementsWithTime = driver.findElements(By.xpath("//*[text()[contains(., ':') and (contains(., 'AM') or contains(., 'PM'))]]"));
        if (!elementsWithTime.isEmpty()) {
            for (var elementWithTime : elementsWithTime) {
                var elementText = elementWithTime.getText();
                elementText = elementText.replaceAll(timeRegex, "hh:mm AA");
                ((JavascriptExecutor) driver).executeScript("arguments[0].innerHTML='%s';".formatted(elementText), elementWithTime);
            }
        }
    }

    /**
     * Calculates the {@link IgnoreAreas} of specified elements when shooting a specific element.
     * This method adjusts the areas according to the element we want to shoot
     *
     * @param elements       elements to get the IgnoreAreas for
     * @param elementToShoot the parent (root) element we are shooting
     * @return the {@link IgnoreAreas} of the elements
     */
    public List<IgnoreAreas> getAreaOfWebElements(List<WebElement> elements, WebElement elementToShoot) {
        return elements
                .stream()
                .map(element -> IgnoreAreas
                        .builder()
                        .height(Integer.valueOf(element.getRect().getHeight()).longValue())
                        .width(Integer.valueOf(element.getRect().getWidth()).longValue())
                        .x((Integer.valueOf(element.getRect().getX() - elementToShoot.getRect().getX())).longValue())
                        .y(Integer.valueOf(element.getRect().getY() - elementToShoot.getRect().getY()).longValue())
                        .build())
                .toList();
    }

    /**
     * Calculates the {@link IgnoreAreas} of specified elements when shooting a full web page.
     *
     * @param elements elements to get the IgnoreAreas for
     * @return the IgnoreAreas of the specified elements
     */
    public List<IgnoreAreas> getAreaOfWebElements(List<WebElement> elements) {
        return elements
                .stream()
                .map(element -> IgnoreAreas
                        .builder()
                        .height(Integer.valueOf(element.getRect().getHeight()).longValue())
                        .width(Integer.valueOf(element.getRect().getWidth()).longValue())
                        .x(Integer.valueOf(element.getRect().getX()).longValue())
                        .y(Integer.valueOf(element.getRect().getY()).longValue())
                        .build())
                .toList();
    }

    /**
     * Gets the {@link IgnoreAreas} of the elements with the user's email when shooting a specific element
     *
     * @return the {@link IgnoreAreas} of the elements with the user's email, while adjusting for the parent element we are shooting
     */
    public List<IgnoreAreas> getAreasOfElementsWithEmail(WebElement elementToShoot) {
        return getAreaOfWebElements(findElementsWithEmailToIgnore(), elementToShoot);
    }

    /**
     * Gets the {@link IgnoreAreas} of the elements with the user's email when shooting a full web page
     *
     * @return the IgnoreAres of the elements with the user's email
     */
    public List<IgnoreAreas> getAreasOfElementsWithEmail() {
        var ignoreAreas = new ArrayList<IgnoreAreas>();
        loopThroughFrames(ignoreAreas);
        Allure.step("switching to default frame", () -> driver.switchTo().defaultContent());
        ignoreAreas.addAll(findElementsWithEmailToIgnore()
                .stream()
                .map(element -> IgnoreAreas
                        .builder()
                        .height(Integer.valueOf(element.getRect().getHeight()).longValue())
                        .width(Integer.valueOf(element.getRect().getWidth()).longValue())
                        .x(Integer.valueOf(element.getRect().getX()).longValue())
                        .y(Integer.valueOf(element.getRect().getY()).longValue())
                        .build())
                .toList());
        return ignoreAreas;
    }

    /**
     * loops through all the frames in the page and adds the {@link IgnoreAreas} of the elements with the user's email to the list
     * calculates the offset of the iframe and adds it to the x and y of the element
     * we extract the frame x and y before switching to the frame to avoid stale element exception
     *
     * @param ignoreAreas the list of {@link IgnoreAreas} to add to
     */
    public void loopThroughFrames(List<IgnoreAreas> ignoreAreas) {
        var frames = driver.findElements(By.tagName("iframe"));
        if (!frames.isEmpty()) {
            for (var frame : frames) {
                var frameX = frame.getRect().getX();
                var frameY = frame.getRect().getY();
                driver.switchTo().frame(frame);
                ignoreAreas.addAll(findElementsWithEmailToIgnore()
                        .stream()
                        .map(element -> IgnoreAreas
                                .builder()
                                .height(Integer.valueOf(element.getRect().getHeight()).longValue())
                                .width(Integer.valueOf(element.getRect().getWidth()).longValue())
                                .x(Integer.valueOf(element.getRect().getX() + frameX).longValue())
                                .y(Integer.valueOf(element.getRect().getY() + frameY).longValue())
                                .build())
                        .toList());
                loopThroughFrames(ignoreAreas);
                driver.switchTo().parentFrame();
            }
        }
    }
}

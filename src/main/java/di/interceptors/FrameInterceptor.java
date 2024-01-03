package di.interceptors;

import annotations.Frame;
import com.google.inject.Inject;
import com.google.inject.Injector;
import di.providers.ScenarioContext;
import enums.FrameTitle;
import io.qameta.allure.Allure;
import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import static enums.ApplicationUnderTest.ALL;
import static enums.FrameTitle.DEFAULT;

public class FrameInterceptor implements MethodInterceptor {
    @Inject
    private Injector injector;

    @Override
    public Object invoke(MethodInvocation invocation) throws Throwable {
        switchToFrame(invocation.getMethod().getAnnotation(Frame.class).value());
        return invocation.proceed();
    }

    /**
     * Switching to every iframe in the frameTitles array if it's relevant for our scenario.
     * If the frame is {@link FrameTitle#DEFAULT}, it's always relevant, and we switch to the default frame.
     * Otherwise, we only switch to the frame if The frame is relevant to all applications
     * OR
     * this frame or a previous frame is relevant specifically for our application, therefore, all following frames must be relevant as well: framesMustBeValid
     * <p>
     * <font color="red"> sometimes a delay is needed before switching to the frame, in order for all the frame elements to be loaded. </font>
     *
     * @param frameTitles An array of frames to switch to according to the logic above.
     *                    The iframes are located based on their title -> {@link FrameTitle#getTitle()}
     */
    private void switchToFrame(FrameTitle[] frameTitles) {
        var driver = injector.getInstance(WebDriver.class);
        var wait = injector.getInstance(WebDriverWait.class);
        var scenarioContext = injector.getInstance(ScenarioContext.class);
        Allure.step("switching to default frame", () -> driver.switchTo().defaultContent());
        var framesMustBeValid = false;
        for (var frameTitle : frameTitles) {
            if (!frameTitle.equals(DEFAULT)) {
                if (frameTitle.getApplicationUnderTest().equals(scenarioContext.getApplicationUnderTest())) {
                    framesMustBeValid = true;
                }
                if (frameTitle.getApplicationUnderTest().equals(ALL) || framesMustBeValid) {
                    Allure.step("switching to frame: %s".formatted(frameTitle.getTitle()), () -> wait.until(ExpectedConditions.frameToBeAvailableAndSwitchToIt(By.cssSelector("iframe[title='%s']".formatted(frameTitle.getTitle())))));
                }
            }
        }
    }
}
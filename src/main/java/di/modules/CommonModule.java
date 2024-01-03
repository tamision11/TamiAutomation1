package di.modules;

import annotations.Frame;
import annotations.JobName;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.inject.AbstractModule;
import com.google.inject.Provides;
import com.google.inject.Scopes;
import com.google.inject.TypeLiteral;
import com.google.inject.matcher.Matchers;
import com.google.inject.name.Names;
import com.manybrain.mailinator.client.MailinatorClient;
import com.manybrain.mailinator.client.message.Inbox;
import common.glue.utilities.Constants;
import common.glue.utilities.DriverEventListener;
import common.glue.utilities.GeneralActions;
import di.interceptors.FrameInterceptor;
import di.interceptors.JobNameInterceptor;
import di.providers.*;
import di.providers.mailinator.MailinatorClientProvider;
import di.providers.mailinator.MailinatorInboxProvider;
import di.providers.web.DevToolsProvider;
import di.providers.web.WebDriverActionsProvider;
import di.providers.web.WebDriverProvider;
import di.providers.web.WebDriverWaitProvider;
import entity.Data;
import enums.HostsMapping;
import extensions.ClientExtension;
import extensions.ResponseExtension;
import io.cucumber.guice.ScenarioScoped;
import io.visual_regression_tracker.sdk_java.VisualRegressionTracker;
import jakarta.inject.Singleton;
import lombok.SneakyThrows;
import net.datafaker.Faker;
import org.aopalliance.intercept.MethodInterceptor;
import org.apache.commons.lang3.SystemUtils;
import org.jdbi.v3.core.Jdbi;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.devtools.DevTools;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.events.EventFiringDecorator;
import org.openqa.selenium.support.ui.WebDriverWait;
import software.amazon.awssdk.services.s3.S3Client;

import java.io.FileInputStream;
import java.net.http.HttpClient;
import java.nio.file.Paths;
import java.util.EnumMap;
import java.util.Map;
import java.util.Properties;

import static com.google.inject.matcher.Matchers.annotatedWith;
import static org.apache.commons.lang3.SystemUtils.USER_DIR;

/**
 * User: nirtal
 * Date: 06/10/2021
 * Time: 2:12
 * Created with IntelliJ IDEA
 *
 * @see <a href="https://stackoverflow.com/a/55872560/4515129">How to inject this map as a bean using guice</a>
 */
public class CommonModule extends AbstractModule {

    @Provides
    @ScenarioScoped
    public EventFiringDecorator<WebDriver> getEventFiringDecorator() {
        return new EventFiringDecorator<>(new DriverEventListener());
    }

    /**
     * Will run on headless mode on linux based OS - which is CircleCI (locally we are working on Mac)
     * <table>
     * <thead>
     * <th style="text-align: center; text-decoration: underline;">Brief description of the Chrome option listed</th
     * </thead>
     * <tr>
     * <th>Option</th>
     * <th>Description</th>
     * </tr>
     * </thead>
     * <tbody>
     * <tr>
     * <td>headless</td>
     * <td>Starts Chrome in headless mode, which means there is no user interface.</td>
     * </tr>
     * <tr>
     * <td>no-sandbox</td>
     * <td>Disables the Chrome sandbox, which can improve performance but is less secure.</td>
     * </tr>
     * <tr>
     * <td>force-device-scale-factor</td>
     * <td>sets the scale factor of the device's display.
     * A scale factor of less than 1 will cause the browser to zoom out, while a scale factor greater than 1 will cause it to zoom in  to force the browser to zoom out to 80% of its default scale we use 0.8</td>
     * </tr>
     * <tr>
     * <td>allow-file-access-from-files</td>
     * <td>Allows web pages loaded from file:// URLs to access other files on the local file system.</td>
     * </tr>
     * <tr>
     * <td>use-fake-device-for-media-stream</td>
     * <td>Simulates a camera or microphone device for use in automated testing.</td>
     * </tr>
     * <tr>
     * <td>use-fake-ui-for-media-stream</td>
     * <td>Simulates user interface elements for media stream input devices.</td>
     * </tr>
     * <tr>
     * <td>hide-scrollbars</td>
     * <td>Hides the scrollbars in Chrome.</td>
     * </tr>
     * <tr>
     * <td>disable-features=VizDisplayCompositor</td>
     * <td>Disables the VizDisplayCompositor feature, which can cause issues on some systems.</td>
     * </tr>
     * <tr>
     * <td>disable-features=IsolateOrigins,site-per-process</td>
     * <td>Disables the IsolateOrigins and site-per-process features, which can improve performance but are less secure.</td>
     * </tr>
     * <tr>
     * <td>disable-popup-blocking</td>
     * <td>Disables popup blocking in Chrome.</td>
     * </tr>
     * <tr>
     * <td>disable-dev-shm-usage</td>
     * <td>Disables the /dev/shm usage in Chrome, which can cause issues on some systems.</td>
     * </tr>
     * <tr>
     * <td>disable-notifications</td>
     * <td>Disables notifications in Chrome.</td>
     * </tr>
     * <tr>
     * <td>setExperimentalOption("excludeSwitches", new String[]{"enable-automation"})</td>
     * <td>Excludes the enable-automation switch, which can prevent Chrome from detecting automation scripts.</td>
     * </tr>
     * <tr>
     * <td>setExperimentalOption("prefs", ...)</td>
     * <td>Sets various preferences for the Chrome browser, including disabling notifications, enabling camera and microphone access, and specifying the default download directory.</td>
     * </tr>
     * </tbody>
     * </table>
     *
     * @return ChromeOptions
     * @see <a href="https://stackoverflow.com/questions/53280678/why-arent-network-requests-for-iframes-showing-in-the-chrome-developer-tools-un/53435499#53435499">intercept traffic in iframes</a>
     * @see <a href="https://stackoverflow.com/questions/47396547/how-to-set-the-geo-location-through-code">https://stackoverflow.com/questions/47396547/how-to-set-the-geo-location-through-code</a>
     * @see <a href="https://stackoverflow.com/a/65275540/4515129">https://stackoverflow.com/a/65275540/4515129</a>
     * @see <a href="https://www.semicolonworld.com/question/54999/how-to-allow-or-deny-notification-geo-location-microphone-camera-pop-up">https://www.semicolonworld.com/question/54999/how-to-allow-or-deny-notification-geo-location-microphone-camera-pop-up</a>
     * @see <a href="https://www.selenium.dev/documentation/en/webdriver/page_loading_strategy/">https://www.selenium.dev/documentation/en/webdriver/page_loading_strategy/</a>
     * @see <a href="https://stackoverflow.com/questions/43223857/save-password-for-this-website-dialog-with-chromedriver-despite-numerous-comm">https://stackoverflow.com/questions/43223857/save-password-for-this-website-dialog-with-chromedriver-despite-numerous-comm</a>
     * @see <a href="https://github.com/GoogleChrome/chrome-launcher/blob/main/docs/chrome-flags-for-tools.md">Chrome Flags for Tooling</a>
     * @see <a href="https://www.youtube.com/watch?v=Mvg08wMy5iE">SetHeadLess Browser Is Deprecated in Selenium 4.8.0 Version</a>
     * @see <a href="https://www.selenium.dev/blog/2023/headless-is-going-away/?s=03">SetHeadLess Browser Is Deprecated in Selenium 4.8.0 Version</a>
     * @see <a href="https://support.google.com/chrome/thread/205167021/selenium-is-not-working-with-chrome-after-updating-chrome-to-latest-version-111-0-5563-65?hl=en">Selenium is not working with Chrome after updating chrome to latest version - 111</a>
     * @see <a href="https://github.com/GoogleChromeLabs/chrome-for-testing/issues/30#issuecomment-1644019722">ChromeDriver requires a Chrome for Testing binary by default</a>
     * @see <a href="https://talktala.atlassian.net/browse/PLATFORM-4375"> Set up a custom User Agent for the automation tests</a>
     */
    @Provides
    @Singleton
    public ChromeOptions getChromeOptions() {
        var chromeOptions = new ChromeOptions().addArguments(
                        "allow-file-access-from-files",
                        "use-fake-device-for-media-stream",
                        "use-fake-ui-for-media-stream",
                        "hide-scrollbars",
                        "user-agent=".concat(Constants.AUTOMATION_USER_AGENT),
                        "disable-features=VizDisplayCompositor",
                        "disable-features=IsolateOrigins,site-per-process",
                        "disable-popup-blocking",
                        "disable-dev-shm-usage",
                        "disable-notifications"
                )
                .setExperimentalOption("excludeSwitches", new String[]{"enable-automation"})
                .setExperimentalOption("prefs", Map.of(
                        "profile.default_content_setting_values.notifications", 2,
                        "profile.default_content_setting_values.media_stream_mic", 1,
                        "profile.default_content_setting_values.geolocation", 1,
                        "profile.default_content_setting_values.media_stream_camera", 1,
                        "credentials_enable_service", false,
                        "profile.password_manager_enabled", false,
                        "download.default_directory", Constants.CHROME_DOWNLOAD_DIRECTORY)
                );
        if (SystemUtils.IS_OS_MAC) {
            chromeOptions.setBinary("/Applications/Google Chrome.app/Contents/MacOS/Google Chrome");
        }
        return chromeOptions;
    }

    @SneakyThrows
    @Override
    protected void configure() {
        bind(Faker.class).in(Scopes.SINGLETON);
        MethodInterceptor frameInterceptor = new FrameInterceptor();
        requestInjection(frameInterceptor);
        bindInterceptor(Matchers.any(),
                annotatedWith(Frame.class),
                frameInterceptor);
        MethodInterceptor jobNameInterceptor = new JobNameInterceptor();
        requestInjection(jobNameInterceptor);
        bindInterceptor(Matchers.any(),
                annotatedWith(JobName.class),
                jobNameInterceptor);
        bind(MailinatorClient.class).toProvider(MailinatorClientProvider.class);
        bind(Inbox.class).toProvider(MailinatorInboxProvider.class);
        bind(Actions.class).toProvider(WebDriverActionsProvider.class).in(ScenarioScoped.class);
        bind(WebDriver.class).toProvider(WebDriverProvider.class).in(ScenarioScoped.class);
        bind(WebDriverWait.class).toProvider(WebDriverWaitProvider.class).in(ScenarioScoped.class);
        bind(DevTools.class).toProvider(DevToolsProvider.class).in(ScenarioScoped.class);
        bind(ObjectMapper.class).toProvider(ObjectMapperProvider.class).in(Scopes.SINGLETON);
        bind(Data.class).toProvider(DataProvider.class).in(Scopes.SINGLETON);
        requestStaticInjection(GeneralActions.class, ClientExtension.class, ResponseExtension.class);
        bind(VisualRegressionTracker.class).toProvider(VisualRegressionTrackerProvider.class).in(Scopes.SINGLETON);
        bind(new TypeLiteral<EnumMap<HostsMapping, String>>() {
        }).toProvider(HostsProvider.class).in(Scopes.SINGLETON);
        bind(HttpClient.class).toInstance(HttpClient.newBuilder().build());
        var properties = new Properties();
        try (var input = new FileInputStream(Paths.get(USER_DIR).getParent() + "/resources/secret.properties")) {
            properties.load(input);
        }
        Names.bindProperties(binder(), properties);
        bind(Jdbi.class).toProvider(JdbciProvider.class).in(Scopes.SINGLETON);
        bind(S3Client.class).toProvider(S3Provider.class).in(Scopes.SINGLETON);
    }
}
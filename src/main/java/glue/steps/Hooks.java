package glue.steps;

import com.assertthat.selenium_shutterbug.core.Capture;
import com.assertthat.selenium_shutterbug.core.Shutterbug;
import com.google.inject.Inject;
import com.stripe.Stripe;
import common.glue.steps.web.Step;
import common.glue.utilities.Constants;
import common.glue.utilities.GeneralActions;
import entity.Response;
import entity.Room;
import entity.User;
import enums.Address;
import enums.Domain;
import enums.UserEmailType;
import enums.data.NicknameType;
import enums.data.PasswordType;
import enums.data.PhoneNumberType;
import enums.data.RoomStatus;
import enums.feature_flag.LaunchDarklyFeatureFlag;
import enums.feature_flag.PrivateFeatureFlagType;
import extensions.ClientExtension;
import extensions.ResponseExtension;
import io.cucumber.java.*;
import io.cucumber.plugin.ConcurrentEventListener;
import io.cucumber.plugin.event.EventHandler;
import io.cucumber.plugin.event.EventPublisher;
import io.cucumber.plugin.event.TestCaseFinished;
import io.qameta.allure.Allure;
import io.qameta.allure.awaitility.AllureAwaitilityListener;
import io.vavr.control.Try;
import io.visual_regression_tracker.sdk_java.VisualRegressionTracker;
import jakarta.inject.Named;
import lombok.experimental.ExtensionMethod;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.SystemUtils;
import org.apache.hc.core5.http.HttpStatus;
import org.assertj.core.api.SoftAssertions;
import org.awaitility.Awaitility;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.devtools.v120.console.Console;
import org.openqa.selenium.devtools.v120.log.Log;
import org.openqa.selenium.devtools.v120.network.Network;
import org.openqa.selenium.devtools.v120.network.model.ResponseReceived;
import org.openqa.selenium.devtools.v120.page.Page;
import org.openqa.selenium.html5.WebStorage;

import javax.ws.rs.core.MediaType;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.google.common.net.HttpHeaders.CONTENT_TYPE;
import static javax.ws.rs.core.MediaType.APPLICATION_JSON;
import static org.assertj.core.api.Assertions.assertThat;

/**
 * User: nirtal
 * Date: 12/08/2021
 * Time: 9:34
 * Created with IntelliJ IDEA
 * <p>
 * This class contains the code that is run before and after a scenario defined in feature files
 *
 * @see <a href="https://github.com/cucumber/cucumber-jvm/pull/2432">Injector source is now part of the glue</a>
 */
@ExtensionMethod({ClientExtension.class, ResponseExtension.class})
public class Hooks extends Step implements ConcurrentEventListener {

    @Inject
    private VisualRegressionTracker visualRegressionTracker;
    private static boolean loggedInToAdmin = false;
    @Inject
    @Named("dev_stripe_key")
    private String devStripeKey;
    @Inject
    @Named("canary_stripe_key")
    private String canaryStripeKey;
    @Inject
    @Named("admin_token_dev")
    private String adminTokenDev;
    @Inject
    @Named("admin_token_canary")
    private String adminTokenCanary;
    private static final HttpClient httpClient = HttpClient.newBuilder().build();
    private final EventHandler<TestCaseFinished> sendNotificationForSanityFails = testCaseFinished -> Try.run(() -> setSendNotificationForSanityFails(testCaseFinished));
    //region Before hooks

    /**
     * this hook does the following:
     * <ul>
     *    <li> creating directory storing video files.
     *    <li> creating directory storing superbills pdf files.
     *    <li> adding {@link AllureAwaitilityListener} listener.
     *    <li> creating map that contain secrets (launch darkly api token stored for now) if running on local.
     *  </ul>
     *
     * @throws IOException if an I/O error occurs
     * @see <a href="https://github.com/allure-framework/allure-java/tree/master/allure-awaitility">Allure-awaitility</a>
     * @see <a href="https://www.selenium.dev/blog/2022/using-java11-httpclient/">Using Java 11+ HTTP Client in Selenium 4.5.0 and beyond</a>
     */
    @BeforeAll
    public static void beforeAll() throws IOException {
        Files.createDirectories(Paths.get(Constants.VIDEO_DIRECTORY));
        Files.createDirectories(Paths.get(Constants.CHROME_DOWNLOAD_DIRECTORY));
        Awaitility.setDefaultConditionEvaluationListener(new AllureAwaitilityListener());
    }

    /**
     * when running locally, the first scenario will set the admin token, the rest will reuse the same admin token.
     * to get the token in case expired, we need to log in to backoffice admin
     * the URL for backoffice admin dev:
     * <a href="https://backoffice.dev.talkspace.com/">backoffice admin dev</a>
     * the URL for backoffice admin in canary:
     * <a href="https://backoffice.canary.talkspace.com/">backoffice admin canary</a>
     * and to run localStorage.getItem("token") in the console.
     * then update the token in the secrets.
     * <p>
     * on circle ci we will use a predefined token.
     */
    @Before(value = "@admin")
    public void loginToAdmin() {
        if (!loggedInToAdmin) {
            if (data.getConfiguration().getDomain().equals(Domain.DEV.getName())) {
                Stripe.apiKey = devStripeKey;
                data.getConfiguration().setAdminToken(adminTokenDev);
            } else if (data.getConfiguration().getDomain().equals(Domain.CANARY.getName())) {
                Stripe.apiKey = canaryStripeKey;
                data.getConfiguration().setAdminToken(adminTokenCanary);
            }
            loggedInToAdmin = true;
        }
    }

    /**
     * this hook does the following:
     * <ul>
     *     <li> start visual regression tracker.
     *
     * @throws IOException          if an I/O error occurs
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    @Before(value = "@visual")
    public void startVisualRegressionTracker() throws IOException, InterruptedException {
        visualRegressionTracker.start();
    }


    /**
     * this hook does the following:
     * <ul>
     *    <li>setting the current time - for later reuse.
     *    <li>generating a private mailinator email for usage in QM flows - for later reuse.
     *    <li>setting a default strong password for the client - for later reuse.
     *    <li>deleting the existing login tokens for all users so the report won't mix up existing logged in users (which are not primary or partner).
     *    <li>initializing the room list for all users.
     *    <li> start devtools session.
     *    <li> start a screencast of the current web page and adds a listener to capture each frame of the screencast.
     *    frames are save it to disk as a series of JPEG images, with the file names being the current timestamp in milliseconds.
     *    The code also acknowledges each captured frame to ensure that the screencast continues uninterrupted.
     *    recoding will not be performed for production testing.
     *  </ul>
     *
     * @param scenario current scenario
     * @see <a href="https://www.way2automation.com/capture-console-logs-new-feature-selenium-4/">Capture Console Logs – New feature Selenium 4</a>
     */
    @Before(order = 3)
    public void startScenario(Scenario scenario) {
        //region Data initialization
        data.getUsers().forEach((userType, user) -> user.setLoginToken(StringUtils.EMPTY));
        scenarioContext.setScenarioStartTime(System.currentTimeMillis());
        data.getUsers().put("primary", User.createUser()
                .withEmail(GeneralActions.getEmailAddress(UserEmailType.NEW))
                .withPendingEmail(GeneralActions.getEmailAddress(UserEmailType.NEW))
                .withFirstName(data.getUserDetails().getFirstName())
                .withLastName(String.valueOf(scenarioContext.getScenarioStartTime()))
                .withOldPassword(StringUtils.EMPTY)
                .withPhoneNumber(PhoneNumberType.FAKE.getValue())
                .withAddress(Address.US)
                .create());
        data.getUsers().get("primary").setPassword(PasswordType.STRONG.getValue());
        data.getUsers().get("primary").setNickName(NicknameType.VALID.getValue());
        data.getUsers().put("partner", User.createUser()
                .withEmail(GeneralActions.getEmailAddress(UserEmailType.NEW))
                .withPendingEmail(StringUtils.EMPTY)
                .withFirstName(data.getUserDetails().getFirstName())
                .withLastName(String.valueOf(scenarioContext.getScenarioStartTime()))
                .withOldPassword(StringUtils.EMPTY)
                .withPhoneNumber(PhoneNumberType.FAKE.getValue())
                .withAddress(Address.US)
                .create());
        data.getUsers().get("partner").setPassword(PasswordType.STRONG.getValue());
        data.getUsers().get("partner").setNickName(NicknameType.VALID.getValue());
        data.getUsers().forEach((userType, user) -> user.setRoomsList(new ArrayList<>()));
        scenarioContext.setSmsCount(new EnumMap<>(PhoneNumberType.class));
        scenarioContext.setSqlAndApiResults(new HashMap<>());
        scenarioContext.setScenarioName(scenario.getName());
        //endregion
        //region Driver and screen recording initialization
        driver.manage().window().maximize();
        devTools.createSession();
        devTools.send(Network.enable(Optional.empty(), Optional.empty(), Optional.empty()));
        scenarioContext.setTalkspaceApiResponses(new ArrayList<>());
        scenarioContext.setPrivateFeatureFlagTypeMap(new EnumMap<>(PrivateFeatureFlagType.class));
        scenarioContext.setLaunchDarklyFeatureFlagMap(new EnumMap<>(LaunchDarklyFeatureFlag.class));
        scenarioContext.setResponses(new ArrayList<>());
        scenarioContext.setSoftAssertions(new SoftAssertions());
        devTools.addListener(Network.responseReceived(),
                responseReceived -> Try.run(() -> {
                    if (responseReceived.getResponse()
                            .getHeaders()
                            .toJson()
                            .containsKey(data.getConfiguration().getHeaderName().toLowerCase())) {
                        scenarioContext.getTalkspaceApiResponses().add(responseReceived);
                    }
                }));
        devTools.send(Log.enable());
        devTools.send(Console.enable());
        scenarioContext.setConsoleLogs(objectMapper.createArrayNode());
        scenarioContext.setConsoleMessages(objectMapper.createArrayNode());
        devTools.addListener(Log.entryAdded(),
                logEntry -> Try.run(() ->
                        scenarioContext.getConsoleLogs().add(objectMapper.createObjectNode()
                                .put("Level", logEntry.getLevel().toJson())
                                .put("URL", logEntry.getUrl().orElse(null))
                                .put("Source", logEntry.getSource().toJson())
                                .put("Text", logEntry.getText())
                                .put("Time stamp", DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").format(LocalDateTime.ofInstant(Instant.ofEpochMilli(logEntry.getTimestamp().toJson().longValue()), ZoneId.systemDefault())))
                                .put("WorkerId", logEntry.getWorkerId().orElse(null))
                                .put("Line Number", logEntry.getLineNumber().orElse(null)))));
        devTools.addListener(Console.messageAdded(),
                message -> Try.run(() -> scenarioContext.getConsoleMessages().add(objectMapper.createObjectNode()
                        .put("Level", message.getLevel().toJson())
                        .put("URL", message.getUrl().orElse(null))
                        .put("Source", message.getSource().toJson())
                        .put("Text", message.getText())
                        .put("Column", message.getColumn().orElse(null))
                        .put("Line Number", message.getLine().orElse(null)))));
        if (!GeneralActions.isRunningOnProd()) {
            if (!SystemUtils.IS_OS_MAC) {
                devTools.send(Page.enable());
                // The everyNthFrame command in the CDP Chrome Screencast API specifies how often a frame is captured during screen recording.
                devTools.send(Page.startScreencast(Optional.of(Page.StartScreencastFormat.JPEG), Optional.of(100), Optional.of(1920), Optional.of(1080), Optional.of(1)));
                devTools.addListener(Page.screencastFrame(), screencastFrame ->
                        Try.withResources(() -> new FileOutputStream(Constants.VIDEO_DIRECTORY + File.separator + System.currentTimeMillis() + ".jpeg"))
                                .of(stream -> {
                                    stream.write(Base64.getDecoder().decode(screencastFrame.getData()));
                                    // send ack otherwise frames stop to arrive
                                    devTools.send(Page.screencastFrameAck(screencastFrame.getSessionId()));
                                    return true;
                                }));
            }
        }
        //endregion
    }
    //endregion
    //region After hooks


    /**
     * claims scenarios are a special case where the user is not logged in and the room is created via the API.
     *
     * @throws IOException        if an I/O error occurs
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @After(order = 3)
    public void cancelSubscriptionForRoom(Scenario scenario) throws IOException, URISyntaxException {
        var primaryUser = data.getUsers().get("primary");
        var userWasLoggedIn = StringUtils.isNotBlank(primaryUser.getLoginToken());
        if (userWasLoggedIn) {
            if (scenario.getSourceTagNames().stream().noneMatch(tagName -> tagName.equals("@admin"))) {
                extractLoginTokenFromUI(primaryUser);
            }
            cancelSubscriptionAndBookings(primaryUser);
        }
    }


    /**
     * cancel subscription only done after purchase to avoid Sendgrid emails to this account and real payments on production.
     * only relevant for logged-in users, room ids taken from rooms endpoint.
     * in case the room is b2c, we will cancel the subscription via the API.
     * in b2b rooms subscription is canceled after canceling the room.
     *
     * @param primaryUser the user to cancel subscription for
     * @throws IOException        if an I/O error occurs
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    private void cancelSubscriptionAndBookings(User primaryUser) throws IOException, URISyntaxException {
        //Refreshing the rooms list with up-tp-date details
        clientSteps.getRoomsInfoOfUser(primaryUser);
        primaryUser
                .getRoomsList()
                .stream()
                .filter(Room::isCancellable)
                .forEach(room -> Awaitility
                        .await()
                        .alias("room %d canceled via API".formatted(room.getId()))
                        .atMost(Duration.ofMinutes(3))
                        .pollInterval(Duration.ofMinutes(1))
                        .untilAsserted(() ->
                        {
                            if (!room.isB2B()) {
                                var bookingRequest = clientSteps.getSessionBookingsForRoomId(primaryUser, room.getId());
                                assertThat(bookingRequest)
                                        .extracting(HttpResponse::statusCode)
                                        .as("Get bookings response")
                                        .withFailMessage(GeneralActions.failMessage(bookingRequest))
                                        .isEqualTo(HttpStatus.SC_OK);
                                var bookingsIds = objectMapper.readTree(bookingRequest.body())
                                        .get("data")
                                        .findValuesAsText("id");
                                if (!bookingsIds.isEmpty()) {
                                    for (var bookingId : bookingsIds) {
                                        var response = clientSteps.cancelBookingForRoomId(primaryUser, room.getId(), bookingId);
                                        assertThat(response.statusCode())
                                                .as("Cancel booking {} response", bookingId)
                                                .withFailMessage(GeneralActions.failMessage(response))
                                                .isBetween(HttpStatus.SC_OK, HttpStatus.SC_NO_CONTENT);
                                    }
                                }
                            }
                            var response = List.of(RoomStatus.WAITING_TO_BE_MATCHED, RoomStatus.WAITING_TO_BE_MATCHED_QUEUE).contains(room.getRoomStatus()) || room.isB2B() ?
                                    clientSteps.cancelNonSubscription(primaryUser, room.getId()) : clientSteps.cancelSubscription(primaryUser, room.getId()).log();
                            assertThat(response.statusCode())
                                    .as("Cancel subscription response")
                                    .withFailMessage(GeneralActions.failMessage(response))
                                    .isBetween(HttpStatus.SC_OK, HttpStatus.SC_NO_CONTENT);
                        }));
    }

    /**
     * extract login access token is taken from session or local storage.
     * in case working with multiple tabs (when tab count is greater than 1) - must return to the
     * first tab in the scenario to get the access token.
     *
     * @param primaryUser the primary user
     */
    private void extractLoginTokenFromUI(User primaryUser) {
        if (driver.getWindowHandles().size() > 1) {
            commonWebSteps.switchTab(0);
        }
        //region if there is a new token available use it
        // First, we're trying to get the access token from Session Storage
        Optional.ofNullable(((WebStorage) driver).getSessionStorage().getItem(Constants.ACCESS_TOKEN))
                .ifPresentOrElse(primaryUser::setLoginToken, () ->
                        //If the access token is not present in Session Storage, we try to get it from Local Storage,
                        // this is not mandatory because there can be a case we are completely logged out.
                        Optional.ofNullable(((WebStorage) driver).getLocalStorage().getItem(Constants.ACCESS_TOKEN))
                                .ifPresent(primaryUser::setLoginToken));
    }

    /**
     * this hook verifies all soft assertions.
     */
    @After(order = 4)
    public void verifySoftAssertions() {
        scenarioContext.getSoftAssertions().assertAll();
    }

    /**
     * This hook does the following:
     *
     * <ul>
     * <li> attaching the video recording to the cucumber report if a scenario is failed or skipped.
     * <li> attaching logged-in users to allure report.
     * <li> attaching the browser console logs to allure report if a scenario is failed or skipped.
     * <li> attaching screenshot to allure report if a scenario is failed or skipped - image will be blurred on sanity testing.
     * In the case of working with multiple tabs (when tab count is greater than 1) - we will shoot all the tabs - this generally happens on partner invitation scenarios.
     * <li> attaching the browser network logs to allure report if a scenario is failed or skipped.
     * <li> attaching the browser cookies to the allure report if a scenario is failed or skipped.
     * <li> attaching the browser local storage the allure report if a scenario is failed or skipped.
     * <li> attaching all iframe titles to the allure report if a scenario is failed or skipped.
     * <li> attaching the browser session storage the allure report if a scenario is failed or skipped.
     * <li> We use the {@link ProcessBuilder} to start a new process that runs the FFmpeg tool.
     * FFmpeg is a multimedia framework used for encoding, decoding, and manipulating video and audio files.
     * FFmpeg is instructed to take the series of JPEG images in the specified directory (given by the constant "Constants.VIDEO_DIRECTORY"),
     * combine them into a single video file with a framerate of 15 frames per second, and save the resulting
     * video file with the start time of the scenario as the file name and a ".mp4" extension.
     * The video's resolution is set to 1280x960. After FFmpeg has finished running, the code deletes the individual JPEG image
     * files used to create the video. The code uses the FileUtils
     * class from the Apache Commons IO library to delete the files quietly, meaning that if a file is
     * not found or cannot be deleted for some reason, no exception will be thrown.
     * Recoding will not be performed nor an allure link will be displayed for production testing.
     * <li> quit the driver.
     */
    @After(order = 2)
    public void finishScenario(Scenario scenario) throws IOException, InterruptedException {
        var scenarioLoggedInUsers = objectMapper.valueToTree(data.getUsers()
                .entrySet()
                .stream()
                .filter(userEntry -> StringUtils.isNotBlank(userEntry.getValue().getLoginToken()))
                .toList());
        if (!scenarioLoggedInUsers.isEmpty()) {
            scenario.attach(scenarioLoggedInUsers.toPrettyString(), MediaType.APPLICATION_JSON, "Logged in users in this scenario");
        }
        scenario.attach(data.getUsers().get("primary").getEmail(), MediaType.TEXT_PLAIN, "Primary user email generated in this scenario");
        if (List.of(Status.SKIPPED, Status.FAILED).contains(scenario.getStatus()) && !driver.getCurrentUrl().equals("data:,")) {
            //region Scrolling to the bottom of the page.
            Try.run(() -> ((JavascriptExecutor) driver).executeScript("window.scrollTo(0, document.body.scrollHeight)"));
            //endregion
            var tabCount = driver.getWindowHandles().size();
            if (tabCount == 1) {
                scenario.attach(GeneralActions.isRunningOnProd() ? Shutterbug.shootPage(driver, Capture.FULL, true).blur().getBytes() : ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES), "image/png", "Full Page Screen Shot");
                scenario.attach(driver.getCurrentUrl(), "text/uri-list", "URL On Failure");
                driver.switchTo().defaultContent();
                var frames = driver.findElements(By.tagName("iframe"))
                        .stream()
                        .filter(frame -> StringUtils.isNotBlank(frame.getAttribute("title")))
                        .map(frame -> frame.getAttribute("title"))
                        .toList();
                if (!frames.isEmpty()) {
                    Allure.addAttachment("Iframes", String.join(System.lineSeparator(), frames));
                }
            } else {
                for (int tab = 0; tab <= tabCount - 1; tab++) {
                    commonWebSteps.switchTab(tab);
                    scenario.attach(driver.getCurrentUrl(), "text/uri-list", "URL On Failure of window in index %d".formatted(tab));
                    scenario.attach(GeneralActions.isRunningOnProd() ? Shutterbug.shootPage(driver, Capture.FULL, true).blur().getBytes() : ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES), "image/png", "Full Page Screen Shot of window in index %d".formatted(tab));
                }
            }
            scenario.attach(scenarioContext.getConsoleLogs().isEmpty() ? "No Console Logs Found" : objectMapper.writeValueAsString(scenarioContext.getConsoleLogs()), MediaType.APPLICATION_JSON, "Console Logs");
            scenario.attach(scenarioContext.getConsoleMessages().isEmpty() ? "No Console Messages Found" : objectMapper.writeValueAsString(scenarioContext.getConsoleMessages()), MediaType.APPLICATION_JSON, "Console Messages");
            scenario.attach(objectMapper.writeValueAsString(driver.manage().getCookies()), MediaType.APPLICATION_JSON, "Cookies");
            Try.run(() -> scenario.attach(objectMapper.writeValueAsString(((WebStorage) driver).getLocalStorage()
                    .keySet()
                    .stream()
                    .collect(Collectors.toMap(Function.identity(), ((WebStorage) driver).getLocalStorage()::getItem))), MediaType.APPLICATION_JSON, "Local storage"));
            Try.run(() -> scenario.attach(objectMapper.writeValueAsString(((WebStorage) driver).getSessionStorage()
                    .keySet()
                    .stream()
                    .collect(Collectors.toMap(Function.identity(), ((WebStorage) driver).getSessionStorage()::getItem))), MediaType.APPLICATION_JSON, "Session storage"));
            scenario.attach(commonTalkspaceApiSteps.getPublicIp().body(), MediaType.TEXT_PLAIN, "Public IP");
            if (!scenarioContext.getLaunchDarklyFeatureFlagMap().isEmpty()) {
                scenario.attach(objectMapper.writeValueAsString(scenarioContext.getLaunchDarklyFeatureFlagMap()), MediaType.APPLICATION_JSON, "LaunchDarkly Feature Flags");
            }
            if (!scenarioContext.getPrivateFeatureFlagTypeMap().isEmpty()) {
                scenario.attach(objectMapper.writeValueAsString(scenarioContext.getPrivateFeatureFlagTypeMap()), MediaType.APPLICATION_JSON, "Private Feature Flags");
            }
            Try.run(() -> {
                        for (ResponseReceived responseReceived : scenarioContext
                                .getTalkspaceApiResponses()) {
                            scenarioContext.getResponses().add(Response.createResponse()
                                    .withStatusCode(responseReceived.getResponse().getStatus())
                                    .withUrl(responseReceived.getResponse().getUrl())
                                    .withExecutionId(responseReceived.getResponse().getHeaders().get(data.getConfiguration().getHeaderName().toLowerCase()).toString())
                                    .withRequestBody(Try.of(() -> GeneralActions.createObjectNodeFromString(devTools.send(Network.getRequestPostData(responseReceived.getRequestId())))).getOrNull())
                                    .withResponseBody(Try.of(() -> GeneralActions.createObjectNodeFromString(devTools.send(Network.getResponseBody(responseReceived.getRequestId())).getBody())).getOrNull())
                                    .create());
                        }
                    })
                    .onSuccess(success -> {
                        var partitionedResponses = scenarioContext.getResponses()
                                .stream()
                                .collect(Collectors.partitioningBy(response -> response.statusCode() < HttpStatus.SC_BAD_REQUEST));
                        var successfulResponses = objectMapper.valueToTree(partitionedResponses.get(true));
                        var failedResponses = objectMapper.valueToTree(partitionedResponses.get(false));
                        if (!failedResponses.isEmpty()) {
                            scenario.attach(failedResponses.toPrettyString(), MediaType.APPLICATION_JSON, "API error responses with ExecutionID");
                        }
                        if (!successfulResponses.isEmpty()) {
                            scenario.attach(successfulResponses.toPrettyString(), MediaType.APPLICATION_JSON, "Successful API responses with ExecutionID");
                        }
                    })
                    .onFailure(failure -> scenario.attach(Objects.nonNull(failure.getMessage()) ? "No error message found" : failure.getMessage(), MediaType.TEXT_PLAIN, "could not generate network via selenium - click to view failure message"));
        }
        if (!GeneralActions.isRunningOnProd()) {
            if (!SystemUtils.IS_OS_MAC) {
                if (List.of(Status.SKIPPED, Status.FAILED).contains(scenario.getStatus())) {
                    scenario.attach("<html><body><video width='100%%' height='100%%' controls autoplay><source src='https://automation-reports.dev.talkspace.com/automation-tests/%s' type='video/mp4'></video></body></html>".formatted(scenarioContext.getScenarioStartTime()
                            .toString()
                            .concat(".mp4")), MediaType.TEXT_HTML, "Video record");
                    //The framerate option in FFmpeg specifies the number of frames per second (FPS) of the output video.
                    new ProcessBuilder("ffmpeg",
                            "-framerate", "30",
                            "-pattern_type", "glob", "-i", "*.jpeg",
                            "-vf", "scale=1280:960",
                            "-c:v", "libx264",
                            "-pix_fmt", "yuv420p",
                            scenarioContext.getScenarioStartTime().toString().concat(".mp4"))
                            .directory(new File(Constants.VIDEO_DIRECTORY))
                            .redirectErrorStream(true)
                            .start()
                            .waitFor();
                }
                var jpegFiles = new File(Constants.VIDEO_DIRECTORY).listFiles((directory, name) -> name.endsWith(".jpeg"));
                if (jpegFiles != null) {
                    Arrays.stream(jpegFiles).forEach(FileUtils::deleteQuietly);
                }
            }
        }
        driver.quit();
    }

    @After(value = "@visual")
    public void stopVisualRegressionTracker() throws IOException, InterruptedException {
        visualRegressionTracker.stop();
    }

    //endregion
    @Override
    public void setEventPublisher(EventPublisher eventPublisher) {
        if (StringUtils.equals(System.getProperty("job_name"), "web_sanity_tests")) {
            eventPublisher.registerHandlerFor(TestCaseFinished.class, sendNotificationForSanityFails);
        }
    }

    /**
     * Sends a Slack message to the engineering notification channel for each failing test only for prod sanity tests with the test name and fail reason.
     *
     * @param testCaseFinished test case finished object.
     * @throws IOException          if an I/O error occurs
     * @throws InterruptedException if the current thread was interrupted while waiting
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2673">Better reporting on hotfix auto-sanity</a>
     */
    private void setSendNotificationForSanityFails(TestCaseFinished testCaseFinished) throws
            IOException, InterruptedException {
        if (testCaseFinished.getResult().getStatus().equals(io.cucumber.plugin.event.Status.FAILED)) {
            var request = HttpRequest.newBuilder(URI.create("https://hooks.slack.com/services/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"))
                    .headers(CONTENT_TYPE, APPLICATION_JSON)
                    .POST(HttpRequest.BodyPublishers.ofString("""
                            {
                                                                     "text": ":rotating_light: AUTOMATED PROD SANITY TEST FAILED!",
                                                                     "attachments": [
                                                                       {
                                                                         "color": "danger",
                                                                         "fields": [
                                                                           {
                                                                             "title": "Test Name",
                                                                             "value": "%s"
                                                                           },
                                                                           {
                                                                             "title": "Failure reason",
                                                                             "value": "%s"
                                                                           }
                                                                         ]
                                                                       }
                                                                     ]
                                                                   }
                                                    """.formatted(testCaseFinished.getTestCase().getName(), testCaseFinished.getResult().getError().getMessage())))
                    .build();
            httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        }
    }
}
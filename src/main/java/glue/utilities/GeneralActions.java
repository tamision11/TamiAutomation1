package glue.utilities;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.google.common.util.concurrent.Uninterruptibles;
import com.google.inject.Inject;
import common.glue.steps.api.calls.SauceLabsCalls;
import di.providers.ScenarioContext;
import entity.Data;
import enums.Domain;
import enums.UserEmailType;
import extensions.ClientExtension;
import extensions.ResponseExtension;
import io.vavr.control.Try;
import lombok.experimental.ExtensionMethod;
import lombok.experimental.UtilityClass;
import net.datafaker.Faker;
import org.apache.commons.io.comparator.LastModifiedFileComparator;
import org.apache.commons.io.filefilter.FileFilterUtils;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.InvalidArgumentException;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import java.time.temporal.ChronoField;
import java.util.Arrays;
import java.util.Base64;
import java.util.Calendar;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.StreamSupport;

/**
 * This class contains generic methods used in the project
 */
@UtilityClass
@ExtensionMethod({ClientExtension.class, ResponseExtension.class})
public class GeneralActions {

    @Inject
    private Data data;
    @Inject
    private Faker faker;
    @Inject
    private ObjectMapper objectMapper;
    @Inject
    private SauceLabsCalls sauceLabsCalls;

    /**
     * <a href="https://app.saucelabs.com/live/app-testing">filter section filters by apk identifier - identifiers are visible here</a>
     * filtering apps uploaded automatically - they are identified by the name "androidApp.apk", manual upload has other names.
     *
     * @return used for app download for local testing
     * @throws IOException          if an I/O error occurs
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    public String getLatestAndroidApkIdentifier() throws IOException, InterruptedException {
        var response = sauceLabsCalls.getAppStorageFiles().log();
        var appIdentifier = switch (data.getConfiguration().getDomain()) {
            case "canary" -> "com.talkspace.talkspaceapp.canary";
            case "dev" -> "com.talkspace.talkspaceapp.debug";
            case "prod" -> "com.talkspace.talkspaceapp";
            default -> throw new InvalidArgumentException("Unexpected value: " + data.getConfiguration().getDomain());
        };
        return StreamSupport.stream(objectMapper.readTree(response.body()).get("items").spliterator(), false)
                .filter(jsonNode -> jsonNode.get("metadata").get("identifier").asText().equals(appIdentifier))
                .filter(jsonNode -> jsonNode.get("name").asText().equals("androidApp.apk"))
                .map(jsonNode -> jsonNode.get("id").asText())
                .findFirst()
                .orElseThrow();
    }

    /**
     * formatted fail message for api calls
     *
     * @param response the http response that failed
     * @return fail message
     */
    public String failMessage(HttpResponse<String> response) {
        return String.format("%s to: %s failed %n status code: %d %n body: %s %n %s: %s",
                response.request().method(),
                response.request().uri().toString(),
                response.statusCode(),
                response.body(),
                data.getConfiguration().getHeaderName(),
                response.headers().map().getOrDefault(data.getConfiguration().getHeaderName(), null));
    }

    /**
     * placeholder replacement for db queries - when trying to get the second room it might not been created,
     * we use a try catch to get the second room id if it exists
     *
     * @param condition the original condition
     * @return the condition after placeholder replacement
     */
    public String replacePlaceholders(String condition, ScenarioContext scenarioContext) {
        return StringUtils.replaceEach(condition,
                new String[]{
                        "{room_id_1}", // room id of first room
                        "{room_id_2}", // room id of second room
                        "{user_id}", // user id
                        "{session_report_id}", // session report id
                        "{allowed_amount}", // allowed amount
                        "{insurance_paid}", // insurance paid
                        "{invoice_id}", // invoice id
                        "{claim_id}", // claim id
                        "{claims}", // claims
                        "{external_id}", // external id
                        "{invalid_external_id}", // invalid external id
                        "{era_id}", // era id
                        "{worklist_id}" // worklist id
                },
                new String[]{
                        Try.of(() -> data.getUsers().get("primary").getRoomsList().get(0).getId().toString()).getOrNull(), // room id of first room
                        Try.of(() -> data.getUsers().get("primary").getRoomsList().get(1).getId().toString()).getOrNull(), // room id of second room
                        Try.of(() -> data.getUsers().get("primary").getId().toString()).getOrNull(), // user id
                        Try.of(() -> data.getUsers().get("primary").getId().toString()).getOrNull(), // session report id
                        scenarioContext.getSqlAndApiResults().get("allowed_amount"), // allowed amount
                        scenarioContext.getSqlAndApiResults().get("insurance_paid"), // insurance paid
                        scenarioContext.getSqlAndApiResults().get("invoice_id"), // invoice id
                        scenarioContext.getSqlAndApiResults().get("claim_id"), // claim id
                        scenarioContext.getSqlAndApiResults().get("claims"), // claims
                        scenarioContext.getSqlAndApiResults().get("external_id"), // external id
                        scenarioContext.getSqlAndApiResults().get("invalid_external_id"), // invalid external id
                        scenarioContext.getSqlAndApiResults().get("era_id"), // era id
                        scenarioContext.getSqlAndApiResults().get("worklist_id") // worklist id
                });
    }


    /**
     * @return are we running on prod?
     */
    public boolean isRunningOnProd() {
        return data.getConfiguration().getDomain().equals(Domain.PROD.getName());
    }

    /**
     * @param yearDiff  the year difference from today
     * @param monthDiff the month difference from today
     * @param dayDiff   the day difference from today
     * @return a date in the format of MM/dd/yyyy which is used in the web
     */
    public String generateDate(int dayDiff, int monthDiff, int yearDiff) {
        Calendar prevYear = Calendar.getInstance();
        SimpleDateFormat month = new SimpleDateFormat("MM");
        prevYear.add(Calendar.DAY_OF_MONTH, -dayDiff);
        prevYear.add(Calendar.MONTH, -monthDiff);
        prevYear.add(Calendar.YEAR, -yearDiff);
        int day = prevYear.get(Calendar.DAY_OF_MONTH);
        int year = prevYear.get(Calendar.YEAR);
        if (day < 10) {
            return month.format(prevYear.getTime()) + "/0" + day + File.separator + year;
        } else {
            return month.format(prevYear.getTime()) + File.separator + day + File.separator + year;
        }
    }

    /**
     * @param yearDiff the year difference from today
     * @return a date in the format of yyyy-MM-dd which is used in the api
     */
    public static String generateApiDate(int dayDiff, int monthDiff, int yearDiff) {
        return LocalDate.parse(generateDate(dayDiff, monthDiff, yearDiff),
                        new DateTimeFormatterBuilder()
                                .appendPattern("MM/dd/yyyy")
                                .parseDefaulting(ChronoField.HOUR_OF_DAY, 0)
                                .parseDefaulting(ChronoField.MINUTE_OF_HOUR, 0)
                                .parseDefaulting(ChronoField.SECOND_OF_MINUTE, 0)
                                .toFormatter())
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }


    /**
     * Attempts to create an {@link ObjectNode}  from the input String.
     * If the input String is a valid Json object, the ObjectNode will be read directly from the input.
     * Otherwise, a new {@link ObjectNode} will be created with the input String as the value
     *
     * @param input String to generate an ObjectNode out of
     * @return ObjectNode that is read from the input (if the input is a valid Json object) or created with the input as value (if the input is not a valid Json object)
     * @see <a href="https://stackoverflow.com/a/41279446/4515129">How to convert JsonNode to ObjectNode</a>
     */
    public ObjectNode createObjectNodeFromString(String input) {
        return Try.of(() -> objectMapper.readValue(input, ObjectNode.class))
                .getOrElse(() -> objectMapper.createObjectNode().put("value", input));
    }

    /**
     * @param text String to encode.
     * @return base64 encoded string.
     */
    public String encodeBase64(String text) {
        return Base64.getUrlEncoder()
                .withoutPadding()
                .encodeToString(text.getBytes(StandardCharsets.UTF_8));
    }

    /**
     * @param directory the directory to look in.
     * @return list files in a directory.
     */
    public List<File> listFilesInDirectory(String directory) {
        return Try.withResources(() -> Files.list(Paths.get(directory)))
                .of(fileList -> fileList.filter(Files::isRegularFile)
                        .map(Path::toFile)
                        .toList())
                .get();
    }

    /**
     * @param directory the directory to look in.
     * @return the last modified file
     */
    public File findLastModifiedFile(String directory) {
        var fileDirectory = new File(directory);
        if (fileDirectory.isDirectory()) {
            var dirFiles = fileDirectory.listFiles((FileFilter) FileFilterUtils.fileFileFilter());
            if (dirFiles != null && dirFiles.length > 0) {
                Arrays.sort(dirFiles, LastModifiedFileComparator.LASTMODIFIED_REVERSE);
                return dirFiles[0];
            }
        }
        return null;
    }

    /**
     * The "testautomation" or "test"
     * prefixes are used to identify emails that were generated by the automation and flag them in launchdarkly.
     * <br><font color="red"><u>Please do not change it!</u></font>
     *
     * @param userEmailType the type of email to generate or to retrieve.
     * @return a new unique email address
     * @see <a href="https://talktala.atlassian.net/browse/PLATFORM-4670">add "auto&lt;generated_number&gt;" + @talkspace.m8r.co as prefix to automation users same as "testautomation&lt;generated_number&gt;"</a>
     */
    public String getEmailAddress(UserEmailType userEmailType) {
        Uninterruptibles.sleepUninterruptibly(300, TimeUnit.MILLISECONDS);
        return switch (userEmailType) {
            case NEW -> "auto".concat(String.valueOf(System.currentTimeMillis()).concat("@talkspace.m8r.co"));
            case PRIMARY -> data.getUsers().get("primary").getEmail();
            case PARTNER -> data.getUsers().get("partner").getEmail();
            case TWO_FACTOR_US -> data.getUsers().get("2faUs").getEmail();
            case EXISTING_CLIENT -> data.getUsers().get("inPlatformMatching").getEmail();
            case INVALID -> "1nv4l1d";
            case RANDOM -> faker.internet().emailAddress();
        };
    }
}
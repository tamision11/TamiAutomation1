package di.providers;

import com.fasterxml.jackson.databind.node.ArrayNode;
import entity.Response;
import entity.RmtFile;
import enums.ApplicationUnderTest;
import enums.data.PhoneNumberType;
import enums.feature_flag.LaunchDarklyFeatureFlag;
import enums.feature_flag.PrivateFeatureFlagType;
import io.cucumber.guice.ScenarioScoped;
import lombok.Data;
import org.assertj.core.api.SoftAssertions;
import org.openqa.selenium.devtools.v120.network.model.ResponseReceived;

import java.util.ArrayList;
import java.util.Map;

/**
 * Storage for scenario objects, cleaned after each scenario.
 */
@ScenarioScoped
@Data
public class ScenarioContext {

    /**
     * The chat message that was sent between the member and provider.
     */
    private String chatMessage;
    /**
     * sql query and api responses stored in memory for later usage.
     */
    private Map<String, String> sqlAndApiResults;
    /**
     * The length of the chat message that was sent between the member and provider.
     */
    private int messageLength;
    /**
     * The scenario name.
     */
    private String scenarioName;
    /**
     * logs from the browser console.
     */
    private ArrayNode consoleLogs;
    /**
     * messages from the browser console.
     */
    private ArrayNode consoleMessages;
    /**
     * SMS count for a specific phone number.
     */
    private Map<PhoneNumberType, Long> smsCount;
    /**
     * private feature flag type and its value.
     */
    private Map<PrivateFeatureFlagType, Boolean> privateFeatureFlagTypeMap;
    /**
     * launch darkly feature flag type and its value.
     */
    private Map<LaunchDarklyFeatureFlag, Boolean> launchDarklyFeatureFlagMap;
    /**
     * responses from the talkspace api.
     */
    private ArrayList<Response> responses;
    /**
     * responses from network calls.
     */
    private ArrayList<ResponseReceived> talkspaceApiResponses;
    /**
     * The application under test.
     */
    private ApplicationUnderTest applicationUnderTest;
    /**
     * The scenario start time.
     */
    private Long scenarioStartTime;
    /**
     * soft assertions.
     */
    private SoftAssertions softAssertions;
    /**
     * SMB company name.
     */
    private String companyName;
    /**
     * backoffice admin note.
     */
    private String note;
    /**
     * token from zocdoc.
     */
    private String zocdocToken;
    /**
     * rmt file from AWS.
     */
    private RmtFile rmtFile;
    /**
     * booking amount of talksapce member in a specific room.
     */
    private int bookingAmount;
    /**
     * zocdoc therapist ids.
     */
    private int[] zocdocTherapistIds;
}
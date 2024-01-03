package glue.steps.api;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.inject.Inject;
import di.providers.ScenarioContext;
import entity.Data;
import enums.feature_flag.LaunchDarklyFeatureFlag;
import extensions.ClientExtension;
import extensions.ResponseExtension;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import jakarta.inject.Named;
import lombok.experimental.ExtensionMethod;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.hc.core5.http.HttpStatus;
import org.assertj.core.api.Assumptions;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import static com.google.common.net.HttpHeaders.AUTHORIZATION;
import static org.assertj.core.api.Assertions.assertThat;


/**
 * Created by emanuela.biro on 7/22/2019.
 * <p>
 * class contains the step definitions for the api calls
 */
@ExtensionMethod({ClientExtension.class, ResponseExtension.class})
public class CommonTalkspaceApiSteps {

    @Inject
    private HttpClient client;
    @Inject
    private ScenarioContext scenarioContext;
    @Inject
    private ObjectMapper objectMapper;
    @Inject
    private Data data;
    @Inject
    @Named("ld_token")
    private String ldToken;

    /**
     * getting current Launch darkly flag value for all environments
     *
     * @return HTTP response.
     * @see <a href="https://apidocs.launchdarkly.com/tag/Feature-flags#operation/getFeatureFlag">Get LD feature flag</a>
     */
    public HttpResponse<String> getLdFlags(LaunchDarklyFeatureFlag launchDarklyFeatureFlag) {
        var request = HttpRequest.newBuilder(URI.create("https://app.launchdarkly.com/api/v2/flags/default/%s".formatted(launchDarklyFeatureFlag.getName())))
                .headers(AUTHORIZATION, ldToken)
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * getting the machine public ip - helps to debug cases where request was made and no response was returned.
     *
     * @return HTTP response.
     * @see <a href="https://stackoverflow.com/questions/2939218/getting-the-external-ip-address-in-java/">Getting the 'external' IP address in Java</a>
     */
    public HttpResponse<String> getPublicIp() {
        var request = HttpRequest.newBuilder(URI.create("https://checkip.amazonaws.com"))
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * This step used to check {@link LaunchDarklyFeatureFlag} is enabled or not - and skip the scenario when a feature flag is not in the required state
     *
     * @param launchDarklyFeatureFlag the launch darkly feature flag
     * @param status                  true if feature is enabled, false if feature is disabled.
     */
    @And("LaunchDarkly - {} feature flag activation status is {}")
    public void skipScenarioLdStatus(LaunchDarklyFeatureFlag launchDarklyFeatureFlag, boolean status) throws IOException {
        getLdFeatureFlags(launchDarklyFeatureFlag);
        Assumptions.assumeThat(scenarioContext.getLaunchDarklyFeatureFlagMap().get(launchDarklyFeatureFlag))
                .withFailMessage("'%s' is not in '%b' activation status - Skipping this scenario", launchDarklyFeatureFlag.getName(), status)
                .isEqualTo(status);
    }

    /**
     * Store the current Launch darkly flag value for a given environment for later usage at {@link ScenarioContext#getLaunchDarklyFeatureFlagMap()}
     * <p>
     *
     * @param launchDarklyFeatureFlag the launch darkly feature flag
     * @throws IOException if an I/O error occurs
     */
    @Given("LaunchDarkly - Store {} feature flag status")
    public void getLdFeatureFlags(LaunchDarklyFeatureFlag launchDarklyFeatureFlag) throws IOException {
        var response = getLdFlags(launchDarklyFeatureFlag).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Get LD flag response")
                .withFailMessage("%s to: %s failed %n status code: %d %n body: %s",
                        response.request().method(),
                        response.request().uri().toString(),
                        response.statusCode(),
                        response.body())
                .isEqualTo(HttpStatus.SC_OK);
        switch (data.getConfiguration().getDomain()) {
            case "dev" ->
                    scenarioContext.getLaunchDarklyFeatureFlagMap().put(launchDarklyFeatureFlag, objectMapper.readTree(response.body()).get("environments").get("test").get(BooleanUtils.ON).booleanValue());
            case "canary" ->
                    scenarioContext.getLaunchDarklyFeatureFlagMap().put(launchDarklyFeatureFlag, objectMapper.readTree(response.body()).get("environments").get("canary").get(BooleanUtils.ON).booleanValue());
            case "prod" ->
                    scenarioContext.getLaunchDarklyFeatureFlagMap().put(launchDarklyFeatureFlag, objectMapper.readTree(response.body()).get("environments").get("production").get(BooleanUtils.ON).booleanValue());
            default -> throw new IllegalStateException("Unexpected value: " + data.getConfiguration().getDomain());
        }
    }
}
package extensions;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.google.inject.Inject;
import dev.failsafe.Failsafe;
import dev.failsafe.RetryPolicy;
import io.qameta.allure.Allure;
import lombok.experimental.UtilityClass;

import java.io.IOException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Path;
import java.time.Duration;

import static javax.ws.rs.core.MediaType.APPLICATION_JSON;

/**
 * User: nirtal
 * Date: 08/11/2021
 * Time: 11:23
 * Created with IntelliJ IDEA
 * Extension methods for HTTP client.
 *
 * @see <a href="https://dzone.com/articles/lomboks-extension-methods">https://dzone.com/articles/lomboks-extension-methods</a>
 */
@UtilityClass
public class ClientExtension {

    @Inject
    private ObjectMapper objectMapper;

    /**
     * Logging the request to allure report then sending it.
     * This code uses the Failsafe library to wrap the call to client.send() with a retry policy.
     * withMaxRetries(3) specifies the maximum number of retries to perform (in this case, 3).
     * withJitter(0.5) adds randomization to the backoff delay time to prevent all retries from happening at the same time.
     * The 0.5 parameter means that the actual delay time will be randomly chosen between 50% less and 50% more than the calculated delay time.
     * withDelay(Duration.ofSeconds(5)) sets a fixed delay of 5 seconds before the first retry.
     * This option is used to ensure that the system has enough time to recover before retrying, especially when there is a temporary overload or network issue.
     * The get() method of the Failsafe instance takes a Callable that performs the actual HTTP request.
     * The get() method executes the Callable and applies the retry policy until the Callable succeeds, or the maximum number of retries is reached.
     *
     * @param client      HTTP client
     * @param requestBody request body
     * @param request     HTTP request
     * @return HTTP response
     */
    public HttpResponse<String> logThenSend(HttpClient client, ObjectNode requestBody, HttpRequest request) {
        logRequest(requestBody, request);
        return Failsafe.with(RetryPolicy.builder()
                        .withMaxRetries(5)
                        .withJitter(0.5)
                        .withDelay(Duration.ofSeconds(5))
                        .build())
                .get(() -> client.send(request, HttpResponse.BodyHandlers.ofString()));
    }

    /**
     * Logging the request to allure report then sending it.
     *
     * @param client  HTTP client
     * @param request HTTP request
     * @return HTTP response
     * @throws IOException          if an I/O error occurs
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    public HttpResponse<Path> logThenSend(HttpClient client, HttpRequest request, Path path) throws IOException, InterruptedException {
        logRequest(request);
        return client.send(request, HttpResponse.BodyHandlers.ofFile(path));
    }

    /**
     * Logging the request to allure report then sending it.
     *
     * @param client  HTTP client
     * @param request HTTP request
     * @return HTTP response
     */
    public HttpResponse<String> logThenSend(HttpClient client, HttpRequest request) {
        logRequest(request);
        return Failsafe.with(RetryPolicy.builder()
                        .withMaxRetries(5)
                        .withJitter(0.5)
                        .withDelay(Duration.ofSeconds(5))
                        .build())
                .get(() -> client.send(request, HttpResponse.BodyHandlers.ofString()));
    }

    /**
     * Logging HTTP request to Allure report - with Body
     *
     * @param requestBody request body
     * @param request     HTTP request
     */
    private void logRequest(ObjectNode requestBody, HttpRequest request) {
        Allure.addAttachment("Request of %s".formatted(request.uri().toString()), APPLICATION_JSON, objectMapper.createObjectNode()
                .put("Method", request.method())
                .putPOJO("Headers", request.headers().map())
                .putPOJO("Body", requestBody)
                .toPrettyString(), "json");
    }

    /**
     * Logging HTTP request to Allure report - without Body
     *
     * @param request HTTP request
     */
    private void logRequest(HttpRequest request) {
        Allure.addAttachment("Request of %s".formatted(request.uri().toString()), APPLICATION_JSON, objectMapper.createObjectNode()
                .put("Method", request.method())
                .putPOJO("Headers", request.headers().map())
                .toPrettyString(), "json");
    }
}

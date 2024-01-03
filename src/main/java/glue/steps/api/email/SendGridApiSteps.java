package glue.steps.api.email;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.inject.Inject;
import common.glue.utilities.GeneralActions;
import entity.Data;
import entity.User;
import extensions.ClientExtension;
import extensions.ResponseExtension;
import io.cucumber.java.en.And;
import io.netty.handler.codec.http.HttpScheme;
import jakarta.inject.Named;
import lombok.experimental.ExtensionMethod;
import org.apache.commons.lang3.StringUtils;
import org.apache.hc.core5.http.HttpStatus;
import org.apache.hc.core5.net.URIBuilder;
import org.awaitility.Awaitility;

import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import static com.google.common.net.HttpHeaders.*;
import static javax.ws.rs.core.MediaType.APPLICATION_JSON;
import static javax.ws.rs.core.MediaType.WILDCARD;
import static org.assertj.core.api.Assertions.assertThat;

/**
 * User: nirtal
 * Date: 14/02/2022
 * Time: 15:02
 * Created with IntelliJ IDEA
 *
 * @see <a href="https://docs.sendgrid.com/api-reference/how-to-use-the-sendgrid-v3-api/authentication">How to use the SendGrid V3 API</a>
 * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2992">EMAILS - replace mailchimp API with Sendgrid API for testing transactional emails</a>
 */
@ExtensionMethod({ClientExtension.class, ResponseExtension.class})
public class SendGridApiSteps {
    @Inject
    private Data data;
    @Inject
    private ObjectMapper objectMapper;
    @Inject
    @Named("send_grid_token_dev")
    private String sendgridTokenDev;
    @Inject
    @Named("send_grid_token_canary")
    private String sendgridTokenCanary;
    @Inject
    private HttpClient client;

    /**
     * It is recommended that this verification will be the last step in the scenario.
     * Email verification will not be performed if the scenario is running in production.
     * <a href="https://mandrillapp.com/templates/code?id=notifyclientpurchaseevent">this email should NOT be sent for a copay purchase (BH flows)</a>
     * <a href="https://mandrillapp.com/templates/code?id=voucher-generation-send-access-code">this email should NOT be sent when going via dispatcher\eligibility widget</a>
     * <a href="https://mandrillapp.com/templates/code?id=selfServiceRequestToDischargeAndCancelCustomer_var1">this email should NOT be sent when asking to refund LVS credits - LVS is not a subscription</a>
     * <a href="https://mandrillapp.com/templates/code?id=canary-notifyclientrefundpurchase">this email should be sent - After each successful refund flow</a>
     * <p>
     * Emails sent by sendgrid can be validated with the following GET request example: <br>
     * https://api.sendgrid.com/v3/messages?query=to_email="testautomation1690107696296@talkspace.m8r.co"&limit=10
     * <br>
     * where the query parameter is the email address and the limit is the number of emails to retrieve.
     * <br>
     * Alternatively,
     * they can be validated on the <a href="https://app.sendgrid.com/login">SendGrid website</a>.
     *
     * @param user                   the user to verify
     * @param emailTemplateAmountMap the email template and amount to verify
     * @see <a href="https://mandrillapp.com/templates/">templates location on mandrill</a>
     * @see <a href="https://mandrillapp.com/activity">check the outbound activity on mandrill - in case of mismacth with mailinator</a>
     * @see <a href="https://docs.sendgrid.com/for-developers/sending-email/getting-started-email-activity-api#filter-by-recipient-email">filter-by-recipient-email</a>
     */
    @And("Sendgrid API - {user} user has the following email subjects at his inbox")
    public void verifyMessagePresentInEmail(User user, Map<String, String> emailTemplateAmountMap) throws URISyntaxException {
        if (GeneralActions.isRunningOnProd()) {
            return;
        }
        var sendGridToken = switch (data.getConfiguration().getDomain()) {
            case "dev" -> sendgridTokenDev;
            case "canary" -> sendgridTokenCanary;
            default -> throw new IllegalStateException("Unexpected value: " + data.getConfiguration().getDomain());
        };
        var transformedMap = emailTemplateAmountMap.entrySet().stream()
                .collect(Collectors.toMap(entry -> data.getEmails().get(entry.getKey()), entry -> Long.parseLong(entry.getValue())));
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost("api.sendgrid.com")
                        .setPath("/v3/messages")
                        .setParameter("query", "to_email=\"%s\"".formatted(user.getEmail()))
                        .setParameter("limit", "10")
                        .build())
                .headers(ACCEPT, WILDCARD,
                        CONTENT_TYPE, APPLICATION_JSON,
                        AUTHORIZATION, "Bearer".concat(StringUtils.SPACE).concat(sendGridToken))
                .GET()
                .build();
        Awaitility.await()
                .alias("Waiting for email to arrive")
                .atMost(Duration.ofMinutes(7))
                .pollInterval(Duration.ofSeconds(15))
                .ignoreExceptions()
                .untilAsserted(() ->
                {
                    var response = client.logThenSend(request).log();
                    assertThat(response)
                            .extracting(HttpResponse::statusCode)
                            .as("Sendgrid API - Get member message response status code")
                            .isEqualTo(HttpStatus.SC_OK);
                    var map = StreamSupport.stream(objectMapper.readTree(response.body()).get("messages").spliterator(), false)
                            .filter(jsonNode -> jsonNode.get("status").asText().contains("delivered"))
                            .map(jsonNode -> jsonNode.get("subject"))
                            .map(JsonNode::asText)
                            .collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));
                    assertThat(map).containsAllEntriesOf(transformedMap);
                });
    }
}
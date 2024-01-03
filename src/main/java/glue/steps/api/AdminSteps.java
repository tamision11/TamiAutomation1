package glue.steps.api;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.google.common.util.concurrent.Uninterruptibles;
import com.google.inject.Inject;
import common.glue.utilities.Constants;
import common.glue.utilities.GeneralActions;
import di.providers.ScenarioContext;
import entity.Data;
import entity.Provider;
import entity.Room;
import entity.User;
import enums.AdjudicationStatus;
import enums.Domain;
import enums.HostsMapping;
import enums.backoffice.ClaimActions;
import enums.backoffice.Cron;
import extensions.ClientExtension;
import extensions.ResponseExtension;
import io.cucumber.java.en.Given;
import io.netty.handler.codec.http.HttpScheme;
import io.vavr.control.Try;
import lombok.experimental.ExtensionMethod;
import net.datafaker.Faker;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.hc.core5.http.HttpStatus;
import org.apache.hc.core5.net.URIBuilder;
import org.assertj.core.api.SoftAssertions;
import org.awaitility.Awaitility;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Path;
import java.time.Duration;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.EnumMap;
import java.util.List;
import java.util.Optional;

import static com.google.common.net.HttpHeaders.*;
import static enums.HostsMapping.*;
import static javax.ws.rs.HttpMethod.PATCH;
import static javax.ws.rs.core.MediaType.APPLICATION_JSON;
import static javax.ws.rs.core.MediaType.WILDCARD;
import static net.javacrumbs.jsonunit.core.Option.IGNORING_EXTRA_FIELDS;
import static net.javacrumbs.jsonunit.fluent.JsonFluentAssert.assertThatJson;
import static org.assertj.core.api.Assertions.assertThat;


/**
 * User: nirtal
 * Date: 28/02/2023
 * Time: 14:32
 * Created with IntelliJ IDEA
 * * <p>
 * Backoffice admin calls.
 */
@ExtensionMethod({ClientExtension.class, ResponseExtension.class})
public class AdminSteps {

    @Inject
    private HttpClient client;
    @Inject
    private EnumMap<HostsMapping, String> hostMapping;
    @Inject
    private ObjectMapper objectMapper;
    @Inject
    private Faker faker;
    @Inject
    private ScenarioContext scenarioContext;
    @Inject
    private Data data;

    private String[] headers() {
        return new String[]{ACCEPT, WILDCARD,
                CONTENT_TYPE, APPLICATION_JSON,
                USER_AGENT, Constants.AUTOMATION_USER_AGENT,
                AUTHORIZATION, "Bearer".concat(StringUtils.SPACE).concat(data.getConfiguration().getAdminToken())};
    }

    public HttpResponse<String> performClaimAction(ClaimActions claimActions, String claimStatus) throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .putPOJO("claimData", objectMapper.createArrayNode()
                        .add(objectMapper.createObjectNode()
                                .put("status", claimStatus)
                                .put("isTest", true)
                                .put("claimID", Integer.parseInt(scenarioContext.getSqlAndApiResults().get("claim_id")))));
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLAIMS_API))
                        .setPath("/admin/claims/%s".formatted(claimActions.getAction()))
                        .build())
                .headers(headers())
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> addNote() throws URISyntaxException {
        scenarioContext.setNote(faker.lorem().paragraph());
        var requestBody = objectMapper.createObjectNode()
                .put("assigneeUserID", data.getConfiguration().getAdmin().get(data.getConfiguration().getDomain()))
                .put("notes", scenarioContext.getNote());
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLAIMS_API))
                        .setPath("admin/claims/%d".formatted(Integer.parseInt(scenarioContext.getSqlAndApiResults().get("claim_id"))))
                        .build())
                .headers(headers())
                .method(PATCH, HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> assignManualClaimToEra() throws URISyntaxException {
        var randomExternalID = String.valueOf(faker.number().numberBetween(10000, 50000000));
        var requestBody = objectMapper.createObjectNode()
                .put("isManual", true)
                .put("externalID", randomExternalID)
                .put("dateOfService", "2023-06-30")
                .put("allowedAmount", 125)
                .put("deductibleFinal", 120)
                .put("coinsuranceFinal", 110)
                .put("copayFinal", 51)
                .put("payerControlNumber", RandomStringUtils.randomAlphanumeric(7).concat(RandomStringUtils.randomAlphabetic(3)))
                .put("insurancePaid", 90);
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLAIMS_API))
                        .setPath("/admin/eras/%s/claim/%s".formatted(scenarioContext.getSqlAndApiResults().get("era_id"), randomExternalID))
                        .build())
                .headers(headers())
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> assignClaimToEra() throws URISyntaxException {
        var eraId = data.getConfiguration().getDomain().equals(Domain.CANARY.getName()) ? 5030 : 4060;
        var requestBody = objectMapper.createObjectNode()
                .put("isManual", false)
                .put("externalID", scenarioContext.getSqlAndApiResults().get("external_id"))
                .put("dateOfService", "2023-06-30")
                .put("allowedAmount", 200)
                .put("deductibleFinal", 190)
                .put("coinsuranceFinal", 150)
                .put("copayFinal", 90)
                .put("insurancePaid", 110)
                .put("adjudicationStatus", "DENIED")
                .put("payerControlNumber", RandomStringUtils.randomAlphanumeric(7).concat(RandomStringUtils.randomAlphabetic(3)));
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLAIMS_API))
                        .setPath("/admin/eras/%s/claim/%s".formatted(eraId, scenarioContext.getSqlAndApiResults().get("external_id")))
                        .build())
                .headers(headers())
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> assignClaimToEra(AdjudicationStatus adjudicationStatus) throws URISyntaxException {
        var allowedAmount = Optional.ofNullable(scenarioContext.getSqlAndApiResults().get("allowed_amount"))
                .map(Integer::parseInt)
                .orElse(123);
        var insurancePaid = Optional.ofNullable(scenarioContext.getSqlAndApiResults().get("insurance_paid"))
                .map(Integer::parseInt)
                .orElse(123);
        var externalID = scenarioContext.getSqlAndApiResults().get("external_id");
        var requestBody = objectMapper.createObjectNode()
                .put("isManual", false)
                .put("externalID", externalID)
                .put("allowedAmount", allowedAmount)
                .put("deductibleFinal", 123)
                .put("coinsuranceFinal", 123)
                .put("copayFinal", 123)
                .put("totalMemberLiability", 123)
                .put("adjudicationStatus", adjudicationStatus.getStatus())
                .put("payerControlNumber", RandomStringUtils.randomAlphanumeric(7).concat(RandomStringUtils.randomAlphabetic(3)))
                .put("insurancePaid", insurancePaid);
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLAIMS_API))
                        .setPath("/admin/eras/%s/claim/%s".formatted(scenarioContext.getSqlAndApiResults().get("era_id"), externalID))
                        .build())
                .headers(headers())
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> assignClaimToAdmin() throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .put("assigneeUserID", data.getConfiguration().getAdmin().get(data.getConfiguration().getDomain()))
                .putNull("notes");
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLAIMS_API))
                        .setPath("admin/claims/%d".formatted(Integer.parseInt(scenarioContext.getSqlAndApiResults().get("claim_id"))))
                        .build())
                .headers(headers())
                .method(PATCH, HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> getRoomData(User user, int roomIndex) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/admin/rooms/%d".formatted(user.getRoomsList().get(roomIndex).getId()))
                        .build())
                .headers(headers())
                .GET()
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> getClaim() throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLAIMS_API))
                        .setPath("/admin/claims/%s".formatted(scenarioContext.getSqlAndApiResults().get("claim_id")))
                        .build())
                .headers(headers())
                .GET()
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> getWorklist(int claimItems) throws URISyntaxException {
        var builder = new URIBuilder()
                .setScheme(HttpScheme.HTTPS.toString())
                .setHost(hostMapping.get(CLAIMS_API))
                .setPath("admin/claims")
                .setParameter("sort", "-id")
                .setParameter("offset", "0")
                .setParameter("count", "50")
                .setParameter("id", scenarioContext.getSqlAndApiResults().get("claim_id"));
        if (claimItems == 0) {
            builder.setParameter("snoozedClaims", scenarioContext.getSqlAndApiResults().get("claim_id"));
        }
        var request = HttpRequest.newBuilder(builder.build())
                .headers(headers())
                .GET()
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> snoozeClaim() throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .put("snoozeEndDate", LocalDate.now()
                        .plusDays(2)
                        .format(DateTimeFormatter.ISO_DATE));
        requestBody.putArray("claimIDs")
                .add(Integer.parseInt(scenarioContext.getSqlAndApiResults().get("claim_id")));
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLAIMS_API))
                        .setPath("admin/worklists/snooze/%s".formatted(scenarioContext.getSqlAndApiResults().get("worklist_id")))
                        .build())
                .headers(headers())
                .method(PATCH, HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> refundInvoiceFromRoomCharges(User user, int roomIndex, int amount) throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .put("invoiceID", scenarioContext.getSqlAndApiResults().get("invoice_id"))
                .put("userID", user.getId())
                .put("roomID", user.getRoomsList().get(roomIndex).getId())
                .put("amount", amount)
                .put("reasonForRefund", "test reason")
                .put("notes", "test note");
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENTAPI_INTERNAL))
                        .setPath("/admin/room-invoices/%s/refund".formatted(scenarioContext.getSqlAndApiResults().get("invoice_id")))
                        .build())
                .headers(headers())
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(request);
    }

    private HttpResponse<String> updateMemberDataInfo(User user, ObjectNode memberDataInformation) throws URISyntaxException {
        memberDataInformation.put("id", user.getClientInsuranceInfoId())
                .put("userID", user.getId())
                .put("email", user.getEmail());
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENTAPI_INTERNAL))
                        .setPath("/admin/client-insurance-info/%d".formatted(user.getClientInsuranceInfoId()))
                        .build())
                .headers(headers())
                .method(PATCH, HttpRequest.BodyPublishers.ofString(memberDataInformation.toString()))
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> deleteWorklist() throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLAIMS_API))
                        .setPath("admin/worklists/%s".formatted(scenarioContext.getSqlAndApiResults().get("worklist_id")))
                        .build())
                .headers(headers())
                .DELETE()
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> createWorklist() throws URISyntaxException {
        var fieldsNode = objectMapper.createObjectNode()
                .put("id", scenarioContext.getSqlAndApiResults().get("claim_id"));
        var requestBody = objectMapper.createObjectNode();
        requestBody.set("fields", fieldsNode);
        requestBody.put("label", scenarioContext.getSqlAndApiResults().get("claim_id"));
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLAIMS_API))
                        .setPath("admin/worklists")
                        .build())
                .headers(headers())
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> chargeMemberManually() throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .put("status", "denied")
                .put("isTest", true)
                .put("adminChargeAmount", 24.99);
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLAIMS_API))
                        .setPath("/admin/claims/%s/charge-member".formatted(scenarioContext.getSqlAndApiResults().get("claim_id")))
                        .build())
                .headers(headers())
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> getMember(User user) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENTAPI_INTERNAL))
                        .setPath("/admin/client-insurance-info/%d".formatted(user.getClientInsuranceInfoId()))
                        .build())
                .headers(headers())
                .GET()
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> executeCron(Cron cron) {
        var request = HttpRequest.newBuilder(URI.create("https://%s.execute-api.us-east-1.amazonaws.com/prod/v1/crons/%s/execute"
                        .formatted(data.getConfiguration().getDomain().equals(Domain.CANARY.getName()) ? "igq0mdjuo5-vpce-0e243f02fcf1acde8" : "dzjxb4q80a-vpce-0975f4b4675ed94b6",
                                cron.getName())))
                .headers(headers())
                .POST(HttpRequest.BodyPublishers.noBody())
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> verifyCronStatus(Cron cron) {
        var request = HttpRequest.newBuilder(URI.create("https://%s.execute-api.us-east-1.amazonaws.com/prod/v1/cron-history?sort=created&offset=0&count=1&cronId=%s"
                        .formatted(data.getConfiguration().getDomain().equals(Domain.CANARY.getName()) ? "igq0mdjuo5-vpce-0e243f02fcf1acde8" : "dzjxb4q80a-vpce-0975f4b4675ed94b6",
                                cron.getName())))
                .headers(headers())
                .GET()
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<Path> downloadClaimFile(String claimDownloadPath) throws IOException, InterruptedException {
        var request = HttpRequest.newBuilder(URI.create(claimDownloadPath))
                .GET()
                .build();
        return client.logThenSend(request, new File(Constants.CHROME_DOWNLOAD_DIRECTORY + "/raw837URL_%s.txt".formatted(scenarioContext.getScenarioStartTime())).toPath());
    }

    public HttpResponse<Path> downloadEraFile(String eraDownloadPath) throws IOException, InterruptedException {
        var request = HttpRequest.newBuilder(URI.create(eraDownloadPath))
                .GET()
                .build();
        return client.logThenSend(request, new File(Constants.CHROME_DOWNLOAD_DIRECTORY + "/raw837URL_%s.txt".formatted(scenarioContext.getScenarioStartTime())).toPath());
    }

    public HttpResponse<String> getEraData(String eraId) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLAIMS_API))
                        .setPath("/admin/eras/%s".formatted(eraId))
                        .build())
                .headers(headers())
                .GET()
                .build();
        return client.logThenSend(request);
    }

    private HttpResponse<String> updateSessionInfo(ObjectNode claimSessionInformation) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLAIMS_API))
                        .setPath("/admin/claims-data/%s".formatted(scenarioContext.getSqlAndApiResults().get("claim_id")))
                        .build())
                .headers(headers())
                .method(PATCH, HttpRequest.BodyPublishers.ofString(claimSessionInformation.toString()))
                .build();
        return client.logThenSend(request);
    }

    private HttpResponse<String> getManualClaimDataByEraId() throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLAIMS_API))
                        .setPath("/admin/eras/claims/manual")
                        .setParameter("sort", "-id")
                        .setParameter("offset", "0")
                        .setParameter("count", "10")
                        .setParameter("eraID", scenarioContext.getSqlAndApiResults().get("era_id"))
                        .build())
                .headers(headers())
                .GET()
                .build();
        return client.logThenSend(request);
    }

    private HttpResponse<String> getClaimDataByEraId() throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLAIMS_API))
                        .setPath("/admin/eras/claims/claims-by-eraID")
                        .setParameter("sort", "-id")
                        .setParameter("offset", "0")
                        .setParameter("count", "10")
                        .setParameter("eraID", scenarioContext.getSqlAndApiResults().get("era_id"))
                        .build())
                .headers(headers())
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * @return claim data
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    private String getClaimData() throws URISyntaxException {
        var response = getClaim().log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Get claim response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        return response.body();
    }

    public HttpResponse<String> adminCharge(int amount, String claimStatus) throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .put("status", claimStatus)
                .put("isTest", true)
                .put("adminChargeAmount", amount);
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLAIMS_API))
                        .setPath("/admin/claims/%s/charge-member".formatted(scenarioContext.getSqlAndApiResults().get("claim_id")))
                        .build())
                .headers(headers())
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> runLiveCheck(ObjectNode liveCheckBody) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENTAPI_INTERNAL))
                        .setPath("/admin/eligibility/run-live-check")
                        .build())
                .headers(headers())
                .POST(HttpRequest.BodyPublishers.ofString(liveCheckBody.toString()))
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> eligibilityCheck() throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENTAPI_INTERNAL))
                        .setPath("/admin/eligibilityChecks/%s".formatted(scenarioContext.getSqlAndApiResults().get("eligibilityCheckID")))
                        .build())
                .headers(headers())
                .GET()
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> extendEapAuthCode(User user, int roomIndex) throws URISyntaxException {
        String oneYearFromToday = LocalDate.now().plusYears(1).toString();
        var requestBody = objectMapper.createObjectNode()
                .put("extendDate", oneYearFromToday)
                .put("authorizationCode", "111111-11");
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENTAPI_INTERNAL))
                        .setPath("/admin/rooms/%d/extend-auth-code".formatted(user.getRoomsList().get(roomIndex).getId()))
                        .build())
                .headers(headers())
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(request);
    }

    public HttpResponse<String> addEapCredits(String reason, User user, int roomIndex) throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .put("manualSessionReason", reason)
                .put("creditsToAdd", 1);
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENTAPI_INTERNAL))
                        .setPath("/admin/rooms/%d/create-session-report".formatted(user.getRoomsList().get(roomIndex).getId()))
                        .build())
                .headers(headers())
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(request);
    }

    /**
     * execute cron
     *
     * @param cron cron to execute
     * @see <a href="https://backoffice.dev.talkspace.com/crons">monitor cron excution direct link for dev</a>
     * @see <a href="https://backoffice.canary.talkspace.com/crons">monitor cron excution direct link for canary</a>
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3115">update executeCron method - wait for success </a>
     */
    @Given("Admin API - Execute {} cron")
    public void apiExecuteCron(Cron cron) {
        var executeCronResponse = executeCron(cron).log();
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(10));
        assertThat(executeCronResponse)
                .extracting(HttpResponse::statusCode)
                .as("Execute %s cron response".formatted(cron.getName()))
                .withFailMessage(GeneralActions.failMessage(executeCronResponse))
                .isEqualTo(HttpStatus.SC_OK);
        Awaitility
                .await()
                .alias("Verify %s cron status".formatted(cron.getName()))
                .atMost(Duration.ofMinutes(10))
                .pollInterval(Duration.ofSeconds(10))
                .failFast("Cron execution failed ", () -> {
                    var cronStatusResponse = verifyCronStatus(cron).log();
                    assertThat(cronStatusResponse)
                            .extracting(HttpResponse::statusCode)
                            .as("Verify %s cron status response".formatted(cron.getName()))
                            .withFailMessage(GeneralActions.failMessage(cronStatusResponse))
                            .isEqualTo(HttpStatus.SC_OK);
                    var cronStatus = objectMapper.readTree(cronStatusResponse.body()).get("data").get(0).get("status").asText();
                    assertThat(cronStatus)
                            .as("Cron status")
                            .isNotEqualTo("FAILURE");
                })
                .untilAsserted(() -> {
                    var cronStatusResponse = verifyCronStatus(cron).log();
                    assertThat(cronStatusResponse)
                            .extracting(HttpResponse::statusCode)
                            .as("Verify %s cron status response".formatted(cron.getName()))
                            .withFailMessage(GeneralActions.failMessage(cronStatusResponse))
                            .isEqualTo(HttpStatus.SC_OK);
                    var cronStatus = objectMapper.readTree(cronStatusResponse.body()).get("data").get(0).get("status").asText();
                    assertThat(cronStatus)
                            .as("Cron status")
                            .isEqualTo("SUCCESS");
                });
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(5));
    }

    //region worklist
    @Given("Admin API - Snooze claim")
    public void verifySnoozeClaim() {
        Awaitility
                .await()
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var response = snoozeClaim().log();
                    assertThat(response)
                            .extracting(HttpResponse::statusCode)
                            .as("Snooze claim response")
                            .withFailMessage(GeneralActions.failMessage(response))
                            .isEqualTo(HttpStatus.SC_OK);
                });
    }

    @Given("Admin API - Delete worklist")
    public void verifyDeleteWorklist() {
        Awaitility
                .await()
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var response = deleteWorklist().log();
                    assertThat(response)
                            .extracting(HttpResponse::statusCode)
                            .as("Delete worklist response")
                            .withFailMessage(GeneralActions.failMessage(response))
                            .isEqualTo(HttpStatus.SC_NO_CONTENT);
                });
    }

    @Given("Admin API - Verify worklist has {int} item(s)")
    public void verifyClaimInWorklist(int claimItems) {
        Awaitility
                .await()
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var response = getWorklist(claimItems).log();
                    assertThat(response)
                            .extracting(HttpResponse::statusCode)
                            .as("GET worklist response")
                            .withFailMessage(GeneralActions.failMessage(response))
                            .isEqualTo(HttpStatus.SC_OK);
                    if (claimItems == 0) {
                        assertThatJson(objectMapper.readTree(response.body()))
                                .as("GET worklist response")
                                .isArray()
                                .isEmpty();
                    }
                    assertThatJson(objectMapper.readTree(response.body()))
                            .as("GET worklist response")
                            .isArray()
                            .ofLength(claimItems);
                });
    }

    @Given("Client API - Create worklist")
    public void apiCreateWorklist() {
        Awaitility
                .await()
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var response = createWorklist().log();
                    assertThat(response)
                            .extracting(HttpResponse::statusCode)
                            .as("Create worklist response")
                            .withFailMessage(GeneralActions.failMessage(response))
                            .isEqualTo(HttpStatus.SC_CREATED);
                });
    }
    //endregion

    /**
     * assign claim to admin
     * <p>
     * we must have the following data in scenario context:
     * claim_id
     */
    @Given("Admin API - Assign admin to claim")
    public void apiAssignClaimToAdmin() throws URISyntaxException {
        var response = assignClaimToAdmin().log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Assign admin response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_NO_CONTENT);
    }

    /**
     * we must have the following data in scenario context:
     * era_id
     *
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @Given("Admin API - Assign manual claim to ERA")
    public void apiAssignManualClaimToEra() throws URISyntaxException {
        var response = assignManualClaimToEra().log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Assign manual claim response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_CREATED);
    }

    /**
     * we must have the following data in scenario context:
     * external_id
     *
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3067">CLAIMS - assign claim to ERA</a>
     */
    @Given("Admin API - Assign claim to ERA")
    public void apiAssignClaimToEra() throws URISyntaxException {
        var response = assignClaimToEra().log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Assign claim response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_CREATED);
    }

    /**
     * we must have the following data in scenario context:
     * era_id
     * <p>
     * there are two optional values:
     * allowed_amount - if not provided, default value is 123
     * insurance_paid - if not provided, default value is 123
     *
     * @param adjudicationStatus {@link AdjudicationStatus}
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @Given("Admin API - Assign claim with {} adjudication status to ERA")
    public void apiAssignManualClaimToEra(AdjudicationStatus adjudicationStatus) throws URISyntaxException {
        var response = assignClaimToEra(adjudicationStatus).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Assign manual claim to ERA response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_CREATED);
    }

    /**
     * add note to claim
     * <p>
     * we must have the following data in scenario context:
     * claim_id
     */
    @Given("Admin API - Add note to claim")
    public void apiAddNote() throws URISyntaxException {
        var response = addNote().log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Add note response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_NO_CONTENT);
    }

    /**
     * Update claim session information
     */
    @Given("Admin API - Update claim session information")
    public void apiAddNote(ObjectNode claimSessionInformation) throws URISyntaxException {
        var response = updateSessionInfo(claimSessionInformation).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Update claim session information response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_NO_CONTENT);
    }

    /**
     * verify claim status - dynamic fields are added to the expected claim data, all other fields are ignored
     * <p>
     * we must have the following data:
     * {@link Room#getSessionReportId()}
     */
    @Given("Admin API - Verify claim data of {user} user and {provider} provider")
    public void apiGetClaim(User user, Provider provider, ObjectNode expectedClaimData) {
        if (expectedClaimData.has("claimPayment") && expectedClaimData.get("claimPayment").has("invoicePaymentPageURL")) {
            ((ObjectNode) expectedClaimData.get("claimPayment")).put("invoicePaymentPageURL", scenarioContext.getSqlAndApiResults().get("payment_url"));
        }
        Awaitility
                .await()
                .alias("Verify claim data")
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var claimDataResponseJSON = getClaimData();
                    expectedClaimData
                            .put("sessionReportID", Integer.parseInt(user.getRoomsList().get(0).getSessionReportId()))
                            .put("memberRoomID", user.getRoomsList().get(0).getId())
                            .put("providerUserID", provider.getId());
                    assertThatJson(claimDataResponseJSON)
                            .as("Claim data")
                            .when(IGNORING_EXTRA_FIELDS)
                            .isEqualTo(expectedClaimData);
                });
    }

    /**
     * when there is a mismatch, there is no eligibilityCheckID
     *
     * @param liveCheckBody live eligibility check data
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3063">BACKOFFICE - run live eligibility check (admin)</a>
     */
    @Given("Admin API - Run live eligibility check")
    public void apiRunLiveEligibilityCheck(ObjectNode liveCheckBody) throws URISyntaxException {
        var response = runLiveCheck(liveCheckBody).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Live eligibility check response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isIn(HttpStatus.SC_OK, HttpStatus.SC_BAD_REQUEST);
        Try.run(() -> scenarioContext.getSqlAndApiResults().put("eligibilityCheckID", objectMapper.readTree(response.body()).get("data").get("eligibilityCheckID").asText()));
        scenarioContext.getSqlAndApiResults().put("live_eligibility_check_response", response.body());
    }

    /**
     * @param liveCheckBody live eligibility check data
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3095">run live eligibility - user’s details don’t match</a>
     */
    @Given("Admin API - Verify live eligibility check response")
    public void verifyLiveEligibilityCheckResponse(ObjectNode liveCheckBody) throws JsonProcessingException {
        assertThatJson(objectMapper.readTree(scenarioContext.getSqlAndApiResults().get("live_eligibility_check_response")))
                .as("Eligibility check data")
                .when(IGNORING_EXTRA_FIELDS)
                .isEqualTo(liveCheckBody);
    }

    /**
     * verify eligibility check
     * <p>
     * we must have the following data in scenario context:
     * eligibilityCheckID
     *
     * @param expectedBody expected eligibility check data
     * @throws URISyntaxException      if a string could not be parsed as a URI reference
     * @throws JsonProcessingException if a string could not be parsed as a URI reference
     */
    @Given("Admin API - Verify ineligible member in check response")
    public void apiVerify(ObjectNode expectedBody) throws URISyntaxException, JsonProcessingException {
        var response = eligibilityCheck().log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Eligibility check response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        assertThatJson(objectMapper.readTree(response.body()))
                .as("Eligibility check data")
                .when(IGNORING_EXTRA_FIELDS)
                .isEqualTo(expectedBody);
    }

    /**
     * verify eligibility check
     * <p>
     * we must have the following data in scenario context:
     * insurance_eligibility_id
     * user_id
     * room_id
     *
     * @param expectedBody expected eligibility check data
     * @throws URISyntaxException      if a string could not be parsed as a URI reference
     * @throws JsonProcessingException if a string could not be parsed as a URI reference
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3094">Admin API - Verify Eligibility check:  - support user/room/request ids on response verification</a>
     */
    @Given("Admin API - Verify eligible member in check response")
    public void apiVerifyEligible(ObjectNode expectedBody) throws URISyntaxException, JsonProcessingException {
        expectedBody.put("id", Integer.parseInt(scenarioContext.getSqlAndApiResults().get("insurance_eligibility_id")))
                .put("userID", Integer.parseInt(scenarioContext.getSqlAndApiResults().get("user_id")))
                .put("roomID", Integer.parseInt(scenarioContext.getSqlAndApiResults().get("room_id")));
        apiVerify(expectedBody);
    }

    /**
     * @param user      user
     * @param roomIndex room index
     * @param reason    reason for adding EAP credits
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3105">create-session-report API (admin)</a>
     */
    @Given("Admin API - Add EAP credit with reason: {string} for {user} user in the {optionIndex} room")
    public void addCredits(String reason, User user, int roomIndex) throws URISyntaxException {
        var response = addEapCredits(reason, user, roomIndex).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("eap credit response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_NO_CONTENT);
    }

    /**
     * verify room data
     */
    @Given("Admin API - Verify room data of {user} user in the {optionIndex} room")
    public void apiVerifyRoomData(User user, int roomIndex, ObjectNode expectedRoomData) {
        Awaitility
                .await()
                .alias("Verify room data")
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var claimDataResponseJSON = getRoomData(user, roomIndex).log();
                    assertThatJson(claimDataResponseJSON)
                            .as("Room data")
                            .when(IGNORING_EXTRA_FIELDS)
                            .isEqualTo(expectedRoomData);
                });
    }

    /**
     * we must have the following data in scenario context:
     * claim_id
     *
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @Given("Admin API - Charge member manually")
    public void apiChargeMemberManually() throws URISyntaxException {
        var response = chargeMemberManually().log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Charge member manually response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_NO_CONTENT);
    }

    @Given("Admin API - Verify claim is assigned to backoffice admin user")
    public void verifyClaimAssigneeUserId() {
        Awaitility
                .await()
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var claimDataResponseJSON = getClaimData();
                    assertThatJson(claimDataResponseJSON)
                            .as("Claim data")
                            .when(IGNORING_EXTRA_FIELDS)
                            .isEqualTo(objectMapper.createObjectNode()
                                    .put("assigneeUserID", data.getConfiguration().getAdmin().get(data.getConfiguration().getDomain())));
                });
    }

    @Given("Admin API - Verify claim data by eraID")
    public void verifyClaimDataByEraId(ObjectNode expectedClaimData) {
        Awaitility
                .await()
                .alias("Verify claim data")
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var claimDataResponse = getClaimDataByEraId().log();
                    assertThat(claimDataResponse)
                            .extracting(HttpResponse::statusCode)
                            .as("Get claim data by eraID")
                            .withFailMessage(GeneralActions.failMessage(claimDataResponse))
                            .isEqualTo(HttpStatus.SC_OK);
                    var claimDataResponseJSON = objectMapper.readTree(claimDataResponse.body());
                    assertThatJson(claimDataResponseJSON)
                            .as("Claim data")
                            .when(IGNORING_EXTRA_FIELDS)
                            .isEqualTo(expectedClaimData);
                });
    }

    @Given("Admin API - Verify manual claim Data by eraID")
    public void verifyManualClaimDataByEraId(ObjectNode expectedClaimData) {
        Awaitility
                .await()
                .alias("Verify claim data")
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var claimDataResponse = getManualClaimDataByEraId().log();
                    assertThat(claimDataResponse)
                            .extracting(HttpResponse::statusCode)
                            .as("Get manual claim data by eraID")
                            .withFailMessage(GeneralActions.failMessage(claimDataResponse))
                            .isEqualTo(HttpStatus.SC_OK);
                    var claimDataResponseJSON = objectMapper.readTree(claimDataResponse.body());
                    assertThatJson(claimDataResponseJSON)
                            .as("Claim data")
                            .when(IGNORING_EXTRA_FIELDS)
                            .isEqualTo(expectedClaimData);
                });
    }

    @Given("Admin API - Verify note is added to claim")
    public void verifyNoteAddedToClaim() {
        Awaitility
                .await()
                .alias("Verify claim data")
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var claimDataResponseJSON = getClaimData();
                    assertThatJson(claimDataResponseJSON)
                            .as("Claim data")
                            .when(IGNORING_EXTRA_FIELDS)
                            .isEqualTo(objectMapper.createObjectNode()
                                    .put("notes", scenarioContext.getNote()));
                });
    }

    /**
     * Download and verify claim data contains some content
     */
    @Given("Admin API - Verify {string} claim file contains")
    public void verifyX12Claim(String fileKind, List<String> x12Content) {
        Awaitility
                .await()
                .alias("Verify claim data")
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var claimDownloadPath = objectMapper.readTree(getClaimData()).get(fileKind).asText();
                    var claimFile = downloadClaimFile(claimDownloadPath).body().toFile();
                    SoftAssertions.assertSoftly(softAssertions -> x12Content.forEach(content -> softAssertions.assertThat(claimFile).content().as("X12 claim file content").contains(content)));
                });
    }

    /**
     * Download and verify claim data does not contain some content
     */
    @Given("Admin API - Verify {string} claim file does not contain")
    public void verifyX12ClaimDoesNotContains(String fileKind, List<String> x12Content) {
        Awaitility
                .await()
                .alias("Verify claim data")
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var claimDownloadPath = objectMapper.readTree(getClaimData()).get(fileKind).asText();
                    var claimFile = downloadClaimFile(claimDownloadPath).body().toFile();
                    SoftAssertions.assertSoftly(softAssertions -> x12Content.forEach(content -> softAssertions.assertThat(claimFile).content().as("X12 claim file content").doesNotContain(content)));
                });
    }

    /**
     * Download and verify era data
     */
    @Given("Admin API - Verify ERA file")
    public void verifyX12Era(List<String> x12Content) throws IOException, URISyntaxException, InterruptedException {
        var eraId = objectMapper.readTree(getClaimData()).get("claimPayment").get("eraID").asText();
        var response = getEraData(eraId).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Get ERA response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        var responseJSON = objectMapper.readTree(response.body());
        var eraPath = responseJSON.get("raw835URL").asText();
        var eraFile = downloadEraFile(eraPath).body().toFile();
        SoftAssertions.assertSoftly(softAssertions -> x12Content.forEach(content -> softAssertions.assertThat(eraFile).content().as("X12 ERA file content").contains(GeneralActions.replacePlaceholders(content, scenarioContext))));
    }

    /**
     * perform claim action - need to refresh claim status from API before performing action
     * <p>
     * we must have the following data in scenario context:
     * claim_id
     */
    @Given("Admin API - {} the claim")
    public void apiSubmitClaim(ClaimActions claimActions) throws URISyntaxException, JsonProcessingException {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(5));
        var claimStatus = objectMapper.readTree(getClaimData()).get("status").asText();
        var response = performClaimAction(claimActions, claimStatus).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("{} claim response", claimActions.getAction())
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
    }

    /**
     * perform charge action - need to refresh claim status from API before performing action
     */
    @Given("Admin API - Submit a charge of {int} dollars")
    public void apiSubmitClaim(int amount) {
        Awaitility
                .await()
                .alias("Verify claim data")
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var claimStatus = objectMapper.readTree(getClaimData()).get("status").asText();
                    var response = adminCharge(amount, claimStatus).log();
                    assertThat(response)
                            .extracting(HttpResponse::statusCode)
                            .as("Admin submit charge response")
                            .withFailMessage(GeneralActions.failMessage(response))
                            .isEqualTo(HttpStatus.SC_NO_CONTENT);
                });
    }

    /**
     * we must have the following data in scenario context:
     * invoice_id
     *
     * @param user      the  {@link User}
     * @param roomIndex the room index in a room list.
     * @param amount    the amount to refund
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @Given("Admin API - Refund invoice of {user} user in the {optionIndex} room for {int} dollars")
    public void apiRefundInvoiceFromRoomCharges(User user, int roomIndex, int amount) throws URISyntaxException {
        var response = refundInvoiceFromRoomCharges(user, roomIndex, amount).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Refund invoice from room charge response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_NO_CONTENT);
    }

    @Given("Admin API - Extend EAP auth code for {user} user in the {optionIndex} room")
    public void addCredits(User user, int roomIndex) throws URISyntaxException {
        var response = extendEapAuthCode(user, roomIndex).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Extend auth code response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_NO_CONTENT);
    }

    /**
     * we must have the following data in scenario context:
     * {@link User#getClientInsuranceInfoId()}
     *
     * @param user               the  {@link User}
     * @param expectedMemberData expected member data
     * @throws URISyntaxException      if a string could not be parsed as a URI reference
     * @throws JsonProcessingException if a string could not be parsed as a URI reference
     */
    @Given("Admin API - Verify member data by client insurance information id for {user} user")
    public void getMemberData(User user, ObjectNode expectedMemberData) throws URISyntaxException, JsonProcessingException {
        expectedMemberData.put("id", user.getClientInsuranceInfoId())
                .put("userID", user.getId())
                .put("email", user.getEmail());
        var response = getMember(user).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Get member data response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        assertThatJson(objectMapper.readTree(response.body()))
                .as("Member data")
                .when(IGNORING_EXTRA_FIELDS)
                .isEqualTo(expectedMemberData);
    }

    /**
     * we must have the following data in scenario context:
     * {@link User#getClientInsuranceInfoId()}
     *
     * @param user                  the  {@link User}
     * @param memberDataInformation member data information
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @Given("Admin API - Update member data for {user} user")
    public void updateMemberData(User user, ObjectNode memberDataInformation) throws URISyntaxException {
        var response = updateMemberDataInfo(user, memberDataInformation).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Update member data information response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_NO_CONTENT);
    }
}
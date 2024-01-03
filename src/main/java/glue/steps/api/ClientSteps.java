package glue.steps.api;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.google.inject.Inject;
import common.glue.utilities.Constants;
import common.glue.utilities.GeneralActions;
import dev.failsafe.Failsafe;
import dev.failsafe.RetryPolicy;
import di.providers.ScenarioContext;
import entity.*;
import enums.*;
import enums.data.AuthCode;
import enums.data.BhMemberIDType;
import enums.data.RoomStatus;
import enums.feature_flag.PrivateFeatureFlagType;
import enums.feature_flag.PublicFeatureFlagType;
import extensions.ClientExtension;
import extensions.ResponseExtension;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.netty.handler.codec.http.HttpScheme;
import lombok.experimental.ExtensionMethod;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.hc.core5.http.HttpStatus;
import org.apache.hc.core5.http.message.BasicNameValuePair;
import org.apache.hc.core5.net.URIBuilder;
import org.assertj.core.api.Assumptions;
import org.awaitility.Awaitility;

import javax.annotation.Nullable;
import java.io.IOException;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.util.*;

import static com.google.common.net.HttpHeaders.*;
import static enums.HostsMapping.*;
import static enums.data.RoomStatus.*;
import static javax.ws.rs.HttpMethod.PATCH;
import static javax.ws.rs.core.MediaType.APPLICATION_JSON;
import static javax.ws.rs.core.MediaType.WILDCARD;
import static org.apache.hc.client5.http.auth.StandardAuthScheme.BASIC;
import static org.assertj.core.api.Assertions.assertThat;

/**
 * User: nirtal
 * Date: 22/06/2021
 * Time: 22:39
 * Created with IntelliJ IDEA
 * <p>
 * Client calls.
 *
 * @see <a href="https://stackoverflow.com/a/19540066/4515129">URI builder</a>
 */
@ExtensionMethod({ClientExtension.class, ResponseExtension.class})
public class ClientSteps {

    @Inject
    private HttpClient client;
    @Inject
    private Data data;
    @Inject
    private EnumMap<HostsMapping, String> hostMapping;
    @Inject
    private ObjectMapper objectMapper;
    @Inject
    private ScenarioContext scenarioContext;

    private String[] headers(User user) {
        return new String[]{ACCEPT, WILDCARD,
                CONTENT_TYPE, APPLICATION_JSON,
                USER_AGENT, Constants.AUTOMATION_USER_AGENT,
                AUTHORIZATION, "Bearer".concat(StringUtils.SPACE).concat(user.getLoginToken())};
    }

    /**
     * @param user       the user that will subscribe to the plan
     * @param roomIndex  the index of the room in the rooms list
     * @param offerId    the offerID that includes the plan we want to subscribe to
     * @param planId     the PlanID of the plan we are subscribing to
     * @param creditCard the {@link CreditCard} to purchase with
     * @return HTTP response
     */
    public HttpResponse<String> subscribeToPlan(User user, int roomIndex, int offerId, int planId, CreditCard creditCard) throws URISyntaxException {
        Assumptions.assumeThat(data.getConfiguration().getDomain())
                .withFailMessage("Unable to run this step because credit card token is not available on prod")
                .isNotEqualTo(Domain.PROD.getName());
        var requestBody = objectMapper.createObjectNode()
                .put("offerID", offerId)
                .put("cardToken", creditCard.token());
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v2/payments/rooms/%s/plan/%s/subscribe".formatted(user.getRoomsList().get(roomIndex).getId(), planId))
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * Creates a new DTE room with random therapist for the user.
     * Uses {@link #getAccessToken(String)} and {@link #getB2BAccessCodeByKeyword(User, Map)}
     * <p>
     *
     * @param provider the {@link Provider} to register the user with
     * @param user     the {@link User} user that will register to the room
     * @param flowData the data that will be used to create the room
     * @return HTTP response.
     */
    public HttpResponse<String> createDteRoom(User user, Provider provider, Map<String, String> flowData) throws
            IOException, URISyntaxException {
        var getAccessTokenResponse = getAccessToken(flowData.get("flowId")).log();
        user.setLoginToken(objectMapper.readTree(getAccessTokenResponse.body()).at("/data/accessToken").asText());
        var accessCodeResponse = getB2BAccessCodeByKeyword(user, flowData).log();
        var googleAccessCode = objectMapper.readTree(accessCodeResponse.body()).at("/data/accessCode").asText();
        var registrationUrl = GeneralActions.isRunningOnProd()
                ? String.format("https://match.talkspace.com/flow/2/step/19?qmPartnerCode=%s&redirectFrom=11&clientAge=1999-11-22", googleAccessCode)
                : String.format("https://match.%s.talkspace.com/flow/2/step/19?qmPartnerCode=%s&redirectFrom=11&clientAge=1999-11-22", data.getConfiguration().getDomain(), googleAccessCode);
        var requestBody = objectMapper.createObjectNode()
                .putPOJO("attribution", Map.of(
                        "registrationUrl", registrationUrl
                ))
                .put("clientDateOfBirth", GeneralActions.generateApiDate(0, 0, Integer.parseInt(flowData.get("age"))))
                .put("email", user.getEmail())
                .put("funnelVariation", "customer_selected")
                .put("gender", 1)
                .put("nickname", user.getNickName())
                .putPOJO("presentingProblems", objectMapper.createArrayNode()
                        .add(objectMapper.createObjectNode()
                                .put("id", 3)
                                .put("name", "I'm feeling anxious or panicky")))
                .putPOJO("quickmatchResponses", objectMapper.createArrayNode()
                        .add(buildQuickmatchResponse(null, 54, "To begin, please select why you thought about getting help from a provider", 2,
                                "I'm feeling anxious or panicky", "3", objectMapper.createObjectNode()
                                        .put("field", "fieldsOfExpertise")
                                        .putPOJO("value", List.of(25))))
                        .add(buildQuickmatchResponse(null, 57, "Would you prefer a provider that is...", 3,
                                "I'm not sure yet", null, objectMapper.createObjectNode()
                                        .put("field", "therapistGender")
                                        .put("value", "any")))
                        .add(buildQuickmatchResponse(null, 58, "Have you been to a provider before?", 7,
                                "No", "No", null))
                        .add(buildQuickmatchResponse(null, 59, "How would you rate your sleeping habits?", 7,
                                "Fair", "Fair", null))
                        .add(buildQuickmatchResponse(null, 60, "How would you rate your current physical health?", 7,
                                "Good", "Good", null))
                        .add(buildQuickmatchResponse(null, 62, "Please select your gender.", 4,
                                "Male", "1", null))
                        .add(buildQuickmatchResponse(true, 63, "Please select your state of residence.", 6,
                                Us_States.valueOf(flowData.get("state")).getName(), Us_States.valueOf(flowData.get("state")).getAbbreviation(), null)))
                .put("roomType", ServiceType.THERAPY.getType())
                .put("timezone", "America/New_York")
                .put("voucherCode", googleAccessCode)
                .put("password", user.getPassword());
        if (flowData.containsKey("isPendingMatch")) {
            requestBody.put("isPendingMatch", true)
                    .put("therapistId", 0);
        } else {
            requestBody.put("therapistId", provider.getId());
        }
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(MATCH_API))
                        .setPath("/api/v3/registerWithVoucher")
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * Creates a new EAP room with random therapist for the user.
     * Uses {@link #getAccessToken(String)} and {@link #getB2BAccessCodeByKeyword(User, Map)}
     * <p>
     *
     * @param user     the {@link User} user that will register to the room
     * @param flowData the data that will be used to create the room
     * @return HTTP response.
     */
    public HttpResponse<String> createEapRoom(User user, Provider provider, Map<String, String> flowData) throws
            IOException, URISyntaxException {
        var getAccessTokenResponse = getAccessToken(flowData.get("flowId")).log();
        user.setLoginToken(objectMapper.readTree(getAccessTokenResponse.body()).at("/data/accessToken").asText());
        var accessCodeResponse = getB2BAccessCodeByKeyword(user, flowData).log();
        var eapAccessCode = objectMapper.readTree(accessCodeResponse.body()).at("/data/accessCode").asText();
        var registrationUrl = GeneralActions.isRunningOnProd()
                ? String.format("https://match.talkspace.com/flow/2/step/19?qmPartnerCode=%s&redirectFrom=11&clientAge=1999-11-22", eapAccessCode)
                : String.format("https://match.%s.talkspace.com/flow/2/step/19?qmPartnerCode=%s&redirectFrom=11&clientAge=1999-11-22", data.getConfiguration().getDomain(), eapAccessCode);
        var requestBody = objectMapper.createObjectNode()
                .putPOJO("attribution", Map.of(
                        "registrationUrl", registrationUrl
                ))
                .put("clientDateOfBirth", GeneralActions.generateApiDate(0, 0, Integer.parseInt(flowData.get("age"))))
                .put("email", user.getEmail())
                .put("funnelVariation", "customer_selected")
                .put("gender", 1)
                .put("nickname", user.getNickName())
                .putPOJO("presentingProblems", objectMapper.createArrayNode()
                        .add(objectMapper.createObjectNode()
                                .put("id", 3)
                                .put("name", "I'm feeling anxious or panicky")))
                .putPOJO("quickmatchResponses", objectMapper.createArrayNode()
                        .add(buildQuickmatchResponse(null, 54, "To begin, please select why you thought about getting help from a provider", 2,
                                "I'm feeling anxious or panicky", "3", objectMapper.createObjectNode()
                                        .put("field", "fieldsOfExpertise")
                                        .putPOJO("value", List.of(25))))
                        .add(buildQuickmatchResponse(null, 57, "Would you prefer a provider that is...", 3,
                                "I'm not sure yet", null, objectMapper.createObjectNode()
                                        .put("field", "therapistGender")
                                        .put("value", "any")))
                        .add(buildQuickmatchResponse(null, 58, "Have you been to a provider before?", 7,
                                "No", "No", null))
                        .add(buildQuickmatchResponse(null, 59, "How would you rate your sleeping habits?", 7,
                                "Fair", "Fair", null))
                        .add(buildQuickmatchResponse(null, 60, "How would you rate your current physical health?", 7,
                                "Good", "Good", null))
                        .add(buildQuickmatchResponse(null, 62, "Please select your gender.", 4,
                                "Male", "1", null))
                        .add(buildQuickmatchResponse(true, 63, "Please select your state of residence.", 6,
                                Us_States.valueOf(flowData.get("state")).getName(), Us_States.valueOf(flowData.get("state")).getAbbreviation(), null)))
                .put("roomType", ServiceType.THERAPY.getType())
                .put("therapistId", provider.getId())
                .put("timezone", "America/New_York")
                .put("voucherCode", eapAccessCode)
                .put("password", user.getPassword());
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(MATCH_API))
                        .setPath("/api/v3/registerWithVoucher")
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * Cancels a booked session in the room for the specified user
     *
     * @param user   the {@link User} user we want cancel the session for
     * @param roomId the roomId of the room we want to cancel the session for
     * @return HTTP response
     */
    public HttpResponse<String> cancelBookingForRoomId(User user, int roomId, String bookingId) throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .put("action", "cancel")
                .put("shouldRedeemCredit", false)
                .put("reason", "providerNotAvailableProvider");
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v4/rooms/%d/bookings/%s".formatted(roomId, bookingId))
                        .build())
                .headers(headers(user))
                .method(PATCH, HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * Sends API request to /keywordMetadata and returns the response containing the access code
     *
     * @param user     the user that will receive the access code.
     * @param flowData the data that will be used to create the room
     * @return HTTP response.
     */
    private HttpResponse<String> getB2BAccessCodeByKeyword(User user, Map<String, String> flowData) throws
            URISyntaxException {
        var map = objectMapper.createObjectNode()
                .put("firstName", user.getFirstName())
                .put("lastName", user.getLastName())
                .put("dateOfBirth", GeneralActions.generateApiDate(0, 0, Integer.parseInt(flowData.get("age"))))
                .put("phone", user.getPhoneNumber())
                .put("employeeRelationship", EmployeeRelation.valueOf(flowData.get("employee Relation")).getValue())
                .put("heardAbout", data.getUserDetails().getReferral())
                .put("address", "222")
                .put("addressStreet", user.getAddress().getHomeAddress())
                .put("city", user.getAddress().getCity())
                .put("country", user.getAddress().name())
                .put("state", Us_States.valueOf(flowData.get("state")).getAbbreviation())
                .put("zipcode", user.getAddress().getZipCode());
        switch (flowData.get("keyword")) {
            //region DTE
            case "google", "manh" -> map.put("employeeId", data.getUserDetails().getEmployeeId())
                    .put("authorizationCode", StringUtils.EMPTY);
            //endregion
            //region EAP - organization keyword
            case "humanatest1", "nottinghamhealthandrehabilitation", "alternativeseaptestkeyword", "icuba" -> map.put(
                    "authorizationCode", StringUtils.EMPTY);
            //endregion
            //region EAP - authorization code
            case "optumwellbeingprogram16" -> map.put(
                            "authorizationCode", AuthCode.MOCK_OPTUM.getCode())
                    .put("numberOfSessions", "16")
                    .put("employeeId", StringUtils.EMPTY)
                    .put("groupId", StringUtils.EMPTY);
            //endregion
            //region BH
            case "premerabhmanualpsychiatrytest" -> map.put(
                            "memberId", BhMemberIDType.valueOf(flowData.get("Member ID")).getMemberID())
                    .put("employeeId", StringUtils.EMPTY);
            case "premerabh", "premerabhpsychiatry", "aetnabhtherapyvideoonly", "allegiancebhwithvideo" -> map.put(
                    "memberId", BhMemberIDType.valueOf(flowData.get("Member ID")).getMemberID());
            //endregion
            default -> throw new IllegalStateException("Unexpected keyword: " + flowData.get("keyword"));
        }
        var requestBody = objectMapper.createObjectNode()
                .put("keyword", flowData.get("keyword"))
                .put("email", user.getEmail())
                .put("flowId", Integer.parseInt(flowData.get("flowId")))
                .putPOJO("metadata", map);
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(MATCH_API))
                        .setPath("/api/v3/accessCodeBy/keywordMetadata")
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * Gets the registering visitor's JWT to authenticate when completing the registration.
     * Used in {@link #createDteRoom(User, Provider, Map)} , {@link #createEapRoom(User, Provider, Map)}
     *
     * @param flowId the related quickmatch flow
     * @return HTTP response.
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    private HttpResponse<String> getAccessToken(String flowId) throws URISyntaxException {
        var requestBody = objectMapper
                .createObjectNode()
                .putPOJO("attrLandingPage",
                        Map.of(
                                "roomType", ServiceType.THERAPY.getType(),
                                "funnelVariation", "direct",
                                "registrationUrl", GeneralActions.isRunningOnProd() ? "https://match.talkspace.com/flow/%s/step/1".formatted(flowId) : "https://match.%s.talkspace.com/flow/%s/step/1".formatted(data.getConfiguration().getDomain(), flowId),
                                "referrerUrl", StringUtils.EMPTY
                        ))
                .putPOJO("attrMP", Map.of(
                        "distinctID", scenarioContext.getScenarioStartTime().toString()));
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(MATCH_API))
                        .setPath("/api/v4/session/auth")
                        .build())
                .headers(ACCEPT, WILDCARD,
                        USER_AGENT, Constants.AUTOMATION_USER_AGENT,
                        CONTENT_TYPE, APPLICATION_JSON)
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * Gets an array of the client's payments/charges that are eligible for a refund.
     * In order for a refund to be applied, one of the JSONObjects in the returned JSONArray needs to be sent as the API request payload to /v2/payments/refund.
     * Used in {@link #refundCharge(User)}
     *
     * @param user the {@link User} that might be eligible for a refund.
     * @return HTTP response.
     */
    public HttpResponse<String> getRefundableCharges(User user) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v2/payments/refundable-charges")
                        .build())
                .headers(headers(user))
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * Gets insurance providers payers.
     *
     * @return HTTP response.
     */
    public HttpResponse<String> getPayers(User user) throws IOException, URISyntaxException {
        var getAccessTokenResponse = getAccessToken("90").log();
        user.setLoginToken(objectMapper.readTree(getAccessTokenResponse.body()).at("/data/accessToken").asText());
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(MATCH_API))
                        .setPath("/api/v3/insurance-payers")
                        .build())
                .headers(headers(user))
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * Gets details about a user's subscription in the specified roomId.
     *
     * @param user   the user that has subscription information
     * @param roomId the roomId of the subscription
     * @return HTTP response
     * @see <a href="https://therapistapi.dev.talkspace.com/api-docs/#/Subscriptions/get_v2_clients__clientUserID__subscriptions">API documentation</a>
     */
    public HttpResponse<String> getSubscriptionInformation(User user, int roomId) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v2/clients/%s/subscriptions".formatted(user.getId()))
                        .setParameter("roomID", String.valueOf(roomId))
                        .build())
                .headers(headers(user))
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * Gets all user rooms.
     * Timing out after 20 seconds to avoid waiting for too long
     *
     * @param user the {@link User} that have all the rooms.
     * @return HTTP response
     */
    public HttpResponse<String> getRooms(User user) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v2/clients/%s/rooms".formatted(user.getId()))
                        .setParameter("include", "therapistInfo")
                        .build())
                .timeout(Duration.ofSeconds(20))
                .headers(headers(user))
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * Applies a refund for the first charge of the user returned by {@link #getRefundableCharges(User)}
     * Once a client's subscription charge is refunded, the room is instantly cancelled, thus enabling us to trigger the reactivation flow.
     *
     * @param user the {@link User} that get a refund.
     * @return HTTP response.
     */
    public HttpResponse<String> refundCharge(User user) throws IOException, URISyntaxException {
        var response = getRefundableCharges(user).log();
        var requestBody = objectMapper.readTree(response.body()).get("data").get(0);
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v2/payments/refund")
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody.deepCopy(), request);
    }

    /**
     * Switches a client's existing room to the specified therapist.
     * Must call {@link #loginWithClient(User)} first to get bearer in a scenario
     *
     * @param user      the {@link User} user that wants to switch therapist.
     * @param provider  the {@link Provider} we want to switch the room to
     * @param roomIndex the index of the room in the rooms list
     * @return HTTP response.
     */
    public HttpResponse<String> switchTherapist(int roomIndex, Provider provider, User user) throws URISyntaxException {
        var requestBody = objectMapper
                .createObjectNode()
                .put("consentSigned", true)
                .put("shareHistory", true);
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v2/rooms/%d/select-therapist/%s".formatted(user.getRoomsList().get(roomIndex).getId(), provider.getId()))
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * we are not setting the password in the request body because it is not possible via the UI
     * (isPendingMatch = true, and 0 for providerId)
     * Creates a new room with a new BH psychiatry client.
     * <p>
     * Uses {@link #getAccessToken(String)} and {@link #getB2BAccessCodeByKeyword(User, Map)}
     *
     * @param user       the {@link User} user whose room will be created.
     * @param creditCard the {@link CreditCard} to purchase with
     * @param flowData   the data that will be used to create the room.
     * @return HTTP response
     */
    public HttpResponse<String> createBhPsychiatryRoom(User user, CreditCard creditCard, Map<String, String> flowData) throws
            IOException, URISyntaxException {
        Assumptions.assumeThat(data.getConfiguration().getDomain())
                .withFailMessage("Unable to run this step because credit card token is not available on prod")
                .isNotEqualTo("prod");
        var getAccessTokenResponse = getAccessToken(flowData.get("flowId")).log();
        user.setLoginToken(objectMapper.readTree(getAccessTokenResponse.body()).at("/data/accessToken").asText());
        var getAccessCodeResponse = getB2BAccessCodeByKeyword(user, flowData).log();
        var premeraAccessCode = objectMapper.readTree(getAccessCodeResponse.body())
                .at("/data/accessCode")
                .asText();
        var verifyMemberResponse = verifyMember(user, "premeraWashington", "psychiatry", GeneralActions.generateApiDate(0, 0, Integer.parseInt(flowData.get("age"))), flowData).log();
        assertThat(verifyMemberResponse)
                .extracting(HttpResponse::statusCode)
                .as("verify member response")
                .withFailMessage(GeneralActions.failMessage(verifyMemberResponse))
                .isEqualTo(HttpStatus.SC_OK);
        var insuranceCode = objectMapper.readTree(verifyMemberResponse.body()).get("data").get("insuranceCode").asText();
        var trizettoRequestId = objectMapper.readTree(verifyMemberResponse.body()).get("data").get("trizettoRequestId").asInt();
        var registrationUrl = String.format("https://match.%s.talkspace.com/flow/7/step/20?redirectFrom=28&cpPartnerCode=%s&serviceType=psychiatry&clientAge=1999-11-22&tr=227933&insuranceCode=%s&accountType=bh", data.getConfiguration().getDomain(), premeraAccessCode, insuranceCode);
        var requestBody = objectMapper.createObjectNode()
                .putPOJO("attribution", Map.of(
                        "registrationUrl", registrationUrl,
                        "referrerUrl", registrationUrl
                ))
                .put("clientDateOfBirth", GeneralActions.generateApiDate(0, 0, Integer.parseInt(flowData.get("age"))))
                .put("email", user.getEmail())
                .put("funnelVariation", "psychiatry_quickmatch")
                .put("insuranceCode", insuranceCode)
                .putPOJO("presentingProblems", objectMapper.createArrayNode().add(objectMapper.createObjectNode()
                        .put("id", 3)
                        .put("name", "I'm feeling anxious or panicky")))
                .putPOJO("quickmatchResponses", objectMapper.createArrayNode()
                        .add(buildQuickmatchResponse(null, 54, "To begin, please select why you thought about getting help from a provider", 2,
                                "Anxiety", "3", objectMapper.createObjectNode()
                                        .put("field", "fieldsOfExpertise")
                                        .putPOJO("value", List.of(25))))
                        .add(buildQuickmatchResponse(true, 63, "Please select your state of residence.", 6,
                                Us_States.valueOf(flowData.get("state")).getName(), Us_States.valueOf(flowData.get("state")).getAbbreviation(), null)))
                .put("roomType", ServiceType.PSYCHIATRY.getType())
                .put("therapistId", 0)
                .put("isPendingMatch", true)
                .put("timezone", "America/New_York")
                .put("tokenizedCreditCard", creditCard.token())
                .put("trizettoRequest", trizettoRequestId)
                .put("voucherCode", premeraAccessCode);
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(MATCH_API))
                        .setPath("/api/v3/registerWithCopay")
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * Creates a new room with a new BH psychiatry client.
     * Uses {@link #getAccessToken(String)} and {@link #getB2BAccessCodeByKeyword(User, Map)}
     *
     * @param user     the {@link User} user whose room will be created.
     * @param provider the {@link Provider} in the room
     * @param flowData the data that will be used to create the room.
     * @return HTTP response
     */
    public HttpResponse<String> createManualBhPsychiatryRoom(User user, Provider provider, Map<String, String> flowData) throws
            IOException, URISyntaxException {
        var getAccessTokenResponse = getAccessToken(String.valueOf(flowData.get("flowId"))).log();
        user.setLoginToken(objectMapper.readTree(getAccessTokenResponse.body()).at("/data/accessToken").asText());
        var getAccessCodeResponse = getB2BAccessCodeByKeyword(user, flowData).log();
        var premeraAccessCode = objectMapper.readTree(getAccessCodeResponse.body())
                .at("/data/accessCode")
                .asText();
        var registrationUrl = GeneralActions.isRunningOnProd()
                ? String.format("https://match.talkspace.com/flow/2/step/19?redirectFrom=25&qmPartnerCode=%s&serviceType=psychiatry&clientAge=1999-11-22", premeraAccessCode)
                : String.format("https://match.%s.talkspace.com/flow/2/step/19?redirectFrom=25&qmPartnerCode=%s&serviceType=psychiatry&clientAge=1999-11-22", data.getConfiguration().getDomain(), premeraAccessCode);
        var requestBody = objectMapper.createObjectNode()
                .putPOJO("attribution", Map.of(
                        "registrationUrl", registrationUrl
                ))
                .put("clientDateOfBirth", GeneralActions.generateApiDate(0, 0, Integer.parseInt(flowData.get("age"))))
                .put("email", user.getEmail())
                .put("funnelVariation", "psychiatry_quickmatch")
                .put("gender", 1)
                .put("nickname", user.getNickName())
                .putPOJO("presentingProblems", objectMapper.createArrayNode().add(objectMapper.createObjectNode()
                        .put("id", 3)
                        .put("name", "I'm feeling anxious or panicky")))
                .putPOJO("quickmatchResponses", objectMapper.createArrayNode()
                        .add(buildQuickmatchResponse(null, 54, "To begin, please select why you thought about getting help from a provider", 2,
                                "Anxiety", "3", objectMapper.createObjectNode()
                                        .put("field", "fieldsOfExpertise")
                                        .putPOJO("value", List.of(25))))
                        .add(buildQuickmatchResponse(true, 63, "Please select your state of residence.", 6,
                                Us_States.valueOf(flowData.get("state")).getName(), Us_States.valueOf(flowData.get("state")).getAbbreviation(), null)))
                .put("registerUrl", registrationUrl)
                .put("roomType", ServiceType.PSYCHIATRY.getType())
                .put("therapistId", provider.getId())
                .put("timezone", "America/New_York")
                .put("voucherCode", premeraAccessCode)
                .put("password", user.getPassword());
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(MATCH_API))
                        .setPath("/api/v3/registerWithVoucher")
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * Creates a new room with a new BH therapy client.
     * Uses {@link #getAccessToken(String)} and {@link #getB2BAccessCodeByKeyword(User, Map)}
     *
     * @param user       the user whose room will be created.
     * @param provider   the {@link Provider} in the room
     * @param creditCard the {@link CreditCard} to purchase with
     * @param flowData   the data that will be used to create the room.
     * @return HTTP response
     */
    public HttpResponse<String> createBhTherapyRoom(User user, Provider provider, CreditCard creditCard, Map<String, String> flowData) throws
            IOException, URISyntaxException {
        Assumptions.assumeThat(data.getConfiguration().getDomain())
                .withFailMessage("Unable to run this step because credit card token is not available on prod")
                .isNotEqualTo("prod");
        var getAccessTokenResponse = getAccessToken(flowData.get("flowId")).log();
        user.setLoginToken(objectMapper.readTree(getAccessTokenResponse.body()).at("/data/accessToken").asText());
        var getAccessCodeResponse = getB2BAccessCodeByKeyword(user, flowData).log();
        var premeraAccessCode = objectMapper.readTree(getAccessCodeResponse.body())
                .at("/data/accessCode")
                .asText();
        var verifyMemberResponse = verifyMember(user, "premeraWashington", "psychotherapy", GeneralActions.generateApiDate(0, 0, Integer.parseInt(flowData.get("age"))), flowData).log();
        assertThat(verifyMemberResponse)
                .extracting(HttpResponse::statusCode)
                .as("verify member response")
                .withFailMessage(GeneralActions.failMessage(verifyMemberResponse))
                .isEqualTo(HttpStatus.SC_OK);
        var insuranceCode = objectMapper.readTree(verifyMemberResponse.body()).get("data").get("insuranceCode").asText();
        var trizettoRequestId = objectMapper.readTree(verifyMemberResponse.body()).get("data").get("trizettoRequestId").asInt();
        var registrationUrl = String.format("https://match.%s.talkspace.com/flow/7/step/20?redirectFrom=28&cpPartnerCode=%s&serviceType=psychotherapy&clientAge=1999-11-22&tr=107639&insuranceCode=%s&cpc=2500", data.getConfiguration().getDomain(), premeraAccessCode, insuranceCode);
        var requestBody = objectMapper.createObjectNode()
                .putPOJO("attribution", Map.of(
                        "registrationUrl", registrationUrl,
                        "referrerUrl", registrationUrl
                ))
                .put("clientDateOfBirth", GeneralActions.generateApiDate(0, 0, Integer.parseInt(flowData.get("age"))))
                .put("email", user.getEmail())
                .put("funnelVariation", "customer_selected")
                .put("gender", 1)
                .put("insuranceCode", insuranceCode)
                .put("roomType", ServiceType.THERAPY.getType())
                .put("therapistId", provider.getId())
                .put("timezone", "America/New_York")
                .put("tokenizedCreditCard", creditCard.token())
                .put("trizettoRequest", trizettoRequestId)
                .put("voucherCode", premeraAccessCode)
                .putPOJO("presentingProblems", objectMapper.createArrayNode().add(objectMapper.createObjectNode()
                        .put("id", 3)
                        .put("name", "I'm feeling anxious or panicky")));
        var quickmatchResponses = objectMapper.createArrayNode()
                .add(buildQuickmatchResponse(null, 54, "To begin, please select why you thought about getting help from a provider", 2,
                        "I'm feeling anxious or panicky", "3", objectMapper.createObjectNode()
                                .put("field", "fieldsOfExpertise")
                                .putPOJO("value", List.of(25))))
                .add(buildQuickmatchResponse(null, 57, "Would you prefer a provider that is...", 3, "Male", "1", objectMapper.createObjectNode()
                        .put("field", "therapistGender")
                        .putPOJO("value", "male")))
                .add(buildQuickmatchResponse(null, 58, "Have you been to a provider before?", 7, "No", "No", null))
                .add(buildQuickmatchResponse(null, 59, "How would you rate your sleeping habits?", 7, "Excellent", "Excellent", null))
                .add(buildQuickmatchResponse(null, 60, "How would you rate your current physical health?", 7, "Good", "Good", null))
                .add(buildQuickmatchResponse(null, 62, "Please select your gender.", 4, "Male", "1", null))
                .add(buildQuickmatchResponse(true, 63, "Please select your state of residence.", 6,
                        Us_States.valueOf(flowData.get("state")).getName(), Us_States.valueOf(flowData.get("state")).getAbbreviation(), null));
        requestBody.putPOJO("quickmatchResponses", quickmatchResponses)
                .put("roomType", ServiceType.THERAPY.getType())
                .put("timezone", "America/New_York")
                .put("tokenizedCreditCard", creditCard.token())
                .put("trizettoRequest", trizettoRequestId)
                .put("voucherCode", premeraAccessCode);
        if (flowData.containsKey("isPendingMatch")) {
            requestBody.put("isPendingMatch", true)
                    .put("therapistId", 0);
        } else {
            requestBody.put("therapistId", provider.getId());
        }
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(MATCH_API))
                        .setPath("/api/v3/registerWithCopay")
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * verify member eligibility
     *
     * @param user        the user whose room will be created.
     * @param payer       the service payer
     * @param service     the service that is requested.
     * @param dateOfBirth the user date of birth.
     * @param flowData    the data that will be used to create the room.
     * @return HTTP response
     */
    private HttpResponse<String> verifyMember(User user, String payer, String service, String dateOfBirth, Map<String, String> flowData) throws
            URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .put("dateOfBirth", dateOfBirth)
                .put("firstName", user.getFirstName())
                .put("flowId", Integer.parseInt(flowData.get("flowId")))
                .put("lastName", user.getLastName())
                .put("memberID", BhMemberIDType.valueOf(flowData.get("Member ID")).getMemberID())
                .put("payer", payer)
                .put("sendEmail", true)
                .put("service", service)
                .put("state", Us_States.valueOf(flowData.get("state")).getAbbreviation())
                .put("userEmail", user.getEmail())
                .putPOJO("getVoucherParams", Map.of(
                        "keyword", flowData.get("keyword"),
                        "email", user.getEmail(),
                        "flowId", Integer.parseInt(flowData.get("flowId")),
                        "metadata", Map.ofEntries(
                                Map.entry("firstName", user.getFirstName()),
                                Map.entry("lastName", user.getLastName()),
                                Map.entry("dateOfBirth", dateOfBirth),
                                Map.entry("phone", user.getPhoneNumber()),
                                Map.entry("employeeId", StringUtils.EMPTY),
                                Map.entry("heardAbout", data.getUserDetails().getReferral()),
                                Map.entry("employeeRelationship", EmployeeRelation.valueOf(flowData.get("employee Relation")).getValue()),
                                Map.entry("memberID", BhMemberIDType.valueOf(flowData.get("Member ID")).getMemberID()),
                                Map.entry("groupId", StringUtils.EMPTY),
                                Map.entry("address", "222"),
                                Map.entry("addressStreet", user.getAddress().getHomeAddress()),
                                Map.entry("address2", user.getAddress().getUnitAddress()),
                                Map.entry("city", user.getAddress().getCity()),
                                Map.entry("state", Us_States.valueOf(flowData.get("state")).getAbbreviation()),
                                Map.entry("zipcode", user.getAddress().getZipCode()),
                                Map.entry("country", user.getAddress().name()),
                                Map.entry("authorizationCode", StringUtils.EMPTY))
                ));
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(MATCH_API))
                        .setPath("/api/v4/eligibility/verify-member")
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * Verify member eligibility
     *
     * @param user        the user whose room will be created.
     * @param gediPayerID the ID of the payer we want to verify the member eligibility with.
     * @return HTTP response
     */
    private HttpResponse<String> verifyMember(User user, String gediPayerID, String dateOfBirth, Map<String, String> flowData) throws
            URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .put("memberID", BhMemberIDType.valueOf(flowData.get("Member ID")).getMemberID())
                .put("firstName", user.getFirstName())
                .put("lastName", user.getLastName())
                .put("gediPayerID", gediPayerID)
                .put("dateOfBirth", dateOfBirth)
                .put("state", Us_States.valueOf(flowData.get("state")).getAbbreviation());
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(MATCH_API))
                        .setPath("/api/v4/eligibility/verify-member")
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * Creates {@link ObjectNode} from QM response. Used to register B2B rooms.
     * Used in {@link #createDteRoom(User, Provider, Map)}, {@link #createEapRoom(User, Provider, Map)} , {@link #createBhPsychiatryRoom(User, CreditCard, Map)}
     *
     * @param livesInTheUS       value for the JSON key "livesInTheUS"
     * @param payFirstStepId     value for the JSON key "payfirst_Step_id"
     * @param payFirstStepPrompt value for the JSON key "payfirst_step_prompt"
     * @param responseCategoryId value for the JSON key "response_category_id"
     * @param responsePrompt     value for the JSON key "response_prompt"
     * @param responseValue      value for the JSON key "response_value"
     * @param responseSelfServe  value for the JSON key "response_self_serve"
     * @return JSONObject of a quickmatch response inside JSON object with key "quickMatchResponses"
     */
    private ObjectNode buildQuickmatchResponse(@Nullable Boolean livesInTheUS, int payFirstStepId, String
            payFirstStepPrompt, int responseCategoryId, String responsePrompt,
                                               @Nullable String responseValue, @Nullable ObjectNode responseSelfServe) {
        var quickmatchResponseToReturn = objectMapper.createObjectNode();
        if (livesInTheUS != null) {
            quickmatchResponseToReturn.put("livesInTheUS", livesInTheUS);
        }
        if (responseValue != null) {
            quickmatchResponseToReturn.put("response_value", responseValue);
        }
        if (responseSelfServe != null) {
            quickmatchResponseToReturn.putPOJO("response_self_serve", responseSelfServe);
        }
        quickmatchResponseToReturn.put("payfirst_step_id", payFirstStepId);
        quickmatchResponseToReturn.put("payfirst_step_prompt", payFirstStepPrompt);
        quickmatchResponseToReturn.put("response_category_id", responseCategoryId);
        quickmatchResponseToReturn.put("response_prompt", responsePrompt);
        return quickmatchResponseToReturn;
    }

    /**
     * Gets the existing starred messages for the specified userId
     * must call {@link #loginWithClient(User)} first to get bearer in a scenario
     *
     * @param user the {@link User} that has chat messages.
     * @return HTTP response.
     */
    public HttpResponse<String> getStarredMessages(User user) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v3/users/%s/stars".formatted(user.getId()))
                        .build())
                .headers(headers(user))
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * Gets the messages that exist in the chat for the specified roomId
     * there is an optional parameter called rate which specify the number of messages the api will return - we want all of them so
     * we are not passing it.
     * Must call {@link #loginWithClient(User)} first to get bearer in a scenario
     *
     * @param user the {@link User} that has chat messages.
     * @return HTTP response.
     */
    public HttpResponse<String> getChatMessages(User user, int roomId) throws URISyntaxException {
        var requestBody = objectMapper
                .createObjectNode()
                .putPOJO("params", Map.of(
                        "deviceType", "pc",
                        "appVersion", "1",
                        "lastMessageId", 0,
                        "loadMediaURLs", true,
                        "tid", roomId));
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(API))
                        .setPath("/rest/ios/method/getAllRepliesForThread")
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * Stars the message with the specified messageId
     * must call {@link #loginWithClient(User)} first to get bearer in a scenario
     *
     * @param messageId the message id to star
     * @param user      the {@link User} user that has chat messages.
     * @return HTTP response.
     */
    public HttpResponse<String> starMessage(int messageId, User user) throws URISyntaxException {
        var requestBody = objectMapper
                .createObjectNode()
                .put("messageID", messageId);
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v2/stars")
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * Unstars the message with the specified messageId.
     * Make sure you only call this method with a messageId of a starred message.
     * The bearer token must belong to the user who has access to the messages.
     * Must call {@link #loginWithClient(User)} first to get bearer in a scenario
     *
     * @param messageId the message id to star
     * @param user      the {@link User} user that has chat messages.
     * @return HTTP response.
     */
    public HttpResponse<String> unstarMessage(User user, String messageId) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("v2/stars/%s".formatted(messageId))
                        .build())
                .headers(headers(user))
                .DELETE()
                .build();
        return client.logThenSend(request);
    }

    /**
     * cancel subscription-based plans - e.g bundle a plan -> offer #62
     * must call {@link #loginWithClient(User)} first to get bearer in a scenario
     *
     * @param user   that needs to cancel the room.
     * @param roomId room id to cancel for the client
     * @return HTTP response.
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    public HttpResponse<String> cancelSubscription(User user, int roomId) throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .put("cancellationReason", "cancel after automation run");
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(THERAPIST_API))
                        .setPath("/v2/rooms/%d/cancel-subscription".formatted(roomId))
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * Cancel non-subscriptions such as B2B plans - e.g., Premera BH Therapy
     * must call {@link #loginWithClient(User)} first to get bearer in a scenario
     *
     * @param user   that needs to cancel the room.
     * @param roomId room id to cancel for the client
     * @return HTTP response.
     * @throws IOException if an I/O error occurs
     */
    public HttpResponse<String> cancelNonSubscription(User user, int roomId) throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .put("cancellationReason", "cancel after automation run");
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(THERAPIST_API))
                        .setPath("/v2/rooms/%d/cancel-non-subscription".formatted(roomId))
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * Gets 2fa status - using us for existing users.
     *
     * @param user the {@link User}
     * @return HTTP response
     */
    public HttpResponse<String> getTwoFactorStatus(User user) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v3/2fa/status")
                        .build())
                .headers(headers(user))
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * @param user      the {@link User}
     * @param roomIndex the index of the room in the rooms list
     * @return HTTP response
     */
    public HttpResponse<String> getVideoCreditOffers(User user, int roomIndex) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v3/rooms/%d/video-credit-offers".formatted(user.getRoomsList().get(roomIndex).getId()))
                        .build())
                .headers(headers(user))
                .GET()
                .build();
        return client.logThenSend(request);
    }


    /**
     * Gets the user's video credit offers. To trigger eligibility checks on book session.
     *
     * @param user      the {@link User} user whose subscription will be canceled.
     * @param roomIndex the index of the room in the user's room list.
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @And("Client API - Send video-credit-offers request for {user} user in the {optionIndex} room")
    public void apiGetVideoCreditOffers(User user, int roomIndex) throws URISyntaxException {
        getVideoCreditOffers(user, roomIndex).log();
    }

    /**
     * Authenticating as a user.
     * The request has a timeout to avoid waiting too long for a single request.
     *
     * @param user to authenticate as
     * @return HTTP response.
     */
    public HttpResponse<String> loginWithClient(User user) throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .put("userType", "CLIENT")
                .put("platform", "web-client")
                .put("version", "1.0.0");
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v3/2fa/auth")
                        .build())
                .timeout(Duration.ofSeconds(20))
                .headers(ACCEPT, WILDCARD,
                        USER_AGENT, Constants.AUTOMATION_USER_AGENT,
                        CONTENT_TYPE, APPLICATION_JSON,
                        AUTHORIZATION, BASIC + StringUtils.SPACE + GeneralActions.encodeBase64(user.getEmail() + ":" + user.getPassword()))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * this method will create a room for the user and will purchase the service.
     * <p>
     * the provider will be ignored by the system - needs to switch provider via API.
     *
     * @param serviceType the service that is requested.
     * @param user        the user whose room will be created.
     * @param provider    the {@link Provider} that will create the room.
     * @param creditCard  the {@link CreditCard} to purchase with
     * @param flowData    <table>
     *                    <thead>
     *                    <th>the data to be used to create the room</th>
     *                    <thead>
     *                    <tbody>
     *                    <tr><td>flowId</td><td>the flow id</td></tr>
     *                    <tr><td>keyword</td><td>keyword</td></tr>
     *                    <tr><td>member id</td><td>member id {@link BhMemberIDType}</td></tr>
     *                    <tr><td>state</td><td>the user {@link Us_States}</td></tr>
     *                    <tr><td>age</td><td>the member age</td></tr
     *                    <tr><td>employee relation</td><td>{@link EmployeeRelation}</td></tr>
     *                    </tbody>
     *                    </table>
     * @throws IOException        if an I/O error occurs
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @And("Client API - Create {} BH room for {user} user with {provider} with {cardType} card")
    @And("Client API - Create {} BH room for {user} user with {provider} provider with {cardType} card")
    public void apiCreateBhRoom(ServiceType serviceType, User user, Provider provider, CreditCard creditCard, Map<String, String> flowData) throws IOException, URISyntaxException {
        var response = switch (serviceType) {
            case PSYCHIATRY -> createBhPsychiatryRoom(user, creditCard, flowData).log();
            case THERAPY -> createBhTherapyRoom(user, provider, creditCard, flowData).log();
            default -> throw new IllegalArgumentException("Service type " + serviceType + " not supported");
        };
        response.log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("register With Copay Response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        var responseJSON = objectMapper.readTree(response.body());
        user.setId(responseJSON
                .at("/data/user/id")
                .asInt());
        user.setLoginToken(responseJSON
                .at("/data/user/updateCredentialsJWTToken")
                .asText());
        user.getRoomsList().add(new Room(responseJSON.at("/data/room/id").asInt(), provider));
        response = setBasicDetails(user).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Set basic details response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
    }

    /**
     * used to send messages from member to therapist
     * must call {@link #loginWithClient(User)} first to get bearer in a scenario
     *
     * @param roomIndex the room index in a room list.
     * @param user      the {@link User} user that will send the message
     * @param text      the massage that the {@link User} sends to the provider
     * @return HTTP response.
     */
    public HttpResponse<String> postMessage(User user, String text, int roomIndex) throws URISyntaxException {
        var requestBody = objectMapper
                .createObjectNode()
                .putPOJO("params", Map.of(
                        "apnsCertificate", "1",
                        "appVersion", "7.4.0",
                        "contextSwitch", "1",
                        "gid", user.getRoomsList().get(roomIndex).getId(),
                        "mediaType", 0,
                        "message", text,
                        "tokenId", StringUtils.EMPTY
                ));
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(API))
                        .setPath("/rest/ios/method/postMessage")
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * a random therapist will be assigned to the room.
     *
     * @param user     the {@link User} user whose room will be created.
     * @param flowData <table>
     *                 <thead>
     *                 <th>the data to be used to create the room</th>
     *                 <thead>
     *                 <tbody>
     *                 <tr><td>flowId</td><td>the flow id</td></tr>
     *                 <tr><td>keyword</td><td>keyword</td></tr>
     *                 <tr><td>state</td><td>the user {@link Us_States}</td></tr>
     *                 <tr><td>age</td><td>the member age</td></tr>
     *                 </tbody>
     *                 </table>
     * @throws IOException if an I/O error occurs
     */
    @And("Client API - Create EAP room to {user} user with {provider} provider")
    public void apiCreateEAPRoomForUser(User user, Provider provider, Map<String, String> flowData) throws IOException, URISyntaxException {
        var response = createEapRoom(user, provider, flowData).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Create EAP room response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        user.setId(objectMapper.readTree(response.body())
                .at("/data/userId").asInt());
    }

    /**
     * Gets the specified provider's available session timeslots
     *
     * @param user           The user requesting the {@link Provider} timeslots
     * @param sessionMinutes the duration of the session we want to book later (in minutes)
     * @param provider       the {@link Provider} we want to get the timeslots of
     * @return HTTP response
     */
    public HttpResponse<String> getTherapistTimeslots(int sessionMinutes, User user, Provider provider) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v2/therapist/%s/timeslots".formatted(provider.getId()))
                        .setParameters(
                                new BasicNameValuePair("length", "%d minutes".formatted(sessionMinutes)),
                                new BasicNameValuePair("from", "2 day"),
                                new BasicNameValuePair("to", "32 day"))
                        .build())
                .headers(headers(user))
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * Gets the list of booked sessions in the room for the specified user
     *
     * @param user      the {@link User} user we want to get the booked sessions for
     * @param roomIndex the index of the room we want to get the bookings for in {@link User#getRoomsList()}
     * @return HTTP response
     */
    public HttpResponse<String> getSessionBookingsForRoomIndex(User user, int roomIndex) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v3/rooms/%d/bookings".formatted(user.getRoomsList().get(roomIndex).getId()))
                        .build())
                .headers(headers(user))
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * Gets the list of booked sessions in the room for the specified user
     *
     * @param user   the {@link User} user we want to get the booked sessions for
     * @param roomId the id of the room we want to get the bookings for
     * @return HTTP response
     */
    public HttpResponse<String> getSessionBookingsForRoomId(User user, int roomId) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v3/rooms/%d/bookings".formatted(roomId))
                        .build())
                .headers(headers(user))
                .GET()
                .build();
        return client.logThenSend(request);
    }


    /**
     * cancel a non-paying subscription.
     * <p>
     * in case the room list is empty, or the room index is out of bounds, the method will refresh the room list.
     *
     * @param user      the {@link User} user whose subscription will be canceled.
     * @param roomIndex the index of the room in the user's room list.
     * @throws IOException        if an I/O error occurs
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @And("Client API - Cancel a non paying subscription of {user} user in the {optionIndex} room")
    public void apiCancelNonSubscription(User user, int roomIndex) throws IOException, URISyntaxException {
        if (user.getRoomsList().isEmpty() || roomIndex > user.getRoomsList().size() - 1) {
            getRoomsInfoOfUser(user);
        }
        var response = cancelNonSubscription(user, user.getRoomsList().get(roomIndex).getId()).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Cancel a non paying subscription")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_NO_CONTENT);
    }

    /**
     * Books a Live Video Session as the specified user
     *
     * @param user          The user who schedules the session
     * @param roomIndex     The index of the room in which the session is to be scheduled
     * @param provider      the {@link Provider} in the session
     * @param creditMinutes Duration of the session in minutes (like 10, 30, 60)
     * @param startTime     The starting time we want to schedule the booking for. Only call this with a valid and available timeslot.
     * @return HTTP response
     */
    public HttpResponse<String> bookSession(User user, int roomIndex, Provider provider, int creditMinutes, Date startTime) throws URISyntaxException {
        var roomId = user.getRoomsList().get(roomIndex).getId();
        int therapistId = user.getRoomsList().get(roomIndex).getProvider().getId();
        // planID in the request needs to be null for introduction sessions
        Integer planId = null;
        var sessionType = switch (creditMinutes) {
            case 10 -> "introduction";
            case 30 -> {
                if (provider.getProviderType().equals(ProviderType.PSYCHIATRIST)) {
                    yield "psychiatry";
                }
                // planID in the request needs to be 247 for 30-minutes sessions
                planId = 247;
                yield "therapy";
            }
            case 45 -> "therapy";
            case 60 -> "psychiatry";
            default -> throw new IllegalStateException("Unexpected value: " + creditMinutes);
        };
        var formatter = new SimpleDateFormat(data.getApiEndpointDateFormats().get("bookings"));
        var start = formatter.format(startTime);
        var requestBody = objectMapper.createObjectNode()
                .put("creditMinutes", creditMinutes)
                .put("isPurchase", false)
                .put("isVideoOnly", false)
                .put("modality", "video")
                .put("planID", planId)
                .put("start", start)
                .put("therapistUserID", therapistId)
                .put("type", sessionType)
                .put("withinAllowRefundHours", false);
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v3/rooms/%d/bookings".formatted(roomId))
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * @param user        The user who creates the room (registers)
     * @param provider    the {@link Provider} the that user registers with directly
     * @param serviceType The room type (couples/psychiatry/therapy).
     * @return HTTP response.
     */
    public HttpResponse<String> createRoomForUser(ServiceType serviceType, User user, Provider provider, Map<String, String> flowData) throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .putPOJO("flowData", Map.of(
                        "registrationUrl", GeneralActions.isRunningOnProd() ? "https://app.talkspace.com/signup" : String.format("https://app.%s.talkspace.com/signup", data.getConfiguration().getDomain()),
                        "funnelVariation", "therapist_direct",
                        "roomType", serviceType.getType()
                )).putPOJO("userDetails", Map.of(
                        "customerInformation", objectMapper.createObjectNode()
                                .put("country", user.getAddress().name())
                                .put("state", Us_States.valueOf(flowData.get("state")).getAbbreviation()),
                        "email", user.getEmail(),
                        "nickname", user.getNickName(),
                        "password", user.getPassword(),
                        "timezone", "America/Denver"
                )).putPOJO("therapistData", Collections
                        .singletonMap("therapistID", provider.getId()));
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v2/registration/")
                        .build())
                .timeout(Duration.ofSeconds(40))
                .headers(ACCEPT, WILDCARD,
                        USER_AGENT, Constants.AUTOMATION_USER_AGENT,
                        CONTENT_TYPE, APPLICATION_JSON)
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * get active feature flags
     *
     * @param user the {@link User} whose feature flags will be retrieved.
     * @return HTTP response.
     */
    public HttpResponse<String> getActiveFeatureFlags(User user) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v3/users/get-admin-config-values")
                        .setParameters(
                                new BasicNameValuePair("key", PrivateFeatureFlagType.TREATMENT_INTAKE_IN_ONBOARDING.getName()),
                                new BasicNameValuePair("key", PrivateFeatureFlagType.LIVE_CHAT_ACTIVE.getName()),
                                new BasicNameValuePair("key", PrivateFeatureFlagType.PDF_UPLOAD.getName()),
                                new BasicNameValuePair("key", PrivateFeatureFlagType.CLINICAL_PROGRESS_WEB.getName()),
                                new BasicNameValuePair("key", PrivateFeatureFlagType.EMAIL_VERIFICATION.getName()),
                                new BasicNameValuePair("key", PrivateFeatureFlagType.SUPERBILLS.getName()))
                        .build())
                .headers(headers(user))
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * return if a public feature flag is on (1) or off (0).
     *
     * @param publicFeatureFlagType the {@link PublicFeatureFlagType} to check for.
     * @return HTTP response.
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    public HttpResponse<String> getPublicFeatureFlag(PublicFeatureFlagType publicFeatureFlagType) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(PUBLIC_API))
                        .setPath("/public/v1/get-admin-config-value")
                        .setParameter("key", publicFeatureFlagType.getName())
                        .build())
                .headers(ACCEPT, WILDCARD,
                        CONTENT_TYPE, APPLICATION_JSON)
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * setting basic user information prior to registration.
     *
     * @param user the {@link User} who creates the room (registers)
     * @return HTTP response.
     */
    public HttpResponse<String> setBasicDetails(User user) throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode();
        requestBody.put("password", user.getPassword())
                .put("confirmedPassword", user.getPassword());
        requestBody.put("pseudonym", user.getFirstName());
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v2/registration/user/%s/basic-details".formatted(user.getId()))
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * Creates a new room with a new AARP (Out-of-Network) therapy client.
     * To complete registration to log in, using {@link #setBasicDetails(User)} is still needed after registering.
     *
     * @param user     the {@link User} user whose room will be created.
     * @param provider the {@link Provider} in the room
     * @return HTTP response
     */
    public HttpResponse<String> createOutOfNetworkTherapyRoom(User user, Provider provider, CreditCard creditCard, Map<String, String> flowData) throws
            IOException, URISyntaxException {
        Assumptions.assumeThat(data.getConfiguration().getDomain())
                .withFailMessage("Unable to run this step because credit card token is not available on prod")
                .isNotEqualTo("prod");
        var getAccessTokenResponse = getAccessToken("66").log();
        user.setLoginToken(objectMapper.readTree(getAccessTokenResponse.body()).at("/data/accessToken").asText());
        var verifyMemberResponse = verifyMember(user, "87726", GeneralActions.generateApiDate(0, 0, Integer.parseInt(flowData.get("age"))), flowData).log();
        assertThat(verifyMemberResponse)
                .extracting(HttpResponse::statusCode)
                .as("verify member response")
                .withFailMessage(GeneralActions.failMessage(verifyMemberResponse))
                .isEqualTo(HttpStatus.SC_OK);
        var insuranceCode = objectMapper.readTree(verifyMemberResponse.body()).get("data").get("insuranceCode").asText();
        var trizettoRequestId = objectMapper.readTree(verifyMemberResponse.body()).get("data").get("trizettoRequestId").asInt();
        var registrationUrl = String.format("https://match.%s.talkspace.com/flow/66/step/24", data.getConfiguration().getDomain());
        var requestBody = objectMapper.createObjectNode()
                .putPOJO("attribution", Map.of(
                        "registrationUrl", registrationUrl,
                        "referrerUrl", StringUtils.EMPTY
                ))
                .put("clientDateOfBirth", GeneralActions.generateApiDate(0, 0, Integer.parseInt(flowData.get("age"))))
                .put("email", user.getEmail())
                .put("funnelVariation", "customer_selected")
                .put("gender", 1)
                .put("insuranceCode", insuranceCode)
                .put("isPendingMatch", false)
                .put("planId", 582)
                .putPOJO("presentingProblems", objectMapper.createArrayNode().add(objectMapper.createObjectNode()
                        .put("id", 3)
                        .put("name", "I'm feeling anxious or panicky")))
                .putPOJO("quickmatchResponses", objectMapper.createArrayNode()
                        .add(buildQuickmatchResponse(null, 54, "To begin, please select why you thought about getting help from a provider", 2,
                                "I'm feeling anxious or panicky", "3", objectMapper.createObjectNode()
                                        .put("field", "fieldsOfExpertise")
                                        .putPOJO("value", List.of(25))))
                        .add(buildQuickmatchResponse(null, 97, "I'm looking for a provider that will...", 7, "Teach new skills", "1", null))
                        .add(buildQuickmatchResponse(null, 58, "Have you been to a therapist or psychiatrist before?", 7, "Yes", "Yes", null))
                        .add(buildQuickmatchResponse(null, 59, "How would you rate your sleeping habits?", 7, "Excellent", "Excellent", null))
                        .add(buildQuickmatchResponse(null, 60, "How would you rate your current physical health?", 7, "Good", "Good", null))
                        .add(buildQuickmatchResponse(null, 62, "What gender do you identify with?", 4, "Male", "1", null))
                        .add(buildQuickmatchResponse(null, 57, "What gender would you prefer in a provider?", 3, "Male", "1", objectMapper.createObjectNode()
                                .put("field", "therapistGender")
                                .putPOJO("value", "male")))
                        .add(buildQuickmatchResponse(null, 61, "What is your age?", 5, "18-25", "1", null))
                        .add(buildQuickmatchResponse(true, 63, "What state do you live in?", 6,
                                Us_States.valueOf(flowData.get("state")).getName(), Us_States.valueOf(flowData.get("state")).getAbbreviation(), null)))
                .put("roomType", ServiceType.THERAPY.getType())
                .put("therapistId", provider.getId())
                .put("timezone", "America/New_York")
                .put("tokenizedCreditCard", creditCard.token())
                .put("trizettoRequest", trizettoRequestId);
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(MATCH_API))
                        .setPath("/api/v3/processPaymentAndRegister")
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * starts an async session for a room.
     *
     * @param user       the {@link User} user that wants to switch therapist.
     * @param roomIndex  the index of the room in the rooms list
     * @param isPurchase if the session is a purchase
     * @return HTTP response.
     */
    public HttpResponse<String> startAsyncSession(User user, int roomIndex, boolean isPurchase) throws URISyntaxException {
        var requestBody = objectMapper
                .createObjectNode()
                .put("isPurchase", isPurchase);
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(CLIENT_API))
                        .setPath("/v2/rooms/%s/async-session".formatted(user.getRoomsList().get(roomIndex).getId()))
                        .build())
                .headers(headers(user))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * @param user the {@link User}.
     * @throws IOException if an I/O error occurs
     */
    @Given("Client API - Get two factor status of {user} user")
    public void apiGetTwoFactorStatus(User user) throws IOException, URISyntaxException {
        var response = getTwoFactorStatus(user).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Get two factor status response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        var jsonResponse = objectMapper.readTree(response.body());
        user.setTwoFactorStatusType(TwoFactorStatusType.valueOf(jsonResponse
                .at("/data/status")
                .asText()
                .toUpperCase()));
    }

    /**
     * updates {@link PrivateFeatureFlagType} activation status in {@link ScenarioContext}
     *
     * @param user the {@link User} with the feature flags we want to verify
     * @throws IOException        if an I/O error occurs
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @And("Client API - Get active feature flags for {user} user")
    public void talkspaceAPIGetActiveFeatureFlagsForUser(User user) throws IOException, URISyntaxException {
        var response = getActiveFeatureFlags(user).log();
        var responseJSON = objectMapper.readTree(response.body()).get("data");
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Get active feature flags response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        responseJSON.forEach(featureFlag -> scenarioContext.getPrivateFeatureFlagTypeMap().put(PrivateFeatureFlagType.valueOf(featureFlag.get("name").asText().toUpperCase()), featureFlag.get("value").asBoolean()));
    }

    /**
     * Verifies the number of bookings for a user in a room.
     *
     * @param user          the {@link User} user we want to make sure has no bookings
     * @param bookingAmount the number of bookings we want to make sure the member has
     * @param roomIndex     the index of the user's room to verify there are no bookings in
     */
    @And("Client API - There are/is {int} scheduled booking(s) for {user} user in the {optionIndex} room")
    public void apiBookSessionWithTherapist(int bookingAmount, User user, int roomIndex) {
        Awaitility
                .await()
                .alias("Waiting that Amount of bookings to be: " + bookingAmount)
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() ->
                {
                    var response = getSessionBookingsForRoomIndex(user, roomIndex).log();
                    assertThat(response)
                            .extracting(HttpResponse::statusCode)
                            .as("Get Bookings response")
                            .withFailMessage(GeneralActions.failMessage(response))
                            .isEqualTo(HttpStatus.SC_OK);
                    assertThat(objectMapper.readTree(response.body()).get("data"))
                            .as("Bookings amount")
                            .hasSize(bookingAmount);
                });
    }

    /**
     * storing the booking amount for a user in a room in {@link ScenarioContext} for later use.
     *
     * @param user      the {@link User} user who needs to store the booking amount for
     * @param roomIndex the index of the room in the user's room list
     * @throws IOException        if an I/O error occurs
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @And("Client API - Store booking amount for {user} user in the {optionIndex} room")
    public void storeBookingAmount(User user, int roomIndex) throws IOException, URISyntaxException {
        var response = getSessionBookingsForRoomIndex(user, roomIndex).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Get Bookings response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        scenarioContext.setBookingAmount(objectMapper.readTree(response.body()).get("data").size());
    }

    /**
     * Verifies the number of bookings for a user in a room
     * We can't guarantee the number of bookings,
     * so we check that the number of bookings is less than the number
     * prior to cancelling the booking.
     *
     * @param user          the {@link User} user we want to make sure has no bookings
     * @param bookingAmount the number of bookings we want to make sure the member has
     * @param roomIndex     the index of the user's room to verify there are no bookings in
     */
    @And("Client API - There is {int} less scheduled booking(s) for {user} user in the {optionIndex} room")
    public void apiThereIsLessBookings(int bookingAmount, User user, int roomIndex) {
        Awaitility
                .await()
                .alias("Waiting that Amount of bookings to be: " + bookingAmount)
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() ->
                {
                    var response = getSessionBookingsForRoomIndex(user, roomIndex).log();
                    assertThat(response)
                            .extracting(HttpResponse::statusCode)
                            .as("Get Bookings response")
                            .withFailMessage(GeneralActions.failMessage(response))
                            .isEqualTo(HttpStatus.SC_OK);
                    assertThat(objectMapper.readTree(response.body()).get("data"))
                            .as("Bookings amount")
                            .hasSize(scenarioContext.getBookingAmount() - bookingAmount);
                });
    }

    /**
     * Verifies the number of bookings for a user in a room - this is specifically for recurring bookings.
     * We can't guarantee the number of bookings, so we check that the number of bookings is between a range.
     *
     * @param user             the {@link User} user we want to make sure has no bookings
     * @param minBookingAmount the number of minimum bookings we want to make sure the member has
     * @param maxBookingAmount the number of maximum bookings we want to make sure the member has
     * @param roomIndex        the index of the user's room to verify there are no bookings in
     */
    @And("Client API - There are between {int} to {int} scheduled bookings for {user} user in the {optionIndex} room")
    public void apiBookSessionWithTherapistRecurringValidation(int minBookingAmount, int maxBookingAmount, User user, int roomIndex) {
        Awaitility
                .await()
                .alias("Waiting that Amount of bookings to be: between" + minBookingAmount + " to" + maxBookingAmount)
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() ->
                {
                    var response = getSessionBookingsForRoomIndex(user, roomIndex).log();
                    assertThat(response)
                            .extracting(HttpResponse::statusCode)
                            .as("Get Bookings response")
                            .withFailMessage(GeneralActions.failMessage(response))
                            .isEqualTo(HttpStatus.SC_OK);
                    assertThat(objectMapper.readTree(response.body()).get("data"))
                            .as("Bookings amount")
                            .hasSizeBetween(minBookingAmount, maxBookingAmount);
                });
    }


    /**
     * @param provider the {@link Provider} that will create the room.
     * @param user     the {@link User} user whose room will be created.
     * @param flowData <table>
     *                 <thead>
     *                 <th>the data to be used to create the room</th>
     *                 <thead>
     *                 <tbody>
     *                 <tr><td>flowId</td><td>the flow id</td></tr>
     *                 <tr><td>keyword</td><td>keyword</td></tr>
     *                 <tr><td>age</td><td>the member age</td></tr>
     *                 <tr><td>state</td><td>the user {@link Us_States}</td></tr>
     *                 <tr><td>isPendingMatch</td><td>if specified we ignore the therapist and use the matching cron</td></tr>
     *                 </tbody>
     *                 </table>
     * @throws IOException if an I/O error occurs
     */
    @And("Client API - Create DTE room to {user} user with {provider} provider")
    public void apiCreateDteRoomForUser(User user, Provider provider, Map<String, String> flowData) throws IOException, URISyntaxException {
        var response = createDteRoom(user, provider, flowData).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Create DTE room for new client response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        user.setId(objectMapper.readTree(response.body())
                .at("/data/userId").asInt());
    }

    /**
     * Creating a new room for the user by the therapist used to bypass the creation in the therapist web.
     * A new user will be created with private mailinator domain and strong password taken from data.json file.
     * <p>
     * the provider must be in "provider" phase to create a room with him or else the request will fail with 400 status code.
     * We can check the phase of the provider by logging in to backoffice admin and checking the status of the provider in providers > settings tab.
     * Or run the following query:
     * select therapist_phase from therapists where user_id = 5004641;
     * replace 5004641 with the user id of the provider.
     * The result should be two (provider) to create a room with him.
     * The Result of three means the provider is in phasing out status.
     *
     * @param provider the {@link Provider} that will create the room.
     * @param user     the {@link User} user whose room will be created.
     * @param flowData <table>
     *                 <thead>
     *                 <th>the data to be used to create the room</th>
     *                 <thead>
     *                 <tbody>
     *                 <tr><td>state</td><td>the user {@link Us_States}</td></tr>
     *                 </tbody>
     *                 </table>
     */
    @And("Client API - Create {} room for {user} user with {provider} provider")
    @And("Client API - Create {} room for {user} user with {provider}")
    public void apiCreateRoomForUser(ServiceType serviceType, User user, Provider provider, Map<String, String> flowData) throws IOException {
        var response =
                Awaitility.await()
                        .alias("room created via API")
                        .atMost(Duration.ofMinutes(2))
                        .pollInterval(Duration.ofSeconds(1))
                        .ignoreExceptions()
                        .until(() -> createRoomForUser(serviceType, user, provider, flowData), userResponse -> {
                            userResponse.log();
                            return userResponse.statusCode() == HttpStatus.SC_CREATED;
                        });
        var responseJSON = objectMapper.readTree(response.body());
        user.getRoomsList().add(new Room(responseJSON.get("roomID").asInt(), provider));
        user.setId(responseJSON.get("userID").asInt());
    }

    /**
     * this method will create a room for the user and will purchase the service.
     * <p>
     * the provider will be ignored by the system - needs to switch provider via API.
     *
     * @param user     the user whose room will be created.
     * @param provider the {@link Provider} that will create the room.
     * @param flowData <table>
     *                 <thead>
     *                 <th>the data to be used to create the room</th>
     *                 <thead>
     *                 <tbody>
     *                 <tr><td>flowId</td><td>the flow id</td></tr>
     *                 <tr><td>keyword</td><td>keyword</td></tr>
     *                 <tr><td>member id</td><td>member id {@link BhMemberIDType}</td></tr>
     *                 <tr><td>state</td><td>the user {@link Us_States}</td></tr>
     *                 <tr><td>employee relation</td><td>{@link EmployeeRelation}</td></tr>
     *                 <tr><td>age</td><td>the member age</td></tr>
     *                 </tbody>
     *                 </table>
     * @throws IOException        if an I/O error occurs
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @And("Client API - BH - Create manual psychiatry room for {user} user with {provider}")
    public void apiCreateManualPsychiatryBhRoom(User user, Provider provider, Map<String, String> flowData) throws IOException, URISyntaxException {
        var response = createManualBhPsychiatryRoom(user, provider, flowData)
                .log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("register With Copay Response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        var responseJSON = objectMapper.readTree(response.body());
        user.setId(responseJSON.at("/data/userId").asInt());
    }

    /**
     * Sends a message from the member in a certain room.
     *
     * @param amount          The number of messages to send
     * @param roomIndex       The room index to send the message to
     * @param chatMessageType message type to send.
     * @param user            the user that will send the message
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @And("Client API - Send {int} {} message as {user} user in the {optionIndex} room")
    public void apiSendMessageAsTherapist(int amount, ChatMessageType chatMessageType, User user, int roomIndex) throws URISyntaxException {
        for (int i = 0; i < amount; i++) {
            switch (chatMessageType) {
                case URL -> scenarioContext.setChatMessage(data.getCharacters().get("url"));
                case VALID_RANDOM -> scenarioContext.setChatMessage(RandomStringUtils.randomAlphabetic(3));
                case SPECIAL_CHARACTER -> scenarioContext.setChatMessage(data.getCharacters().get("specialCharacters"));
                default -> throw new IllegalStateException("Unexpected value: " + chatMessageType);
            }
            var response = postMessage(user, scenarioContext.getChatMessage(), roomIndex)
                    .log();
            assertThat(response)
                    .extracting(HttpResponse::statusCode)
                    .as("Send message response")
                    .withFailMessage(GeneralActions.failMessage(response))
                    .isEqualTo(HttpStatus.SC_OK);
        }
    }

    /**
     * Subscribe to plan, must call {@link #apiLoginToUser(User)} before.
     * Two retries are done to avoid 504 Gateway Time-out errors
     *
     * @param offerId   the client offer id
     * @param planId    the client plan id
     * @param cardType  the card type we complete purchase with
     * @param user      the {@link User} user that will subscribe to plan.
     * @param roomIndex the room where the plan will be activated.
     */
    @And("Client API - Subscribe to offer {int} of plan {int} with {cardType} card of {user} user in the {optionIndex} room")
    public void apiSubscribeToPlan(int offerId, int planId, CreditCard cardType, User user, int roomIndex) {
        Failsafe.with(RetryPolicy.builder()
                        .withMaxRetries(2)
                        .withDelay(Duration.ofSeconds(10))
                        .build())
                .run(() ->
                {
                    var response = subscribeToPlan(user, roomIndex, offerId, planId, cardType)
                            .log();
                    assertThat(response)
                            .extracting(HttpResponse::statusCode)
                            .as("subscribe to offer")
                            .withFailMessage(GeneralActions.failMessage(response))
                            .isEqualTo(HttpStatus.SC_OK);
                });
    }

    /**
     * Login to user - this triggers 2fa message.
     *
     * @param user existing user
     * @throws IOException if an I/O error occurs
     */
    @Given("Client API - Login to {user} user")
    public void apiLoginToUser(User user) throws IOException, URISyntaxException {
        var response = loginWithClient(user).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Login to client response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        var jsonResponse = objectMapper.readTree(response.body());
        if (Objects.isNull(user.getId())) {
            user.setId(jsonResponse
                    .at("/data/userID")
                    .asInt());
        }
        user.setLoginToken(jsonResponse
                .at("/data/access")
                .asText());
        user.setTwoFactorStatusType(TwoFactorStatusType.valueOf(jsonResponse
                .at("/data/twoFAStatus")
                .asText()
                .toUpperCase()));
    }

    /**
     * we might need to switch provider in case room is B2B type (opposite to B2C rooms created via provider slug).
     * <p>
     * we are refreshing to room info to get the latest provider id.
     * in case the provider is already the provider in the room, the method will do nothing.
     * <p>
     * the provider must be in "provider" phase to switch to him or else the request will fail with 400 status code.
     * we can check the phase of the provider by logging in to backoffice admin and checking the status of the provider in providers > settings tab.
     * or run the following query:
     * select therapist_phase from therapists where user_id = 5004641;
     * replace 5004641 with the user id of the provider.
     * the result should be two (provider) to switch to him.
     * the result of 3 means the provider is "phasing out" status.
     *
     * @param provider  the {@link Provider} to switch to.
     * @param roomIndex the index of the {@link Room} to switch to.
     * @param user      the {@link User} that is switching to the {@link Provider}.
     * @throws IOException        if an I/O error occurs
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @And("Client API - Switch to {provider} provider in the {optionIndex} room for {user} user")
    public void apiSwitchTherapistInRoomTo(Provider provider, int roomIndex, User user) throws IOException, URISyntaxException {
        getRoomsInfoOfUser(user);
        if (user.getRoomsList().get(roomIndex).getProvider().equals(provider)) {
            return;
        }
        var response = switchTherapist(roomIndex, provider, user).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Switch therapist response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        user.getRoomsList().get(roomIndex).setProvider(provider);
    }

    @And("Client API - Start async messaging session for {user} user")
    public void apiStartAsyncSession(User user, Map<String, String> options) throws URISyntaxException {
        var response = startAsyncSession(user, Integer.parseInt(options.get("roomIndex")), Boolean.parseBoolean(options.get("isPurchase"))).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Start async session response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_NO_CONTENT);
    }

    @And("Client API - Cancel Subscription of {user} user in the {optionIndex} room")
    public void apiCancelSubscription(User user, int roomIndex) throws URISyntaxException {
        var response = cancelSubscription(user, user.getRoomsList().get(roomIndex).getId()).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("cancel subscription response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
    }

    @And("Client API - Refund Charge of {user} user")
    public void apiRefundCharge(User user) throws IOException, URISyntaxException {
        var response = refundCharge(user).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("refund response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_CREATED);
    }

    /**
     * in case treatment_intake_in_onboarding=0 and the room status is 16, we will re-assign it to status 15.
     *
     * @param roomIndex  the room index in a room list.
     * @param user       the user whose room will be created.
     * @param roomStatus the expected {@link RoomStatus}
     * @see <a href="https://stackoverflow.com/a/18788168/4515129">can't merge false and false check</a>
     */
    @Then("Client API - The {optionIndex} room status of {user} user is {}")
    public void apiVerifyRoomStatus(int roomIndex, User user, RoomStatus roomStatus) {
        Awaitility
                .await()
                .alias("room status")
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .ignoreExceptions()
                .untilAsserted(() ->
                {
                    getRoomsInfoOfUser(user);
                    assertThat(user.getRoomsList().get(roomIndex).getRoomStatus())
                            .as("Room status")
                            .isEqualTo(roomStatus);
                });
    }

    /**
     * @param roomSize the room size in a room list.
     * @param user     the user whose room will be created.
     */
    @Then("Client API - The room count of {user} user is {int}")
    public void apiVerifyRoomCount(User user, int roomSize) {
        Awaitility
                .await()
                .alias("room status")
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .ignoreExceptions()
                .untilAsserted(() ->
                {
                    getRoomsInfoOfUser(user);
                    assertThat(user.getRoomsList().size())
                            .as("Room Count")
                            .isEqualTo(roomSize);
                });
    }

    @And("Client API - Unstar all user messages of {user} user")
    public void apiUnstarAllUserMessages(User user) throws IOException, URISyntaxException {
        var starMessageResponse = getStarredMessages(user).log();
        var listOfStarredMessages = objectMapper.readTree(starMessageResponse.body()).get("data");
        for (var message : listOfStarredMessages) {
            var starredMessageId = message.get("messageID").asText();
            var unstarMessageResponse = unstarMessage(user, starredMessageId).log();
            assertThat(unstarMessageResponse)
                    .extracting(HttpResponse::statusCode)
                    .as("Unstar message")
                    .withFailMessage(GeneralActions.failMessage(unstarMessageResponse))
                    .isEqualTo(HttpStatus.SC_NO_CONTENT);
        }
    }

    /**
     * Gets the specified User's rooms and subscription info and resetting the room list to the values in the response.
     * Room will always be marked for cancellation is status is WAITING_TO_BE_MATCHED (15) or WAITING_TO_BE_MATCHED_QUEUE (16) or if it's a b2c room and room status is ACTIVE (1) or FREE_TRIAL (14).
     *
     * @param user the {@link User} to get the rooms and subscriptions info for
     */
    @And("Client API - Get rooms info of {user} user")
    public void getRoomsInfoOfUser(User user) throws IOException, URISyntaxException {
        var response = getRooms(user).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Get rooms response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        user.getRoomsList().clear();
        var roomList = objectMapper.readTree(response.body())
                .get("data")
                .findValuesAsText("roomID")
                .stream()
                .map(Integer::parseInt)
                .toList();
        for (int roomId : roomList) {
            var subscriptionInfoResponse = getSubscriptionInformation(user, roomId).log();
            assertThat(response)
                    .extracting(HttpResponse::statusCode)
                    .as("Get subscription info")
                    .withFailMessage(GeneralActions.failMessage(response))
                    .isEqualTo(HttpStatus.SC_OK);
            var subscriptionInfo = objectMapper.readTree(subscriptionInfoResponse.body()).get("data").get(0);
            var roomStatus = valueOf(subscriptionInfo.get("status").asInt());
            var isB2B = subscriptionInfo.get("subscription").get("isB2B").asBoolean();
            // Setting providerInRoom to a new provider object with the therapistID and type we received from the API to add it later to the Room.
            var providerInRoom = new Provider(subscriptionInfo.get("therapistID").asInt(), ProviderType.getByType(subscriptionInfo.get("therapist").get("type").asText()));
            for (var providerInData : data.getProvider().get(data.getConfiguration().getDomain()).values()) {
                // Checking if data contains the providerId we got from the API.
                if (providerInRoom.getId() == providerInData.getId()) {
                    //If it does, we will add the provider from data to the Room instead of the default provider that only has an id and type.
                    providerInRoom = providerInData;
                    break;
                }
            }
            var statusToCancelList = List.of(ACTIVE, FREE_TRIAL);
            var roomIsPending = List.of(WAITING_TO_BE_MATCHED, WAITING_TO_BE_MATCHED_QUEUE).contains(roomStatus);
            var isCancellable = (statusToCancelList.contains(roomStatus)) || roomIsPending;
            user.getRoomsList().add(new Room(roomId, providerInRoom, roomStatus, isB2B, isCancellable));
        }
    }

    /**
     * Gets the specified provider's timeslots and then books a session on the first (nearest) available timeslot
     *
     * @param sessionMinutes the duration of the session we want to book later (in minutes)
     * @param provider       the provider to book the session with
     * @param user           the user to book the session as
     * @param roomIndex      the index of the user's room to book the session in
     */
    @And("Client API - Book {int} minutes session with {provider} provider as {user} user in the {optionIndex} room")
    public void apiBookSessionWithTherapist(int sessionMinutes, Provider provider, User user, int roomIndex) throws IOException, ParseException, URISyntaxException {
        var timeslotsResponse = getTherapistTimeslots(sessionMinutes, user, provider).log();
        assertThat(timeslotsResponse)
                .extracting(HttpResponse::statusCode)
                .as("Get timeslots response")
                .withFailMessage(GeneralActions.failMessage(timeslotsResponse))
                .isEqualTo(HttpStatus.SC_OK);
        var firstTimeSlot = objectMapper.readTree(timeslotsResponse.body()).get("data").get("timeslots").get(0);
        var formatter = new SimpleDateFormat(data.getApiEndpointDateFormats().get("timeslots"));
        var timeslotStartTime = formatter.parse(firstTimeSlot.get("start").asText());
        var bookingResponse = bookSession(user, roomIndex, provider, sessionMinutes, timeslotStartTime).log();
        assertThat(bookingResponse)
                .extracting(HttpResponse::statusCode)
                .as("Book session response")
                .withFailMessage(GeneralActions.failMessage(bookingResponse))
                .isEqualTo(HttpStatus.SC_CREATED);
    }

    @And("Client API - {int} refundable charges exist for {user} user")
    public void apiVerifyRefundableChargesExist(int chargesAmount, User user) throws IOException, URISyntaxException {
        var response = getRefundableCharges(user).log();
        var chargesArray = objectMapper.readTree(response.body()).get("data");
        assertThat(chargesArray)
                .as("Charges Array")
                .hasSize(chargesAmount);
    }

    /**
     * verify insurance providers payers list.
     *
     * @throws IOException        if an I/O error occurs
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @And("Client API - Verify insurance payers for {user} user has over {int} payers")
    public void apiVerifyPayers(User user, int payersAmount) throws IOException, URISyntaxException {
        var response = getPayers(user).log();
        var responseJSON = objectMapper.readTree(response.body()).get("data");
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Get insurance payers response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        scenarioContext.getSoftAssertions().assertThat(responseJSON.findValuesAsText("label"))
                .as("payers list")
                .doesNotHaveDuplicates()
                .hasSizeGreaterThan(payersAmount);
    }

    /**
     * {@link BhMemberIDType} must be set to OUT_OF_NETWORK
     *
     * @param creditCard the {@link CreditCard} to purchase with
     * @param provider   the {@link Provider} that will create the room.
     * @param user       the user whose room will be created.
     * @param flowData   <table>
     *                   <thead>
     *                   <th>the data to be used to create the room</th>
     *                   <thead>
     *                   <tbody>
     *                   <tr><td>member id</td><td>member id {@link BhMemberIDType}</td></tr>
     *                   <tr><td>state</td><td>the user {@link Us_States}</td></tr>
     *                   <tr><td>age</td><td>the member age</td></tr>
     *                   </tbody>
     *                   </table>
     */
    @And("Client API - Create Out of Network room for {user} user with {provider} provider with {cardType} card")
    public void apiCreateOutOfNetworkTherapyRoom(User user, Provider provider, CreditCard creditCard, Map<String, String> flowData) throws IOException, URISyntaxException {
        var response = createOutOfNetworkTherapyRoom(user, provider, creditCard, flowData).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Create Out of Network room response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        var responseJSON = objectMapper.readTree(response.body());
        user.setId(responseJSON
                .at("/data/user/id")
                .asInt());
        user.setLoginToken(responseJSON
                .at("/data/user/updateCredentialsJWTToken")
                .asText());
        user.setAuthToken(responseJSON.at("/data/authToken").asText());
        user.getRoomsList().add(new Room(responseJSON.at("/data/room/id").asInt(), provider));
        response = setBasicDetails(user).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Set basic details response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
    }
}
package glue.steps.api;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.google.inject.Inject;
import common.glue.utilities.Constants;
import common.glue.utilities.GeneralActions;
import di.providers.ScenarioContext;
import entity.Data;
import entity.Provider;
import entity.Room;
import entity.User;
import enums.ChatMessageType;
import enums.HostsMapping;
import enums.ProviderType;
import enums.ServiceType;
import extensions.ClientExtension;
import extensions.ResponseExtension;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.netty.handler.codec.http.HttpScheme;
import lombok.experimental.ExtensionMethod;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateUtils;
import org.apache.hc.core5.http.HttpStatus;
import org.apache.hc.core5.http.message.BasicNameValuePair;
import org.apache.hc.core5.net.URIBuilder;
import org.awaitility.Awaitility;
import org.openqa.selenium.InvalidArgumentException;

import java.io.IOException;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Date;
import java.util.EnumMap;
import java.util.Map;

import static com.google.common.net.HttpHeaders.*;
import static enums.HostsMapping.API;
import static enums.HostsMapping.THERAPIST_API;
import static javax.ws.rs.HttpMethod.PATCH;
import static javax.ws.rs.core.MediaType.APPLICATION_JSON;
import static javax.ws.rs.core.MediaType.WILDCARD;
import static net.javacrumbs.jsonunit.core.Option.IGNORING_EXTRA_FIELDS;
import static net.javacrumbs.jsonunit.fluent.JsonFluentAssert.assertThatJson;
import static org.apache.hc.client5.http.auth.StandardAuthScheme.BASIC;
import static org.assertj.core.api.Assertions.assertThat;

/**
 * User: nirtal
 * Date: 22/06/2021
 * Time: 22:39
 * Created with IntelliJ IDEA
 * <p>
 * Therapist calls.
 */
@ExtensionMethod({ClientExtension.class, ResponseExtension.class})
public class TherapistSteps {

    @Inject
    private HttpClient client;
    @Inject
    private EnumMap<HostsMapping, String> hostMapping;
    @Inject
    private ObjectMapper objectMapper;
    @Inject
    private ScenarioContext scenarioContext;
    @Inject
    private Data data;

    private String[] headers(Provider provider) {
        return new String[]{ACCEPT, WILDCARD,
                CONTENT_TYPE, APPLICATION_JSON,
                USER_AGENT, Constants.AUTOMATION_USER_AGENT,
                AUTHORIZATION, "Bearer".concat(StringUtils.SPACE).concat(provider.getLoginToken())};
    }

    /**
     * Sends an API request to customer-information with the specified map as the payload.
     * The map should represent the Customer Information fields we want to update and their new values.
     * <p>
     *
     * @param provider the {@link Provider} that will send the message
     * @param user     the {@link User} user we want to update the information of
     * @param map      the fields we want to update and the new values, to send as the body of the API request to /customer-information
     * @return HTTP response.
     * @see <a href="https://stackoverflow.com/questions/58841919/java-11-httprequest-with-patch-method/">https://stackoverflow.com/questions/58841919/java-11-httprequest-with-patch-method/a>
     * must call {@link #loginWithTherapist(Provider)}  first to get bearer in a scenario
     */
    public HttpResponse<String> setCustomerInformation(User user, Provider provider, Map<String, String> map) throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode().putPOJO("data", map);
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(THERAPIST_API))
                        .setPath("/v3/clients/%s/customer-information".formatted(user.getId()))
                        .build())
                .headers(headers(provider))
                .method(PATCH, HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * used to send messages from therapist to client could be text or offers
     * must call {@link #loginWithTherapist(Provider)}  first to get bearer in a scenario
     *
     * @param roomIndex the room index in a room list.
     * @param provider  the {@link Provider} that will send the message
     * @param user      the {@link User} user that will receive the message
     * @param text      the massage that the {@link Provider} sends to the client
     * @return HTTP response.
     */
    public HttpResponse<String> postMessage(Provider provider, User user, String text, int roomIndex) throws URISyntaxException {
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
                .headers(headers(provider))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * @param provider to login.
     * @return HTTP response.
     */
    public HttpResponse<String> loginWithTherapist(Provider provider) throws URISyntaxException {
        var requestBody = objectMapper
                .createObjectNode()
                .put("platform", "web-therapist")
                .put("userType", "THERAPIST")
                .put("version", "1.0.0");
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(THERAPIST_API))
                        .setPath("/v3/2fa/auth")
                        .build())
                .headers(ACCEPT, WILDCARD,
                        CONTENT_TYPE, APPLICATION_JSON,
                        AUTHORIZATION, BASIC + StringUtils.SPACE + GeneralActions.encodeBase64(provider.getEmail() + ":" + provider.getPassword()),
                        USER_AGENT, Constants.AUTOMATION_USER_AGENT)
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * used to retrieve parental consent information.
     * must call {@link #loginWithTherapist(Provider)} first to get bearer in a scenario
     *
     * @param provider the {@link Provider} to retrieve the details
     * @param user     the {@link User} user whose details are retrieved
     * @return HTTP response.
     */
    public HttpResponse<String> getParentalConsent(User user, Provider provider) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(THERAPIST_API))
                        .setPath("/v2/users/%s/parental-consent".formatted(user.getId()))
                        .build())
                .headers(headers(provider))
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * used to retrieve client medical information.
     * must call {@link #loginWithTherapist(Provider)} first to get bearer in a scenario
     *
     * @param provider the {@link Provider} to retrieve the details
     * @param user     the {@link User} user whose details are retrieved
     * @return HTTP response.
     */
    public HttpResponse<String> getMedicalInformation(User user, Provider provider) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(THERAPIST_API))
                        .setPath("/v3/clients/%s/medical-information".formatted(user.getId()))
                        .build())
                .headers(headers(provider))
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * Creates an additional room for an existing client.
     * Used to test the reactivation flow with clients who have two rooms.
     * Must call {@link #loginWithTherapist(Provider)}  first to get bearer in a scenario
     * <p>
     *
     * @param provider    the {@link Provider} that will add another room
     * @param user        the user that will receive an additional room.
     * @param serviceType The room type (couples/psychiatry/therapy).
     * @return HTTP response.
     */
    public HttpResponse<String> addAnotherClientRoom(ServiceType serviceType, User user, Provider provider) throws URISyntaxException {
        var requestBody = objectMapper
                .createObjectNode()
                .put("clientID", user.getId())
                .put("currentRoomID", user.getRoomsList().get(0).getId())
                .put("roomType", serviceType.getType())
                .put("therapistID", provider.getId());
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(THERAPIST_API))
                        .setPath("/api/v1/rooms")
                        .build())
                .headers(headers(provider))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * must call {@link #loginWithTherapist(Provider)} first to get bearer in a scenario
     *
     * @param provider  the {@link Provider} that will send the message
     * @param user      the {@link User} user that will receive the message
     * @param roomIndex the room index in a room list of the user where the message will be sent.
     * @return HTTP response.
     */
    public HttpResponse<String> sendEligibility(Provider provider, User user, int roomIndex) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(THERAPIST_API))
                        .setPath("/v2/rooms/%d/eligibility/message".formatted(user.getRoomsList().get(roomIndex).getId()))
                        .build())
                .headers(headers(provider))
                .POST(HttpRequest.BodyPublishers.noBody())
                .build();
        return client.logThenSend(request);
    }

    /**
     * used to retrieve client clinical information.
     * must call {@link #loginWithTherapist(Provider)} first to get bearer in a scenario
     *
     * @param provider the {@link Provider} to retrieve the details
     * @param user     the {@link User} user whose details are retrieved
     * @return HTTP response.
     */
    public HttpResponse<String> getClinicalInformation(User user, Provider provider) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(THERAPIST_API))
                        .setPath("/v3/clients/%s/clinical-information".formatted(user.getId()))
                        .build())
                .headers(headers(provider))
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * Books recurring Live Video Sessions as the specified user
     *
     * @param sessionAmount The number of sessions to book
     * @param user          The user who schedules the session
     * @param roomIndex     The index of the room in which the session is to be scheduled
     * @param provider      the {@link Provider} in the session
     * @param creditMinutes Duration of the session in minutes (like 10, 30, 60)
     * @param startTime     The starting time we want to schedule the booking for. Only call this with a valid and available timeslot.
     * @return HTTP response
     * @see <a href="https://therapist.canary.talkspace.com/room/2422725/lvs-tab">live sessions tab - replace 2422725 with the current member room id</a>
     */
    public HttpResponse<String> bookRecurringSessions(User user, int roomIndex, Provider provider, int sessionAmount, int creditMinutes, Date startTime) throws URISyntaxException {
        var roomId = user.getRoomsList().get(roomIndex).getId();
        int therapistId = user.getRoomsList().get(roomIndex).getProvider().getId();
        var sessionType = switch (creditMinutes) {
            case 10 -> "introduction";
            case 30 -> {
                if (provider.getProviderType().equals(ProviderType.PSYCHIATRIST)) {
                    yield "psychiatry";
                }
                yield "therapy";
            }
            case 45 -> "therapy";
            case 60 -> "psychiatry";
            default -> throw new IllegalStateException("Unexpected value: " + creditMinutes);
        };
        var formatter = new SimpleDateFormat(data.getApiEndpointDateFormats().get("bookings"));
        var start = formatter.format(startTime);
        var dates = new ArrayList<String>();
        dates.add(start);
        for (int i = 1; i < sessionAmount; i++) {
            dates.add(formatter.format(DateUtils.addWeeks(startTime, i)));
        }
        var requestBody = objectMapper.createObjectNode()
                .put("creditMinutes", creditMinutes)
                .put("funnelName", "In Room")
                .put("hasBreakAfterSession", false)
                .put("modality", "video")
                .put("repeatingPeriod", "every-week")
                .put("repeatingSessions", sessionAmount)
                .putPOJO("startDates", dates)
                .put("therapistUserID", therapistId)
                .put("type", sessionType);
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(THERAPIST_API))
                        .setPath("/v3/rooms/%d/repeating-bookings".formatted(roomId))
                        .build())
                .headers(headers(provider))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * must call {@link #loginWithTherapist(Provider)} first to get bearer in a scenario
     *
     * @param provider  the {@link Provider} that will send the message
     * @param user      the {@link User} user that will receive the message
     * @param roomIndex the room index in a room list of the user where the message will be sent.
     * @return HTTP response
     */
    public HttpResponse<String> sendIntake(User user, Provider provider, int roomIndex, String intakeType) throws InvalidArgumentException, URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(THERAPIST_API))
                        .setPath("/v3/rooms/%d/intake/%s".formatted(user.getRoomsList().get(roomIndex).getId(), user.getId()))
                        .setParameter("type", intakeType)
                        .build())
                .headers(headers(provider))
                .POST(HttpRequest.BodyPublishers.noBody())
                .build();
        return client.logThenSend(request);
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
                        .setHost(hostMapping.get(THERAPIST_API))
                        .setPath("/v3/rooms/%d/bookings".formatted(roomId))
                        .build())
                .headers(headers(provider))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * Gets the specified provider's available session timeslots
     *
     * @param user           The user requesting the {@link Provider} timeslots
     * @param sessionMinutes the duration of the session we want to book later (in minutes)
     * @param provider       the {@link Provider} we want to get the timeslots of
     * @return HTTP response
     */
    public HttpResponse<String> getTimeslots(int sessionMinutes, User user, int roomIndex, Provider provider) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(THERAPIST_API))
                        .setPath("/v2/therapist/%s/timeslots".formatted(provider.getId()))
                        .setParameters(
                                new BasicNameValuePair("length", "%d minutes".formatted(sessionMinutes)),
                                new BasicNameValuePair("from", "31 day"),
                                new BasicNameValuePair("to", "120 day"),
                                new BasicNameValuePair("roomID", user.getRoomsList().get(roomIndex).getId().toString()))
                        .build())
                .headers(headers(provider))
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * used to submit BH session summary notes.
     * must call {@link #loginWithTherapist(Provider)} first to get bearer in a scenario
     *
     * @param roomIndex the room index in a room list.
     * @param provider  the {@link Provider} to retrieve the details
     * @param user      the {@link User} user whose details are retrieved
     * @param cptCode   the cpt code to submit
     * @return HTTP response.
     */
    public HttpResponse<String> submitBhSessionSummaryNotes(User user, Provider provider, int roomIndex, String cptCode) throws URISyntaxException, JsonProcessingException {
        var requestBody = """
                {
                                                      "formSections": {
                                                          "sessionDateAndModality": {
                                                              "completed": true,
                                                              "open": false
                                                          },
                                                          "sessionInformation": {
                                                              "completed": true,
                                                              "open": false
                                                          },
                                                          "diagnosis": {
                                                              "completed": true,
                                                              "open": false
                                                          },
                                                          "riskAssessment": {
                                                              "completed": true,
                                                              "open": false
                                                          },
                                                          "substanceUse": {
                                                              "completed": true,
                                                              "open": false
                                                          },
                                                          "treatmentPlanProgress": {
                                                              "completed": true,
                                                              "open": false
                                                          },
                                                          "sessionSummary": {
                                                              "completed": true,
                                                              "open": false
                                                          },
                                                          "medicalInformation": {
                                                              "completed": false,
                                                              "open": false
                                                          },
                                                          "mentalStatusExam": {
                                                              "completed": false,
                                                              "open": false
                                                          },
                                                          "psychSessionSummary": {
                                                              "completed": false,
                                                              "open": false
                                                          },
                                                          "psychPlan": {
                                                              "completed": false,
                                                              "open": false
                                                          }
                                                      },
                                                      "caseID": case_id,
                                                      "sessionReportID": session_report_id,
                                                      "modalityID": 1,
                                                      "serviceStartDate": "service_start_date",
                                                      "serviceEndDate": "service_end_date",
                                                      "videoCalls": [],
                                                      "sessionAttendees": [{
                                                          "attendeeName": "test Automation",
                                                          "relationshipToClient": "Identified client",
                                                          "id": 0
                                                      }],
                                                      "sessionServiceID": cpt_code,
                                                      "diagnoses": [{
                                                          "conditionID": 632,
                                                          "isProvisionalDiagnosis": false
                                                      }],
                                                      "riskAssessment": {
                                                          "pastSuicidalIdeation": false,
                                                          "pastSuicidalIdeationSeverity": null,
                                                          "pastSuicidalIdeationNotes": null,
                                                          "currentSuicidalIdeation": false,
                                                          "currentSuicidalIdeationSeverity": null,
                                                          "currentSuicidalIdeationNotes": null,
                                                          "pastHomicidalIdeation": false,
                                                          "pastHomicidalIdeationSeverity": null,
                                                          "pastHomicidalIdeationNotes": null,
                                                          "currentHomicidalIdeation": false,
                                                          "currentHomicidalIdeationSeverity": null,
                                                          "currentHomicidalIdeationNotes": null,
                                                          "pastPsychosis": false,
                                                          "pastPsychosisNotes": null,
                                                          "currentPsychosis": false,
                                                          "currentPsychosisNotes": null,
                                                          "otherAssessment": false,
                                                          "otherAssessmentNotes": null
                                                      },
                                                      "substanceUse": {
                                                          "pastSubstanceUse": null,
                                                          "pastCigarettesUseNotes": null,
                                                          "pastVapingUseNotes": null,
                                                          "pastAlcoholUseNotes": null,
                                                          "pastMarijuanaUseNotes": null,
                                                          "pastStimulantsUseNotes": null,
                                                          "pastCocaineUseNotes": null,
                                                          "pastHeroinUseNotes": null,
                                                          "pastBenzodiazepinesUseNotes": null,
                                                          "pastOpioidsUseNotes": null,
                                                          "pastOtherSubstanceUseNotes": null,
                                                          "currentSubstanceUse": false,
                                                          "currentCigarettesUseNotes": null,
                                                          "currentVapingUseNotes": null,
                                                          "currentAlcoholUseNotes": null,
                                                          "currentMarijuanaUseNotes": null,
                                                          "currentStimulantsUseNotes": null,
                                                          "currentCocaineUseNotes": null,
                                                          "currentHeroinUseNotes": null,
                                                          "currentBenzodiazepinesUseNotes": null,
                                                          "currentOpioidsUseNotes": null,
                                                          "currentOtherSubstanceUseNotes": null
                                                      },
                                                      "medicalInformation": null,
                                                      "medicalInformationConditions": [],
                                                      "medicalInformationMedications": [],
                                                      "mentalStatusExam": null,
                                                      "treatmentPlanID": null,
                                                      "presentingProblems": [],
                                                      "treatmentPlanProgress": {
                                                          "buildRapport": true,
                                                          "shortTermTreatmentObjective": "a",
                                                          "riskOrBarriersHandling": "None reported by provider"
                                                      },
                                                      "treatmentPlanGoals": [],
                                                      "treatmentPlanObjectives": [],
                                                      "treatmentPlanInterventions": [],
                                                      "sessionSummary": {
                                                          "summary": "a",
                                                          "userRoomSurveyID": null,
                                                          "followupPlan": null,
                                                          "recommendations": null,
                                                          "presentIllnessHistory": null,
                                                          "assessment": null,
                                                          "patientReport": null
                                                      },
                                                      "psychiatryPlan": null,
                                                      "psychiatryPlanMedications": [],
                                                      "referralID": null,
                                                      "otherReferral": null,
                                                      "statementCertified": true,
                                                      "version": 2
                                                  }
                                                   """
                .replace("case_id", user.getRoomsList().get(roomIndex).getCaseId())
                .replace("cpt_code", cptCode)
                .replace("session_report_id", user.getRoomsList().get(roomIndex).getSessionReportId())
                .replace("service_start_date", scenarioContext.getSqlAndApiResults().get("service_start_date"))
                .replace("service_end_date", scenarioContext.getSqlAndApiResults().get("service_end_date"));
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(THERAPIST_API))
                        .setPath("/v2/rooms/%d/progress-notes/submit".formatted(user.getRoomsList().get(roomIndex).getId()))
                        .build())
                .headers(headers(provider))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                .build();
        return client.logThenSend(objectMapper.readValue(requestBody, ObjectNode.class), request);
    }

    /**
     * Gets the list of booked sessions in the room for the specified user
     *
     * @param user      the {@link User} user we want to get the booked sessions for
     * @param roomIndex the index of the room we want to get the bookings for in {@link User#getRoomsList()}
     * @return HTTP response
     */
    public HttpResponse<String> getSessionBookings(Provider provider, User user, int roomIndex) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(THERAPIST_API))
                        .setPath("/v3/rooms/%d/bookings".formatted(user.getRoomsList().get(roomIndex).getId()))
                        .build())
                .headers(headers(provider))
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * used to send offers from therapist to client
     * must call {@link #loginWithTherapist(Provider)} first to get bearer in a scenario
     *
     * @param provider  the {@link Provider} that will send the offer
     * @param user      the {@link User} user that will receive the offer
     * @param roomIndex the room index in a room list of the user where the offer will be sent.
     * @param planId    the plan id send to the user
     * @param offerId   the offer id send to the client
     * @return HTTP response.
     */
    public HttpResponse<String> sendOffer(int offerId, int planId, User user, Provider provider, int roomIndex) throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .putPOJO("params", Map.of(
                        "device_type", "pc",
                        "appVersion", "1",
                        "gid", user.getRoomsList().get(roomIndex).getId(),
                        "offer_id", offerId,
                        "plan_id", planId
                ));
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(API))
                        .setPath("/rest/ios/method/postMessage")
                        .build())
                .headers(headers(provider))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * used to retrieve client emergency contact details.
     * must call {@link #loginWithTherapist(Provider)} first to get bearer in a scenario
     *
     * @param provider the {@link Provider} to retrieve the details
     * @param user     the {@link User} user whose details are retrieved
     * @return HTTP response.
     */
    public HttpResponse<String> getEmergencyContactDetails(User user, Provider provider) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(THERAPIST_API))
                        .setPath("/api/v1/clients/%s/emergency-contact".formatted(user.getId()))
                        .build())
                .headers(headers(provider))
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * Cancels a booked session in the room for the specified user
     *
     * @param user      the {@link User} user we want to cancel the booking for
     * @param roomIndex the index of the room cancel the booking for in {@link User#getRoomsList()}
     * @return HTTP response
     */
    public HttpResponse<String> cancelBooking(Provider provider, User user, int roomIndex, boolean isBatchMode) throws URISyntaxException, JsonProcessingException {
        var bookingRequest = getSessionBookings(provider, user, roomIndex).log();
        assertThat(bookingRequest)
                .extracting(HttpResponse::statusCode)
                .as("Get bookings response")
                .withFailMessage(GeneralActions.failMessage(bookingRequest))
                .isEqualTo(HttpStatus.SC_OK);
        var bookingsIds = objectMapper.readTree(bookingRequest.body())
                .get("data")
                .findValuesAsText("id");
        var bookingId = bookingsIds.get(0);
        var requestBody = objectMapper.createObjectNode()
                .put("action", "cancel")
                .put("isBatchMode", isBatchMode)
                .put("reason", "providerNotAvailableProvider");
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(THERAPIST_API))
                        .setPath("/v4/rooms/%d/bookings/%s".formatted(user.getRoomsList().get(roomIndex).getId(), bookingId))
                        .build())
                .headers(headers(provider))
                .method(PATCH, HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * @param provider    the {@link Provider} in the room
     * @param user        the {@link User} user we want to cancel booked sessions for
     * @param roomIndex   the index of the room we want to cancel the bookings for
     * @param isBatchMode if we want to cancel the booking in batch mode - meaning we want to cancel all the bookings in the room
     * @throws URISyntaxException      if a string could not be parsed as a URI reference
     * @throws JsonProcessingException if an error occurs while processing the JSON.
     */
    @And("Therapist API - Cancel booking as {provider} provider with {user} user in the {optionIndex} room, batch mode {}")
    public void apiCancelBooking(Provider provider, User user, int roomIndex, boolean isBatchMode) throws URISyntaxException, JsonProcessingException {
        var response = cancelBooking(provider, user, roomIndex, isBatchMode);
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Cancel booking response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_NO_CONTENT);
    }

    /**
     * Gets the specified provider's timeslots and then books a session on the first (nearest) available timeslot
     *
     * @param sessionMinutes the duration of the session we want to book later (in minutes)
     * @param provider       the provider to book the session with
     * @param user           the user to book the session as
     * @param roomIndex      the index of the user's room to book the session in
     */
    @And("Therapist API - Schedule {int} minutes one-time session as {provider} provider with {user} user in the {optionIndex} room")
    public void apiBookOneTimeSessionWithTherapist(int sessionMinutes, Provider provider, User user, int roomIndex) throws IOException, ParseException, URISyntaxException {
        var timeslotsResponse = getTimeslots(sessionMinutes, user, roomIndex, provider).log();
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

    /**
     * Gets the specified provider's timeslots and then books a session on the first (nearest) available timeslot
     *
     * @param sessionMinutes the duration of the session we want to book later (in minutes)
     * @param provider       the provider to book the session with
     * @param user           the user to book the session as
     * @param roomIndex      the index of the user's room to book the session in
     */
    @And("Therapist API - Schedule {int} minutes {int} recurring session as {provider} provider with {user} user in the {optionIndex} room")
    public void apiBooRecurringSessionsWithTherapist(int sessionMinutes, int seesionAmount, Provider provider, User user, int roomIndex) throws IOException, ParseException, URISyntaxException {
        var timeslotsResponse = getTimeslots(sessionMinutes, user, roomIndex, provider).log();
        assertThat(timeslotsResponse)
                .extracting(HttpResponse::statusCode)
                .as("Get timeslots response")
                .withFailMessage(GeneralActions.failMessage(timeslotsResponse))
                .isEqualTo(HttpStatus.SC_OK);
        var firstTimeSlot = objectMapper.readTree(timeslotsResponse.body()).get("data").get("timeslots").get(0);
        var formatter = new SimpleDateFormat(data.getApiEndpointDateFormats().get("timeslots"));
        var timeslotStartTime = formatter.parse(firstTimeSlot.get("start").asText());
        var bookingResponse = bookRecurringSessions(user, roomIndex, provider, seesionAmount, sessionMinutes, timeslotStartTime).log();
        assertThat(bookingResponse)
                .extracting(HttpResponse::statusCode)
                .as("Book session response")
                .withFailMessage(GeneralActions.failMessage(bookingResponse))
                .isEqualTo(HttpStatus.SC_OK);
    }

    @And("Therapist API - {user} user clinical information for {provider} provider is")
    public void apiGetClinicalInformation(User user, Provider provider, ObjectNode clinicalContactDetailsExpectedResponse) throws IOException, URISyntaxException {
        var response = getClinicalInformation(user, provider).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("get user clinical information response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        assertThatJson(objectMapper.readTree(response.body()).get("data"))
                .when(IGNORING_EXTRA_FIELDS)
                .as("Clinical information Response Body")
                .isEqualTo(clinicalContactDetailsExpectedResponse);
    }

    @And("Therapist API - {user} user parental consent for {provider} provider is")
    public void apiGetParentalConsent(User user, Provider provider, ObjectNode parentalConsentDetailsExpectedResponse) throws IOException, URISyntaxException {
        var response = getParentalConsent(user, provider).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("get user clinical information response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        assertThatJson(objectMapper.readTree(response.body()).get("data"))
                .when(IGNORING_EXTRA_FIELDS)
                .as("Clinical information Response Body")
                .isEqualTo(parentalConsentDetailsExpectedResponse);
    }

    /**
     * @param user      the {@link User} user to send the offer to
     * @param offerId   the client offer id
     * @param roomIndex the index of the room in the rooms list
     * @param planId    the client plan id
     */
    @And("Therapist API - Send offer {int} of plan {int} to {user} user from {provider} provider in the {optionIndex} room")
    public void apiSendTheOfferInRoom(int offerId, int planId, User user, Provider provider, int roomIndex) throws URISyntaxException {
        var response = sendOffer(offerId, planId, user, provider, roomIndex).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Send offer response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
    }

    @And("Therapist API - Send eligibility with {provider} provider to {user} user in the {optionIndex} room")
    public void apiSendEligibilityToUser(Provider provider, User user, int roomIndex) throws URISyntaxException {
        var response = sendEligibility(provider, user, roomIndex).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("send eligibility response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_CREATED);
    }

    /**
     * @param serviceType The room type (couples/psychiatry/therapy).
     * @throws IOException if an I/O error occurs
     */
    @And("Therapist API - Add another {} room to {user} user with {provider} provider")
    public void apiAddAnotherRoomOfTypeToUser(ServiceType serviceType, User user, Provider provider) throws IOException, URISyntaxException {
        var response = addAnotherClientRoom(serviceType, user, provider).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Add Another user Room response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_CREATED);
        user.getRoomsList().add(new Room(objectMapper.readTree(response.body())
                .at("/data/id")
                .asInt(), provider));
    }

    /**
     * @param provider to login.
     * @throws IOException if an I/O error occurs
     */
    @Given("Therapist API - Login to {provider} provider")
    public void apiLoginToTherapist(Provider provider) throws IOException, URISyntaxException {
        var response = loginWithTherapist(provider).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Login to provider response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        var loginToken = objectMapper.readTree(response.body())
                .at("/data/access")
                .asText();
        assertThat(loginToken)
                .withFailMessage("Could not login to provider " + provider)
                .isNotNull()
                .isNotEmpty();
        provider.setLoginToken(loginToken);
    }

    /**
     * this method is used to submit BH session summary notes.
     * <p>
     * default room index is 0. <br>
     * default provider is therapist. <br>
     * default member is primary.
     * <p>
     * we must have the following data in scenario context:
     * service_start_date, service_end_date.
     * {@link Room#getCaseId()} and {@link Room#getSessionReportId()} are also used to submit the session summary notes.
     *
     * @param sessionSummaryData to submit.
     * @throws IOException        if an I/O error occurs
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @And("Therapist API - Submit BH messaging session summary notes")
    public void apiSubmitBhSessionSummaryNotes(Map<String, String> sessionSummaryData) throws IOException, URISyntaxException {
        var user = data.getUsers().getOrDefault(sessionSummaryData.get("member"), data.getUsers().get("primary"));
        var provider = data.getProvider().get(data.getConfiguration().getDomain()).getOrDefault(sessionSummaryData.get("provider"), data.getProvider().get(data.getConfiguration().getDomain()).get("therapist"));
        var roomIndex = Integer.parseInt(sessionSummaryData.getOrDefault("roomIndex", "0"));
        var cptCode = sessionSummaryData.get("cpt code");
        var response = submitBhSessionSummaryNotes(user, provider, roomIndex, cptCode).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Submit summery notes response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
    }

    /**
     * @param intakeType available options: matching, treatment.
     * @param user       the user that will receive the intake.
     * @param provider   the {@link Provider} that will send the intake.
     * @param roomIndex  the room index in a room list of the user where the intake will be sent.
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @And("Therapist API - Send {intakeType} intake to {user} user from {provider} provider in the {optionIndex} room")
    public void apiSendIntake(String intakeType, User user, Provider provider, int roomIndex) throws URISyntaxException {
        var response = sendIntake(user, provider, roomIndex, intakeType).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Send %s Intake response".formatted(intakeType))
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
    }

    /**
     * we are ignoring extra fields to do validation on the whole response for female, and just the pregnant field value is null for male.
     *
     * @param provider                           provider of the user
     * @param user                               the user that updated his medical information.
     * @param medicalInformationExpectedResponse the expected medical information response from the server.
     * @see <a href="https://github.com/lukas-krecan/JsonUnit#ignoreelements">JsonUnit - ignoreelements</a>
     */
    @And("Therapist API - {user} user medical information for {provider} provider is")
    public void apiGetMedicalInformation(User user, Provider provider, ObjectNode medicalInformationExpectedResponse) {
        Awaitility
                .await()
                .alias("get user medical information response")
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() ->
                {
                    var response = getMedicalInformation(user, provider).log();
                    assertThat(response)
                            .extracting(HttpResponse::statusCode)
                            .as("get medical information response")
                            .withFailMessage(GeneralActions.failMessage(response))
                            .isEqualTo(HttpStatus.SC_OK);
                    assertThatJson(objectMapper.readTree(response.body()).get("data"))
                            .as("medical information Response Body")
                            .when(IGNORING_EXTRA_FIELDS)
                            .isEqualTo(medicalInformationExpectedResponse);
                });
    }

    /**
     * Sends a message from the provider to the specified user.
     *
     * @param amount          The number of messages to send
     * @param roomIndex       The room index to send the message to
     * @param chatMessageType message type to send.
     * @param provider        the {@link Provider} that will send the message
     * @param user            the user that will receive the message
     * @throws URISyntaxException if a string could not be parsed as a URI reference
     */
    @And("Therapist API - Send {int} {} message as {provider} provider to {user} user in the {optionIndex} room")
    public void apiSendMessageAsTherapist(int amount, ChatMessageType chatMessageType, Provider provider, User user, int roomIndex) throws URISyntaxException {
        for (int i = 0; i < amount; i++) {
            switch (chatMessageType) {
                case URL -> scenarioContext.setChatMessage(data.getCharacters().get("url"));
                case LINE_BREAK ->
                        scenarioContext.setChatMessage(RandomStringUtils.randomAlphabetic(3) + System.lineSeparator() + RandomStringUtils.randomAlphabetic(3));
                case VALID_RANDOM -> scenarioContext.setChatMessage(RandomStringUtils.randomAlphabetic(3));
                case SPECIAL_CHARACTER -> scenarioContext.setChatMessage(data.getCharacters().get("specialCharacters"));
                default -> throw new IllegalStateException("Unexpected value: " + chatMessageType);
            }
            var response = postMessage(provider, user, scenarioContext.getChatMessage(), roomIndex)
                    .log();
            assertThat(response)
                    .extracting(HttpResponse::statusCode)
                    .as("Send message response")
                    .withFailMessage(GeneralActions.failMessage(response))
                    .isEqualTo(HttpStatus.SC_OK);
        }
    }

    @And("Therapist API - {user} user of {provider} provider emergency contact details are")
    public void apiGetEmergencyContactDetails(User user, Provider provider, ObjectNode emergencyContactDetailsExpectedResponse) throws IOException, URISyntaxException {
        var response = getEmergencyContactDetails(user, provider).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("get user emergency contact details response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        assertThatJson(objectMapper.readTree(response.body()).get("data"))
                .as("Emergency contact details Response Body")
                .when(IGNORING_EXTRA_FIELDS)
                .isEqualTo(emergencyContactDetailsExpectedResponse);
    }

    /**
     * Change client details, must call {@link #apiLoginToTherapist(Provider)} before.
     *
     * @param provider the {@link Provider} that will update user information.
     * @param user     the {@link User} user whose details will be updated.
     * @param map      details to update
     */
    @And("Therapist API - Set {user} user Information with {provider} provider")
    public void apiSetCustomerInformation(User user, Provider provider, Map<String, String> map) throws URISyntaxException {
        var response = setCustomerInformation(user, provider, map).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("get customer-information response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_NO_CONTENT);
    }
}
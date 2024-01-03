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
import entity.User;
import enums.Domain;
import enums.HostsMapping;
import enums.Us_States;
import extensions.ClientExtension;
import extensions.ResponseExtension;
import io.cucumber.java.en.Given;
import io.netty.handler.codec.http.HttpScheme;
import jakarta.inject.Named;
import lombok.experimental.ExtensionMethod;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateUtils;
import org.apache.hc.core5.http.HttpStatus;
import org.apache.hc.core5.net.URIBuilder;
import org.assertj.core.api.Assertions;

import java.io.IOException;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.util.Date;
import java.util.EnumMap;
import java.util.Optional;
import java.util.stream.StreamSupport;

import static com.google.common.net.HttpHeaders.*;
import static enums.HostsMapping.WEBHOOKS;
import static javax.ws.rs.core.MediaType.APPLICATION_JSON;
import static javax.ws.rs.core.MediaType.WILDCARD;
import static javax.ws.rs.core.Response.Status;
import static net.javacrumbs.jsonunit.fluent.JsonFluentAssert.assertThatJson;
import static org.apache.hc.client5.http.auth.StandardAuthScheme.BASIC;
import static org.assertj.core.api.Assertions.assertThat;

/**
 * User: nirtal
 * Date: 18/12/2023
 * Time: 13:53
 * Created with IntelliJ IDEA
 */
@ExtensionMethod({ClientExtension.class, ResponseExtension.class})
public class ZocDocSteps {
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
    @Inject
    @Named("zocdoc_api_secret")
    private String zocdocApiSecret;
    @Inject
    @Named("zocdoc_api_user")
    private String zocdocApiUser;

    private String[] headers() {
        return new String[]{ACCEPT, WILDCARD,
                CONTENT_TYPE, APPLICATION_JSON,
                USER_AGENT, Constants.AUTOMATION_USER_AGENT,
                AUTHORIZATION, "Bearer".concat(StringUtils.SPACE).concat(scenarioContext.getZocdocToken())};
    }

    /**
     * authenticate to zocdoc api
     *
     * @return HTTP response.
     */
    public HttpResponse<String> login() throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .put("grant_type", "client_credentials");
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(WEBHOOKS))
                        .setPath("/v1/zocdoc/oauth2/access_token")
                        .build())
                .timeout(Duration.ofSeconds(20))
                .headers(ACCEPT, WILDCARD,
                        USER_AGENT, Constants.AUTOMATION_USER_AGENT,
                        CONTENT_TYPE, APPLICATION_JSON,
                        AUTHORIZATION, BASIC + StringUtils.SPACE + GeneralActions.encodeBase64(zocdocApiUser + ":" + zocdocApiSecret))
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * create patient
     *
     * @param user the user to create the patient for
     * @return HTTP response.
     */
    public HttpResponse<String> createPatient(User user) throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .put("email_address", user.getEmail())
                .put("first_name", user.getFirstName())
                .put("last_name", user.getLastName())
                .put("date_of_birth", "1984-01-25")
                .put("phone_number", "216-245-2368")
                .put("gender", "F")
                .put("insurance_carrier", "Cigna")
                .put("insurance_plan", "bla bla")
                .put("insurance_member_id", "123456");
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(WEBHOOKS))
                        .setPath("/v1/zocdoc/patients")
                        .build())
                .timeout(Duration.ofSeconds(20))
                .headers(headers())
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * search patient
     *
     * @param user the user to search the patient for
     * @return HTTP response.
     */
    public HttpResponse<String> searchPatient(User user) throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .put("email_address", user.getEmail())
                .put("first_name", user.getFirstName())
                .put("last_name", user.getLastName())
                .put("date_of_birth", "1984-01-25");
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(WEBHOOKS))
                        .setPath("/v1/zocdoc/patients/search")
                        .build())
                .timeout(Duration.ofSeconds(20))
                .headers(headers())
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * cancel appointment
     *
     * @param provider the provider to cancel the appointment for
     * @return HTTP response.
     */
    public HttpResponse<String> cancelAppointment(Provider provider, String appointmentId) throws URISyntaxException {
        var requestBody = objectMapper.createObjectNode()
                .put("appointment_id", appointmentId)
                .put("patient_id", "22")
                .put("provider_id", String.valueOf(provider.getId()))
                .put("start_time", "2023-12-10T09:15:00+00:00")
                .put("duration", 45)
                .put("schedulable_resource_id", "DUMMYID")
                .put("visit_reason_id", "1")
                .put("location_id", "HI");
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(WEBHOOKS))
                        .setPath("/v1/zocdoc/appointments/cancel")
                        .build())
                .headers(headers())
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(requestBody, request);
    }

    /**
     * get providers
     *
     * @return HTTP response.
     */
    public HttpResponse<String> getProviders() throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(WEBHOOKS))
                        .setPath("/v1/zocdoc/providers")
                        .build())
                .headers(headers())
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * get provider timeslots
     *
     * @param provider the provider to get the timeslots for
     * @return HTTP response.
     * @throws URISyntaxException if the URI is invalid
     */
    public HttpResponse<String> getProviderTimeslots(Provider provider) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(WEBHOOKS))
                        .setPath("/v1/zocdoc/available_slots/by_provider")
                        .setParameter("provider_id", String.valueOf(provider.getId()))
                        .setParameter("start_date", new SimpleDateFormat("yyyy-MM-dd").format(new Date()))
                        .setParameter("end_date", new SimpleDateFormat("yyyy-MM-dd").format(DateUtils.addDays(new Date(), 7)))
                        .build())
                .headers(headers())
                .GET()
                .build();
        return client.logThenSend(request);
    }

    /**
     * get provider appointments
     * in case no user is provided, a test double patient will be used.
     * in case no provider is provided, a test double provider will be used.
     * in case no start time is provided, a test double start time will be used in 7 days from now.
     *
     * @param provider         the provider to get the appointments for
     * @param usStates         the US state to get the appointments for
     * @param user             the user to get the appointments for
     * @param insuranceCarrier the insurance carrier to get the appointments for
     * @param duration         the duration to get the appointments for - we only support 45 minutes
     * @return HTTP response.
     * @throws URISyntaxException if the URI is invalid
     */
    public HttpResponse<String> createAppointment(Provider provider, User user, Us_States usStates, String insuranceCarrier, int duration) throws URISyntaxException {
        var userId = Optional.ofNullable(user)
                .map(User::getZocdocPatientId)
                .orElse("DUMMYID");
        var providerId = Optional.ofNullable(provider)
                .map(Provider::getId)
                .orElse(55555);
        var startTime = Optional.ofNullable(scenarioContext.getSqlAndApiResults().get("start_time"))
                .orElse("%sT12:15:00+00:00".formatted(new SimpleDateFormat("yyyy-MM-dd").format(DateUtils.addDays(new Date(), 7))));
        var requestBody = objectMapper.createObjectNode()
                .put("patient_id", userId)
                .put("provider_id", String.valueOf(providerId))
                .put("start_time", startTime)
                .put("duration", duration)
                .put("schedulable_resource_id", "DUMMYID")
                .put("visit_reason_id", "1")
                .put("location_id", usStates.getAbbreviation())
                .put("insurance_carrier", insuranceCarrier)
                .put("insurance_plan", "bla bla")
                .put("insurance_member_id", "123456")
                .put("patient_address1", "123 East Main St.")
                .put("patient_address2", "Unit B")
                .put("patient_city", "New York")
                .put("patient_state", "NY")
                .put("patient_zip", "100001")
                .put("notes", "bla bla bla");
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(WEBHOOKS))
                        .setPath("/v1/zocdoc/appointments")
                        .build())
                .headers(headers())
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();
        return client.logThenSend(request);
    }

    /**
     * get provider appointments
     *
     * @param appointmentId the appointment id to get the appointments for
     * @return HTTP response.
     * @throws URISyntaxException if the URI is invalid
     */
    public HttpResponse<String> getProviderAppointments(String appointmentId) throws URISyntaxException {
        var request = HttpRequest.newBuilder(new URIBuilder()
                        .setScheme(HttpScheme.HTTPS.toString())
                        .setHost(hostMapping.get(WEBHOOKS))
                        .setPath("/v1/zocdoc/appointments/by_ids")
                        .build())
                .headers(headers())
                .POST(HttpRequest.BodyPublishers.ofString(appointmentId))
                .build();
        return client.logThenSend(request);
    }

    /**
     * Login to zocdoc api
     *
     * @throws IOException if an I/O error occurs
     */
    @Given("Zocdoc API - Store returning therapist id")
    public void apiVerifyUser() throws IOException, URISyntaxException {
        var response = getProviders().log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Login to zocdoc response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        scenarioContext.setZocdocTherapistIds(objectMapper.readValue(response.body(), int[].class));
    }

    /**
     * Login to zocdoc api
     *
     * @throws IOException if an I/O error occurs
     */
    @Given("Zocdoc API - Login to client")
    public void apiLoginToUser() throws IOException, URISyntaxException {
        var response = login().log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Login to zocdoc response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(HttpStatus.SC_OK);
        var jsonResponse = objectMapper.readTree(response.body());
        scenarioContext.setZocdocToken(jsonResponse.get("access_token").asText());
    }

    /**
     * @param user               the user to search the patient for
     * @param expectedStatusCode the expected status code
     * @throws URISyntaxException if the URI is invalid
     */
    @Given("Zocdoc API - Search patient with details of {user} user should return {} status code")
    public void apiSearchPatient(User user, Status expectedStatusCode) throws URISyntaxException {
        var response = searchPatient(user).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Create patient response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(expectedStatusCode.getStatusCode());
    }

    /**
     * @param appointmentStatus  the appointment status to cancel - could be canceled or non-existing
     * @param provider           the provider to cancel the appointment for
     * @param expectedStatusCode the expected status code
     * @throws URISyntaxException if the URI is invalid
     */
    @Given("Zocdoc API - Cancel {string} appointment for {provider} provider should return {} status code")
    public void apiCancelNonExistingAppointment(String appointmentStatus, Provider provider, Status expectedStatusCode, ObjectNode message) throws URISyntaxException, JsonProcessingException {
        String appointmentId = null;
        if (appointmentStatus.equals("cancelled")) {
            if (data.getConfiguration().getDomain().equals(Domain.DEV.getName()))
                appointmentId = "534327b5-9dee-43f0-91eb-08a1e0a28b92";
            else if (data.getConfiguration().getDomain().equals(Domain.CANARY.getName())) {
                appointmentId = "4a5ae914-ee84-4fe3-8ac2-408d9aaf8fa3";
            }
        } else if (appointmentStatus.equals("non existing")) {
            appointmentId = "asdas";
        }
        var response = cancelAppointment(provider, appointmentId).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Create patient response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(expectedStatusCode.getStatusCode());
        assertThatJson(objectMapper.readTree(response.body()))
                .as("Response body")
                .isEqualTo(message);
    }

    /**
     * @param user               the user to create the patient for
     * @param provider           the provider to cancel the appointment for
     * @param expectedStatusCode the expected status code
     * @throws URISyntaxException if the URI is invalid
     */
    @Given("Zocdoc API - Cancel existing appointment of {user} user to {provider} provider in {} should return {} status code")
    public void apiCancelExistingAppointment(User user, Provider provider, Us_States usStates, Status expectedStatusCode, ObjectNode message) throws URISyntaxException, JsonProcessingException {
        var cancelAppointmentResponse = cancelAppointment(provider, apiCreateAppointment(user, provider, usStates, expectedStatusCode)).log();
        assertThat(cancelAppointmentResponse)
                .extracting(HttpResponse::statusCode)
                .as("Cancel appointment response")
                .withFailMessage(GeneralActions.failMessage(cancelAppointmentResponse))
                .isEqualTo(HttpStatus.SC_OK);
        assertThatJson(objectMapper.readTree(cancelAppointmentResponse.body()))
                .as("Response body")
                .isEqualTo(message);
    }

    /**
     * @param user     the user to create the patient for
     * @param provider the provider to cancel the appointment for
     * @throws URISyntaxException if the URI is invalid
     */
    @Given("Zocdoc API - Create appointment to {user} user with {provider} provider in {}")
    public void apiCancelExistingAppointment(User user, Provider provider, Us_States usStates) throws URISyntaxException, JsonProcessingException {
        apiCreateAppointment(user, provider, usStates, Status.OK);
    }

    /**
     * @param user               the user to create the patient for
     * @param provider           the provider to cancel the appointment for
     * @param expectedStatusCode the expected status code
     * @throws URISyntaxException if the URI is invalid
     */
    public String apiCreateAppointment(User user, Provider provider, Us_States usStates, Status expectedStatusCode) throws URISyntaxException, JsonProcessingException {
        var createPatientResponse = createPatient(user).log();
        assertThat(createPatientResponse)
                .extracting(HttpResponse::statusCode)
                .as("Create patient response")
                .withFailMessage(GeneralActions.failMessage(createPatientResponse))
                .isEqualTo(expectedStatusCode.getStatusCode());
        user.setZocdocPatientId(objectMapper.readTree(createPatientResponse.body()).get("patient_id").asText());
        var getProviderTimeslotsResponse = getProviderTimeslots(provider).log();
        assertThat(getProviderTimeslotsResponse)
                .extracting(HttpResponse::statusCode)
                .as("Get provider timeslots response")
                .withFailMessage(GeneralActions.failMessage(getProviderTimeslotsResponse))
                .isEqualTo(HttpStatus.SC_OK);
        scenarioContext.getSqlAndApiResults().put("start_time", StreamSupport.stream(objectMapper.readTree(getProviderTimeslotsResponse.body()).spliterator(), false)
                .filter(timeslot -> timeslot.get("location_id").asText().equals(usStates.getAbbreviation()))
                .findFirst()
                .orElseThrow()
                .get("start_time")
                .asText());
        var createAppointmentResponse = createAppointment(provider, user, usStates, "Cigna", 45).log();
        assertThat(createAppointmentResponse)
                .extracting(HttpResponse::statusCode)
                .as("Create appointment response")
                .withFailMessage(GeneralActions.failMessage(createAppointmentResponse))
                .isEqualTo(HttpStatus.SC_OK);
        var appointmentId = objectMapper.readTree(createAppointmentResponse.body()).get("appointment_id").asText();
        var getProviderAppointmentsResponse = getProviderAppointments(String.valueOf(objectMapper.createArrayNode()
                .add(objectMapper.createObjectNode()
                        .put("appointment_id", appointmentId))))
                .log();
        assertThat(getProviderAppointmentsResponse)
                .extracting(HttpResponse::statusCode)
                .as("Get provider appointments response")
                .withFailMessage(GeneralActions.failMessage(getProviderAppointmentsResponse))
                .isEqualTo(HttpStatus.SC_OK);
        Assertions.assertThat(objectMapper.readTree(getProviderAppointmentsResponse.body()).size())
                .as("Number of appointments")
                .isEqualTo(1);
        Assertions.assertThat(objectMapper.readTree(getProviderAppointmentsResponse.body()).get(0).get("appointment_status_id").asText())
                .as("Appointment status")
                .isEqualTo("tentative");
        Assertions.assertThat(objectMapper.readTree(getProviderAppointmentsResponse.body()).get(0).get("patient_id").asText())
                .as("patient_id")
                .isEqualTo(user.getZocdocPatientId());
        return appointmentId;
    }

    /**
     * @param user               the user to create the patient for
     * @param expectedStatusCode the expected status code
     * @throws URISyntaxException if the URI is invalid
     */
    @Given("Zocdoc API - Create appointment to {user} user with dummy provider in {} should return {} status code")
    public void apiCreateAppointmentNonExistingProvider(User user, Us_States usStates, Status expectedStatusCode, ObjectNode message) throws URISyntaxException, JsonProcessingException {
        var createPatientResponse = createPatient(user).log();
        assertThat(createPatientResponse)
                .extracting(HttpResponse::statusCode)
                .as("Create patient response")
                .withFailMessage(GeneralActions.failMessage(createPatientResponse))
                .isEqualTo(HttpStatus.SC_OK);
        user.setZocdocPatientId(objectMapper.readTree(createPatientResponse.body()).get("patient_id").asText());
        var createAppointmentResponse = createAppointment(null, user, usStates, "Cigna", 45).log();
        assertThatJson(objectMapper.readTree(createAppointmentResponse.body()))
                .as("Response body")
                .isEqualTo(message);
    }

    /**
     * @param user               the user to create the patient for
     * @param provider           the provider to cancel the appointment for
     * @param expectedStatusCode the expected status code
     * @throws URISyntaxException if the URI is invalid
     */
    @Given("Zocdoc API - Create 2 appointment for {user} user to {provider} provider in {} should return {} status code")
    public void apiDoubleBooking(User user, Provider provider, Us_States usStates, Status expectedStatusCode, ObjectNode message) throws URISyntaxException, JsonProcessingException {
        var createPatientResponse = createPatient(user).log();
        assertThat(createPatientResponse)
                .extracting(HttpResponse::statusCode)
                .as("Create patient response")
                .withFailMessage(GeneralActions.failMessage(createPatientResponse))
                .isEqualTo(HttpStatus.SC_OK);
        user.setZocdocPatientId(objectMapper.readTree(createPatientResponse.body()).get("patient_id").asText());
        var getProviderTimeslotsResponse = getProviderTimeslots(provider).log();
        assertThat(getProviderTimeslotsResponse)
                .extracting(HttpResponse::statusCode)
                .as("Get provider timeslots response")
                .withFailMessage(GeneralActions.failMessage(getProviderTimeslotsResponse))
                .isEqualTo(HttpStatus.SC_OK);
        scenarioContext.getSqlAndApiResults().put("start_time", StreamSupport.stream(objectMapper.readTree(getProviderTimeslotsResponse.body()).spliterator(), false)
                .filter(timeslot -> timeslot.get("location_id").asText().equals(usStates.getAbbreviation()))
                .findFirst()
                .orElseThrow()
                .get("start_time")
                .asText());
        var createAppointmentResponse = createAppointment(provider, user, usStates, "Cigna", 45).log();
        assertThat(createAppointmentResponse)
                .extracting(HttpResponse::statusCode)
                .as("Create appointment response")
                .withFailMessage(GeneralActions.failMessage(createAppointmentResponse))
                .isEqualTo(HttpStatus.SC_OK);
        var appointmentId = objectMapper.readTree(createAppointmentResponse.body()).get("appointment_id").asText();
        var getProviderAppointmentsResponse = getProviderAppointments(String.valueOf(objectMapper.createArrayNode()
                .add(objectMapper.createObjectNode()
                        .put("appointment_id", appointmentId))))
                .log();
        assertThat(getProviderAppointmentsResponse)
                .extracting(HttpResponse::statusCode)
                .as("Get provider appointments response")
                .withFailMessage(GeneralActions.failMessage(getProviderAppointmentsResponse))
                .isEqualTo(HttpStatus.SC_OK);
        Assertions.assertThat(objectMapper.readTree(getProviderAppointmentsResponse.body()).size())
                .as("Number of appointments")
                .isEqualTo(1);
        Assertions.assertThat(objectMapper.readTree(getProviderAppointmentsResponse.body()).get(0).get("appointment_status_id").asText())
                .as("Appointment status")
                .isEqualTo("tentative");
        Assertions.assertThat(objectMapper.readTree(getProviderAppointmentsResponse.body()).get(0).get("patient_id").asText())
                .as("patient_id")
                .isEqualTo(user.getZocdocPatientId());
        getProviderTimeslotsResponse = getProviderTimeslots(provider).log();
        assertThat(getProviderTimeslotsResponse)
                .extracting(HttpResponse::statusCode)
                .as("Get provider timeslots response")
                .withFailMessage(GeneralActions.failMessage(getProviderTimeslotsResponse))
                .isEqualTo(HttpStatus.SC_OK);
        scenarioContext.getSqlAndApiResults().put("start_time", StreamSupport.stream(objectMapper.readTree(getProviderTimeslotsResponse.body()).spliterator(), false)
                .filter(timeslot -> timeslot.get("location_id").asText().equals(usStates.getAbbreviation()))
                .findFirst()
                .orElseThrow()
                .get("start_time")
                .asText());
        createAppointmentResponse = createAppointment(provider, user, usStates, "Cigna", 45).log();
        assertThat(createAppointmentResponse)
                .extracting(HttpResponse::statusCode)
                .as("Create appointment response")
                .withFailMessage(GeneralActions.failMessage(createAppointmentResponse))
                .isEqualTo(expectedStatusCode.getStatusCode());
        assertThatJson(objectMapper.readTree(createAppointmentResponse.body()))
                .as("Response body")
                .isEqualTo(message);
    }

    /**
     * @param provider           the provider to cancel the appointment for
     * @param expectedStatusCode the expected status code
     * @throws URISyntaxException if the URI is invalid
     */
    @Given("Zocdoc API - Create appointment to {provider} provider with dummy patient in {} should return {} status code")
    public void apiCreateAppointmentNonExistingPatient(Provider provider, Us_States usStates, Status expectedStatusCode, ObjectNode message) throws URISyntaxException, JsonProcessingException {
        var getProviderTimeslotsResponse = getProviderTimeslots(provider).log();
        assertThat(getProviderTimeslotsResponse)
                .extracting(HttpResponse::statusCode)
                .as("Get provider timeslots response")
                .withFailMessage(GeneralActions.failMessage(getProviderTimeslotsResponse))
                .isEqualTo(HttpStatus.SC_OK);
        scenarioContext.getSqlAndApiResults().put("start_time", StreamSupport.stream(objectMapper.readTree(getProviderTimeslotsResponse.body()).spliterator(), false)
                .filter(timeslot -> timeslot.get("location_id").asText().equals(usStates.getAbbreviation()))
                .findFirst()
                .orElseThrow()
                .get("start_time")
                .asText());
        var createAppointmentResponse = createAppointment(provider, null, usStates, "Cigna", 45).log();
        assertThat(createAppointmentResponse)
                .extracting(HttpResponse::statusCode)
                .as("Create appointment response")
                .withFailMessage(GeneralActions.failMessage(createAppointmentResponse))
                .isEqualTo(expectedStatusCode.getStatusCode());
        assertThatJson(objectMapper.readTree(createAppointmentResponse.body()))
                .as("Response body")
                .isEqualTo(message);
    }

    /**
     * mismatch between provider and patient state should - meeting should not be created
     *
     * @param provider           the provider to cancel the appointment for
     * @param expectedStatusCode the expected status code
     * @throws URISyntaxException if the URI is invalid
     */
    @Given("Zocdoc API - Create appointment for {user} user in {} to {provider} provider in {} should return {} status code")
    public void apiCreateAppointmentNonMatchingState(User user, Us_States patientState, Provider provider, Us_States providerState, Status expectedStatusCode, ObjectNode message) throws URISyntaxException, JsonProcessingException {
        var createPatientResponse = createPatient(user).log();
        assertThat(createPatientResponse)
                .extracting(HttpResponse::statusCode)
                .as("Create patient response")
                .withFailMessage(GeneralActions.failMessage(createPatientResponse))
                .isEqualTo(HttpStatus.SC_OK);
        user.setZocdocPatientId(objectMapper.readTree(createPatientResponse.body()).get("patient_id").asText());
        var getProviderTimeslotsResponse = getProviderTimeslots(provider).log();
        assertThat(getProviderTimeslotsResponse)
                .extracting(HttpResponse::statusCode)
                .as("Get provider timeslots response")
                .withFailMessage(GeneralActions.failMessage(getProviderTimeslotsResponse))
                .isEqualTo(HttpStatus.SC_OK);
        scenarioContext.getSqlAndApiResults().put("start_time", StreamSupport.stream(objectMapper.readTree(getProviderTimeslotsResponse.body()).spliterator(), false)
                .filter(timeslot -> timeslot.get("location_id").asText().equals(patientState.getAbbreviation()))
                .findFirst()
                .orElseThrow()
                .get("start_time")
                .asText());
        var createAppointmentResponse = createAppointment(provider, user, providerState, "Cigna", 45).log();
        assertThat(createAppointmentResponse)
                .extracting(HttpResponse::statusCode)
                .as("Create appointment response")
                .withFailMessage(GeneralActions.failMessage(createAppointmentResponse))
                .isEqualTo(expectedStatusCode.getStatusCode());
        assertThatJson(objectMapper.readTree(createAppointmentResponse.body()))
                .as("Response body")
                .isEqualTo(message);
    }

    /**
     * @param provider           the provider to cancel the appointment for
     * @param expectedStatusCode the expected status code
     * @throws URISyntaxException if the URI is invalid
     */
    @Given("Zocdoc API - Create appointment to {provider} provider with dummy insurance carrier details for {user} user in {} should return {} status code")
    public void apiCreateAppointmentNonExistingInsuranceCarrier(Provider provider, User user, Us_States usStates, Status expectedStatusCode, ObjectNode message) throws URISyntaxException, JsonProcessingException {
        var createPatientResponse = createPatient(user).log();
        assertThat(createPatientResponse)
                .extracting(HttpResponse::statusCode)
                .as("Create patient response")
                .withFailMessage(GeneralActions.failMessage(createPatientResponse))
                .isEqualTo(HttpStatus.SC_OK);
        user.setZocdocPatientId(objectMapper.readTree(createPatientResponse.body()).get("patient_id").asText());
        var getProviderTimeslotsResponse = getProviderTimeslots(provider).log();
        assertThat(getProviderTimeslotsResponse)
                .extracting(HttpResponse::statusCode)
                .as("Get provider timeslots response")
                .withFailMessage(GeneralActions.failMessage(getProviderTimeslotsResponse))
                .isEqualTo(HttpStatus.SC_OK);
        scenarioContext.getSqlAndApiResults().put("start_time", StreamSupport.stream(objectMapper.readTree(getProviderTimeslotsResponse.body()).spliterator(), false)
                .filter(timeslot -> timeslot.get("location_id").asText().equals(usStates.getAbbreviation()))
                .findFirst()
                .orElseThrow()
                .get("start_time")
                .asText());
        var createAppointmentResponse = createAppointment(provider, user, usStates, "Cigna1233", 45).log();
        assertThat(createAppointmentResponse)
                .extracting(HttpResponse::statusCode)
                .as("Create appointment response")
                .withFailMessage(GeneralActions.failMessage(createAppointmentResponse))
                .isEqualTo(expectedStatusCode.getStatusCode());
        assertThatJson(objectMapper.readTree(createAppointmentResponse.body()))
                .as("Response body")
                .isEqualTo(message);
    }

    /**
     * @param provider           the provider to cancel the appointment for
     * @param expectedStatusCode the expected status code
     * @throws URISyntaxException if the URI is invalid
     */
    @Given("Zocdoc API - Create appointment to {provider} provider with invalid duration for {user} user in {} should return {} status code")
    public void apiCreateAppointmentInvalidDuration(Provider provider, User user, Us_States usStates, Status expectedStatusCode, ObjectNode message) throws URISyntaxException, JsonProcessingException {
        var createPatientResponse = createPatient(user).log();
        assertThat(createPatientResponse)
                .extracting(HttpResponse::statusCode)
                .as("Create patient response")
                .withFailMessage(GeneralActions.failMessage(createPatientResponse))
                .isEqualTo(HttpStatus.SC_OK);
        user.setZocdocPatientId(objectMapper.readTree(createPatientResponse.body()).get("patient_id").asText());
        var getProviderTimeslotsResponse = getProviderTimeslots(provider).log();
        assertThat(getProviderTimeslotsResponse)
                .extracting(HttpResponse::statusCode)
                .as("Get provider timeslots response")
                .withFailMessage(GeneralActions.failMessage(getProviderTimeslotsResponse))
                .isEqualTo(HttpStatus.SC_OK);
        scenarioContext.getSqlAndApiResults().put("start_time", StreamSupport.stream(objectMapper.readTree(getProviderTimeslotsResponse.body()).spliterator(), false)
                .filter(timeslot -> timeslot.get("location_id").asText().equals(usStates.getAbbreviation()))
                .findFirst()
                .orElseThrow()
                .get("start_time")
                .asText());
        var createAppointmentResponse = createAppointment(provider, user, usStates, "Cigna1233", 30).log();
        assertThat(createAppointmentResponse)
                .extracting(HttpResponse::statusCode)
                .as("Create appointment response")
                .withFailMessage(GeneralActions.failMessage(createAppointmentResponse))
                .isEqualTo(expectedStatusCode.getStatusCode());
        assertThatJson(objectMapper.readTree(createAppointmentResponse.body()))
                .as("Response body")
                .isEqualTo(message);
    }

    /**
     * we are deducting 7 days from the start date to make sure the appointment start date is in the past and is invalid
     *
     * @param provider           the provider to cancel the appointment for
     * @param expectedStatusCode the expected status code
     * @throws URISyntaxException if the URI is invalid
     */
    @Given("Zocdoc API - Create appointment to {provider} provider with invalid start date for {user} user in {} should return {} status code")
    public void apiCreateAppointmentInvalidStartDate(Provider provider, User user, Us_States usStates, Status expectedStatusCode, ObjectNode message) throws URISyntaxException, JsonProcessingException, ParseException {
        var createPatientResponse = createPatient(user).log();
        assertThat(createPatientResponse)
                .extracting(HttpResponse::statusCode)
                .as("Create patient response")
                .withFailMessage(GeneralActions.failMessage(createPatientResponse))
                .isEqualTo(HttpStatus.SC_OK);
        user.setZocdocPatientId(objectMapper.readTree(createPatientResponse.body()).get("patient_id").asText());
        scenarioContext.getSqlAndApiResults().put("start_time", "2022-12-30T11:15:00+00:00");
        var createAppointmentResponse = createAppointment(provider, user, usStates, "Cigna", 45).log();
        assertThat(createAppointmentResponse)
                .extracting(HttpResponse::statusCode)
                .as("Create appointment response")
                .withFailMessage(GeneralActions.failMessage(createAppointmentResponse))
                .isEqualTo(expectedStatusCode.getStatusCode());
        assertThatJson(objectMapper.readTree(createAppointmentResponse.body()))
                .as("Response body")
                .isEqualTo(message);
    }

    /**
     * @param user               the user to create the patient for
     * @param expectedStatusCode the expected status code
     * @throws URISyntaxException if the URI is invalid
     */
    @Given("Zocdoc API - Create patient with details of {user} user should return {} status code")
    public void apiCreatePatient(User user, Status expectedStatusCode) throws URISyntaxException {
        var response = createPatient(user).log();
        assertThat(response)
                .extracting(HttpResponse::statusCode)
                .as("Create patient response")
                .withFailMessage(GeneralActions.failMessage(response))
                .isEqualTo(expectedStatusCode.getStatusCode());
    }
}

package glue.steps.db;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.util.concurrent.Uninterruptibles;
import com.google.inject.Inject;
import common.glue.utilities.GeneralActions;
import di.providers.ScenarioContext;
import entity.Data;
import entity.User;
import enums.Domain;
import enums.data.RoomStatus;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.qameta.allure.Allure;
import org.apache.commons.lang3.StringUtils;
import org.awaitility.Awaitility;
import org.jdbi.v3.core.Jdbi;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * User: nirtal
 * Date: 08/02/2023
 * Time: 13:28
 * Created with IntelliJ IDEA
 * <p>
 * DB testing will not run on prod
 *
 * @see <a href="https://jdbi.org/">Jdbi 3 Developer Guide</a>
 * @see <a href="https://stackoverflow.com/a/67969576/4515129">Communications link failure on circle are resolved with adding ?enabledTLSProtocols=TLSv1.2 to connaction string</a>
 */
public class DbSteps {

    @Inject
    protected ScenarioContext scenarioContext;
    @Inject
    private Jdbi jdbi;
    @Inject
    private Data data;
    @Inject
    private ObjectMapper objectMapper;

    /**
     * @deprecated will be replaced with native sql queries
     */
    @Deprecated(since = "2023-12-24", forRemoval = true)
    @Given("DB - SELECT {string} FROM {string} WHERE {string} is")
    public void validateData(String colum, String table, String condition, List<String> expectedValues) {
        var query = "SELECT %s FROM %s WHERE %s".formatted(colum, table, GeneralActions.replacePlaceholders(condition, scenarioContext));
        Allure.addAttachment("Query", query);
        Awaitility
                .await()
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var queryResult = jdbi.withHandle(handle ->
                            handle.select(query)
                                    .mapTo(String.class)
                                    .list());
                    Allure.addAttachment("Query Result", StringUtils.join(expectedValues, System.lineSeparator()));
                    assertThat(queryResult)
                            .as(query)
                            .isEqualTo(expectedValues);
                });
    }

    /**
     * This code performs an update on a database table by calling the executed method on the JDBI handle.
     *
     * @param table     table name to update
     * @param newValue  new value to set
     * @param condition condition
     * @deprecated will be replaced with native sql queries
     */
    @Deprecated(since = "2023-12-24", forRemoval = true)
    @Given("DB - UPDATE {string} SET {string} WHERE {string}")
    public void updateData(String table, String newValue, String condition) {
        var query = "UPDATE %s SET %s WHERE %s".formatted(table, newValue, GeneralActions.replacePlaceholders(condition, scenarioContext));
        Allure.addAttachment("Query", query);
        jdbi.useHandle(handle ->
                handle.createUpdate(query)
                        .execute());
    }

    /**
     * <p>
     * The code then performs a SQL query on the database by calling the select method on the JDBI handle,
     * passing in a formatted string as the argument. The query retrieves data from the specified table and column based on a condition.
     * The result is mapped to a string and returned as the result variable
     *
     * @see <a href="https://www.ontestautomation.com/using-data-tables-in-cucumber-jvm-for-better-readable-specifications/">Using data tables in Cucumber-JVM for better readable specifications</a>
     * @see <a href="https://www.ontestautomation.com/using-data-table-types-in-cucumber-jvm/">Using data table types in Cucumber-JVM</a>
     * @deprecated will be replaced with native sql queries
     */
    @Deprecated(since = "2023-12-24", forRemoval = true)
    @Given("DB - Store the following data")
    public void storeData(List<Map<String, String>> queryData) {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(30));
        jdbi.useHandle(handle -> queryData.forEach(query -> {
            var colum = query.get("column");
            var table = query.get("table");
            var resultName = query.get("resultName");
            var queryToBeExecuted = "SELECT %s FROM %s WHERE %s".formatted(colum, table, GeneralActions.replacePlaceholders(query.get("condition"), scenarioContext));
            Allure.addAttachment("Query", queryToBeExecuted);
            scenarioContext.getSqlAndApiResults().put(resultName, handle.select(queryToBeExecuted)
                    .mapTo(String.class)
                    .one());
            Allure.addAttachment("Query Result", scenarioContext.getSqlAndApiResults().get(resultName));
        }));
    }

    @Given("DB - Store customer id for {user} user")
    public void storeCustomerId(User user) {
        var customerId = jdbi.onDemand(DbQueries.class)
                .getCustomerId(user.getId());
        Allure.addAttachment("Query Result", customerId);
        user.setCustomerId(customerId);
    }

    @Given("DB - Store last eligibility check date for {user} user in the {optionIndex} room")
    public void storeCustomerId(User user, int roomIndex) {
        var lastEligibilityCheckDate = jdbi.onDemand(DbQueries.class)
                .getLastEligibilityCheckDate(user.getRoomsList().get(roomIndex).getId(), user.getId());
        Allure.addAttachment("Query Result", lastEligibilityCheckDate);
        scenarioContext.getSqlAndApiResults().put("original_eligibility_check_date", lastEligibilityCheckDate);
    }

    @Given("DB - Store room id of {user} user in the {optionIndex} room in {} status")
    public void storeCustomerId(User user, int roomIndex, RoomStatus status) {
        var roomId = jdbi.onDemand(DbQueries.class)
                .getRoomId(user.getId(), status.getStatus());
        Allure.addAttachment("Query Result", String.valueOf(roomId));
        user.getRoomsList().get(roomIndex).setId(roomId);
    }

    @Given("DB - Change reason for {user} user in the {optionIndex} room in {} status is {string}")
    public void verifyChangeReason(User user, int roomIndex, RoomStatus newStatus, String resultName) {
        Awaitility
                .await()
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var changeReason = jdbi.onDemand(IneligibilityBhQueries.class)
                            .getChangeReason(user.getRoomsList().get(roomIndex).getId(), newStatus.getStatus());
                    Allure.addAttachment("Query Result", changeReason);
                    assertThat(changeReason)
                            .as("change reason")
                            .isEqualTo(resultName);
                });
    }

    @Given("DB - Change reason for {user} user in the {optionIndex} room that was in {} status and now is in {} status is {string}")
    public void verifyChangeReason(User user, int roomIndex, RoomStatus oldStatus, RoomStatus newStatus, String resultName) {
        Awaitility
                .await()
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .ignoreExceptions()
                .untilAsserted(() -> {
                    var changeReason = jdbi.onDemand(IneligibilityBhQueries.class)
                            .getChangeReason(user.getRoomsList().get(roomIndex).getId(), oldStatus.getStatus(), newStatus.getStatus());
                    Allure.addAttachment("Query Result", changeReason);
                    assertThat(changeReason)
                            .as("change reason")
                            .isEqualTo(resultName);
                });
    }

    @Given("DB - Funnel variation for {user} user in the {optionIndex} room is {string}")
    public void verifyFunnelVariation(User user, int roomIndex, String resultName) {
        Awaitility
                .await()
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var funnelVariation = jdbi.onDemand(IneligibilityBhQueries.class)
                            .getFunnelVariation(user.getRoomsList().get(roomIndex).getId());
                    Allure.addAttachment("Query Result", funnelVariation);
                    assertThat(funnelVariation)
                            .as("funnel variation")
                            .isEqualTo(resultName);
                });
    }

    /**
     * we must have the following data in scenario context:
     * claim_id
     */
    @Given("DB - Store payment URL")
    public void storePaymentUrl() {
        var paymentUrl = jdbi.onDemand(ClaimsQueries.class)
                .getPaymentUrl(scenarioContext.getSqlAndApiResults().get("claim_id"));
        Allure.addAttachment("Query Result", paymentUrl);
        scenarioContext.getSqlAndApiResults().put("payment_url", paymentUrl);
    }

    /**
     * we must have the following data in scenario context:
     * claim_id
     */
    @Given("DB - Store era id")
    public void storeCustomerId() {
        var eraId = jdbi.onDemand(ClaimsQueries.class)
                .getEraId(scenarioContext.getSqlAndApiResults().get("claim_id"));
        Allure.addAttachment("Query Result", String.valueOf(eraId));
        scenarioContext.getSqlAndApiResults().put("era_id", String.valueOf(eraId));
    }

    @Given("DB - Store claim id for {user} user")
    public void storeClaimId(User user) {
        var claimId = jdbi.onDemand(ClaimsQueries.class)
                .getClaimId(user.getId());
        Allure.addAttachment("Query Result", claimId);
        scenarioContext.getSqlAndApiResults().put("claim_id", claimId);
    }

    @Given("DB - Store minimum claim id for {user} user")
    public void storeMinimumClaimId(User user) {
        var claimId = jdbi.onDemand(ClaimsQueries.class)
                .getMinimumClaimId(user.getId());
        Allure.addAttachment("Query Result", claimId);
        scenarioContext.getSqlAndApiResults().put("claim_id", claimId);
    }

    @Given("DB - Store maximum claim id for {user} user")
    public void storeMaximumClaimId(User user) {
        var claimId = jdbi.onDemand(ClaimsQueries.class)
                .getMaximumClaimId(user.getId());
        Allure.addAttachment("Query Result", claimId);
        scenarioContext.getSqlAndApiResults().put("claim_id", claimId);
    }

    /**
     * we must have the following data in scenario context:
     * claim_id
     */
    @Given("DB - Store external id")
    public void storeExternalId() {
        var externalId = jdbi.onDemand(ClaimsQueries.class)
                .getExternalId(scenarioContext.getSqlAndApiResults().get("claim_id"));
        Allure.addAttachment("Query Result", externalId);
        scenarioContext.getSqlAndApiResults().put("external_id", externalId);
    }

    @Given("DB - Store claim status for {user} user")
    public void storeClaimStatus(User user) {
        var claimStatus = jdbi.onDemand(ClaimsQueries.class)
                .getClaimStatus(user.getId());
        Allure.addAttachment("Query Result", claimStatus);
        scenarioContext.getSqlAndApiResults().put("claim_status", claimStatus);
    }

    @Given("DB - Store session report id for {user} user in the {optionIndex} room")
    public void storeSessionReportID(User user, int roomIndex) {
        var sessionReportId = jdbi.onDemand(DbQueries.class)
                .getSessionReportId(user.getRoomsList().get(roomIndex).getId());
        Allure.addAttachment("Query Result", sessionReportId);
        user.getRoomsList().get(roomIndex).setSessionReportId(sessionReportId);
    }

    /**
     * we must have the following data in scenario context:
     * claim_id
     */
    @Given("DB - Store worklist id")
    public void storeWorklistId() {
        var worklistId = jdbi.onDemand(ClaimsQueries.class)
                .getWorklistId(scenarioContext.getSqlAndApiResults().get("claim_id"));
        Allure.addAttachment("Query Result", worklistId);
        scenarioContext.getSqlAndApiResults().put("worklist_id", worklistId);
    }

    @Given("DB - Store minimum session report id for {user} user in the {optionIndex} room")
    public void storeMinimumSessionReportID(User user, int roomIndex) {
        var sessionReportId = jdbi.onDemand(DbQueries.class)
                .getMinimumSessionReport(user.getRoomsList().get(roomIndex).getId());
        Allure.addAttachment("Query Result", sessionReportId);
        user.getRoomsList().get(roomIndex).setSessionReportId(sessionReportId);
    }

    @Given("DB - Claim count for {user} user in the {optionIndex} room is {int}")
    public void verifyClaimCount(User user, int roomIndex, int expectedClaimCount) {
        var actualClaimCount = jdbi.onDemand(ClaimsQueries.class)
                .getClaimCount(user.getRoomsList().get(roomIndex).getId());
        Allure.addAttachment("Query Result", String.valueOf(actualClaimCount));
        assertThat(actualClaimCount)
                .as("claim count")
                .isEqualTo(expectedClaimCount);
    }

    /**
     * we must have the following data in scenario context:
     * claim_id
     */
    @Given("DB - Claim copay final is")
    public void verifyClaimCopayFinal(List<String> expectedCopayFinal) {
        var actualCopayFinal = jdbi.onDemand(ClaimsQueries.class)
                .getCopayFinal(scenarioContext.getSqlAndApiResults().get("claim_id"));
        Allure.addAttachment("Query Result", StringUtils.join(actualCopayFinal, System.lineSeparator()));
        assertThat(actualCopayFinal)
                .as("claim copay final")
                .isEqualTo(expectedCopayFinal);
    }

    /**
     * we must have the following data in scenario context:
     * claim_id
     */
    @Given("DB - Claim open member balance is")
    public void verifyOpenMemberBalance(List<String> openMemberBalance) {
        var actualOpenMemberBalance = jdbi.onDemand(ClaimsQueries.class)
                .getOpenMemberBalance(scenarioContext.getSqlAndApiResults().get("claim_id"));
        Allure.addAttachment("Query Result", StringUtils.join(actualOpenMemberBalance, System.lineSeparator()));
        assertThat(actualOpenMemberBalance)
                .as("claim open member balance")
                .isEqualTo(openMemberBalance);
    }

    @Given("DB - Store maximum session report id for {user} user in the {optionIndex} room")
    public void storeMaximumSessionReportID(User user, int roomIndex) {
        var sessionReportId = jdbi.onDemand(DbQueries.class)
                .getMaximumSessionReport(user.getRoomsList().get(roomIndex).getId());
        Allure.addAttachment("Query Result", sessionReportId);
        user.getRoomsList().get(roomIndex).setSessionReportId(sessionReportId);
    }

    @Given("DB - Store case id for {user} user in the {optionIndex} room")
    public void storeCaseId(User user, int roomIndex) {
        var caseId = jdbi.onDemand(DbQueries.class)
                .getCaseId(user.getRoomsList().get(roomIndex).getId());
        Allure.addAttachment("Query Result", caseId);
        user.getRoomsList().get(roomIndex).setCaseId(caseId);
    }

    /**
     * we must have the following data in scenario context:
     * claim_id
     */
    @Given("DB - Store invoice id of {int} amount")
    public void storeInvoiceId(int amount) {
        var invoiceId = jdbi.onDemand(ClaimsQueries.class)
                .getInvoiceId(scenarioContext.getSqlAndApiResults().get("claim_id"), amount);
        Allure.addAttachment("Query Result", invoiceId);
        scenarioContext.getSqlAndApiResults().put("invoice_id", invoiceId);
    }

    @Given("DB - last_eligibility_check_date of {user} user is today")
    public void verifyLastEligibilityCheckDateIsToday(User user) throws ParseException {
        var lastEligibilityCheckDate = jdbi.onDemand(DbQueries.class)
                .getLastEligibilityCheckDate(user.getId());
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = dateFormat.parse(lastEligibilityCheckDate);
        assertThat(date).isToday();
    }

    /**
     * we must have the following data in scenario context:
     * original_eligibility_check_date
     *
     * @param user the user to check
     */
    @Given("DB - last_eligibility_check_date of {user} user did not change")
    public void verifyLastEligibilityCheckDateDidNotChange(User user) {
        var query = "SELECT last_eligibility_check_date from talkspace_test4.insurance_status where user_id=%d order by 1 desc; ".formatted(user.getId());
        Allure.addAttachment("Query", query);
        var queryResult = jdbi.withHandle(handle ->
                handle.select(query)
                        .mapTo(String.class)
                        .one());
        Allure.addAttachment("Query Result", queryResult);
        assertThat(queryResult).isEqualTo(scenarioContext.getSqlAndApiResults().get("original_eligibility_check_date"));
    }

    /**
     * we must have the following data in scenario context:
     * claim_id
     *
     * @param expectedInsuranceRestitution the expected insurance restitution
     */
    @Given("DB - Insurance resolution is {string}")
    public void verifyInsuranceRestitution(String expectedInsuranceRestitution) {
        var actualInsuranceRestitution = jdbi.onDemand(ClaimsQueries.class)
                .getInsuranceResolution(scenarioContext.getSqlAndApiResults().get("claim_id"));
        Allure.addAttachment("Query Result", actualInsuranceRestitution);
        assertThat(actualInsuranceRestitution)
                .as("insurance restitution")
                .isEqualTo(expectedInsuranceRestitution);
    }

    @Given("DB - SELECT {string} FROM {string} WHERE {string} is {int}")
    public void validateData(String colum, String table, String condition, int expectedValue) {
        var query = "SELECT %s FROM %s WHERE %s".formatted(colum, table, GeneralActions.replacePlaceholders(condition, scenarioContext));
        Allure.addAttachment("Query", query);
        var queryResult = jdbi.withHandle(handle ->
                handle.select(query)
                        .mapTo(Integer.class)
                        .one());
        Allure.addAttachment("Query Result", String.valueOf(queryResult));
        assertThat(queryResult)
                .as(query)
                .isEqualTo(expectedValue);
    }

    @Given("DB - Refund amount for {user} user in the {optionIndex} room is")
    public void verifyRefundAmount(User user, int roomIndex, List<String> expectedRefundAmount) {
        Awaitility
                .await()
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var queryResult = jdbi.onDemand(DbQueries.class)
                            .getRefundAmount(user.getRoomsList().get(roomIndex).getId());
                    Allure.addAttachment("Query Result", StringUtils.join(queryResult, System.lineSeparator()));
                    assertThat(queryResult)
                            .as("refund amount")
                            .isEqualTo(expectedRefundAmount);
                });
    }

    /**
     * we must have the following data in scenario context:
     * claim_id
     *
     * @param expectedClaimSubmissionType the expected claim submission type
     */
    @And("DB - Claim submission type are")
    public void verifyClaimSubmissionTye(List<String> expectedClaimSubmissionType) {
        Awaitility
                .await()
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var actualClaimStatus = jdbi.onDemand(ClaimsQueries.class)
                            .getSubmissionType(scenarioContext.getSqlAndApiResults().get("claim_id"));
                    Allure.addAttachment("Query Result", StringUtils.join(actualClaimStatus, System.lineSeparator()));
                    assertThat(actualClaimStatus)
                            .as("claim submission types")
                            .isEqualTo(expectedClaimSubmissionType);
                });
    }

    /**
     * @param expectedStatus the expected pre-register status
     */
    @And("DB - Zocdoc pre-register status of {user} user is")
    public void verifyPreRegisterUserStatus(User user, List<String> expectedStatus) {
        Awaitility
                .await()
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var actualPreRegisterStatus = jdbi.onDemand(ZocdocQueries.class)
                            .getPreRegisterUserStatus(user.getEmail());
                    Allure.addAttachment("Query Result", StringUtils.join(actualPreRegisterStatus, System.lineSeparator()));
                    assertThat(actualPreRegisterStatus)
                            .as("pre-register status")
                            .isEqualTo(expectedStatus);
                });
    }

    /**
     * Twenty-three is the id of the VIP group
     * provider can have multiple plan groups
     *
     * @throws IOException if an I/O error occurs
     */
    @And("DB - Zocdoc verify therapist are in VIP group")
    public void verifyVipGroup() throws IOException {
        var vipGroup = 23;
        var therapistIds = scenarioContext.getZocdocTherapistIds();
        var zocdocIntegrationConfig = objectMapper.readTree(jdbi.onDemand(ZocdocQueries.class)
                .getZocdocIntegrationConfig());
        var expectedTherapistIds = objectMapper.readValue(zocdocIntegrationConfig.get("providers").toString(), int[].class);
        assertThat(therapistIds).containsExactlyInAnyOrder(expectedTherapistIds);
        Arrays.stream(therapistIds).forEach(therapistId -> assertThat(jdbi.onDemand(ZocdocQueries.class)
                .getPlanGroupId(therapistId))
                .withFailMessage("Therapist %d is not in the VIP group - %d".formatted(therapistId, vipGroup))
                .contains(vipGroup));
    }

    /**
     * we must have the following data in scenario context:
     * claim_id
     *
     * @param expectedClaimStatus the expected claim status
     */
    @And("DB - Claim history is")
    public void verifyClaimStatus(List<String> expectedClaimStatus) {
        Awaitility
                .await()
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var actualClaimStatus = jdbi.onDemand(ClaimsQueries.class)
                            .getClaimStatus(scenarioContext.getSqlAndApiResults().get("claim_id"));
                    Allure.addAttachment("Query Result", StringUtils.join(actualClaimStatus, System.lineSeparator()));
                    assertThat(actualClaimStatus)
                            .as("claim status")
                            .isEqualTo(expectedClaimStatus);
                });
    }

    /**
     * we must have the following data in scenario context:
     * claim_id
     *
     * @param expectedClaimBalance expected claim balance
     */
    @And("DB - Claim balance status is")
    public void verifyClaimBalance(List<String> expectedClaimBalance) {
        Awaitility
                .await()
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .untilAsserted(() -> {
                    var actualClaimBalanceStatus = jdbi.onDemand(ClaimsQueries.class)
                            .getClaimBalanceStatus(scenarioContext.getSqlAndApiResults().get("claim_id"));
                    Allure.addAttachment("Query Result", StringUtils.join(actualClaimBalanceStatus, System.lineSeparator()));
                    assertThat(actualClaimBalanceStatus)
                            .as("claim balance status")
                            .isEqualTo(expectedClaimBalance);
                });
    }

    /**
     * @param daysBack   the number of days back to get the date from
     * @param resultName the name of the result to store in the scenario context
     */
    @Given("DB - Get past time from database last {int} days back as {string}")
    public void storeData(int daysBack, String resultName) {
        var date = jdbi.onDemand(DbQueries.class)
                .getDate(daysBack);
        Allure.addAttachment("Query Result", date);
        scenarioContext.getSqlAndApiResults().put(resultName, date);
    }

    @Given("DB - Verify {user} user email")
    public void verifyEmail(User user) {
        jdbi.onDemand(DbQueries.class)
                .verifyUser(user.getId());
    }

    /**
     * we must have the following data in scenario context:
     * claim_id
     */
    @Given("DB - Verify new ERA id on new Payment row")
    public void verifyEraId() {
        var actualEraID = jdbi.onDemand(ClaimsQueries.class)
                .getEraId(scenarioContext.getSqlAndApiResults().get("claim_id"));
        Allure.addAttachment("Query Result", String.valueOf(actualEraID));
        var expectedEraId = data.getConfiguration().getDomain().equals(Domain.CANARY.getName()) ? 5030 : 4060;
        assertThat(actualEraID)
                .as("ERA id")
                .isEqualTo(expectedEraId);
    }

    @Given("DB - Set BH {user} user to be permanently ineligible in grace period")
    public void updateInsuranceStatusGracePeriod(User user) {
        jdbi.onDemand(DbQueries.class)
                .updateInsuranceStatusGracePeriod(user.getId());
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(5));
    }

    @Given("DB - Delete session reposts and video credits for {user} user in the {optionIndex} room")
    public void deleteSessionReportsAndVideoCredits(User user, int roomIndex) {
        jdbi.onDemand(DbQueries.class)
                .deleteSessionReportsAndVideoCredits(user.getRoomsList().get(roomIndex).getId());
    }

    @Given("DB - Set BH {user} user to be permanently ineligible for {int} hours")
    public void updateInsuranceStatusAfterGracePeriod(User user, int hoursBack) {
        jdbi.onDemand(DbQueries.class)
                .updateInsuranceStatusAfterGracePeriod(user.getId(), hoursBack);
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(5));
    }

    /**
     * first we log the query to allure, then we execute it
     *
     * @param daysBack  the number of days back to get the date from
     * @param user      the user to update the dates for
     * @param roomIndex the index of the room to update the dates for
     */
    @Given("DB - Update messaging session data - Move dates {int} days back for {user} user in the {optionIndex} room")
    public void updateMessagingSession(int daysBack, User user, int roomIndex) {
        jdbi.onDemand(DbQueries.class)
                .updateDates(daysBack, user.getRoomsList().get(roomIndex).getId());
    }


    @Given("DB - Update session report status to {string} for {user} user in the {optionIndex} room")
    public void updateSessionReportStatus(String status, User user, int roomIndex) {
        jdbi.onDemand(DbQueries.class)
                .updateSessionReportStatus(status, user.getRoomsList().get(roomIndex).getId());
    }

    @Given("DB - Update client insurance info member id to {string} for {user} user")
    public void updateMemberId(String memberId, User user) {
        jdbi.onDemand(DbQueries.class)
                .updateMemberId(memberId, user.getId());
    }

    @Given("DB - Update insurance eligibilities member id to {string} for {user} user in the {optionIndex} room")
    public void updateMemberId(String memberId, User user, int roomIndex) {
        jdbi.onDemand(DbQueries.class)
                .updateMemberId(memberId, user.getId(), user.getRoomsList().get(roomIndex).getId());
    }

    @Given("DB - Store client insurance information id for {user} user")
    public void storeClientInsuranceInfoId(User user) {
        var clientInsuranceInfoId = jdbi.onDemand(DbQueries.class)
                .getClientInsuranceInfoId(user.getId());
        Allure.addAttachment("Query Result", String.valueOf(clientInsuranceInfoId));
        user.setClientInsuranceInfoId(clientInsuranceInfoId);
    }

    @Given("DB - Store next Aetna member id")
    public void storeAetnaMemberId() {
        var aetnaMemberId = jdbi.onDemand(DbQueries.class)
                .getAetnaMemberId();
        Allure.addAttachment("Query Result", String.valueOf(aetnaMemberId));
        scenarioContext.getSqlAndApiResults().put("member_id", String.valueOf(aetnaMemberId));
    }

    @Given("DB - Store {user} user birth date")
    public void storeMemberDob(User user) {
        var memberDob = jdbi.onDemand(DbQueries.class)
                .getMemberDob(user.getId());
        Allure.addAttachment("Query Result", memberDob);
        user.setDateOfBirth(memberDob);
    }

    @Given("DB - Store auth effective date")
    public void storeAuthEffectiveDate() {
        var currentDate = LocalDate.now();
        var newDate = currentDate.minusDays(14);
        var formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy");
        var authEffectiveDate = newDate.format(formatter);
        Allure.addAttachment("auth effective date", authEffectiveDate);
        scenarioContext.getSqlAndApiResults().put("auth effective date", authEffectiveDate);
    }

    @Given("DB - Store auth date")
    public void storeAuthDate() {
        var currentDate = LocalDate.now();
        var formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy");
        var authDate = currentDate.format(formatter);
        Allure.addAttachment("auth date", authDate);
        scenarioContext.getSqlAndApiResults().put("auth_date", authDate);
    }

    @Given("DB - Store auth effective date {int} days ago")
    public void storeAuthEffectiveDateByDays(int days) {
        var currentDate = LocalDate.now();
        var newDate = currentDate.minusDays(days);
        var formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy");
        var authEffectiveDate = newDate.format(formatter);
        Allure.addAttachment("auth effective date", authEffectiveDate);
        scenarioContext.getSqlAndApiResults().put("auth effective date", authEffectiveDate);
    }

    @Given("DB - Number of session reports is {int} for {user} in the {optionIndex} room")
    public void verifyNumberOfSessionReports(int sessions, User user, int roomIndex) {
        var numberOfSessions = jdbi.onDemand(DbQueries.class)
                .getNumberOfSessionReports(user.getRoomsList().get(roomIndex).getId());
        Allure.addAttachment("Query Result", String.valueOf(numberOfSessions));
        assertThat(numberOfSessions)
                .as("number of sessions")
                .isEqualTo(sessions);
    }

    @Given("DB - Number of video credits is {int} for {user} in the {optionIndex} room")
    public void verifyNumberOfVideoCredits(int credits, User user, int roomIndex) {
        var numberOfVideoCredits = jdbi.onDemand(DbQueries.class)
                .getNumberOfVideoCredits(user.getRoomsList().get(roomIndex).getId());
        Allure.addAttachment("Query Result", String.valueOf(numberOfVideoCredits));
        assertThat(numberOfVideoCredits)
                .as("number of credits")
                .isEqualTo(credits);
    }

    @Given("DB - Client insurance auth request data is {string} for {user} user")
    public void verifyAuthDataRequestStatus(String status, User user) {
        var requestStatus = jdbi.onDemand(DbQueries.class)
                .getRequestStatus(user.getId());
        Allure.addAttachment("Query Result", requestStatus);
        assertThat(requestStatus)
                .as("number of credits")
                .isEqualTo(status);
    }

    @Given("DB - Claim has the correct auth code")
    public void verifyAuthCodeOnClaim() {
        Awaitility
                .await()
                .atMost(Duration.ofMinutes(1))
                .pollInterval(Duration.ofSeconds(1))
                .ignoreExceptions()
                .untilAsserted(() -> {
                    var claimAuthorizationCode = jdbi.onDemand(ClaimsQueries.class)
                            .getClaimAuthorizationCode(scenarioContext.getSqlAndApiResults().get("claim_id"));
                    Allure.addAttachment("Query Result", claimAuthorizationCode);
                    assertThat(claimAuthorizationCode)
                            .as("claim authorization code")
                            .isEqualTo("auto".concat(scenarioContext.getSqlAndApiResults().get("member_id")));
                });
    }

    @Given("DB - Number of cancelled session reports is {int} for {user} in the {optionIndex} room")
    public void verifyNumberOfCancelledSessionReports(int numberOfCancelledSessions, User user, int roomIndex) {
        var cancelledSessions = jdbi.onDemand(DbQueries.class)
                .getNumberOfCancelledSessionReports(user.getRoomsList().get(roomIndex).getId());
        Allure.addAttachment("Query Result", String.valueOf(cancelledSessions));
        assertThat(cancelledSessions)
                .as("number of cancelled sessions")
                .isEqualTo(numberOfCancelledSessions);
    }

    @Given("DB - Number of revoked credits is {int} for {user} in the {optionIndex} room")
    public void verifyNumberOfRevokedVideoCredits(int numberOfRevokedCredits, User user, int roomIndex) {
        var revokedCredits = jdbi.onDemand(DbQueries.class)
                .getNumberOfRevokedVideoCredits(user.getRoomsList().get(roomIndex).getId());
        Allure.addAttachment("Query Result", String.valueOf(revokedCredits));
        assertThat(revokedCredits)
                .as("number of revoked credits")
                .isEqualTo(numberOfRevokedCredits);
    }

    @Given("DB - Set null values on client_insurance_auth_request_data table for {user} user")
    public void setNullValuesOnClientInsuranceAuthRequestData(User user) {
        jdbi.onDemand(DbQueries.class)
                .updateClientInsuranceAuthRequestDataWithNullValues(user.getId());
    }

    @Given("DB - Clear DOB from client insurance info table for {user} user")
    public void setNullDateOfBirthOnClientInsuranceInfoTable(User user) {
        jdbi.onDemand(DbQueries.class)
                .updateClientInsuranceInfoWithNullDOB(user.getId());
    }

    @Given("DB - Is_full_request_data on client insurance auth request data table is false for {user} user")
    public void verifyRequestIsNoFull(User user) {
        var isFullRequestData = jdbi.onDemand(DbQueries.class)
                .getIsFullRequestData(user.getId());
        Allure.addAttachment("Query Result", String.valueOf(isFullRequestData));
        assertThat(isFullRequestData)
                .as("number of credits")
                .isEqualTo(0);
    }

    @Given("DB - Number of aetna_auth_responses for {user} user is {int}")
    public void verifyNumberOfAetnaResponses(User user, int numberOfResponses) {
        var result = jdbi.onDemand(DbQueries.class)
                .getNumberOfAetnaAuthResponses(user.getId());
        Allure.addAttachment("Query Result", String.valueOf(result));
        assertThat(result)
                .as("number of aetna_auth_responses")
                .isEqualTo(numberOfResponses);
    }

    @Given("DB - Update date of birth for {user} user with {string}")
    public void updateDateOfBirth(User user, String newDate) {
        jdbi.onDemand(DbQueries.class)
                .updateDateOfBirth(newDate, user.getId());
    }

    @Given("DB - Assign auth code to {user} user")
    public void updateAuthCode(User user) {
        jdbi.onDemand(DbQueries.class)
                .setAuthCode(user.getId());
    }
}
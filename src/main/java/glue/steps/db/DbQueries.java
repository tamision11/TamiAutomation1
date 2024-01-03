package glue.steps.db;

import org.jdbi.v3.sqlobject.customizer.Define;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.SqlScript;
import org.jdbi.v3.sqlobject.statement.SqlUpdate;

import java.util.List;

public interface DbQueries {
    //region update queries

    /**
     * verify user in database
     *
     * @param userId the user id
     */
    @SqlUpdate("UPDATE talkspace_test4.users SET email_verification_status='verified' WHERE id=?")
    void verifyUser(int userId);

    /**
     * @param userId the user id
     */
    @SqlUpdate("UPDATE talkspace_test4.client_insurance_auth_request_data SET is_full_request_data = 0, first_name = NULL, last_name = NULL, date_of_birth = NULL, gender = NULL, country = NULL, city = NULL, state = NULL, street_address = NULL, street_number = NULL, address_line_2 = NULL, zip = NULL, phone_number = NULL, plan_sponsor_name = NULL, is_employee = NULL, presenting_problem_id = NULL, org_id = NULL, keyword = NULL, business_unit_id = NULL, business_unit_name = NULL WHERE user_id=? limit 1")
    void updateClientInsuranceAuthRequestDataWithNullValues(int userId);

    /**
     * @param roomId the room id
     * @param status the status
     */
    @SqlUpdate("UPDATE talkspace_test4.session_reports SET status=? WHERE room_id=? limit 20")
    void updateSessionReportStatus(String status, int roomId);

    /**
     * @param userId the user id
     */
    @SqlUpdate("UPDATE talkspace_test4.client_insurance_info SET date_of_birth = NULL WHERE user_id=? limit 1")
    void updateClientInsuranceInfoWithNullDOB(int userId);

    /**
     * @param userId   the user id
     * @param memberId the member id
     */
    @SqlUpdate("UPDATE talkspace_test4.client_insurance_info SET member_id=? WHERE user_id=? limit 1")
    void updateMemberId(String memberId, int userId);


    /**
     * @param memberId the member id
     * @param roomId   the room id
     * @param userId   the user id
     */
    @SqlUpdate("UPDATE talkspace_test4.insurance_eligibilities SET member_id=? WHERE user_id=? and room_id=?")
    void updateMemberId(String memberId, int userId, int roomId);

    /**
     * update messaging session data - moving dates back by a certain number of days for a given room id
     *
     * @param daysBack the number of days to subtract from the current date
     * @param roomId   the room id
     */
    @SqlScript("UPDATE talkspace_test4.private_talks SET created_at=(select DATE_SUB(now(), INTERVAL <daysBack> DAY)) WHERE id=<roomId>")
    @SqlScript("UPDATE talkspace_test4.private_talks SET last_therapist_change=(select DATE_SUB(now(), INTERVAL <daysBack> DAY)) WHERE id=<roomId>")
    @SqlScript("UPDATE talkspace_test4.session_reports SET created_at=(select DATE_SUB(now(), INTERVAL <daysBack> DAY)) WHERE  completed_at is null and room_id=<roomId>")
    @SqlScript("UPDATE talkspace_test4.session_reports SET updated_at=(select DATE_SUB(now(), INTERVAL <daysBack> DAY)) WHERE  completed_at is null and room_id=<roomId>")
    @SqlScript("UPDATE talkspace_test4.async_sessions SET start_date=(select DATE_SUB(now(), INTERVAL <daysBack> DAY)) WHERE end_date is null and room_id=<roomId>")
    @SqlScript("UPDATE talkspace_test4.async_sessions SET created_at=(select DATE_SUB(now(), INTERVAL <daysBack> DAY)) WHERE end_date is null and room_id=<roomId>")
    void updateDates(@Define("daysBack") int daysBack, @Define("roomId") int roomId);

    /**
     * Set BH member to be permanently ineligible in a grace period
     *
     * @param userId the user id
     */
    @SqlScript("UPDATE talkspace_test4.insurance_status SET latest_eligibility_status='not eligible' WHERE user_id=<userId>")
    @SqlScript("UPDATE talkspace_test4.insurance_status SET failed_check_counter=9 WHERE user_id=<userId>")
    @SqlScript("UPDATE talkspace_test4.insurance_status SET last_eligibility_check_date = DATE_SUB(NOW(), INTERVAL 5 HOUR) WHERE user_id=<userId>")
    @SqlScript("UPDATE talkspace_test4.insurance_status SET last_successful_check_date = DATE_SUB(NOW(), INTERVAL 5 HOUR) WHERE user_id=<userId>")
    @SqlScript("UPDATE talkspace_test4.insurance_status SET updated_at = DATE_SUB(NOW(), INTERVAL 5 HOUR) WHERE user_id=<userId>")
    @SqlScript("UPDATE talkspace_test4.insurance_status SET member_id='tomcat12' WHERE user_id=<userId>")
    @SqlScript("UPDATE talkspace_test4.client_insurance_info SET member_id='tomcat12' WHERE user_id=<userId>")
    void updateInsuranceStatusGracePeriod(@Define("userId") int userId);

    @SqlScript("DELETE from talkspace_test4.session_reports where room_id=<roomId> limit 20")
    @SqlScript("DELETE from talkspace_test4.video_credits WHERE purchased_in_room_id=<roomId> limit 20")
    void deleteSessionReportsAndVideoCredits(@Define("roomId") int roomId);

    /**
     * Set BH member to be permanently ineligible after a grace period
     *
     * @param userId the user id
     */
    @SqlScript("UPDATE talkspace_test4.insurance_status SET latest_eligibility_status='not eligible' WHERE user_id=<userId>")
    @SqlScript("UPDATE talkspace_test4.insurance_status SET failed_check_counter=10 WHERE user_id=<userId>")
    @SqlScript("UPDATE talkspace_test4.insurance_status SET is_permanent_ineligible=1 WHERE user_id=<userId>")
    @SqlScript("UPDATE talkspace_test4.insurance_status SET last_eligibility_check_date = DATE_SUB(NOW(), INTERVAL <hoursBack> HOUR) WHERE user_id=<userId>")
    @SqlScript("UPDATE talkspace_test4.insurance_status SET last_successful_check_date = DATE_SUB(NOW(), INTERVAL <hoursBack> HOUR) WHERE user_id=<userId>")
    @SqlScript("UPDATE talkspace_test4.insurance_status SET updated_at = DATE_SUB(NOW(), INTERVAL <hoursBack> HOUR) WHERE user_id=<userId>")
    @SqlScript("UPDATE talkspace_test4.insurance_status SET member_id='tomcat12' WHERE user_id=<userId>")
    @SqlScript("UPDATE talkspace_test4.insurance_eligibilities SET member_id='tomcat12' WHERE user_id=<userId>")
    void updateInsuranceStatusAfterGracePeriod(@Define("userId") int userId, @Define("hoursBack") int hoursBack);
    //endregion.

    /**
     * @param userId the user id
     * @return Customer id
     */
    @SqlQuery("SELECT customer_id from talkspace_test4.user_payment_providers where user_id=?")
    String getCustomerId(int userId);

    /**
     * @param roomId the room id
     * @return session report id
     */
    @SqlQuery("SELECT id from talkspace_test4.session_reports where room_id=?")
    String getSessionReportId(int roomId);

    /**
     * getting minimum session report id
     *
     * @param roomId the room id
     * @return session report id
     */
    @SqlQuery("SELECT min(id) from talkspace_test4.session_reports where room_id=?")
    String getMinimumSessionReport(int roomId);

    /**
     * @param roomId the room id
     * @return refund amount
     */
    @SqlQuery("SELECT refund_amount from talkspace_test4.payment_transactions_refunds where room_id=? order by payment_transactions_refunds_id desc")
    List<String> getRefundAmount(int roomId);

    /**
     * getting minimum session report id
     *
     * @param roomId the room id
     * @return session report id
     */
    @SqlQuery("SELECT max(id) from talkspace_test4.session_reports where room_id=?")
    String getMaximumSessionReport(int roomId);

    /**
     * @param userId the user id
     * @param status the status
     * @return id
     */
    @SqlQuery("SELECT id from talkspace_test4.private_talks where participant_id=? and status=?")
    int getRoomId(int userId, int status);

    /**
     * @param roomId the room id
     * @param userId the user id
     * @return last eligibility check date
     */
    @SqlQuery("SELECT last_eligibility_check_date from talkspace_test4.insurance_status where room_id=? and user_id=?")
    String getLastEligibilityCheckDate(int roomId, int userId);

    /**
     * @param userId the user id
     * @return last eligibility check date
     */
    @SqlQuery("SELECT last_eligibility_check_date from talkspace_test4.insurance_status where user_id=? order by 1 desc")
    String getLastEligibilityCheckDate(int userId);


    /**
     * @param roomId the room id
     * @return case id
     */
    @SqlQuery("SELECT id from talkspace_test4.session_report_information where room_id=?")
    String getCaseId(int roomId);

    /**
     * Getting a date from the database that is a certain number of days in the past
     *
     * @param days the number of days to subtract from the current date
     * @return the date
     */
    @SqlQuery("SELECT DATE_SUB(now(), INTERVAL ? DAY)")
    String getDate(int days);

    /**
     * @param userId the user id
     * @return client insurance info id
     */
    @SqlQuery("SELECT id from talkspace_test4.client_insurance_info where user_id=?")
    int getClientInsuranceInfoId(int userId);

    /**
     * @return aetna member id
     */
    @SqlQuery("SELECT max(member_id)+1 from back_office_crons.aetna_auth_responses")
    int getAetnaMemberId();

    /**
     * @param userId the user id
     * @return member date of birth
     */
    @SqlQuery("SELECT DATE_FORMAT(date_of_birth,'%m/%d/%Y') from talkspace_test4.client_insurance_info where user_id=?")
    String getMemberDob(int userId);

    /**
     * @return today's date
     */
    @SqlQuery("SELECT DATE_FORMAT(NOW(), '%m/%d/%Y')")
    String getTodayDate();

    /**
     * @param roomId the room id
     * @return number of session reports
     */
    @SqlQuery("SELECT count(*) from talkspace_test4.session_reports where room_id=?")
    int getNumberOfSessionReports(int roomId);

    @SqlQuery("SELECT count(*) from talkspace_test4.session_reports where room_id=? and status='cancelled'")
    int getNumberOfCancelledSessionReports(int roomId);

    /**
     * @param roomId the room id
     * @return number of video credits
     */
    @SqlQuery("SELECT count(*) from talkspace_test4.video_credits where purchased_in_room_id=?")
    int getNumberOfVideoCredits(int roomId);

    /**
     * @param roomId the room id
     * @return number of revoked video credits
     */
    @SqlQuery("SELECT count(*) from talkspace_test4.video_credits where purchased_in_room_id=? and revoked_at is not null and revoke_reason='payer_consolidation'")
    int getNumberOfRevokedVideoCredits(int roomId);

    /**
     * @param userId the user id
     * @return request status
     */
    @SqlQuery("SELECT status from talkspace_test4.client_insurance_auth_request_data where user_id=?")
    String getRequestStatus(int userId);

    /**
     * @param userId the user id
     * @return is_full_request_data
     */
    @SqlQuery("SELECT is_full_request_data from talkspace_test4.client_insurance_auth_request_data where user_id=?")
    int getIsFullRequestData(int userId);

    /**
     * @param userId the user id
     * @return number of athna auth responses
     */
    @SqlQuery("SELECT count(*) from back_office_crons.aetna_auth_responses where user_id=?")
    int getNumberOfAetnaAuthResponses(int userId);

    /**
     * @param userId the user id
     * @param date the new date of birth
     */
    @SqlUpdate("UPDATE talkspace_test4.client_insurance_info SET date_of_birth=? WHERE user_id=? limit 1")
    void updateDateOfBirth(String date, int userId);

    /**
     * @param userId the user id
     */
    @SqlUpdate("UPDATE talkspace_test4.client_insurance_info SET authorization_code=user_id WHERE user_id=? limit 1")
    void setAuthCode(int userId);
}
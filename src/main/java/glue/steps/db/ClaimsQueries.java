package glue.steps.db;

import org.jdbi.v3.sqlobject.statement.SqlQuery;

import java.util.List;

public interface ClaimsQueries {

    /**
     * @param amount  the amount
     * @param claimId the claim id
     * @return invoice id
     */
    @SqlQuery("SELECT invoice_id from claims.claims_transactions where claim_id=? and amount=?")
    String getInvoiceId(String claimId, int amount);

    /**
     * getting claim id
     *
     * @param userId the user id
     * @return claim_id
     */
    @SqlQuery("SELECT id from claims.claims where member_user_id=?")
    String getClaimId(int userId);

    /**
     * getting submission types
     *
     * @param claimId the claim id
     * @return submission types
     */
    @SqlQuery("SELECT submission_type from claims.claims_submitted where claim_id=? order by id desc")
    List<String> getSubmissionType(String claimId);

    /**
     * getting minimum claim id
     *
     * @param userId the user id
     * @return claim_id
     */
    @SqlQuery("SELECT min(id) from claims.claims where member_user_id=?")
    String getMinimumClaimId(int userId);

    /**
     * @param claimId the claim id
     * @return worklist id
     */
    @SqlQuery("SELECT id from claims.worklists where label=?")
    String getWorklistId(String claimId);

    /**
     * @param claimId the claim id
     * @return insurance resolution
     */
    @SqlQuery("SELECT insurance_resolution from claims.claims_submitted where claim_id=?")
    String getInsuranceResolution(String claimId);

    /**
     * getting maximum claim id
     *
     * @param userId the user id
     * @return claim_id
     */
    @SqlQuery("SELECT max(id) from claims.claims where member_user_id=?")
    String getMaximumClaimId(int userId);

    /**
     * @param userId the user id
     * @return claim status
     */
    @SqlQuery("SELECT status from claims.claims where member_user_id=?")
    String getClaimStatus(int userId);

    /**
     * @param claimId the claim id
     * @return claim balance status
     */
    @SqlQuery("SELECT balance_status from claims.claims_payments where claim_id=? order by id desc")
    List<String> getClaimBalanceStatus(String claimId);

    /**
     * getting era id
     *
     * @param claimId the claim id
     * @return era_id
     */
    @SqlQuery("SELECT era_id from claims.claims_payments where claim_id=? order by 1 asc limit 1")
    int getEraId(String claimId);

    /**
     * @param roomId the room id
     * @return claim count
     */
    @SqlQuery("SELECT count(*) from claims.claims where member_room_id=?")
    int getClaimCount(int roomId);

    /**
     * @param claimId the claim id
     * @return external id
     */
    @SqlQuery("SELECT external_id from claims.claims_submitted where claim_id=?")
    String getExternalId(String claimId);

    /**
     * @param claimId the claim id
     * @return stripe invoice payment page link
     */
    @SqlQuery("SELECT invoice_payment_page_url from claims.claims_payments where claim_id=?")
    String getPaymentUrl(String claimId);

    /**
     * get claim status
     *
     * @param claimId the claim id
     * @return claim status
     */
    @SqlQuery("SELECT status from claims.claims_history where claim_id=? order by id")
    List<String> getClaimStatus(String claimId);

    /**
     * @param claimId the claim id
     * @return copay final
     */
    @SqlQuery("SELECT copay_final from claims.claims_payments where claim_id=? order by id desc")
    List<String> getCopayFinal(String claimId);

    /**
     * @param claimId the claim id
     * @return open-member balance
     */
    @SqlQuery("SELECT open_member_balance from claims.claims_payments where claim_id=? order by id desc")
    List<String> getOpenMemberBalance(String claimId);

    /**
     * @param claimId the claim id
     * @return claim authorization code
     */
    @SqlQuery("SELECT member_authorization_code from claims.claims_data where claim_id=? order by 1 desc limit 1")
    String getClaimAuthorizationCode(String claimId);
}

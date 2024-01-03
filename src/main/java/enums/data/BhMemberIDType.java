package enums.data;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * The copay is determined as the final digits of the member id,
 * for example, memberId ends with 2500 is equal to 25$ copay.
 * Atena memberIDs are only applicable for flow 70.
 *
 * @see <a href="https://talktala.atlassian.net/browse/NYC-7989">Aetna BH non-Amazon user member IDs</a>
 * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2618">Optum UMR copay</a>
 * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2645"> QM - Add tests for new member id for BH automatic flows: tomcat1500</a>
 */
@AllArgsConstructor
@Getter
public enum BhMemberIDType {

    /**
     * mock for bad 277 file
     */
    BAD_277_FILE("tomcat168"),
    /**
     * processed as Primary mock for claims
     */
    CLAIM_BH_ADJUDICATION19("tomcat172"),
    /**
     * processed as Secondary mock for claims
     */
    CLAIM_BH_ADJUDICATION20("tomcat173"),
    /**
     * processed as Tertiary mock for claims
     */
    CLAIM_BH_ADJUDICATION21("tomcat174"),
    /**
     * charge member mock for claims
     */
    CLAIM_BH_AGGREGATE("tomcat166"),
    /**
     * balance 0 mock for claims
     */
    CLAIM_BH_BALANCE_0("tomcat150"),
    /**
     * charge member mock for claims
     */
    CLAIM_BH_CHARGE("tomcat151"),
    /**
     * denied member mock for claims
     */
    CLAIM_BH_DENIED("tomcat155"),
    /**
     * denied for CO adjustment
     */
    CLAIM_BH_DENIED_FOR_CO_ADJUSTMENT("tomcat156"),
    /**
     * max member liability mock for claims
     */
    CLAIM_BH_MAX_MEMBER_LIABILITY("tomcat181"),
    /**
     * refund member mock for claims
     */
    CLAIM_BH_REFUND("tomcat152"),
    /**
     * rejected by payer mock for claims
     */
    CLAIM_BH_REJECTED_BY_PAYER("tomcat154"),
    /**
     * Rejected by payer after accepted by payer
     */
    CLAIM_BH_REJECTED_BY_PAYERS_AFTER_ACCEPTED_BY_PAYER("tomcat158"),
    /**
     * rejected by Trizetto mock for claims
     */
    CLAIM_BH_REJECTED_BY_TRIZETTO("tomcat153"),
    /**
     * Rejected by Trizetto after accepted by Trizetto
     */
    CLAIM_BH_REJECTED_BY_TRIZETTO_AFTER_ACCEPTED_BY_TRIZETTO("tomcat157"),
    /**
     * Free
     */
    COPAY_0("tomcat110"),
    /**
     * 25$ copay
     */
    COPAY_25("tomcat112500"),
    /**
     * Free specifically for FCH
     */
    FCH("tomcat1421"),
    /**
     * Free specifically for FMCP
     */
    FMCP("FM1833018"),
    /**
     * free specifically for gatorcare
     */
    GATORCARE("tomcat1419"),
    /**
     * Free specifically for GATORCARE - eligibility based on file
     */
    GATORCARE_BASED_ON_FILE("tomcat11"),
    /**
     * mock for getting 277p with accepted by payer after a 277p with accepted by payer
     */
    MOCK_277P_ACCEPTED_AFTER_ACCEPTED("tomcat177"),
    /**
     * mock for getting 277p with rejected after a 277p with accepted
     */
    MOCK_277P_REJECTED_AFTER_ACCEPTED("tomcat176"),
    /**
     * mock for getting 277p with rejected by payer after a 277p with rejected by payer
     */
    MOCK_277P_REJECTED_AFTER_REJECTED("tomcat178"),
    /**
     * mock for getting 277p with rejected but not as the last status
     */
    MOCK_277P_REJECTED_NOT_AS_LAST_STATUS("tomcat179"),
    /**
     * mock for recurring eligibility test. eligible BH member
     */
    MOCK_ELIGIBLE_BH_MEMBERS("tomcat114888"),
    /**
     * mock for alligence
     */
    MOCK_FOR_ALLEGIANCE("tomcat1417"),
    /**
     * mock for process ERAs for claims that were rejected
     */
    MOCK_FOR_PROCESS_AFTER_REJECTED("tomcat163"),
    /**
     * mock for multiple adjustments in ERA
     */
    MOCK_MULTIPLE_ADJUSTMENTS("tomcat180"),
    /**
     * mock multi ERA for the same claim - charge
     */
    MOCK_MULTI_ERA_SAME_CLAIM_CHARGE("tomcat160"),
    /**
     * mock multi ERA for the same claim - charge 2
     */
    MOCK_MULTI_ERA_SAME_CLAIM_CHARGE2("tomcat162"),
    /**
     * mock multi ERA for the same claim - denied
     */
    MOCK_MULTI_ERA_SAME_CLAIM_DENIED("tomcat167"),
    /**
     * mock multi ERA for the same claim - refund
     */
    MOCK_MULTI_ERA_SAME_CLAIM_REFUND("tomcat159"),
    /**
     * mock multi ERA for the same claim - refund 2
     */
    MOCK_MULTI_ERA_SAME_CLAIM_REFUND2("tomcat161"),
    /**
     * This is a mock that simulate that id exists in the insurance company but the customer is not eligible anymore
     */
    NOT_ELIGIBLE("tomcat12"),
    /**
     * Depends on plan specifically for OUT OF NETWORK
     */
    OUT_OF_NETWORK("tomcat11_50_100"),
    /**
     * Trizetto not available due to server error mock client is redirected to manual flow - Free
     */
    REDIRECT_TO_MANUAL_DUE_TO_SERVER_ERROR("tomcat1500"),
    /**
     * Trizetto not available due to timeout mock client is redirected to manual flow - Free
     */
    REDIRECT_TO_MANUAL_DUE_TO_TIMEOUT("tomcat121"),
    /**
     * Trizetto not available due to timeout for carelon mock client is redirected to manual flow - Free
     */
    REDIRECT_TO_MANUAL_DUE_TO_TIMEOUT_CARELON("tomcat122"),
    /**
     * Trizetto not available due to be unable to respond mock client is redirected to manual flow - Free
     */
    REDIRECT_TO_MANUAL_DUE_TO_UNABLE_TO_RESPOND("tomcat123"),
    /**
     * free specifically for tyson
     */
    TYSON("tomcat1420"),
    /**
     * Free specifically for UMR
     */
    UMR_BH_COPAY_0("tomcat14180"),
    /**
     * 25$ copay specifically for UMR
     */
    UMR_BH_COPAY_25("tomcat14182500"),
    /**
     * unsupported mock for claims
     */
    UNSUPPORTED_BH_MEMBER_ID("tomcat115000");

    private final String memberID;
}
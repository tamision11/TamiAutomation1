package enums.backoffice;


import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * backoffice admin cron names
 */
@AllArgsConstructor
@Getter
public enum Cron {

    POLL_EDI_FILES("pollEDIFiles"),
    AUTOMATIC_SESSION_REPORTS("automaticSessionReports"),
    SUBMIT_PENDING_CLAIMS("submitPendingClaims"),
    RECURRING_ELIGIBILITY("recurringEligibility"),
    MATCH_ROOMS_FROM_QUEUE_WITH_PROVIDER("matchProvidersWithPendingSubscriptionRooms"),
    SET_AETNA_REQUEST("setAetnaRequest"),
    GET_AETNA_RESPONSE("getAetnaResponse");

    private final String name;
}

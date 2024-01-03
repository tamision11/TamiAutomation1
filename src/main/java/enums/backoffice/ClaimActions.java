package enums.backoffice;

import lombok.AllArgsConstructor;
import lombok.Getter;


/**
 * backoffice claim actions
 */
@AllArgsConstructor
@Getter
public enum ClaimActions {

    SUBMIT("SUBMIT"),
    RESET("RESET"),
    RESUBMIT("RESUBMIT"),
    REVIVE("REVIVE"),
    VOID("VOID"),
    HOLD_OFF_SUBMISSION("HOLD_OFF_SUBMISSION"),
    CANCEL("CANCEL"),
    CHARGE("CHARGE_MEMBER"),
    REFUND("REFUND_MEMBER"),
    WRITE_OFF("WRITE_OFF");

    private final String action;
}

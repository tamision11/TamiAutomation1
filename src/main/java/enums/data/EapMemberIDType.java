package enums.data;

import lombok.AllArgsConstructor;
import lombok.Getter;


@AllArgsConstructor
@Getter
public enum EapMemberIDType {

    CLAIM_BALANCE_0("eap0"),
    CLAIM_BALANCE_GREATER_THEN_0("eap1"),
    DENIED("eap5"),
    PROCESSED_BUT_DENIED_FOR_CO_ADJUSTMENT("eap6"),
    REJECTED_BY_PAYER("eap4"),
    REJECTED_BY_PAYER_AFTER_ACCEPTED_BY_PAYER("eap8"),
    REJECTED_BY_TRIZETTO("eap3"),
    REJECTED_BY_TRIZETTO_AFTER_ACCEPTED_BY_TRIZETTO("eap7");

    private final String memberID;
}
package enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * User: nirtal
 * Date: 25/07/2023
 * Time: 15:06
 * Created with IntelliJ IDEA
 * <p>
 * claim adjudication status
 */
@Getter
@AllArgsConstructor
public enum AdjudicationStatus {

    DENIED("DENIED"),
    PROCESSED("PROCESSED_AS_PRIMARY"),
    REVERSAL("REVERSAL_OF_PREVIOUS_PAYMENT");

    private final String status;
}

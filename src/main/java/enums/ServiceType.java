package enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * service type
 */
@AllArgsConstructor
@Getter
public enum ServiceType {
    
    COUPLES_THERAPY("Therapy - couples therapy", "couplesRoom"),
    PSYCHIATRY("Psychiatry", "psychiatryRoom"),
    TEEN_THERAPY(null, null),
    THERAPY("Therapy", "privateRoom");

    private final String name;
    private final String type;
}


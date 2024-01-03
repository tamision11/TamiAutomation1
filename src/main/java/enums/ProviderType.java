package enums;

import com.fasterxml.jackson.annotation.JsonValue;

/**
 * therapist type
 */
public enum ProviderType {
    
    CONSULTATION_AND_PRIMARY,
    PRIMARY,
    PSYCHIATRIST;

    public static ProviderType getByType(String typeToGet) {
        for (var therapistType : values()) {
            if (therapistType.toString().equals(typeToGet)) {
                return therapistType;
            }
        }
        throw new IllegalArgumentException();
    }

    @Override
    @JsonValue
    public String toString() {
        return name().toLowerCase();
    }
}

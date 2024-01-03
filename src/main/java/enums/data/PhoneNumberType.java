package enums.data;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * phone number type
 */
@AllArgsConstructor
@Getter
public enum PhoneNumberType {

    US("+15674052822"),
    FAKE("+12025550126");

    private final String value;
}

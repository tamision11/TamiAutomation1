package enums.data;

import common.glue.utilities.GeneralActions;
import enums.UserEmailType;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.apache.commons.lang3.RandomStringUtils;

/**
 * Password type
 * <p>
 * examples:
 * 1234567 - Password must be at least 8 characters. Strength: Weak
 * 12345678 - Please select a stronger password. Strength: Weak
 * automa12 - Please select a stronger password. Strength: So-so
 * a123456aB - Please select a stronger password. Strength: Weak
 * 1a23456ab - Strength: Strong
 * qwerty1234 - Please select a stronger password. Strength: Weak
 * password123 - Please select a stronger password. Strength: Weak
 */
@AllArgsConstructor
@Getter
public enum PasswordType {

    SAME_AS_EMAIL(GeneralActions.getEmailAddress(UserEmailType.PRIMARY)),
    SHORT(RandomStringUtils.randomAlphabetic(6)),
    SO_SO(RandomStringUtils.randomAlphabetic(6) + RandomStringUtils.randomAlphanumeric(2)),
    STRONG("plomba100"),
    WEAK(RandomStringUtils.randomAlphabetic(8));

    private final String value;
}

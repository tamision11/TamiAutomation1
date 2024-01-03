package enums.data;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.apache.commons.lang3.RandomStringUtils;


/**
 * nickname type
 *
 * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2603">VISUAL - use consistent special char on relevant tests</a>
 */
@AllArgsConstructor
@Getter
public enum NicknameType {

    RANDOM_VALID(RandomStringUtils.randomAlphabetic(8)),
    SAME_AS_PASSWORD(PasswordType.STRONG.getValue()),
    SHORT("t"),
    SPECIAL_CHARACTERS("testauto!"),
    START_WITH_NUMBER("1t"),
    TOO_LONG("nicknameLong"),
    VALID("testauto");

    private final String value;
}
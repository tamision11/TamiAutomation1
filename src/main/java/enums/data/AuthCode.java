package enums.data;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.apache.commons.lang3.RandomStringUtils;

/**
 * User: nirtal
 * Date: 30/03/2022
 * Time: 16:48
 * Created with IntelliJ IDEA
 * <p>
 * authentication code
 * checkin the auth code is unique in DB with the following query:
 * select count(*) from client_insurance_info where authorization_code='yjhXmB-83';
 * where yjhXmB-83 is the auth code
 *
 * @see <a href="https://talktala.atlassian.net/browse/PLATFORM-4081">As QA, we want to skip auth code validation for duplication in mailinator domains with predefined auth code</a>
 * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3007">QM - adjust our EAP auth code tests to new validation rules</a>
 * @see <a href="https://talktala.atlassian.net/browse/PLATFORM-4085">KGA will also be unique</a>
 */
@AllArgsConstructor
@Getter
public enum AuthCode {

    CIGNA_INVALID("16438abcdefg"),
    /**
     * has 11 characters, the first nine characters are numeric with no leading zeros,
     * the next character is an asterisk, the final character will always be capital 'O'
     */
    CIGNA_OPTION_1("1" + RandomStringUtils.randomNumeric(8) + "*O"),
    /**
     * Auth-codes need to have 12 characters, where the first 2 are “OP”, the next 10 are numbers.
     * Example: OP0054273519
     *
     * @see <a href="https://talktala.atlassian.net/browse/PLATFORM-4354">As a Cigna EAP member, I want my authorization code that has a new syntax to be accepted</a>
     */
    CIGNA_OPTION_2("OP" + RandomStringUtils.randomNumeric(10)),
    EXISTING("123456-78"),
    INVALID("invalid"),
    /**
     * mock auth code for cigna for automation
     */
    MOCK_CIGNA("111111111*O"),
    /**
     * mock auth code for kga for automation
     */
    MOCK_KGA("111111-11"),
    /**
     * mock auth code for optum for automation
     */
    MOCK_OPTUM("111111-11"),
    /**
     * Auth-codes need to have nine characters, where the first 6 are alphanumeric, the 7th is an “-”,
     * and the last 2 are numbers.
     * Example: c48rph-01
     */
    OPTUM(RandomStringUtils.randomAlphabetic(6) + "-" + RandomStringUtils.randomNumeric(2));

    private final String code;
}

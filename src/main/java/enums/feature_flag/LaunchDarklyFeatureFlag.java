package enums.feature_flag;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * User: nirtal
 * Date: 02/01/2022
 * Time: 13:53
 * Created with IntelliJ IDEA
 * <p>
 * list of Launch darkly feature flags
 */
@AllArgsConstructor
@Getter
public enum LaunchDarklyFeatureFlag {

    ADD_COVERAGE_KEEP_PROVIDER("add-coverage-keep-provider"),
    /**
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3025">QM - add tests for auth code expiration date field</a>
     */
    AUTH_CODE_EXPIRATION_FIELD("auth-code-expiration-field"),
    /**
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2873">BH no insurance - support bh-no-insurance FF</a>
     */
    BH_NO_INSURANCE("bh-no-insurance"),
    /**
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3130">Language matching - support new feature flags</a>
     */
    LANGUAGE_MATCHING_DEFAULT("language-matching-default"),
    /**
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3130">Language matching - support new feature flags</a>
     */
    LANGUAGE_MATCHING_TEEN_FLOW_128("language-matching-teen-flow-128"),
    /**
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3130">Language matching - support new feature flags</a>
     */
    LANGUAGE_MATCHING_SWITCH_WIZARD("language-matching-switch-wizard"),
    /**
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3130">Language matching - support new feature flags</a>
     */
    LANGUAGE_MATCHING_THERAPY_B2C("language-matching-therapy-b2c"),
    /**
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3130">Language matching - support new feature flags</a>
     */
    LANGUAGE_MATCHING_THERAPY_BH("language-matching-therapy-bh"),
    /**
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3018">CLIENT-WEB - ineligibility BH - add tests to update coverage on time->keep provider->session scheduled->same length</a>
     */
    MBH_INELIGIBILITY_EXPERIMENT("mbh-ineligibility-experiment"),
    /**
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3036">CLIENT-WEB - broadway - add new questions to general treatment intake questionnaire</a>
     */
    NYC_TEENS_INTAKE("nyc-teens-intake"),
    /**
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3039">QM - Broadway - add tests to new NYC TEENS flow</a>
     */
    NYC_TEENS_QUICKMATCH("nyc-teens-quickmatch"),
    /**
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2996">CLIENT-WEB - adjust our provider schedule Live session tests to Provider Recurring V2</a>
     */
    REPEATING_SESSIONS_FULL_2("repeating-sessions-full-2");

    private final String name;
}

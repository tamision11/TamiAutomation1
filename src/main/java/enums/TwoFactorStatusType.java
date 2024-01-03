package enums;

/**
 * two-factor status type
 *
 * @see <a href="https://docs.google.com/document/d/1A9DHgNbeJinhrroohOZBOhCwCrztmUbmOexicOHqZyc/edit#heading=h.blo2l32ufj60">Client 2FA V2</a>
 * @see <a href="https://talktala.atlassian.net/wiki/spaces/PROD/pages/2845999136/2FA+Spec">Client 2FA Spec</a>
 * @see <a href="https://drive.google.com/file/d/1GEjnr5BuSfKRqxnUrVkwZSbgHJMpNZhe/view">updated sketch</a>
 * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2693">CLIENT-WEB - support 2FA feature flags</a>
 * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2710">CLIENT-WEB - add tests for activate 2FA after registration</a>
 * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2586">CLIENT-WEB - add tests for 2FA section under "login and security"  section</a>
 */
public enum TwoFactorStatusType {

    /**
     * two-factor is not active
     */
    OFF,
    /**
     * two-factor is active
     */
    ON,
    /**
     * two-factor is active - must enter two-factor code
     */
    REQUIRED,
    /**
     * two-factor is not required
     */
    SUGGESTED
}

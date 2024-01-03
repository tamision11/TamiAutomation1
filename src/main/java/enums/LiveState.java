package enums;

/**
 * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2728">CLIENT-WEB - fix tests related to EAP\BH IRS modal</a>
 */

public enum LiveState {

    /**
     * MT
     */
    LIVE,
    /**
     * WY
     */
    NON_LIVE,
    /**
     * used on onboarding scheduler B2C flows (after QUEUE match or switch therapist or slug\API registration) OR when scheduling session from inside the room (IRS) where customer state is not relevant for the screens showing on scheduler.
     */
    IGNORE

}


package enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

import static enums.ApplicationUnderTest.ALL;
import static enums.ApplicationUnderTest.CLIENT_WEB;

/**
 * frame title
 */
@AllArgsConstructor
@Getter
public enum FrameTitle {

    CHECK_MY_COVERAGE("Check my coverage", CLIENT_WEB),
    DEFAULT("default", ALL),
    OFFERS_PAGE("Offers page", ALL),
    REACTIVATION("Reactivation", CLIENT_WEB),
    SECURE_CARD_PAYMENT_INPUT_FRAME("Secure card payment input frame", ALL),
    SECURE_EMAIL_INPUT_FRAME("Secure email input frame", ALL),
    SECURE_PAYMENT_INPUT_FRAME("Secure payment input frame", ALL);


    private final String title;
    private final ApplicationUnderTest applicationUnderTest;
}

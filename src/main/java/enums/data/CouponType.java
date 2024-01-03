package enums.data;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * coupon type
 */
@AllArgsConstructor
@Getter
public enum CouponType {

    /**
     * 25% discount dedicated for automation
     */
    AUTOMATION_PERCENT_25("AUTOMATION_25_PERCENT", "25"),
    /**
     * $45 discount
     */
    DOLLAR_45("BUNDLE45", "$45"),
    /**
     * $65 discount
     */
    DOLLAR_65("APPLY65", "$65"),
    /**
     * Expired coupon
     */
    EXPIRED("LOREM45", "$45"),
    /**
     * 100% discount
     */
    PERCENT_100("100PER", "100"),
    /**
     * 25% discount
     */
    PERCENT_25("25OFF", "25"),
    /**
     * 100% discount dedicated for automation on production.
     */
    PROD(System.getProperty("free_coupon"), "100"),
    /**
     * £50 discount
     */
    UK("UKCARE", "£50"),
    /**
     * $150 discount dedicated for testing on walmart flow - only applicable for test environments
     */
    WALMART("WALMARTAUTO", "$150");

    private final String code;
    private final String value;
}

package enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * User: nirtal
 * Date: 03/07/2023
 * Time: 13:25
 * Created with IntelliJ IDEA
 * <p>
 * Member address
 */
@Getter
@AllArgsConstructor
public enum Address {

    /**
     * American samoa address - US territory
     */
    AMERICAN_SAMOA("American Samoa", "Pago Pago", "96799", "Pago Pago, American Samoa", "123 Main St", "AS"),
    /**
     * Canada address
     */
    CANADA("Canada", "Toronto", "N0B 1M0", "Silver Dart Place", "123 Main St", "ON"),
    /**
     * New york
     */
    NYC("United States", "New York", "10019", "4941 King Arthur Way, Cheyenne, WY 82009, United States", "123 Main St", "New York"),
    /**
     * United Kingdom address
     */
    UNITED_KINGDOM("United Kingdom", "London", "SW1A 2AA", "10 Downing Street", "123 Main St", "England"),
    /**
     * Default US address - the user needs to specify the state on the scenario
     */
    US("United States", "Cheyenne", "82009", "4941 King Arthur Way, Cheyenne, WY 82009, United States", "123 Main St", null);

    private final String country;
    private final String city;
    private final String zipCode;
    private final String homeAddress;
    private final String unitAddress;
    private final String state;
}

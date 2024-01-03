package enums.data;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * User: nirtal
 * Date: 08/12/2021
 * Time: 14:46
 * Created with IntelliJ IDEA
 */
@AllArgsConstructor
@Getter
public enum Locations {

    RENO(39.518781, -119.836591),
    ELIZABETH(40.672374578968494, -74.20253222981613);

    private final Double latitude;
    private final Double longitude;
}

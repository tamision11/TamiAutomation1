package enums.data;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Arrays;

/**
 * room status
 *
 * @see <a href="https://talktala.atlassian.net/wiki/spaces/FD/pages/954597519/private+talks+status">documentation for room status is here</a>
 * @see <a href="https://docs.google.com/spreadsheets/d/1Xep2Wla9v-4wN2Tvuoj9EJ6jDRZSGEPWJcT0jy2cvMo/edit#gid=0">match based on availability</a>
 */
@AllArgsConstructor
@Getter
public enum RoomStatus {

    ACTIVE(1),
    CANCELLED(7),
    EXPIRED(4),
    FREE(5),
    FREE_TRIAL(14),
    FROZEN(13),
    NOT_RENEW(6),
    PAST_DUE(11),
    WAITING_TO_BE_MATCHED(16),
    WAITING_TO_BE_MATCHED_QUEUE(15);

    private final int status;

    /**
     * @param value room status value
     * @return room status
     * @see <a href="https://stackoverflow.com/questions/11047756/getting-enum-associated-with-int-value"> getting-enum-associated-with-int-value</a>
     */
    public static RoomStatus valueOf(int value) {
        return Arrays.stream(values())
                .filter(roomStatus -> roomStatus.status == value)
                .findFirst()
                .orElseThrow(() -> new UnknownError("room status unknown"));
    }
}
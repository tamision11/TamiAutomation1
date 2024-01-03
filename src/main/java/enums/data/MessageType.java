package enums.data;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * chat message type
 */
@AllArgsConstructor
@Getter
public enum MessageType {

    AUDIO(15),
    PDF(40),
    PHOTO(17),
    TEXT(1),
    VIDEO(16);

    private final int type;
}
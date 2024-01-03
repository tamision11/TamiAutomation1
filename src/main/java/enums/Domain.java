package enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * Talkspace domain names
 */
@AllArgsConstructor
@Getter
public enum Domain {
    DEV("dev"),
    CANARY("canary"),
    PROD("prod");
    private final String name;
}

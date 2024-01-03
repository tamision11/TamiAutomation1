package enums;

/**
 * the chat message type
 */
public enum ChatMessageType {

    /**
     * message sent via the keyboard
     */
    COPY_PASTED_MESSAGE,
    /**
     * message with line break
     */
    LINE_BREAK,
    /**
     * message that has the maximum length of characters
     */
    MAXIMUM,
    /**
     * message with line special characters
     */
    SPECIAL_CHARACTER,
    /**
     * message that exceeds the maximum length of characters
     */
    TOO_LONG,
    /**
     * message that is a link
     */
    URL,
    /**
     * valid random message
     */
    VALID_RANDOM
}

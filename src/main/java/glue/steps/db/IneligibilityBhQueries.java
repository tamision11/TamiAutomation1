package glue.steps.db;

import org.jdbi.v3.sqlobject.statement.SqlQuery;

/**
 * User: nirtal
 * Date: 21/12/2023
 * Time: 10:26
 * Created with IntelliJ IDEA
 */
public interface IneligibilityBhQueries {

    /**
     * @param roomId the room id
     * @return funnel variation
     */
    @SqlQuery("SELECT funnel_variation FROM talkspace_test4.private_talks WHERE id=?")
    String getFunnelVariation(int roomId);

    /**
     * @param roomId   the room id
     * @param newValue the new value
     * @return change reason
     */
    @SqlQuery("SELECT change_reason FROM talkspace_test4.private_talks_history WHERE private_talk_id=? and new_value=?")
    String getChangeReason(int roomId, int newValue);

    /**
     * @param roomId   the room id
     * @param oldValue the old value
     * @param newValue the new value
     * @return change reason
     */
    @SqlQuery("SELECT change_reason FROM talkspace_test4.private_talks_history WHERE private_talk_id=? and old_value=? and new_value=?")
    String getChangeReason(int roomId, int oldValue, int newValue);
}

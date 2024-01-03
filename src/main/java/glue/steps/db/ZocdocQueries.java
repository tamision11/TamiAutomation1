package glue.steps.db;

import org.jdbi.v3.sqlobject.statement.SqlQuery;

import java.util.List;

public interface ZocdocQueries {

    /**
     * get zocdoc integration config from backoffice
     *
     * @return zocdoc integration config
     */
    @SqlQuery("SELECT json_data FROM talkspace_test4.admin_config WHERE name=\"zocdoc_integration_config\"")
    String getZocdocIntegrationConfig();

    /**
     * @param email the user email
     * @return zocdoc user status
     */
    @SqlQuery("SELECT status from talkspace_test4.pre_register_user_data where email=? order by id desc")
    List<String> getPreRegisterUserStatus(String email);

    /**
     * @param therapistId the therapist id
     * @return therapist plan group ids
     */
    @SqlQuery("SELECT plan_group_id FROM talkspace_test4.therapist_plan_group where therapist_user_id=?")
    List<Integer> getPlanGroupId(int therapistId);
}

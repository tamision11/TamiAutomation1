package enums.feature_flag;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * User: nirtal
 * Date: 02/01/2022
 * Time: 13:53
 * Created with IntelliJ IDEA
 * <p>
 * list of private feature flags
 */
@AllArgsConstructor
@Getter
public enum PrivateFeatureFlagType {

    CLINICAL_PROGRESS_WEB("clinical_progress_web"),
    EMAIL_VERIFICATION("email_verification"),
    LIVE_CHAT_ACTIVE("live_chat_active"),
    PDF_UPLOAD("pdf_upload"),
    SUPERBILLS("superbills"),
    TREATMENT_INTAKE_IN_ONBOARDING("treatment_intake_in_onboarding");

    private final String name;
}

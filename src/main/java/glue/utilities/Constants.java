package glue.utilities;

import lombok.experimental.UtilityClass;

import java.nio.file.Paths;

import static org.apache.commons.lang3.SystemUtils.USER_DIR;

/**
 * User: nirtal
 * Date: 10/06/2021
 * Time: 20:13
 * Created with IntelliJ IDEA
 * <p>
 * Constant values in our automation framework.
 */
@UtilityClass
public class Constants {

    /**
     * directory for video recording
     */
    public final String VIDEO_DIRECTORY = USER_DIR.concat("/target").concat("/video");
    /**
     * directory for Chrome download files
     */
    public final String CHROME_DOWNLOAD_DIRECTORY = USER_DIR.concat("/target").concat("/downloads");
    /**
     * a constant for the access token
     */
    public final String ACCESS_TOKEN = "accessToken";
    /**
     * a constant for ios client bundle id
     */
    public final String IOS_CLIENT_BUNDLE_ID = "com.talktala.talktala";
    /**
     * a constant for image path
     */
    public final String IMAGE_PATH = "/resources/images/ld_token.png";
    /**
     * a constant for Excel path
     */
    public final String EXCEL_PATH = Paths.get(USER_DIR).getParent() + "/resources/TalkSpace Report auto.xlsx";

    /**
     * diff tolerance percent for visual regression tracker image comparison
     */
    public final Float DIFF_TOLERANCE_PERCENT = 0.01F;
    /**
     * @see <a href="https://talktala.atlassian.net/browse/PLATFORM-4375">Set up a custom User Agent for the automation tests</a>
     */
    public final String AUTOMATION_USER_AGENT = "talkspace-automation";
}

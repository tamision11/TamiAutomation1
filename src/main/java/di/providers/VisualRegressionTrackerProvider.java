package di.providers;

import com.google.inject.Inject;
import com.google.inject.Provider;
import entity.Data;
import io.visual_regression_tracker.sdk_java.VisualRegressionTracker;
import io.visual_regression_tracker.sdk_java.VisualRegressionTrackerConfig;

import java.util.Optional;

/**
 * User: nirtal
 * Date: 22/08/2021
 * Time: 10:56
 * Created with IntelliJ IDEA
 *
 * @see <a href="https://github.com/Visual-Regression-Tracker/sdk-java">Java SDK for Visual Regression Tracker</a>
 */
public class VisualRegressionTrackerProvider implements Provider<VisualRegressionTracker> {

    @Inject
    private Data data;

    @Override
    public VisualRegressionTracker get() {
        var buildNumber = Optional.ofNullable(System.getProperty("build_number")).orElse("Local run");
        var projectId = buildNumber.equals("Local run") ? data.getConfiguration().getVrt().localProjectId() : data.getConfiguration().getVrt().remoteProjectId();
        return new VisualRegressionTracker(new VisualRegressionTrackerConfig(
                // apiUrl - URL where backend is running
                data.getConfiguration().getVrt().url(),
                // apiKey - User apiKey
                data.getConfiguration().getVrt().apiKey(),
                // project - Project name or ID
                projectId,
                // branch - Current git branch
                "master",
                // ciBuildId - id of the build in CI system
                buildNumber,
                // enableSoftAssert - Log errors instead of exceptions
                true,
                // httpTimeoutInSeconds - define http socket timeout in seconds (default 10s)
                15
        ));
    }
}

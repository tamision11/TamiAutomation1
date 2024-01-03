package enums.feature_flag;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * User: nirtal
 * Date: 02/01/2022
 * Time: 13:53
 * Created with IntelliJ IDEA
 * <p>
 * list of public feature flags
 *
 * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2730">clean up Cognito from our automation codey</a>
 */
@AllArgsConstructor
@Getter
public enum PublicFeatureFlagType {
    STRIPE_LINK("stripe_link");

    private final String name;
}

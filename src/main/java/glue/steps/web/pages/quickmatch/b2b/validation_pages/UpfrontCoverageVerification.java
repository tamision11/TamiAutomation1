package glue.steps.web.pages.quickmatch.b2b.validation_pages;

import entity.User;
import enums.Address;
import enums.Us_States;

import java.util.Map;

/**
 * User: nirtal
 * Date: 13/06/2023
 * Time: 23:02
 * Created with IntelliJ IDEA
 *
 * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2987">QM - adjust our QM flow 90 tests to the Upfront coverage verification flow</a>
 */
public class UpfrontCoverageVerification extends BasicValidationWebPage {

    /**
     * if the email already filled - do nothing - happens on eligibility widget.
     *
     * @param userDetails the user details.
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    @Override
    public void enterDetails(User user, Map<String, String> userDetails) throws InterruptedException {
        super.enterDetails(user, userDetails);
        if (userDetails.containsKey("address")) {
            user.setAddress(Address.valueOf(userDetails.get("address")));
            commonWebPage.selectOptionFromDropdown(getState()::click, "I live outside of the US");
            commonWebPage.selectOptionFromDropdown(getCountryDropDown()::click, user.getAddress().getCountry());
        } else if (userDetails.containsKey("state")) {
            commonWebPage.selectOptionFromDropdown(getState()::click, Us_States.valueOf(userDetails.get("state")).getName());
        }
    }
}

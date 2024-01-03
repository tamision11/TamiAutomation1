package glue.steps.web.pages.quickmatch.b2b.validation_pages;

import entity.User;
import enums.Us_States;

import java.util.Map;


public class OutOfNetworkValidationWebPage extends BasicValidationWebPage {

    /**
     * if the email already filled - do nothing - happens on eligibility widget.
     *
     * @param userDetails the user details.
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    @Override
    public void enterDetails(User user, Map<String, String> userDetails) throws InterruptedException {
        super.enterDetails(user, userDetails);
        commonWebPage.selectOptionFromDropdown(getState()::click, Us_States.valueOf(userDetails.get("state")).getName());
    }
}
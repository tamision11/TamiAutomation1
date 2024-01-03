package glue.steps.web.pages.quickmatch.b2b.validation_pages;

import entity.User;
import enums.EmployeeRelation;

import java.util.Map;

/**
 * User: nirtal
 * Date: 19/04/2021
 * Time: 13:02
 * Created with IntelliJ IDEA
 */
public class EapValidationWebPage extends BasicValidationWebPage {

    @Override
    public void enterDetails(User user, Map<String, String> userDetails) throws InterruptedException {
        super.enterDetails(user, userDetails);
        fillPhoneDetails(user, userDetails);
        commonWebPage.selectOptionFromDropdown(getReferralDropdown()::click, data.getUserDetails().getReferral());
        commonWebPage.selectOptionFromDropdown(getEmployeeRelation()::click, EmployeeRelation.valueOf(userDetails.get("employee Relation")).getValue());
    }
}
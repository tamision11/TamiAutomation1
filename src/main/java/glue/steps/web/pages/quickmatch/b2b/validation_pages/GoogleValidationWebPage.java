package glue.steps.web.pages.quickmatch.b2b.validation_pages;

import entity.User;
import enums.EmployeeRelation;

import java.util.Map;

/**
 * User: nirtal
 * Date: 19/04/2021
 * Time: 13:02
 * Created with IntelliJ IDEA
 * <p>
 * google form has employeeID which differs from EAP forms
 */
public class GoogleValidationWebPage extends BasicValidationWebPage {

    @Override
    public void enterDetails(User user, Map<String, String> userDetails) throws InterruptedException {
        super.enterDetails(user, userDetails);
        fillPhoneDetails(user, userDetails);
        getInputEmployeeId().sendKeys(data.getUserDetails().getEmployeeId());
        // if organization is not prefilled complete it
        if (!getInputOrganization().getAttribute("value").contains(data.getUserDetails().getOrganizationName().get("google"))) {
            getInputOrganization().sendKeys(data.getUserDetails().getOrganizationName().get("google"));
        }
        commonWebPage.selectOptionFromDropdown(getReferralDropdown()::click, data.getUserDetails().getReferral());
        commonWebPage.selectOptionFromDropdown(getEmployeeRelation()::click, EmployeeRelation.valueOf(userDetails.get("employee Relation")).getValue());
    }
}
package glue.steps.web.pages.quickmatch.b2b.validation_pages;

import entity.User;
import enums.Address;
import enums.EmployeeRelation;
import enums.Us_States;
import org.apache.commons.lang3.StringUtils;

import java.util.Locale;
import java.util.Map;

/**
 * User: nirtal
 * Date: 19/04/2021
 * Time: 13:02
 * Created with IntelliJ IDEA
 */
public class SharedValidationWebPage extends BasicValidationWebPage {

    /**
     * if the email already filled - do nothing - happens on eligibility widget (confirmed with Asaf).
     * if the zip already filled - do nothing
     *
     * @param userDetails the user details.
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    @Override
    public void enterDetails(User user, Map<String, String> userDetails) throws InterruptedException {
        super.enterDetails(user, userDetails);
        if (userDetails.getOrDefault("address", "US").equals("US")) {
            commonWebPage.selectOptionFromDropdown(getCountryDropDown()::click, new Locale("", "US").getDisplayCountry());
            if (StringUtils.isBlank(getState().getAttribute("value"))) {
                commonWebPage.selectOptionFromDropdown(getState()::click, Us_States.valueOf(userDetails.get("state")).getName());
            }
        } else {
            user.setAddress(Address.valueOf(userDetails.get("address")));
            commonWebPage.selectOptionFromDropdown(getCountryDropDown()::click, user.getAddress().getCountry());
            getState().sendKeys(user.getAddress().getState());
        }
        fillPhoneDetails(user, userDetails);
        getInputUnitAddress().sendKeys(user.getAddress().getUnitAddress());
        getInputCity().sendKeys(user.getAddress().getCity());
        getInputHomeAddress().sendKeys(user.getAddress().getHomeAddress());
        if (StringUtils.isBlank(getInputZipCode().getAttribute("value"))) {
            getInputZipCode().sendKeys(user.getAddress().getZipCode());
        }
        commonWebPage.selectOptionFromDropdown(getReferralDropdown()::click, data.getUserDetails().getReferral());
        commonWebPage.selectOptionFromDropdown(getEmployeeRelation()::click, EmployeeRelation.valueOf(userDetails.get("employee Relation")).getValue());
    }
}
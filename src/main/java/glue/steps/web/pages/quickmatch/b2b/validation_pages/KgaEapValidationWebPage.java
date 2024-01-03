package glue.steps.web.pages.quickmatch.b2b.validation_pages;

import entity.User;
import enums.Address;
import enums.Us_States;
import enums.data.AuthCode;
import org.apache.commons.lang3.StringUtils;

import java.util.Locale;
import java.util.Map;

/**
 * User: nirtal
 * Date: 13/10/2021
 * Time: 2:00
 * Created with IntelliJ IDEA
 *
 * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2557">QA - Add home address collection to optum EAP flow (62)</a>
 */
public class KgaEapValidationWebPage extends EapValidationWebPage {

    /**
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
        getInputAuthorizationCode().sendKeys(AuthCode.valueOf(userDetails.get("authorization code")).getCode());
        getInputUnitAddress().sendKeys(user.getAddress().getUnitAddress());
        getInputCity().sendKeys(user.getAddress().getCity());
        getInputHomeAddress().sendKeys(user.getAddress().getHomeAddress());
        if (StringUtils.isBlank(getInputZipCode().getAttribute("value"))) {
            getInputZipCode().sendKeys(user.getAddress().getZipCode());
        }
    }
}

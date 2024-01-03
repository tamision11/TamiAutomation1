package glue.steps.web.pages.quickmatch.b2b.validation_pages;

import entity.User;
import enums.Address;
import enums.Us_States;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.Keys;

import java.util.Locale;
import java.util.Map;

/**
 * User: nirtal
 * Date: 03/09/2023
 * Time: 13:08
 * Created with IntelliJ IDEA
 */
public class BroadwayvValidationWebPage extends BasicValidationWebPage {

    /**
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
            commonWebPage.selectOptionFromDropdown(getState()::click, user.getAddress().getState());
        }
        getInputUnitAddress().sendKeys(user.getAddress().getUnitAddress());
        getInputCity().sendKeys(user.getAddress().getCity());
        getInputHomeAddress().sendKeys(user.getAddress().getHomeAddress());
        if (StringUtils.isBlank(getInputZipCode().getAttribute("value"))) {
            getInputZipCode().sendKeys(user.getAddress().getZipCode());
        }
        if (userDetails.containsKey("school")) {
            if (userDetails.get("school").equals("other")) {
                actions.click(getAttendedSchoolDropdown())
                        .sendKeys(scenarioContext.getScenarioStartTime().toString())
                        .sendKeys(Keys.ENTER)
                        .build()
                        .perform();
            } else {
                commonWebPage.selectOptionFromDropdown(getAttendedSchoolDropdown()::click, userDetails.get("school"));
            }
        }
    }
}
package glue.steps.web.pages.quickmatch.b2b.validation_pages;

import common.glue.utilities.GeneralActions;
import entity.User;
import enums.EmployeeRelation;
import enums.data.AuthCode;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.util.Map;

/**
 * User: nirtal
 * Date: 19/04/2021
 * Time: 13:02
 * Created with IntelliJ IDEA
 * shared validation form + eap validation form + Cigna EAP addition.
 *
 * @see <a href="https://talktala.atlassian.net/browse/NYC-6527">https://talktala.atlassian.net/browse/NYC-6527/a>
 */
public class CignaEapValidationWebPage extends SharedValidationWebPage {

    @Override
    public void enterDetails(User user, Map<String, String> userDetails) throws InterruptedException {
        super.enterDetails(user, userDetails);
        //EAP additional information
        commonWebPage.selectOptionFromDropdown(getReferralDropdown()::click, data.getUserDetails().getReferral());
        commonWebPage.selectOptionFromDropdown(getEmployeeRelation()::click, EmployeeRelation.valueOf(userDetails.get("employee Relation")).getValue());
        //endregion
        //region Cigna EAP additional information
        if (userDetails.containsKey("authorization code")) {
            wait.until(ExpectedConditions.visibilityOf(getInputAuthorizationCode())).sendKeys(AuthCode.valueOf(userDetails.get("authorization code")).getCode());
        }
        if (userDetails.containsKey("authorization code expiration")) {
            var authorizationCodeExpiration = userDetails.get("authorization code expiration");
            authorizationCodeExpiration = switch (authorizationCodeExpiration) {
                case "future date" -> GeneralActions.generateDate(-180, 0, 0);
                case "past date" -> GeneralActions.generateDate(10, 0, 0);
                case "invalid future date" -> GeneralActions.generateDate(-181, 0, 0);
                default -> throw new IllegalStateException("Unexpected value: " + authorizationCodeExpiration);
            };
            wait.until(ExpectedConditions.visibilityOf(getInputAuthorizationCodeExpiration())).sendKeys(authorizationCodeExpiration);
        }
        getSessionDiv().click();
        wait.until(ExpectedConditions.visibilityOfAllElements(getSessionNumbers())).get(Integer.parseInt(userDetails.get("session number")) - 3).click();
        //endregion
    }
}
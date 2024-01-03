package glue.steps.web.pages.quickmatch.b2b.validation_pages;

import common.glue.utilities.GeneralActions;
import entity.User;
import enums.EmployeeRelation;
import enums.data.AuthCode;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.util.Map;

/**
 * User: nirtal
 * Date: 13/10/2021
 * Time: 2:00
 * Created with IntelliJ IDEA
 *
 * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2557">QA - Add home address collection to optum EAP flow (62)</a>
 */
public class OptumEapValidationWebPage extends SharedValidationWebPage {

    /**
     * on this from, user can choose 12+ as number of sessions that would entitle him with a 16 LVS voucher plan.
     *
     * @param user        the user.
     * @param userDetails the user details.
     * @throws InterruptedException if the thread is interrupted.
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2903">QM - add tests for Optum EAP new sign up flow</a>
     */
    @Override
    public void enterDetails(User user, Map<String, String> userDetails) throws InterruptedException {
        super.enterDetails(user, userDetails);
        //EAP additional information
        commonWebPage.selectOptionFromDropdown(getReferralDropdown()::click, data.getUserDetails().getReferral());
        commonWebPage.selectOptionFromDropdown(getEmployeeRelation()::click, EmployeeRelation.valueOf(userDetails.get("employee Relation")).getValue());
        //endregion
        //region Optum EAP additional information
        if (userDetails.containsKey("authorization code")) {
            wait.until(ExpectedConditions.visibilityOf(getInputAuthorizationCode())).sendKeys(AuthCode.valueOf(userDetails.get("authorization code")).getCode());
        }
        var authorizationCodeExpiration = userDetails.get("authorization code expiration");
        authorizationCodeExpiration = switch (authorizationCodeExpiration) {
            case "future date" -> GeneralActions.generateDate(-365, 0, 0);
            case "past date" -> GeneralActions.generateDate(10, 0, 0);
            case "invalid future date" -> GeneralActions.generateDate(-366, 0, 0);
            default -> throw new IllegalStateException("Unexpected value: " + authorizationCodeExpiration);
        };
        wait.until(ExpectedConditions.visibilityOf(getInputAuthorizationCodeExpiration())).sendKeys(authorizationCodeExpiration);
        getSessionDiv().click();
        if (userDetails.get("session number").contains("12+")) {
            wait.until(ExpectedConditions.visibilityOfAllElements(getSessionNumbers())).get((getSessionNumbers().size() - 1)).click();
        } else {
            wait.until(ExpectedConditions.visibilityOfAllElements(getSessionNumbers())).get(Integer.parseInt(userDetails.get("session number")) - 3).click();
        }
    }
}

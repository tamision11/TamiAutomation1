package glue.steps.web.pages.quickmatch.b2b.validation_pages;

import entity.User;
import enums.EmployeeRelation;
import enums.Us_States;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.util.Locale;
import java.util.Map;

/**
 * User: nirtal
 * Date: 29/08/2022
 * Time: 16:24
 * Created with IntelliJ IDEA
 */
public class CarelonEapValidationWebPage extends SharedValidationWebPage {

    @FindBy(css = "[data-qa=employeeFirstNameInput]")
    private WebElement employeeFirstNameInput;
    @FindBy(css = "[data-qa=employeeLastNameInput]")
    private WebElement employeeLastNameInput;
    @FindBy(css = "[data-qa=employeeSameAddressCheckboxCheckbox]")
    private WebElement employeeSameAddressCheckboxCheckbox;
    @FindBy(css = "[data-qa=employeeCountryDropdown]")
    private WebElement employeeCountryDropdown;
    @FindBy(css = "[data-qa=cityEmployeeInput]")
    private WebElement employeeCity;
    @FindBy(css = "[data-qa=addressLine1EmployeeInput]")
    private WebElement employeeAddress;
    @FindBy(css = "[data-qa=employeeStateDropdown]")
    private WebElement employeeStateDropdown;
    @FindBy(css = "[data-qa=zipCodeEmployeeInput]")
    private WebElement zipCodeEmployeeInput;

    @Override
    public void enterDetails(User user, Map<String, String> userDetails) throws InterruptedException {
        super.enterDetails(user, userDetails);
        // if employ relation is not employee, we will complete the extra fields related to carelon eap
        if (!EmployeeRelation.valueOf(userDetails.get("employee Relation")).getValue().equals(EmployeeRelation.EMPLOYEE.getValue())) {
            if (userDetails.containsKey("first name")) {
                employeeFirstNameInput.sendKeys(user.getFirstName());
            }
            if (userDetails.containsKey("last name")) {
                employeeLastNameInput.sendKeys(user.getLastName());
            }
            if (userDetails.containsKey("Employee’s address is the same as mine")) {
                employeeSameAddressCheckboxCheckbox.click();
            } else {
                commonWebPage.selectOptionFromDropdown(employeeCountryDropdown::click, new Locale("", "US").getDisplayCountry());
                commonWebPage.selectOptionFromDropdown(employeeStateDropdown::click, Us_States.valueOf(userDetails.get("state")).getName());
                employeeCity.sendKeys(user.getAddress().getCity());
                commonWebPage.selectOptionFromDropdown(employeeCountryDropdown::click, new Locale("", "US").getDisplayCountry());
                employeeAddress.sendKeys(user.getAddress().getUnitAddress());
                zipCodeEmployeeInput.sendKeys(user.getAddress().getZipCode());
            }
        }
    }
}

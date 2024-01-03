package glue.steps.web.pages.clientweb;

import common.glue.steps.web.pages.WebPage;
import io.cucumber.java.en.When;
import lombok.Getter;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static org.openqa.selenium.support.ui.ExpectedConditions.elementToBeClickable;

@Getter
public class FinancialAidFormWebPage extends WebPage {

    @FindBy(css = "[data-qa=financialAidIsServingInMilitaryPrimaryButton]")
    private WebElement buttonYesServingInMilitary;
    @FindBy(css = "[data-qa=financialAidIsServingInMilitarySecondaryButton]")
    private WebElement buttonNoServingInMilitary;
    @FindBy(css = "[data-qa=financialAidIsVeteranPrimaryButton]")
    private WebElement buttonIsVeteranYes;
    @FindBy(css = "[data-qa=financialAidIsVeteranSecondaryButton]")
    private WebElement buttonIsVeteranNo;
    @FindBy(css = "[data-qa=financialAidHouseholdBenefitsSecondaryButton]")
    private WebElement buttonNoHouseholdBenefits;
    @FindBy(css = "[data-qa=financialAidIsLivingInRuralAreaPrimaryButton]")
    private WebElement buttonYesLivingInRuralArea;
    @FindBy(css = "[data-qa=financialAidIsLivingInRuralAreaSecondaryButton]")
    private WebElement buttonNoLivingInRuralArea;
    @FindBy(css = "[data-qa=financialAidCheckEligibilityPrimaryButton]")
    private WebElement buttonCheckEligibility;
    @FindBy(css = "[data-qa=applyFinancialAidApplyButton]")
    private WebElement applyFinancialAidDiscount;
    @FindBy(css = "[data-qa=financialAidDoneButton]")
    private WebElement doneButton;

    @When("Financial aid - Click yes under serving in military")
    public void financialAidMilitaryServiceYesButton() {
        wait.until(elementToBeClickable(buttonYesServingInMilitary)).click();
    }

    @When("Financial aid - Click no under serving in military")
    public void financialAidMilitaryServiceNoButton() {
        wait.until(elementToBeClickable(buttonNoServingInMilitary)).click();
    }

    @When("Financial aid - Click yes under is veteran")
    public void financialAidIsVeteranYesButton() {
        wait.until(elementToBeClickable(buttonIsVeteranYes)).click();
    }

    @When("Financial aid - Click no under is veteran")
    public void financialAidIsVeteranNoButton() {
        wait.until(elementToBeClickable(buttonIsVeteranNo)).click();
    }

    @When("Financial aid - Click no household benefits")
    public void financialAidNoHouseholdBenefitsButton() {
        wait.until(elementToBeClickable(buttonNoHouseholdBenefits)).click();
    }

    @When("Financial aid - Click yes living in rural area")
    public void financialAidYesLivingInRuralAreaButton() {
        wait.until(elementToBeClickable(buttonYesLivingInRuralArea)).click();
    }

    @When("Financial aid - Click no living in rural area")
    public void financialAidNoLivingInRuralAreaButton() {
        wait.until(elementToBeClickable(buttonNoLivingInRuralArea)).click();
    }

    @When("Financial aid - Click check eligibility")
    public void financialAidCheckEligibilityButton() {
        wait.until(elementToBeClickable(buttonCheckEligibility)).click();
    }

    @When("Financial aid - Click apply financial aid discount")
    public void applyFinancialAidDiscountButton() {
        wait.until(elementToBeClickable(applyFinancialAidDiscount)).click();
    }

    @When("Financial aid - Click done")
    public void doneButton() {
        wait.until(elementToBeClickable(doneButton)).click();
    }
}

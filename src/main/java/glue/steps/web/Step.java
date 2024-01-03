package glue.steps.web;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.inject.Inject;
import common.glue.steps.api.ClientSteps;
import common.glue.steps.api.CommonTalkspaceApiSteps;
import common.glue.steps.api.TherapistSteps;
import common.glue.steps.api.email.MailinatorApiSteps;
import common.glue.steps.web.pages.CommonWebWebPage;
import common.glue.steps.web.pages.clientweb.*;
import common.glue.steps.web.pages.clientweb.myaccount.LoginAndSecurityWebPage;
import common.glue.steps.web.pages.clientweb.myaccount.PaymentAndPlanWebPage;
import common.glue.steps.web.pages.clientweb.myaccount.PersonalInformationWebPage;
import common.glue.steps.web.pages.quickmatch.FlowWebPage;
import common.glue.steps.web.pages.quickmatch.MatchingWebPage;
import common.glue.steps.web.pages.quickmatch.b2b.B2B_Web_Page;
import common.glue.steps.web.pages.quickmatch.b2b.validation_pages.*;
import di.providers.ScenarioContext;
import entity.Data;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.devtools.DevTools;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.WebDriverWait;

/**
 * User: nirtal
 * Date: 14/10/2021
 * Time: 14:29
 * Created with IntelliJ IDEA
 * <p>
 * this class contains all the step dependencies.
 */
public abstract class Step {

    @Inject
    protected WebDriver driver;
    @Inject
    protected Actions actions;
    @Inject
    protected PersonalInformationWebPage personalInformationPage;
    @Inject
    protected OnboardingWebPage onboardingWebPage;
    @Inject
    protected CancelSubscriptionFormWebPage cancelWebPage;
    @Inject
    protected FlowWebPage flowWebPage;
    @Inject
    protected ScenarioContext scenarioContext;
    @Inject
    protected LoginAndSecurityWebPage loginAndSecurityPage;
    @Inject
    protected RoomWebPage roomPage;
    @Inject
    protected PaymentAndPlanWebPage paymentAndPlanPage;
    @Inject
    protected LoginWebPage loginWebPage;
    @Inject
    protected ChangeTherapistWebPage changeTherapistWebPage;
    @Inject
    protected Data data;
    @Inject
    protected CommonWebWebPage commonWebPage;
    @Inject
    protected SuperBillsWebPage superBillsWebPage;
    @Inject
    protected MatchingWebPage matchingPage;
    @Inject
    protected WebDriverWait wait;
    @Inject
    protected CommonTalkspaceApiSteps commonTalkspaceApiSteps;
    @Inject
    protected TreatmentIntakeWebPage treatmentIntakePage;
    @Inject
    protected DevTools devTools;
    @Inject
    protected ClientSteps clientSteps;
    @Inject
    protected TherapistSteps therapistSteps;
    @Inject
    protected CommonWebSteps commonWebSteps;
    @Inject
    protected ObjectMapper objectMapper;
    @Inject
    protected common.glue.steps.web.pages.quickmatch.b2b.validation_pages.OptumEapValidationWebPage optumEapNewFirstValidationPage;
    @Inject
    protected GoogleValidationWebPage googleFirstValidationPage;
    @Inject
    protected BroadwayvValidationWebPage broadwayvValidationWebPage;
    @Inject
    protected SharedValidationWebPage sharedNewFirstValidationPage;
    @Inject
    protected SharedValidationWebPageAfterUpfront sharedValidationWebPageAfterUpfront;
    @Inject
    protected EapValidationWebPage eapNewFirstValidationPage;
    @Inject
    protected CignaEapValidationWebPage cignaEapNewFirstValidationPage;
    @Inject
    protected CarelonEapValidationWebPage carelonEapValidationWebPage;
    @Inject
    protected KgaEapValidationWebPage kgaEapValidationWebPage;
    @Inject
    protected OutOfNetworkValidationWebPage outOfNetworkValidationPage;
    @Inject
    protected UpfrontCoverageVerification upfrontCoverageVerification;
    @Inject
    protected B2B_Web_Page b2b;
    @Inject
    protected MailinatorApiSteps mailinatorApiSteps;
    @Inject
    protected TwoFactorAuthenticationWebPage twoFactorAuthenticationWebPage;
}
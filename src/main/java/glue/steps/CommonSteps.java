package glue.steps;

import com.google.common.util.concurrent.Uninterruptibles;
import com.google.inject.Inject;
import common.glue.utilities.GeneralActions;
import entity.Data;
import entity.User;
import enums.UserEmailType;
import enums.data.EapMemberIDType;
import enums.data.PhoneNumberType;
import io.cucumber.java.Scenario;
import io.cucumber.java.en.And;
import io.cucumber.java.en.When;
import org.apache.commons.lang3.StringUtils;

import java.time.Duration;

/**
 * User: nirtal
 * Date: 13/08/2021
 * Time: 20:51
 * Created with IntelliJ IDEA
 */
public class CommonSteps {

    @Inject
    private Data data;

    @And("Wait {int} seconds")
    public void waitSeconds(int seconds) {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(seconds));
    }

    /**
     * create a new user with a unique email address
     * used in parental consent flows to create a new parent/guardian user and fetch the consent link
     *
     * @param userType the {@link User} type
     */
    @And("Create {string} user")
    public void createParentUser(String userType) {
        if (userType.equals("parent")) {
            data.getUsers().put(userType, User.createUser()
                    .withEmail(GeneralActions.getEmailAddress(UserEmailType.NEW))
                    .withFirstName("TestParent")
                    .withLastName("AutomationParent")
                    .withPhoneNumber(PhoneNumberType.FAKE.getValue())
                    .withPendingEmail(StringUtils.EMPTY)
                    .create());
        } else if (userType.equals("guardian")) {
            data.getUsers().put(userType, User.createUser()
                    .withEmail(GeneralActions.getEmailAddress(UserEmailType.NEW))
                    .withFirstName("TestGuardian")
                    .withLastName("AutomationGuardian")
                    .withPhoneNumber(PhoneNumberType.FAKE.getValue())
                    .withPendingEmail(StringUtils.EMPTY)
                    .create());
        } else throw new IllegalArgumentException("User type not supported");
    }

    /**
     * this step is used only when updating password > logout without buying rooms,
     * to avoid errors when trying to cancel the room on {@link Hooks#cancelSubscriptionForRoom(Scenario)}
     *
     * @param user the {@link User} that its accessed token we be revoked
     */
    @When("Revoke access token for {user} user")
    public void revokeAccessToken(User user) {
        user.setLoginToken(StringUtils.EMPTY);
    }

    /**
     * Updating the default fake phone number that is set for primary/partner at {@link Hooks#startScenario(Scenario)}
     *
     * @param user            the  {@link User}
     * @param phoneNumberType the associated {@link PhoneNumberType} of the {@link User}
     */
    @And("Set {user} user phone number to {} number")
    public void setUserPhoneNumber(User user, PhoneNumberType phoneNumberType) {
        user.setPhoneNumber(phoneNumberType.getValue());
    }

    /**
     * Updating the default-first name that is set for primary/partner at {@link Hooks#startScenario(Scenario)
     * this is mainly used for EAP members when submitting claims
     * <p>
     *
     * @param user            the  {@link User}
     * @param eapMemberIDType the associated {@link EapMemberIDType} of the {@link User}
     */
    @And("Set {user} user first name to {}")
    public void setFirstName(User user, EapMemberIDType eapMemberIDType) {
        user.setFirstName(eapMemberIDType.getMemberID());
    }

    /**
     * Updating the default-last name that is set for primary/partner at {@link Hooks#startScenario(Scenario)
     * this is mainly used for BH members when submitting claims
     * <p>
     *
     * @param user            the  {@link User}
     * @param eapMemberIDType the associated {@link EapMemberIDType} of the {@link User}
     */
    @And("Set {user} user last name to Automation")
    public void setFirstName(User user) {
        user.setLastName(data.getUserDetails().getLastName());
    }

    /**
     * Updating the default fake email that is set for primary/partner at {@link Hooks#startScenario(Scenario)}
     *
     * @param user          the {@link User}
     * @param userEmailType the associated {@link UserEmailType} of the {@link User}
     */
    @And("Set {user} user email to {} email")
    public void setUserEmail(User user, UserEmailType userEmailType) {
        user.setEmail(GeneralActions.getEmailAddress(userEmailType));
    }
}

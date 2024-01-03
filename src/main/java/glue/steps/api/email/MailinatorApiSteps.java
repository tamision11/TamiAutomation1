package glue.steps.api.email;

import com.google.common.base.CharMatcher;
import com.google.common.util.concurrent.Uninterruptibles;
import com.google.inject.Inject;
import com.google.inject.Provider;
import com.manybrain.mailinator.client.MailinatorClient;
import com.manybrain.mailinator.client.message.*;
import di.providers.ScenarioContext;
import entity.Data;
import entity.User;
import enums.data.PhoneNumberType;
import io.cucumber.java.en.When;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.SoftAssertions;
import org.awaitility.Awaitility;
import org.openqa.selenium.NotFoundException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.html5.WebStorage;

import java.time.Duration;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * @see <a href="https://www.mailinator.com/docs/index.html#mailinator">Mailinator API</a>
 */
public class MailinatorApiSteps {
    @Inject
    private WebDriver driver;
    @Inject
    private Data data;
    @Inject
    private MailinatorClient mailinatorClient;
    @Inject
    private Provider<Inbox> inbox;
    @Inject
    private ScenarioContext scenarioContext;

    @When("Mailinator API - Get verification code from {user} user email")
    public void getTheVerificationCodeFromEmail(User user) {
        user.setVerificationCode(getVerificationCode(user));
    }

    public void getTwoFactorVerificationCodeFromEmail(User user) {
        user.setOtpCode(getTwoFactorVerificationCode(user));
    }

    public void getTwoFactorVerificationCodeFromEmail(User user, int emailIndex) {
        user.setOtpCode(getTwoFactorVerificationCode(user, emailIndex));
    }


    /**
     * Counting the SMS messages received to a specific associated phone number
     * from the beginning of the scenario.
     *
     * @param phoneNumberType the associated phone number
     */
    @When("Mailinator API - Count incoming SMS to {} phone")
    public void getSmsCount(PhoneNumberType phoneNumberType) {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(10));
        scenarioContext.getSmsCount()
                .put(phoneNumberType, inbox.get()
                        .getMsgs()
                        .stream()
                        .filter(message -> message.getTime() > scenarioContext.getScenarioStartTime())
                        .filter(message -> message.getTo().equals(phoneNumberType.getValue().substring(1)))
                        .count());
    }

    /**
     * verifying the number of incoming messages forwarded from <a href="https://www.twilio.com/">twilio</a>
     * to a specific associated phone number from the beginning of the scenario.
     *
     * @param phoneNumberType  the associated phone number
     * @param numberOfMessages number of messages
     */
    @When("Mailinator API - {} phone has {int} more OTP message after the last count")
    public void countInboxForPhone(PhoneNumberType phoneNumberType, int numberOfMessages) {
        Awaitility
                .await()
                .alias("waiting for " + numberOfMessages + " messages to arrive to " + phoneNumberType + " phone")
                .atMost(Duration.ofMinutes(2))
                .pollInterval(Duration.ofSeconds(10))
                .untilAsserted(() ->
                        assertThat(inbox
                                .get()
                                .getMsgs()
                                .stream()
                                .filter(message -> message.getTime() > scenarioContext.getScenarioStartTime())
                                .filter(message -> message.getTo().equals(phoneNumberType.getValue().substring(1))))
                                .as("OTP messages in the inbox for %s phone", phoneNumberType.getValue())
                                .hasSize(Math.toIntExact(scenarioContext.getSmsCount().get(phoneNumberType)) + numberOfMessages));
    }

    /**
     * getting the email link by a partial link name.
     *
     * @param user          the user that will receive the incoming email.
     * @param emailSubject  the subject of the email.
     * @param linkToExtract the link to extract from the email.
     * @return desired link.
     */
    private String getEmailLinkByName(User user, String emailSubject, String linkToExtract) {
        var message = getMessageBySubject(user, emailSubject);
        var links = mailinatorClient.request(new GetLinksRequest(data.getMailinator().domainName(), user.getEmail().split("@")[0], message.getId()));
        return links.getLinks()
                .stream()
                .filter(link -> link.contains(linkToExtract))
                .findFirst()
                .orElseThrow(() -> new NotFoundException("The link '%s' is not found".formatted(linkToExtract)));
    }

    /**
     * getting the email link by a partial link text that surrounds the link.
     *
     * @param user            the user that will receive the incoming email.
     * @param emailSubject    the subject of the email.
     * @param surroundingText the surrounding text link CTA.
     * @return desired link.
     */
    private String getLinkBySurroundingText(User user, String emailSubject, String surroundingText) {
        var message = mailinatorClient.request(new GetMessageRequest(data.getMailinator().domainName(), user.getEmail().split("@")[0], getMessageBySubject(user, emailSubject).getId()));
        return StringUtils.substringBetween(message.getParts().get(0).getBody(), surroundingText, ")")
                .replace("(", StringUtils.EMPTY)
                .replace("&amp;", "&");
    }

    /**
     * getting the message from the user's inbox by subject.
     * <p>
     * in case the email didn't arrive we need to verify on <a href="https://app.sendgrid.com/">sendgrid</a> that it's not there prior to opening a bug.
     *
     * @param user         the user that will receive the incoming email.
     * @param emailSubject the subject of the email.
     * @return message.
     */
    private Message getMessageBySubject(User user, String emailSubject) {
        return Awaitility.await()
                .alias("waiting for email with subject '%s' to arrive to %s user".formatted(emailSubject, user.getEmail()))
                .atMost(Duration.ofMinutes(3))
                .pollInterval(Duration.ofSeconds(10))
                .ignoreExceptions()
                .until(() -> inbox.get()
                        .getMsgs()
                        .stream()
                        .filter(message -> message.getTo().equals(user.getEmail().split("@")[0]))
                        .filter(message -> message.getSubject().equals(emailSubject))
                        .findFirst()
                        .orElseThrow(), Objects::nonNull);
    }

    /**
     * @param user that his email should be verified.
     * @return verification code the user needs to continue the flow.
     */
    private String getVerificationCode(User user) {
        var message = mailinatorClient.request(new GetMessageRequest(data.getMailinator().domainName(), user.getEmail().split("@")[0], getMessageBySubject(user, "Your Talkspace verification code").getId()));
        return StringUtils.substringBetween(message.getParts().get(0).getBody(), "*", "*");
    }

    /**
     * we will get the second message because {@link common.glue.steps.web.ClientWebSteps#logInWith(User, boolean)}
     * calls internally to {@link common.glue.steps.api.ClientSteps#apiLoginToUser(User)} which triggers another 2fa.
     *
     * @param user whose two-factor code should be verified?
     * @return verification code the user needs to continue the flow.
     */
    private String getTwoFactorVerificationCode(User user) {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(10));
        return CharMatcher.inRange('0', '9')
                .retainFrom(inbox.get()
                        .getMsgs()
                        .stream()
                        .filter(message -> message.getTo().equals(user.getPhoneNumber().substring(1)))
                        .toList()
                        .get(1)
                        .getSubject());
    }

    /**
     * @param user       that his two-factor code should be verified.
     * @param emailIndex the index of the email to get the code from.
     * @return verification code the user needs to continue the flow.
     */
    private String getTwoFactorVerificationCode(User user, int emailIndex) {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(10));
        return CharMatcher.inRange('0', '9').retainFrom(inbox.get()
                .getMsgs()
                .stream()
                .filter(message -> message.getTo().equals(user.getPhoneNumber().substring(1)))
                .toList()
                .get(emailIndex)
                .getSubject());
    }


    /**
     * used to verify the email content.
     *
     * @param emailContent the content of the email.
     * @param user         the user that will receive the incoming email.
     * @param emailSubject the subject of the email.
     */
    @When("Mailinator API - {user} user has the following email subject at his inbox {string}")
    public void verifyEmailOnInbox(User user, String emailSubject, List<String> emailContent) {
        Awaitility.await()
                .alias("waiting for email with subject '%s' to arrive to %s user".formatted(emailSubject, user.getEmail()))
                .atMost(Duration.ofMinutes(3))
                .pollInterval(Duration.ofSeconds(10))
                .ignoreExceptions()
                .untilAsserted(() ->
                {
                    var memberInbox = mailinatorClient.request(new GetInboxRequest(data.getMailinator().domainName(), user.getEmail().split("@")[0], 0, 100, Sort.ASC, true));
                    var messagesContent = memberInbox.getMsgs()
                            .stream()
                            .filter(message -> message.getSubject().equals(emailSubject))
                            .map(message -> mailinatorClient.request(new GetMessageRequest(data.getMailinator().domainName(), user.getEmail().split("@")[0], message.getId())))
                            .map(Message::getParts)
                            .flatMap(List::stream)
                            .map(Part::getBody)
                            .collect(Collectors.joining());
                    SoftAssertions.assertSoftly(softAssertions -> emailContent.forEach(content -> softAssertions.assertThat(messagesContent)
                            .as("message content")
                            .containsIgnoringWhitespaces(content)));
                });
    }

    /**
     * on success:
     * <ul>
     *    <li> disable intro video experiment.
     *  </ul>
     *
     * @param user that his email should be verified.
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2611">disable intro video experiment </a>
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2619">Ignore 10 min intro experiment</a>
     * @see <a href="https://talktala.atlassian.net/browse/PLATFORM-1215">added an automation workaround code to delete 2fa session storage key in case of partner invatation.</a>
     */
    @When("Mailinator API - Verify {user} user Email")
    public void clickOnGetStartedInsideEmail(User user) {
        driver.get(getLinkBySurroundingText(user, "Verify your email address", "Verify email"));
        ((WebStorage) driver).getSessionStorage().setItem("ignore-experiments", BooleanUtils.TRUE);
        var twoFactorAuthenticationLocalStorageKey = "2faReminderLastDisplayedAt";
        if (StringUtils.isNotBlank(((WebStorage) driver).getLocalStorage().getItem(twoFactorAuthenticationLocalStorageKey))) {
            ((WebStorage) driver).getLocalStorage().removeItem(twoFactorAuthenticationLocalStorageKey);
        }
        Awaitility
                .await()
                .alias("waiting for the user to be logged in")
                .atMost(Duration.ofMinutes(2))
                .until(() -> !driver.getCurrentUrl().contains("email-verification"));
    }

    /**
     * in the cucumber table we need to decide if we want to:
     * get the link by name which internally calls {@link #getEmailLinkByName(User, String, String)}
     * or by surrounding text which internally calls {@link #getLinkBySurroundingText(User, String, String)}.
     *
     * @param user         the user that will receive the message
     * @param emailDetails <table>
     *                     <thead>
     *                     <th>User the following parameters</th>
     *                     <thead>
     *                     <tbody>
     *                     <tr><td>subject</td><td> the subject of the email</td></tr>
     *                     <tr><td>link name</td><td>the link to extract from the email</td></tr>
     *                     <tr><td>surrounding text</td><td>the surrounding text of the link CTA</td></tr>
     *                     </tbody>
     *                     </table>
     */
    @When("Mailinator API - Go to link on {user} user email")
    public void clickOnLink(User user, Map<String, String> emailDetails) {
        if (emailDetails.containsKey("link name")) {
            driver.get(getEmailLinkByName(user, emailDetails.get("subject"), emailDetails.get("link name")));
        } else if (emailDetails.containsKey("surrounding text")) {
            driver.get(getLinkBySurroundingText(user, emailDetails.get("subject"), emailDetails.get("surrounding text")));
        } else {
            throw new IllegalArgumentException("method to target links are by partial link name or surrounding text");
        }
    }
}
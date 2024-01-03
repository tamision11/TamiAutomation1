package glue.steps.stripe;

import com.google.common.util.concurrent.Uninterruptibles;
import com.google.inject.Inject;
import com.stripe.exception.StripeException;
import com.stripe.model.Customer;
import com.stripe.model.Invoice;
import com.stripe.param.InvoiceListParams;
import common.glue.utilities.GeneralActions;
import di.providers.ScenarioContext;
import entity.User;
import io.cucumber.java.en.Given;
import io.qameta.allure.Allure;
import io.vavr.control.Try;

import javax.ws.rs.core.MediaType;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * User: nirtal
 * Date: 12/02/2023
 * Time: 15:59
 * Created with IntelliJ IDEA
 *
 * @see <a href="https://stripe.com/docs/api?lang=java">Stripe Java SDK</a>
 */
public class StripeSteps {

    @Inject
    private ScenarioContext scenarioContext;

    /**
     * retrieve all invoices for the user and pay all unpaid invoices
     * <p>
     * we must have the following data:
     * {@link User#getCustomerId()
     *
     * @throws StripeException in case of an error
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-2895">get invoices for user id from stripe</a>
     */
    @Given("Stripe - Pay unpaid invoices for {user} user")
    public void payInvoice(User user) throws StripeException {
        Uninterruptibles.sleepUninterruptibly(Duration.ofSeconds(10));
        var invoices = Invoice.list(new InvoiceListParams.Builder()
                .setCustomer(user.getCustomerId())
                .build());
        Allure.addAttachment("Stripe Invoices details", MediaType.APPLICATION_JSON, invoices.toJson());
        invoices.getData().stream()
                .filter(invoice -> !invoice.getStatus().equals(InvoiceListParams.Status.PAID.getValue()))
                .forEach(invoice -> Try.run(invoice::pay));
    }

    /**
     * Detach payment method of the member - this will fail to charge the member on stripe
     * <p>
     * we must have the following data:
     * {@link User#getCustomerId()
     *
     * @throws StripeException in case of an error
     */
    @Given("Stripe - Detach payment method for {user} user")
    public void updateCreditCard(User user) throws StripeException {
        var customer = Customer.retrieve(user.getCustomerId());
        Allure.addAttachment("Stripe Customer details", MediaType.APPLICATION_JSON, customer.toJson());
        customer.listPaymentMethods()
                .getData()
                .get(0)
                .detach();
    }

    /**
     * Verify that the invoice status is as expected
     * <p>
     * we must have the following data in scenario context:
     * invoice_id
     *
     * @throws StripeException in case of an error
     */
    @Given("Stripe - Invoice status is {}")
    public void invoiceStatus(InvoiceListParams.Status status) throws StripeException {
        var invoice = Invoice.retrieve(scenarioContext.getSqlAndApiResults().get("invoice_id"));
        Allure.addAttachment("Stripe Invoice details", MediaType.APPLICATION_JSON, invoice.toJson());
        assertThat(invoice.getStatus())
                .as("invoice status")
                .isEqualTo(status.getValue());
    }

    /**
     * Verify that the invoice metadata is as expected
     * <p>
     * we must have the following data in scenario context:
     * invoice_id
     *
     * @throws StripeException in case of an error
     */
    @Given("Stripe - Invoice metadata is")
    public void invoiceMetadata(Map<String, String> expectedMetadata) throws StripeException {
        var invoice = Invoice.retrieve(scenarioContext.getSqlAndApiResults().get("invoice_id"));
        Allure.addAttachment("Stripe Invoice details", MediaType.APPLICATION_JSON, invoice.toJson());
        var metadata = invoice.getMetadata();
        var modifiedMap = new HashMap<>(expectedMetadata);
        modifiedMap.replaceAll((key, value) -> GeneralActions.replacePlaceholders(value, scenarioContext));
        assertThat(metadata)
                .as("invoice metadata")
                .containsAllEntriesOf(modifiedMap);
    }
}

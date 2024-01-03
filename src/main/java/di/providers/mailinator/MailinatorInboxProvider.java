package di.providers.mailinator;

import com.google.inject.Inject;
import com.google.inject.Provider;
import com.manybrain.mailinator.client.MailinatorClient;
import com.manybrain.mailinator.client.message.GetInboxRequest;
import com.manybrain.mailinator.client.message.Inbox;
import entity.Data;

public class MailinatorInboxProvider implements Provider<Inbox> {
    @Inject
    private MailinatorClient mailinatorClient;
    @Inject
    private Data data;

    @Override
    public Inbox get() {
        return mailinatorClient.request(new GetInboxRequest(data.getMailinator().domainName()));
    }
}

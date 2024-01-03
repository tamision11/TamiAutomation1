package di.providers.mailinator;

import com.manybrain.mailinator.client.MailinatorClient;
import entity.Data;
import jakarta.inject.Inject;
import jakarta.inject.Provider;

public class MailinatorClientProvider implements Provider<MailinatorClient> {
    @Inject
    private Data data;

    @Override
    public MailinatorClient get() {
        return new MailinatorClient(data.getMailinator().apiKey());
    }
}

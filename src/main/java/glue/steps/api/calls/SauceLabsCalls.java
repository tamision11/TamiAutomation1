package glue.steps.api.calls;

import com.google.inject.Inject;
import common.glue.utilities.GeneralActions;
import entity.Data;
import extensions.ClientExtension;
import jakarta.inject.Named;
import lombok.experimental.ExtensionMethod;
import org.apache.commons.lang3.StringUtils;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import static com.google.common.net.HttpHeaders.*;
import static javax.ws.rs.core.MediaType.APPLICATION_JSON;
import static javax.ws.rs.core.MediaType.WILDCARD;
import static org.apache.hc.client5.http.auth.StandardAuthScheme.BASIC;

/**
 * User: nirtal
 * Date: 29/08/2021
 * Time: 14:49
 * Created with IntelliJ IDEA
 */
@ExtensionMethod({ClientExtension.class})
public class SauceLabsCalls {

    @Inject
    private HttpClient client;
    @Inject
    private Data data;
    @Inject
    @Named("sauce_lab_user")
    private String sauceLabUser;
    @Inject
    @Named("sauce_lab_access_key")
    private String sauceLabAccessKey;

    /**
     * getting all sauce labs saved applications in their internal storage
     *
     * @return HTTP response.
     * @throws IOException          if an I/O error occurs
     * @throws InterruptedException if the current thread was interrupted while waiting
     * @see <a href="https://docs.saucelabs.com/dev/api/storage/#get-app-storage-files">Get App Storage Files</a>
     */
    public HttpResponse<String> getAppStorageFiles() throws IOException, InterruptedException {
        var request = HttpRequest.newBuilder(URI.create("https://api.us-west-1.saucelabs.com/v1/storage/files?name=%s_ios_client.ipa".formatted(data.getConfiguration().getDomain())))
                .headers(ACCEPT, WILDCARD,
                        CONTENT_TYPE, APPLICATION_JSON,
                        AUTHORIZATION, BASIC + StringUtils.SPACE + GeneralActions.encodeBase64(sauceLabUser
                                .concat(":")
                                .concat(sauceLabAccessKey)))
                .GET()
                .build();
        return client.send(request, HttpResponse.BodyHandlers.ofString());
    }

    /**
     * @return HTTP response.
     * @see <a href="https://docs.saucelabs.com/dev/api/rdc/#get-real-device-jobs">get-real-device-jobs</a>
     */
    public HttpResponse<String> getRunningJobsRealDevices() throws IOException, InterruptedException {
        var request = HttpRequest.newBuilder(URI.create("https://api.us-west-1.saucelabs.com/v1/rdc/jobs?limit=20"))
                .headers(ACCEPT, WILDCARD,
                        CONTENT_TYPE, APPLICATION_JSON,
                        AUTHORIZATION, BASIC + StringUtils.SPACE + GeneralActions.encodeBase64(sauceLabUser
                                .concat(":")
                                .concat(sauceLabAccessKey)))
                .GET()
                .build();
        return client.send(request, HttpResponse.BodyHandlers.ofString());
    }
}

package extensions;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.inject.Inject;
import common.glue.utilities.GeneralActions;
import io.qameta.allure.Allure;
import lombok.experimental.UtilityClass;
import org.apache.commons.lang3.StringUtils;

import java.net.http.HttpResponse;

import static javax.ws.rs.core.MediaType.APPLICATION_JSON;

/**
 * User: nirtal
 * Date: 08/11/2021
 * Time: 11:23
 * Created with IntelliJ IDEA
 * Extension methods for HTTP response.
 *
 * @see <a href="https://dzone.com/articles/lomboks-extension-methods">https://dzone.com/articles/lomboks-extension-methods</a>
 */
@UtilityClass
public class ResponseExtension {

    @Inject
    private ObjectMapper objectMapper;

    /**
     * Logging HTTP Response to Allure report
     *
     * @param response HTTP response
     * @return HTTP response
     */
    public HttpResponse<String> log(HttpResponse<String> response) {
        Allure.addAttachment("Response of %s".formatted(response.uri().toString()), APPLICATION_JSON, objectMapper.createObjectNode()
                .putPOJO("Headers", response.headers().map())
                .putPOJO("Body", StringUtils.isBlank(response.body()) ? StringUtils.EMPTY : GeneralActions.createObjectNodeFromString(response.body())).toPrettyString(), "json");
        return response;
    }
}

package di.providers;

import com.google.inject.Inject;
import com.google.inject.Provider;
import common.glue.utilities.GeneralActions;
import entity.Data;
import enums.HostsMapping;

import java.util.EnumMap;

import static enums.HostsMapping.*;

/**
 * User: nirtal
 * Date: 07/10/2021
 * Time: 16:42
 * Created with IntelliJ IDEA
 */
public class HostsProvider implements Provider<EnumMap<HostsMapping, String>> {

    @Inject
    private Data data;

    @Override
    public EnumMap<HostsMapping, String> get() {
        var hostsMap = new EnumMap<HostsMapping, String>(HostsMapping.class);
        hostsMap.put(CLIENT_API, GeneralActions.isRunningOnProd() ? "clientapi.talkspace.com" : String.format("clientapi.%s.talkspace.com", data.getConfiguration().getDomain()));
        hostsMap.put(THERAPIST_API, GeneralActions.isRunningOnProd() ? "therapistapi.talkspace.com" : String.format("therapistapi.%s.talkspace.com", data.getConfiguration().getDomain()));
        hostsMap.put(PUBLIC_API, GeneralActions.isRunningOnProd() ? "publicapi.talkspace.com" : String.format("publicapi.%s.talkspace.com", data.getConfiguration().getDomain()));
        hostsMap.put(CLAIMS_API, GeneralActions.isRunningOnProd() ? "claimsapi-internal.talkspace.com" : String.format("claimsapi-internal.%s.talkspace.com", data.getConfiguration().getDomain()));
        hostsMap.put(CLIENTAPI_INTERNAL, GeneralActions.isRunningOnProd() ? "clientapi-internal.talkspace.com" : String.format("clientapi-internal.%s.talkspace.com", data.getConfiguration().getDomain()));
        hostsMap.put(WEBHOOKS, GeneralActions.isRunningOnProd() ? "webhooks.talkspace.com" : String.format("webhooks.%s.talkspace.com", data.getConfiguration().getDomain()));
        hostsMap.put(API, GeneralActions.isRunningOnProd() ? "api.talkspace.com" : String.format("api.%s.talkspace.com", data.getConfiguration().getDomain()));
        hostsMap.put(MATCH_API, GeneralActions.isRunningOnProd() ? "matchapi.talkspace.com" : String.format("matchapi.%s.talkspace.com", data.getConfiguration().getDomain()));
        return hostsMap;
    }
}
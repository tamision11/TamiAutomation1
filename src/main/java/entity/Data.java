package entity;

import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Map;

@Getter
public class Data {
    private UserDetails userDetails;
    private Mailinator mailinator;
    private Map<String, CreditCard> creditCards;
    private Map<String, Map<String, Provider>> provider;
    @Setter
    private Map<String, User> users;
    private Map<String, String> characters;
    private Map<String, String> emails;
    private Configuration configuration;
    @Setter
    private Map<String, List<String>> dropdownOptions;
    private Map<String, String> apiEndpointDateFormats;
}

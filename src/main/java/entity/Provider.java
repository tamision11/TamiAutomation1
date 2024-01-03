package entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import enums.ProviderType;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * User: nirtal
 * Date: 07/04/2021
 * Time: 13:17
 * Created with IntelliJ IDEA
 */
@Getter
@NoArgsConstructor
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class Provider {
    private String email;
    @JsonProperty("therapistId")
    private int id;
    private String password;
    @Setter
    @JsonIgnore
    private String loginToken;
    private ProviderType providerType;

    public Provider(int id, ProviderType providerType) {
        this.id = id;
        this.providerType = providerType;
    }
}

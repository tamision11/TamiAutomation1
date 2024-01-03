package entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import enums.Address;
import enums.TwoFactorStatusType;
import lombok.*;

import java.util.List;

import static com.fasterxml.jackson.annotation.JsonInclude.Include;

/**
 * User: nirtal
 * Date: 08/04/2021
 * Time: 12:40
 * Created with IntelliJ IDEA
 *
 * @see <a href="https://talktala.atlassian.net/wiki/spaces/FD/pages/1623064702/users">Documentation for user status is here</a>
 */
@AllArgsConstructor
@Data
@RequiredArgsConstructor
@Builder(builderMethodName = "createUser", buildMethodName = "create", setterPrefix = "with")
@JsonInclude(Include.NON_EMPTY)
@NoArgsConstructor(force = true, access = AccessLevel.PRIVATE)
public class User {
    @NonNull
    private String email;
    @NonNull
    private String pendingEmail;
    private String oldEmail;
    private String password;
    private String firstName;
    private int clientInsuranceInfoId;
    private String lastName;
    private String phoneNumber;
    /**
     * password before update.
     */
    private String oldPassword;
    private String dateOfBirth;
    private String nickName;
    private String oldNickName;
    private String verificationCode;
    private String otpCode;
    private String zocdocPatientId;
    private String authToken;
    private String customerId;
    private Address address;
    @JsonIgnore
    private String loginToken;
    /**
     * The member rooms list.
     */
    private List<Room> roomsList;
    /**
     * The member 2fa status.
     */
    private TwoFactorStatusType twoFactorStatusType;
    /**
     * The member user id.
     */
    @JsonProperty("userId")
    private Integer id;
}

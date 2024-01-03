package entity;

import lombok.Getter;

import java.util.Map;

/**
 * User: nirtal
 * Date: 14/04/2021
 * Time: 14:23
 * Created with IntelliJ IDEA
 */
@Getter
public class UserDetails {
    private String firstName;
    private String lastName;
    private String middleName;
    private String employeeId;
    private String referral;
    private String referralSource;
    private Map<String, String> organizationName;
    private Map<String, String> birthDate;
    private Map<String, String> emergencyContact;
}

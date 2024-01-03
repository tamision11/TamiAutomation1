package enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * User: nirtal
 * Date: 29/08/2022
 * Time: 14:25
 * Created with IntelliJ IDEA
 * <p>
 * Employee relation
 */
@AllArgsConstructor
@Getter
public enum EmployeeRelation {

    ADULT_DEPENDENT_MEMBER_OF_HOUSEHOLD("Adult dependent/Member of household"),
    EMPLOYEE("Employee"),
    SPOUSE_PARTNER("Spouse/partner"),
    STUDENT("Student");

    private final String value;
}
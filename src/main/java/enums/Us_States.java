package enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * User: nirtal
 * Date: 15/08/2022
 * Time: 12:09
 * Created with IntelliJ IDEA
 * <p>
 * This enum maps abbreviations to their US states.
 */
@Getter
@AllArgsConstructor
public enum Us_States {

    AK("AK", "Alaska"),
    AL("AL", "Alabama"),
    AR("AR", "Arkansas"),
    AZ("AZ", "Arizona"),
    CA("CA", "California"),
    CO("CO", "Colorado"),
    CT("CT", "Connecticut"),
    DE("DE", "Delaware"),
    FL("FL", "Florida"),
    GA("GA", "Georgia"),
    HI("HI", "Hawaii"),
    IA("IA", "Iowa"),
    ID("ID", "Idaho"),
    IL("IL", "Illinois"),
    IN("IN", "Indiana"),
    KS("KS", "Kansas"),
    KY("KY", "Kentucky"),
    LA("LA", "Louisiana"),
    MA("MA", "Massachusetts"),
    MD("MD", "Maryland"),
    ME("ME", "Maine"),
    MI("MI", "Michigan"),
    MN("MN", "Minnesota"),
    MO("MO", "Missouri"),
    MS("MS", "Mississippi"),
    MT("MT", "Montana"),
    NC("NC", "North Carolina"),
    ND("ND", "North Dakota"),
    NE("NE", "Nebraska"),
    NH("NH", "New Hampshire"),
    NJ("NJ", "New Jersey"),
    NM("NM", "New Mexico"),
    NV("NV", "Nevada"),
    NY("NY", "New York"),
    OH("OH", "Ohio"),
    OK("OK", "Oklahoma"),
    OR("OR", "Oregon"),
    PA("PA", "Pennsylvania"),
    RI("RI", "RhodeIsland"),
    SC("SC", "South Carolina"),
    SD("SD", "South Dakota"),
    TN("TN", "Tennessee"),
    TX("TX", "Texas"),
    UT("UT", "Utah"),
    VA("VA", "Virginia"),
    VT("VT", "Vermont"),
    WA("WA", "Washington"),
    WI("WI", "Wisconsin"),
    WV("WV", "WestVirginia"),
    WY("WY", "Wyoming");


    /**
     * The state's abbreviation.
     */
    private final String abbreviation;

    /**
     * The state's name.
     */
    private final String name;
}



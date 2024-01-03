package entity;

import lombok.Getter;
import lombok.Setter;

import java.util.Map;

/**
 * User: nirtal
 * Date: 25/04/2021
 * Time: 11:58
 * Created with IntelliJ IDEA
 * <p>
 * Dynamic run configuration.
 */
@Getter
public class Configuration {

    /**
     * launch darkly test parameter
     */
    private String ldAutomationParameter;
    /**
     * will the automation run locally or on sauce labs?
     */
    private boolean localMobile;
    /**
     * Backoffice admin token.
     */
    @Setter
    private String adminToken;
    /**
     * current domain the automation will run
     */
    private String domain;
    /**
     * visual regression tracker information
     */
    private Vrt vrt;
    /**
     * should we decorate the driver or not (used to add highlight on elements before finding them for debugging)
     */
    private boolean decorateDriver;
    /**
     * header that contains server response info on AWS
     */
    private String headerName;
    /**
     * backoffice admin user id
     */
    private Map<String, Integer> admin;
    /**
     * Wait represents the webdriver wait time before throwing an exception
     */
    private int wait;
}

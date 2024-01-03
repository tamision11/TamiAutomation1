package entity;

import java.util.Map;

/**
 * User: nirtal
 * Date: 19/04/2021
 * Time: 12:30
 * Created with IntelliJ IDEA
 */
public interface ValidationForm {

    void enterDetails(User user, Map<String, String> userDetails) throws InterruptedException;
}

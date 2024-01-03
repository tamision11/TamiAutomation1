package entity;

/**
 * User: nirtal
 * Date: 22/08/2021
 * Time: 11:36
 * Created with IntelliJ IDEA
 * <p>
 * visual regression tracker configuration
 */

public record Vrt(String url, String apiKey, String localProjectId, String remoteProjectId) {
}

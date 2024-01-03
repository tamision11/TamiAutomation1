package glue.utilities;

import entity.User;
import lombok.experimental.UtilityClass;
import org.apache.commons.codec.digest.HmacAlgorithms;
import org.apache.commons.lang3.time.DateUtils;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.util.Date;

/**
 * User: nirtal
 * Date: 31/03/2021
 * Time: 15:23
 * Created with IntelliJ IDEA
 * <p>
 * utility class for jwt creation
 *
 * @see <a href="https://metamug.com/amp/security/jwt-java-tutorial-create-verify.html">jwt java tutorial</a>
 */
@UtilityClass
public class Jwt {
    private static final String JWT_HEADER = "{\"alg\":\"HS256\",\"typ\":\"JWT\"}";

    /**
     * @param secret environment secret token
     * @param user   the {@link User} that will register to the room
     * @return json web token
     * @see <a href="https://jwt.io/">To debug the created JWT use this website.</a>
     */
    public String generateJsonWebToken(User user, String secret) throws NoSuchAlgorithmException, InvalidKeyException {
        var payload = """
                {"userID": %d,
                "resource": [{
                "path":"/v2/users/%s/email-verification",
                "method":"POST",
                "payload":{"email":"%s" }}],
                "iat": %d,
                "exp": %d,
                "iss":"auth-api"}""".formatted(user.getId(),
                user.getId(),
                user.getEmail(),
                new Date().getTime(),
                DateUtils.addDays(new Date(), 1).getTime());
        var encodedHeader = GeneralActions.encodeBase64(JWT_HEADER);
        var encodedPayload = GeneralActions.encodeBase64(payload);
        var signature = hmacSha256(encodedHeader + "." + encodedPayload, secret);
        return encodedHeader + "." + encodedPayload + "." + signature;
    }


    /**
     * @param data   encoded header and payload
     * @param secret 256-bit secret
     * @return signature
     */
    private String hmacSha256(String data, String secret) throws NoSuchAlgorithmException, InvalidKeyException {
        var hash = secret.getBytes(StandardCharsets.UTF_8);
        var sha256Hmac = Mac.getInstance(HmacAlgorithms.HMAC_SHA_256.getName());
        var secretKey = new SecretKeySpec(hash, HmacAlgorithms.HMAC_SHA_256.getName());
        sha256Hmac.init(secretKey);
        var signedBytes = sha256Hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        return Base64.getUrlEncoder().withoutPadding().encodeToString(signedBytes);
    }
}

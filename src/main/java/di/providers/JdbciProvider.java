package di.providers;

import com.google.inject.Inject;
import com.google.inject.Provider;
import entity.Configuration;
import entity.Data;
import jakarta.inject.Named;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.sqlobject.SqlObjectPlugin;

/**
 * User: nirtal
 * Date: 16/02/2023
 * Time: 10:40
 * Created with IntelliJ IDEA
 * <p>
 * This code creates a JDBI instance that connects to a database, either "dev" or "canary", based on the value of {@link Configuration#getDomain()}.
 * The database connection information, including the URL, username, and password.
 */
public class JdbciProvider implements Provider<Jdbi> {

    @Inject
    private Data data;
    @Inject
    @Named("dev_db_url")
    private String devDbUrl;
    @Inject
    @Named("dev_db_user")
    private String devDbUser;
    @Inject
    @Named("dev_db_password")
    private String devDbPassword;
    @Inject
    @Named("canary_db_url")
    private String canaryDbUrl;
    @Inject
    @Named("canary_db_user")
    private String canaryDbUser;
    @Inject
    @Named("canary_db_password")
    private String canaryDbPassword;

    @Override
    public Jdbi get() {
        return switch (data.getConfiguration().getDomain()) {
            case "dev" -> Jdbi.create(devDbUrl, devDbUser, devDbPassword).installPlugin(new SqlObjectPlugin());
            case "canary" ->
                    Jdbi.create(canaryDbUrl, canaryDbUser, canaryDbPassword).installPlugin(new SqlObjectPlugin());
            default -> null;
        };
    }
}

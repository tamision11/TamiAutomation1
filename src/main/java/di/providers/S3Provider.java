package di.providers;


import com.google.inject.Inject;
import com.google.inject.Provider;
import common.glue.utilities.GeneralActions;
import entity.Data;
import enums.Domain;
import jakarta.inject.Named;
import org.apache.commons.lang3.SystemUtils;
import software.amazon.awssdk.auth.credentials.ProfileCredentialsProvider;
import software.amazon.awssdk.auth.credentials.SystemPropertyCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;

/**
 * User: nirtal
 * Date: 11/07/2023
 * Time: 15:58
 * Created with IntelliJ IDEA
 */
public class S3Provider implements Provider<S3Client> {
    @Inject
    private Data data;
    @Inject(optional = true)
    @Named("dev_aws_secret_access_key")
    private String devAwsSecretAccessKey;
    @Inject(optional = true)
    @Named("dev_aws_access_key_id")
    private String devAwsAccessKeyId;
    @Inject(optional = true)
    @Named("canary_aws_secret_access_key")
    private String canaryAwsSecretAccessKey;
    @Inject(optional = true)
    @Named("canary_aws_access_key_id")
    private String canaryAwsAccessKeyId;

    /**
     * aws s3 is not supported on prod, so we return null.
     * in case we are running on Mac, we set the aws credentials as system properties.
     * in case we are running on linux, we use the aws credentials file.
     *
     * @see <a href="https://stackoverflow.com/questions/22588733/unable-to-load-aws-credentials-from-the-awscredentials-properties-file-on-the-c">load aws creadintails</a>
     */
    @Override
    public S3Client get() {
        if (GeneralActions.isRunningOnProd()) {
            return null;
        } else if (!SystemUtils.IS_OS_MAC) {
            return S3Client
                    .builder()
                    .region(Region.US_EAST_1)
                    .credentialsProvider(ProfileCredentialsProvider.create())
                    .build();
        } else {
            if (data.getConfiguration().getDomain().equals(Domain.CANARY.getName())) {
                System.setProperty("aws.accessKeyId", canaryAwsAccessKeyId);
                System.setProperty("aws.secretAccessKey", canaryAwsSecretAccessKey);
            } else {
                System.setProperty("aws.accessKeyId", devAwsAccessKeyId);
                System.setProperty("aws.secretAccessKey", devAwsSecretAccessKey);
            }
            return S3Client
                    .builder()
                    .region(Region.US_EAST_1)
                    .credentialsProvider(SystemPropertyCredentialsProvider.create())
                    .build();
        }
    }
}
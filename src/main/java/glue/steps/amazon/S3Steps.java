package glue.steps.amazon;


import com.google.inject.Inject;
import common.glue.utilities.Constants;
import di.providers.ScenarioContext;
import entity.Data;
import entity.RmtFile;
import entity.User;
import io.cucumber.java.en.And;
import io.cucumber.java.en.When;
import io.qameta.allure.Allure;
import net.datafaker.Faker;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.assertj.core.api.SoftAssertions;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.core.sync.ResponseTransformer;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.ListObjectsV2Request;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.text.ParseException;
import java.text.SimpleDateFormat;

/**
 * User: nirtal
 * Date: 11/07/2023
 * Time: 16:03
 * Created with IntelliJ IDEA
 */
public class S3Steps {

    @Inject(optional = true)
    private S3Client s3Client;
    @Inject
    private Data data;
    @Inject
    private ScenarioContext scenarioContext;
    @Inject
    private Faker faker;


    /**
     * <p>
     * this step does the following:
     * <ul>
     *    <li> download rmt file from s3 bucket by claim id
     *  </ul>
     * <p>
     *
     * @param prefix the prefix of the bucket
     * @see <a href="https://stackoverflow.com/a/12176439/4515129">Download file help for AWS S3 Java SDK</a>
     * @see <a href="https://s3.console.aws.amazon.com/s3/buckets/clearinghouse-mock-sftp-dev?region=us-east-1&prefix=remits/&showversions=false">S3 logs from remits prefix can be found here</a>
     */
    @When("S3 - Download rmt file from {string} prefix")
    public void downloadRmtFile(String prefix) {
        var listing = s3Client.listObjectsV2(ListObjectsV2Request.builder()
                .bucket("clearinghouse-mock-sftp-%s".formatted(data.getConfiguration().getDomain()))
                .prefix(prefix)
                .build());
        for (var s3ObjectSummary : listing.contents()) {
            if (s3ObjectSummary.key().startsWith(prefix.concat("/%s").formatted(scenarioContext.getSqlAndApiResults().get("claim_id"))) && s3ObjectSummary.key().endsWith(".RMT")) {
                scenarioContext.setRmtFile(new RmtFile(s3ObjectSummary.key(), new File(Constants.CHROME_DOWNLOAD_DIRECTORY + File.separator + s3ObjectSummary.key())));
                s3Client.getObject(GetObjectRequest.builder()
                        .key(s3ObjectSummary.key())
                        .bucket("clearinghouse-mock-sftp-%s".formatted(data.getConfiguration().getDomain()))
                        .build(), ResponseTransformer.toFile(scenarioContext.getRmtFile().file()));
            }
        }
    }

    /**
     * update check date (CHK) on rmt file
     */
    @And("S3 - Update Check Date on rmt file")
    public void updateCheckRmtFile() throws IOException {
        var fileContent = Files.readString(scenarioContext.getRmtFile().file().toPath(), StandardCharsets.UTF_8);
        var fileContentAfter = fileContent.replace("CHK************20200925", "CHK************20200926");
        Files.writeString(scenarioContext.getRmtFile().file().toPath(), fileContentAfter);
    }

    /**
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3118">handle Aetna request files </a>
     */
    @And("S3 - Delete athana request files")
    public void deleteAthanaRequestFiles() {
        var listing = s3Client.listObjectsV2(ListObjectsV2Request.builder()
                .bucket("clearinghouse-mock-sftp-%s".formatted(data.getConfiguration().getDomain()))
                .prefix("OnsiteProviderForms/toAetna/")
                .build());
        for (var s3ObjectSummary : listing.contents()) {
            s3Client.deleteObject(builder -> builder.bucket("clearinghouse-mock-sftp-%s".formatted(data.getConfiguration().getDomain()))
                    .key(s3ObjectSummary.key())
                    .build());
        }
    }

    /**
     * @param user the user to verify the file for
     * @throws IOException            if the file cannot be read
     * @throws InvalidFormatException if the file is not in the correct format
     * @see <a href="https://talktala.atlassian.net/browse/AUTOMATION-3118">handle Aetna request files </a>
     */
    @And("S3 - Verify athana request file for {user} user")
    public void verifyAthanaRequestFile(User user) throws IOException, InvalidFormatException {
        var listing = s3Client.listObjectsV2(ListObjectsV2Request.builder()
                .bucket("clearinghouse-mock-sftp-%s".formatted(data.getConfiguration().getDomain()))
                .prefix("OnsiteProviderForms/toAetna/")
                .build());
        var athenaFileName = new File(Constants.CHROME_DOWNLOAD_DIRECTORY + File.separator + "athena_request_file.xlsx");
        Files.deleteIfExists(athenaFileName.toPath());
        for (var s3ObjectSummary : listing.contents()) {
            if (s3ObjectSummary.key().contains("Talkspace-UI1049325-authorization-log-Talkspace-")) {
                s3Client.getObject(GetObjectRequest.builder()
                        .key(s3ObjectSummary.key())
                        .bucket("clearinghouse-mock-sftp-%s".formatted(data.getConfiguration().getDomain()))
                        .build(), ResponseTransformer.toFile(athenaFileName));
                break;
            }
        }
        try (Workbook workbook = new XSSFWorkbook(athenaFileName)) {
            var headerRow = workbook.getSheet("Sheet1").getRow(1);
            SoftAssertions.assertSoftly(softAssertions -> {
                softAssertions.assertThat(Integer.parseInt(headerRow.getCell(0).getStringCellValue()))
                        .as("User id")
                        .isEqualTo(user.getId());
                softAssertions.assertThat(headerRow.getCell(1).getStringCellValue())
                        .as("Last name name")
                        .isEqualTo(user.getLastName());
                softAssertions.assertThat(headerRow.getCell(2).getStringCellValue())
                        .as("first name")
                        .isEqualToIgnoringCase(user.getFirstName());
                softAssertions.assertThat(headerRow.getCell(3).getStringCellValue())
                        .as("Date Of Birth")
                        .isEqualTo(user.getDateOfBirth());
                softAssertions.assertThat(headerRow.getCell(4).getStringCellValue())
                        .as("Gender")
                        .isEqualTo("M");
                softAssertions.assertThat(headerRow.getCell(5).getStringCellValue())
                        .as("Address Line 1")
                        .isEqualTo("222 4941 king arthur way, cheyenne, wy 82009, united states");
                softAssertions.assertThat(headerRow.getCell(6).getStringCellValue())
                        .as("Address Line")
                        .isEqualTo(StringUtils.EMPTY);
                softAssertions.assertThat(headerRow.getCell(7).getStringCellValue())
                        .as("City")
                        .isEqualTo("Cheyenne");
                softAssertions.assertThat(headerRow.getCell(8).getStringCellValue())
                        .as("State")
                        .isEqualTo("MT");
                softAssertions.assertThat(Integer.parseInt(headerRow.getCell(9).getStringCellValue()))
                        .as("Zip")
                        .isEqualTo(82009);
                softAssertions.assertThat(headerRow.getCell(10).getStringCellValue())
                        .as("Phone Number")
                        .isEqualTo("202-555-0126");
                softAssertions.assertThat(headerRow.getCell(11).getStringCellValue())
                        .as("Emp/Dep")
                        .isEqualTo("Yes");
                try {
                    softAssertions.assertThat(new SimpleDateFormat("MM/dd/yyyy").parse(headerRow.getCell(12).getStringCellValue()))
                            .as("Date Of Request")
                            .isNotNull();
                } catch (ParseException e) {
                    throw new RuntimeException(e);
                }
                softAssertions.assertThat(headerRow.getCell(13).getStringCellValue())
                        .as("Presenting Issue")
                        .isEqualTo("Anxiety");
                softAssertions.assertThat(Integer.parseInt(headerRow.getCell(14).getStringCellValue()))
                        .as("Plan Sponsor ID")
                        .isEqualTo(575772);
                softAssertions.assertThat(headerRow.getCell(15).getStringCellValue())
                        .as("Plan Sponsor Name")
                        .isEqualTo("Independent Colleges and Universities Benefits Association Inc.");
                softAssertions.assertThat(headerRow.getCell(16).getStringCellValue())
                        .as("Alias Selected")
                        .isEqualTo("ICUBA");
                softAssertions.assertThat(Integer.parseInt(headerRow.getCell(17).getStringCellValue()))
                        .as("Business Unit ID")
                        .isEqualTo(45826);
                softAssertions.assertThat(headerRow.getCell(18).getStringCellValue())
                        .as("Business Unit Name")
                        .isEqualTo("Independent Colleges and Universities Benefits");
                softAssertions.assertThat(headerRow.getCell(19).getStringCellValue())
                        .as("Authorization #")
                        .isEqualTo(StringUtils.EMPTY);
                softAssertions.assertThat(headerRow.getCell(20).getStringCellValue())
                        .as("# of Units Authorized")
                        .isEqualTo(StringUtils.EMPTY);
                softAssertions.assertThat(headerRow.getCell(21).getStringCellValue())
                        .as("Authorization End Date")
                        .isEqualTo(StringUtils.EMPTY);
            });
        }
    }

    /**
     * update transaction (TRN) on rmt file
     */
    @And("S3 - Update transaction on rmt file: replace first 3 TRN characters with {string}")
    public void updateTrnRmtFile(String replacement) throws IOException {
        var fileContent = Files.readString(scenarioContext.getRmtFile().file().toPath(), StandardCharsets.UTF_8);
        var trnBefore = StringUtils.substringBetween(fileContent, "TRN*1*", "*N~");
        var trnAfter = replacement + trnBefore.substring(3);
        var fileContentAfter = fileContent.replace(trnBefore, trnAfter);
        Allure.addAttachment("TRN Before", trnBefore);
        Allure.addAttachment("TRN after", trnAfter);
        Files.writeString(scenarioContext.getRmtFile().file().toPath(), fileContentAfter);
    }

    /**
     * we must have the following data in scenario context:
     * member_id
     * member_dob
     * auth effective date
     * auth_date
     *
     * @param authorizedSessions the number of authorized sessions
     * @param user               the user to upload the file for
     * @throws IOException if the file cannot be read
     */
    @And("S3 - Upload Aetna’s response file with {int} authorized sessions for {user} user")
    public void uploadExcelFileToS3(int authorizedSessions, User user) throws IOException {
        fillExcel(authorizedSessions, user, true);
    }

    /**
     * we must have the following data in scenario context:
     * member_id
     * member_dob
     * auth effective date
     * auth_date
     *
     * @param authorizedSessions the number of authorized sessions
     * @param user               the user to upload the file for
     * @throws IOException if the file cannot be read
     */
    @And("S3 - Upload Aetna’s response file with {int} authorized sessions for {user} user with blank talkspace user id")
    public void uploadExcelFileToS3WithBlankTsId(int authorizedSessions, User user) throws IOException {
        fillExcel(authorizedSessions, user, false);
    }

    /**
     * we must have the following data in scenario context:
     * member_id
     * member_dob
     * auth effective date
     * auth_date
     *
     * @param authorizedSessions the number of authorized sessions
     * @param user               the user to upload the file for
     * @throws IOException if the file cannot be read
     */
    private void fillExcel(int authorizedSessions, User user, boolean fillTsId) throws IOException {
        FileInputStream file = new FileInputStream(Constants.EXCEL_PATH);
        try (Workbook workbook = new XSSFWorkbook(file)) {
            var headerRow = workbook.getSheet("Sheet1").createRow(1);
            headerRow.createCell(0).setCellValue(scenarioContext.getSqlAndApiResults().get("member_id"));
            headerRow.createCell(1).setCellValue(user.getFirstName());
            headerRow.createCell(2).setCellValue(user.getLastName());
            headerRow.createCell(3).setCellValue(user.getDateOfBirth());
            headerRow.createCell(4).setCellValue("2579 Broadway Auto");
            headerRow.createCell(5).setCellValue("auto".concat(scenarioContext.getSqlAndApiResults().get("member_id")));
            headerRow.createCell(6).setCellValue(authorizedSessions);
            headerRow.createCell(7).setCellValue(scenarioContext.getSqlAndApiResults().get("auth effective date"));
            headerRow.createCell(8).setCellValue(scenarioContext.getSqlAndApiResults().get("auth_date"));
            if (fillTsId) {
                headerRow.createCell(9).setCellValue(user.getId());
            }
            try (var fileOut = new FileOutputStream(Constants.EXCEL_PATH)) {
                workbook.write(fileOut);
            }
        }
        s3Client.putObject(PutObjectRequest.builder()
                .bucket("clearinghouse-mock-sftp-%s".formatted(data.getConfiguration().getDomain()))
                .key("OnsiteProviderForms/fromAetna/TalkSpace Report auto.xlsx")
                .build(), RequestBody.fromFile(new File(Constants.EXCEL_PATH)));
    }


    /**
     * Override existing rmt file
     */
    @When("S3 - Override existing rmt file")
    public void overrideRmtFile() throws IOException {
        Allure.addAttachment("File content before upload", Files.readString(scenarioContext.getRmtFile().file().toPath(), StandardCharsets.UTF_8));
        s3Client.putObject(PutObjectRequest.builder()
                .bucket("clearinghouse-mock-sftp-%s".formatted(data.getConfiguration().getDomain()))
                .key("remits/" + scenarioContext.getRmtFile().awsKey())
                .build(), RequestBody.fromFile(scenarioContext.getRmtFile().file()));
    }


    /**
     * we also store the invalid_external_id in the scenario context
     * <p>
     * we must have the following data in scenario context:
     * external_id
     */
    @And("S3 - Remove first digit from external id")
    public void sRemoveFirstDigitFrom() throws IOException {
        var externalBefore = scenarioContext.getSqlAndApiResults().get("external_id");
        var externalAfter = externalBefore.substring(1);
        scenarioContext.getSqlAndApiResults().put("invalid_external_id", externalAfter);
        Allure.addAttachment("External id before", externalBefore);
        Allure.addAttachment("External id After", externalAfter);
        var fileContent = Files.readString(scenarioContext.getRmtFile().file().toPath(), StandardCharsets.UTF_8);
        var fileContentAfter = fileContent.replace(externalBefore, externalAfter);
        Files.writeString(scenarioContext.getRmtFile().file().toPath(), fileContentAfter);
    }


    @And("S3 - Update unique check amount")
    public void updateUniqueCheckAmount() throws IOException {
        var fileContent = Files.readString(scenarioContext.getRmtFile().file().toPath(), StandardCharsets.UTF_8);
        var checkAmountBefore = StringUtils.substringBetween(fileContent, "BPR*I*", "*C");
        var checkAmountAfter = String.valueOf(faker.number().randomDouble(2, 0, 100000));
        var fileContentAfter = fileContent.replace(checkAmountBefore, checkAmountAfter);
        Allure.addAttachment("Check amount Before", checkAmountBefore);
        Allure.addAttachment("Check amount after", checkAmountAfter);
        Files.writeString(scenarioContext.getRmtFile().file().toPath(), fileContentAfter);
    }
}
package java.runner;


import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;

import static io.cucumber.testng.CucumberOptions.SnippetType.CAMELCASE;


/**
 * User: nirtal
 * Date: 27/06/2021
 * Time: 15:01
 * Created with IntelliJ IDEA
 * Retry runner - collected from target/failed_scenarios.txt
 */
@CucumberOptions(
        features = "@target/failed_scenarios.txt",
        glue = {"common/glue", "glue"}
        , tags = "not @ignore",
        snippets = CAMELCASE
        , plugin = {"pretty",
        "io.qameta.allure.cucumber7jvm.AllureCucumber7Jvm",
        "common.glue.steps.Hooks",  // added report listener
        "json:target/surefire-reports/Cucumber.json",
        "unused:target/unused.txt"}
)
public class RetryRunner extends AbstractTestNGCucumberTests {
}

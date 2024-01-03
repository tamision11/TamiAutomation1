package java.runner;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;

import static io.cucumber.testng.CucumberOptions.SnippetType.CAMELCASE;

/**
 * Created by emanuela.biro on 11/28/2018.
 * The main runner for the tests
 */
@CucumberOptions(
        features = "classpath:features",
        glue = {"common/glue", "glue"}
        , tags = "@devRun",
        snippets = CAMELCASE
        , plugin = {"pretty",
        "io.qameta.allure.cucumber7jvm.AllureCucumber7Jvm",
        "common.glue.steps.Hooks",  // added report listener
        "rerun:target/failed_scenarios.txt", //Creates a text file with failed scenarios
        "json:target/surefire-reports/Cucumber.json",
        "unused:target/unused.txt"}
)
public class DevelopmentRunner extends AbstractTestNGCucumberTests {
}

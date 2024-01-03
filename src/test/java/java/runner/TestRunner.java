package java.runner;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;

import static io.cucumber.testng.CucumberOptions.SnippetType.CAMELCASE;

/**
 * Created by emanuela.biro on 11/28/2018.
 * The main runner for the tests
 */
@CucumberOptions(
//        name = {"Client Web - 2019-teen-bundle-A - Purchase plan and verify credits", "Client Web - In Platform Matching - Click not now"},
        features = "classpath:features",
        glue = {"common/glue", "glue"},
        tags = "not @ignore",
        snippets = CAMELCASE
        , plugin = {"pretty",
        "io.qameta.allure.cucumber7jvm.AllureCucumber7Jvm",
        "common.glue.steps.Hooks",  // added report listener
        "junit:target/cucumber-results.xml",
        "rerun:target/failed_scenarios.txt", //Creates a text file with failed scenarios
        "json:target/surefire-reports/Cucumber.json",
        "unused:target/unused.txt"}
)
public class TestRunner extends AbstractTestNGCucumberTests {
}

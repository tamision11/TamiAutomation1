package java.runner;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;

import static io.cucumber.testng.CucumberOptions.SnippetType.CAMELCASE;

/**
 * add @accessibility tag in this feature to do a test run.
 */
@CucumberOptions(
        features = "src/test/resources/features/clientweb/chat/messages.feature",
        glue = {"common/glue", "glue"}
        , tags = "@visual and not @ignore",
        snippets = CAMELCASE
        , plugin = {"pretty",
        "io.qameta.allure.cucumber7jvm.AllureCucumber7Jvm",
        "common.glue.steps.Hooks",  // added report listener
        "rerun:target/failed_scenarios.txt", //Creates a text file with failed scenarios
        "json:target/surefire-reports/Cucumber.json",
        "unused:target/unused.txt"}
)
public class VisualRunner extends AbstractTestNGCucumberTests {
}

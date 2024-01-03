package java.glue.steps;

import com.google.inject.Injector;
import com.google.inject.Stage;
import com.netflix.governator.guice.LifecycleInjector;
import di.modules.CommonModule;
import io.cucumber.guice.CucumberModules;
import io.cucumber.guice.InjectorSource;

/**
 * User: nirtal
 * Date: 13/07/2022
 * Time: 6:27
 * Created with IntelliJ IDEA
 */
public class WebInjector implements InjectorSource {

    @Override
    public Injector getInjector() {
        return LifecycleInjector.builder()
                .withModules(CucumberModules.createScenarioModule(),
                        new CommonModule())
                .inStage(Stage.PRODUCTION)
                .build()
                .createInjector();
    }
}

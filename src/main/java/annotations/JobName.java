package annotations;

import com.google.inject.BindingAnnotation;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.RetentionPolicy.RUNTIME;


/**
 * method will execute if CircleCI job name is equal to the defined name.
 */
@BindingAnnotation
@Target({
        METHOD,
})
@Retention(RUNTIME)
public @interface JobName {
    String value();
}

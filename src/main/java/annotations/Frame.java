package annotations;

import com.google.inject.BindingAnnotation;
import enums.FrameTitle;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

/**
 * this annotation switch to iframe based on the iframe title, if the frame is default then the defultcontent frame will be selected
 */
@BindingAnnotation
@Target({
        METHOD
})
@Retention(RUNTIME)
public @interface Frame {
    FrameTitle[] value();
}

package di.interceptors;

import annotations.JobName;
import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;
import org.apache.commons.lang3.StringUtils;

/**
 * User: nirtal
 * Date: 01/06/2021
 * Time: 12:53
 * Created with IntelliJ IDEA
 */
public class JobNameInterceptor implements MethodInterceptor {

    @Override
    public Object invoke(MethodInvocation invocation) throws Throwable {
        var jobName = invocation.getMethod().getAnnotation(JobName.class).value();
        return StringUtils.equals(System.getProperty("job_name"), jobName) ? invocation.proceed() : null;
    }
}

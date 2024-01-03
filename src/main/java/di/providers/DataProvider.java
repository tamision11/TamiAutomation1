package di.providers;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.inject.Inject;
import com.google.inject.Provider;
import entity.Data;
import lombok.SneakyThrows;

import java.io.File;
import java.nio.file.Paths;

import static org.apache.commons.lang3.SystemUtils.USER_DIR;

/**
 * User: nirtal
 * Date: 09/08/2021
 * Time: 13:05
 * Created with IntelliJ IDEA
 */
public class DataProvider implements Provider<Data> {
    @Inject
    private ObjectMapper objectMapper;

    @SneakyThrows
    @Override
    public Data get() {
        return objectMapper.readValue(new File(Paths.get(USER_DIR).getParent() + "/resources/data.json"),
                Data.class);
    }
}

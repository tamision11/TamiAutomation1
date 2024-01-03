package entity;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.node.ObjectNode;
import lombok.Builder;

import static com.fasterxml.jackson.annotation.JsonInclude.Include;

@Builder(builderMethodName = "createResponse", buildMethodName = "create", setterPrefix = "with")
@JsonInclude(Include.NON_NULL)
public record Response(String executionId, int statusCode, String url, String methodName, ObjectNode requestBody,
                       ObjectNode responseBody) {
}

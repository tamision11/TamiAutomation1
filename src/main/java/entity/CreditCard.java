package entity;

import lombok.Builder;

@Builder(builderMethodName = "createCard", buildMethodName = "create", setterPrefix = "with")
public record CreditCard(String cardHolderName, String cardNumber, String zipCode, String cvv, String expirationDate,
                         String token) {

}

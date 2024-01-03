Feature: Client web - Rate provider

  Scenario: Rate provider
    Given Navigate to client-web
    And Log in with starring user and
      | remember me   | false |
      | 2fa activated | true  |
    When Open the Room details menu
    And Click on review your provider button
    And Rate provider with 2 stars
    And Enter a provider review
    And Submit provider review
    Then Thanks for your review dialog is displayed
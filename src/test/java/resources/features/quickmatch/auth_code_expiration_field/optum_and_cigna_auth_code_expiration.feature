@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-3025
Feature: QM - Authorization code expiration

  Scenario: Direct flow - Optum - Past expiration date
    Given Navigate to flow62
    When Complete optum eap validation form for primary user
      | age                           | 18         |
      | authorization code            | MOCK_OPTUM |
      | session number                | 12+        |
      | service type                  | THERAPY    |
      | Email                         | PRIMARY    |
      | employee Relation             | EMPLOYEE   |
      | state                         | MT         |
      | phone number                  |            |
      | authorization code expiration | past date  |
    Then Invalid auth code expiration message is displayed

  @visual
  Scenario: Direct flow - Optum - Past expiration date error message - visual
    Given Navigate to flow62
    When Complete optum eap validation form for primary user
      | age                           | 18         |
      | authorization code            | MOCK_OPTUM |
      | session number                | 12+        |
      | service type                  | THERAPY    |
      | Email                         | PRIMARY    |
      | employee Relation             | EMPLOYEE   |
      | state                         | MT         |
      | phone number                  |            |
      | authorization code expiration | past date  |
    Then Shoot baseline "Optum - Past expiration date error message - visual"

  Scenario: Direct flow - Cigna - Invalid future expiration date
  valid dates are one year from now or less.
    Given Navigate to flow78
    And Set primary user last name to Automation
    When Complete cigna eap validation form for primary user
      | birthdate                     | consumer            |
      | authorization code            | MOCK_CIGNA          |
      | session number                | 3                   |
      | service type                  | THERAPY             |
      | Email                         | PRIMARY             |
      | employee Relation             | EMPLOYEE            |
      | state                         | MT                  |
      | phone number                  |                     |
      | authorization code expiration | invalid future date |
    Then Invalid auth code expiration message is displayed

  @visual
  Scenario: Direct flow - Cigna - Invalid future expiration date error message - visual
  valid dates are one year from now or less.
    Given Navigate to flow78
    And Set primary user last name to Automation
    When Complete cigna eap validation form for primary user
      | birthdate                     | consumer            |
      | authorization code            | MOCK_CIGNA          |
      | session number                | 3                   |
      | service type                  | THERAPY             |
      | Email                         | PRIMARY             |
      | employee Relation             | EMPLOYEE            |
      | state                         | MT                  |
      | phone number                  |                     |
      | authorization code expiration | invalid future date |
    Then Shoot baseline "Cigna - Invalid future expiration date error message - visual"

  @visual
  Scenario: Direct flow - Optum - Invalid future expiration date error message - visual
    Given Navigate to flow62
    When Complete optum eap validation form for primary user
      | age                           | 18                  |
      | authorization code            | MOCK_OPTUM          |
      | session number                | 12+                 |
      | service type                  | THERAPY             |
      | Email                         | PRIMARY             |
      | employee Relation             | EMPLOYEE            |
      | state                         | MT                  |
      | phone number                  |                     |
      | authorization code expiration | invalid future date |
    Then Shoot baseline "Optum - Invalid future expiration date error message - visual"

  Scenario: Direct flow - Cigna - No expiration date
    Given Navigate to flow78
    And Set primary user last name to Automation
    When Complete cigna eap validation form for primary user
      | birthdate          | consumer   |
      | authorization code | MOCK_CIGNA |
      | session number     | 3          |
      | service type       | THERAPY    |
      | Email              | PRIMARY    |
      | employee Relation  | EMPLOYEE   |
      | state              | MT         |
      | phone number       |            |
    Then Invalid auth code expiration message is displayed

  @visual
  Scenario: Direct flow - Optum - No expiration date error message - visual
    Given Navigate to flow78
    And Set primary user last name to Automation
    When Complete cigna eap validation form for primary user
      | birthdate          | consumer   |
      | authorization code | MOCK_CIGNA |
      | session number     | 3          |
      | service type       | THERAPY    |
      | Email              | PRIMARY    |
      | employee Relation  | EMPLOYEE   |
      | state              | MT         |
      | phone number       |            |
    Then Shoot baseline "Optum - No expiration date error message - visual"
@visual
Feature: QM - B2B - EAP
  Leads to flow 2

  Background:
    Given Navigate to flow62

  Scenario: B2B - Flow 62 - Optum - User validation page
    Then Shoot baseline

  Scenario: B2B - Flow 62 - Optum - Validation page - invalid EAP code
    When Complete optum eap validation form for primary user
      | age                           | 18          |
      | authorization code            | INVALID     |
      | session number                | 3           |
      | service type                  | THERAPY     |
      | Email                         | PRIMARY     |
      | employee Relation             | EMPLOYEE    |
      | state                         | MT          |
      | phone number                  |             |
      | authorization code expiration | future date |
    Then Shoot baseline
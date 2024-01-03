@visual
Feature: QM - B2B - EAP
  Leads to flow 2
  on test environments (dev/canary):
  - "cignawellbeingprogram3" organization keyword is mapped to 3 sessions and is automatically sent when the organization keyword is not sent.
  - "cigna" organization keyword is mapped to 5 sessions.
  - selecting a different number of sessions from the session selection dropdown will have no affect, only these organization keywords will affect the number of sessions.

  Background:
    Given Navigate to flow78

  Scenario: B2B - Flow 78 - Cigna - Validation page
    Then Shoot baseline

  Scenario: B2B - Flow 78 - Cigna - Validation page - invalid EAP code
    When Complete cigna eap validation form for primary user
      | age                           | 18            |
      | authorization code            | CIGNA_INVALID |
      | session number                | 3             |
      | service type                  | THERAPY       |
      | Email                         | PRIMARY       |
      | employee Relation             | EMPLOYEE      |
      | state                         | MT            |
      | phone number                  |               |
      | authorization code expiration | future date   |
    Then Shoot baseline and ignore
      | email input |
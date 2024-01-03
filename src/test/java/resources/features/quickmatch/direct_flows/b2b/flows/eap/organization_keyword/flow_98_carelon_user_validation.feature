@visual
Feature: QM - B2B - EAP
  Leads to flow 2

  Background:
    Given Navigate to flow98

  Scenario: Flow 98 - Carelon - Spouse or dependent - Missing required fields
    When Complete carelon eap validation form for primary user
      | age               | 18             |
      | organization      | carelon        |
      | service type      | THERAPY        |
      | Email             | PRIMARY        |
      | employee Relation | SPOUSE_PARTNER |
      | state             | MT             |
    Then Shoot baseline and ignore
      | email input |

@tmsLink=talktala.atlassian.net/browse/AUTOMATION-3004
@visual
Feature: QM - B2B - EAP
  Leads to flow 2

  Background:
    Given Navigate to flow41

  Scenario: B2B - Flow 41 (EAP with Teen Support) - User validation page
    Then Shoot baseline

  Scenario: B2B - Flow 41 (EAP with Teen Support) - keyword validation page passed
    When Complete eap validation form for primary user
      | age               | 13       |
      | organization      | mines    |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | phone number      |          |
    Then Shoot baseline
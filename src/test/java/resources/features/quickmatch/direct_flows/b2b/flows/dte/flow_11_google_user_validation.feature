@visual
Feature: QM - B2B - DTE
  Leads to flow 2

  Background:
    Given Navigate to flow11

  Scenario: B2B - Flow 11 - Google - keyword validation page passed
    Given Complete google validation form for primary user
      | age               | 18       |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | phone number      |          |
    Then Shoot baseline

  Scenario: B2B - Flow 11 - Google - User validation page
    Then Shoot baseline
@visual
Feature: QM - B2B - EAP
  Leads to flow 2

  Background:
    Given Navigate to flow19

  Scenario: B2B - Flow 19 - Humana - Validation page
    Then Shoot baseline

  Scenario: B2B - Flow 19 - Humana - Validation page page passed
    When Complete shared validation form for primary user
      | age               | 18       |
      | organization      | humana   |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
      | phone number      |          |
    Then Shoot baseline

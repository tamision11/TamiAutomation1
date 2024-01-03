@visual
Feature: QM - B2B - EAP
  Leads to flow 2

  Background:
    Given Navigate to flow44

  Scenario: B2B - Flow 44 - Aetna/RFL - Validation page page passed
    When Complete shared validation form for primary user
      | age               | 18       |
      | organization      | aetna    |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
      | phone number      |          |
    Then Shoot baseline
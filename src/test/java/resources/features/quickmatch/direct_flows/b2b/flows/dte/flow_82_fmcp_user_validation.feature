@visual
Feature: QM - B2B - DTE
  Leads to flow 2.
  fmcp = eligibility based on file (Member ID + birthdate).

  Background:
    Given Navigate to flow82

  Scenario: B2B - Flow 82 - FMCP - keyword validation page passed
    When Complete shared validation form for primary user
      | Member ID         | FMCP    |
      | birthdate         | fmcp    |
      | service type      | THERAPY |
      | Email             | PRIMARY |
      | employee Relation | STUDENT |
      | state             | MT      |
      | phone number      |         |
    Then Shoot baseline

  Scenario: B2B - Flow 82 - FMCP - Validation page
    Then Shoot baseline
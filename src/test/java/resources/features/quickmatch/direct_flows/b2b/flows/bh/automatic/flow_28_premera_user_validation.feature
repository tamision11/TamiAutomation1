Feature: QM - B2B - Automatic BH
  Leads to flow 7

  Background:
    Given Navigate to flow28

  @visual
  Scenario: B2B - Flow 28 - Premera - Validation page
    Then Shoot baseline

  @visual
  Scenario: B2B - Flow 28 - Premera - Validation page page passed
    When Complete shared validation form for primary user
      | age               | 18       |
      | Member ID         | COPAY_0  |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
      | phone number      |          |
    Then Shoot baseline
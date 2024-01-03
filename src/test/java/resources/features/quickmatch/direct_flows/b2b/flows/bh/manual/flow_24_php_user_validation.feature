@visual
Feature: QM - B2B - Manual BH
  Leads to flow 2
  error page that are only displayed in automatic BH flows when using an invalid Member/SubscriberID

  Background:
    Given Navigate to flow24

  Scenario: B2B - Flow 24 - PHP - Validation page
    Then Shoot baseline

  Scenario: B2B - Flow 24 - PHP - Validation page page passed
    When Complete shared validation form for primary user
      | age               | 18       |
      | Member ID         | COPAY_0  |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
      | phone number      |          |
    Then Shoot baseline
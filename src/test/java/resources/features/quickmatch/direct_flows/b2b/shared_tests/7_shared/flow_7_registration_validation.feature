@visual
Feature: QM - B2B: Flow 7 - Registration Validation

  Background:
    Given Navigate to flow28
    When Complete shared validation form for primary user
      | age               | 18       |
      | Member ID         | COPAY_0  |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
      | phone number      |          |
    And Click on next button to approve you are ready to begin
    And Complete the matching questions with the following options
      | seek help reason                   | I'm feeling anxious or panicky |
      | got it                             |                                |
      | provider gender preference         | Male                           |
      | have you been to a provider before | Yes                            |
      | sleeping habits                    | Excellent                      |
      | physical health                    | Excellent                      |
      | your gender                        | Male                           |
      | state                              | Continue with prefilled state  |
    And Click on secure your match button
    And Click on continue on coverage verification
    And Payment - Complete purchase using "visa" card for primary user

  Scenario: B2B - Flow 7 - Visual regression
    Then Shoot baseline "QM - B2B - Flow 7 - registration page" and ignore
      | email input |
    When Registration Page - Click on Create your account button
    Then Shoot baseline "QM - B2B - Flow 7 - registration page - Missing all details" and ignore
      | email input |

  Scenario Outline: password error
    And Create account for primary user with
      | password | <password> |
      | nickname | VALID      |
    Then Shoot baseline "<baseLineName>" and ignore
      | email input |
    Examples:
      | password      | baseLineName                                     |
      | SHORT         | QM - B2B - Flow 7 - password too short error     |
      | WEAK          | QM - B2B - Flow 7 - Weak password error          |
      | SO_SO         | QM - B2B - Flow 7 - SO-SO password error         |
      | SAME_AS_EMAIL | QM - B2B - Flow 7 - password same as email error |

  Scenario Outline: nickname error
    And Create account for primary user with
      | password | STRONG     |
      | nickname | <nickname> |
    Then Shoot baseline "<baseLineName>" and ignore
      | email input |
    Examples:
      | nickname           | baseLineName                                              |
      | SPECIAL_CHARACTERS | QM - B2B - Flow 7 - Invalid nickname - special characters |
      | START_WITH_NUMBER  | QM - B2B - Flow 7 - Invalid nickname - starts with number |
      | TOO_LONG           | QM - B2B - Flow 7 - Invalid nickname - too long           |
      | SHORT              | QM - B2B - Flow 7 - Invalid nickname - too short          |
      | SAME_AS_PASSWORD   | QM - B2B - Flow 7 - Invalid nickname - same as password   |

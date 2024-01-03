@visual
Feature: QM - B2B: Flow 2 - Registration Validation

  Background:
    Given Navigate to flow11
    And Complete google validation form for primary user
      | age               | 18       |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | phone number      |          |
    And Click on Let's start button
    And Complete the matching questions with the following options
      | seek help reason                   | I'm feeling anxious or panicky |
      | got it                             |                                |
      | provider gender preference         | I'm not sure yet               |
      | have you been to a provider before | No                             |
      | sleeping habits                    | Good                           |
      | physical health                    | Fair                           |
      | your gender                        | Female                         |
      | state                              | MT                             |
    And Click on secure your match button

  Scenario: Visual regression
    Then Shoot baseline "QM - B2B - Flow 2 - registration page" and ignore
      | email input |
    When Registration Page - Click on Create your account button
    Then Shoot baseline "QM - B2B - Flow 2 - registration page - Missing all details" and ignore
      | email input |

  Scenario Outline: password error
    And Create account for primary user with
      | password | <password> |
      | nickname | VALID      |
    Then Shoot baseline "<baseLineName>" and ignore
      | email input |
    Examples:
      | password      | baseLineName                                     |
      | SAME_AS_EMAIL | QM - B2B - Flow 2 - password same as email error |

  Scenario Outline: Visual regression
    And Create account for primary user with
      | password | STRONG     |
      | nickname | <nickname> |
    Then Shoot baseline "<baseLineName>" and ignore
      | email input |
    Examples:
      | nickname           | baseLineName                                              |
      | SPECIAL_CHARACTERS | QM - B2B - Flow 2 - Invalid nickname - special characters |
      | START_WITH_NUMBER  | QM - B2B - Flow 2 - Invalid nickname - starts with number |
      | TOO_LONG           | QM - B2B - Flow 2 - Invalid nickname - too long           |
      | SHORT              | QM - B2B - Flow 2 - Invalid nickname - too short          |
      | SAME_AS_PASSWORD   | QM - B2B - Flow 2 - Invalid nickname - same as password   |

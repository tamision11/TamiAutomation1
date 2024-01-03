Feature: QM - B2B - EAP
  Leads to flow 2

  Background:
    Given Navigate to flow44
    When Complete shared validation form for primary user
      | age               | 18       |
      | organization      | aetna    |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
      | phone number      |          |
    Then Click on Let's start button
    And Complete the matching questions with the following options
      | seek help reason                   | I'm feeling anxious or panicky |
      | got it                             |                                |
      | provider gender preference         | Male                           |
      | have you been to a provider before | Yes                            |
      | sleeping habits                    | Excellent                      |
      | physical health                    | Excellent                      |
      | your gender                        | Male                           |
      | state                              | Continue with prefilled state  |

  @smoke @sanity
  Scenario: Flow 44 - Aetna/RFL - Therapy
    And Click on secure your match button
    And Click on continue on coverage verification
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                          | Aetna EAP 6 Sessions Messaging or Live Session Voucher |
      | credit description                 | credit amount                                          |
      | 6 x Therapy live sessions (30 min) | 1                                                      |
    And Payment and Plan - Waiting to be matched text is displayed for the first room
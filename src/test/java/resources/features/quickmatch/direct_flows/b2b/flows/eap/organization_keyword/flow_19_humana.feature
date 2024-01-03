Feature: QM - B2B - EAP
  Leads to flow 2

  Background:
    Given Navigate to flow19
    When Complete shared validation form for primary user
      | age               | 18                                  |
      | organization      | humana                              |
      | service type      | THERAPY                             |
      | Email             | PRIMARY                             |
      | employee Relation | ADULT_DEPENDENT_MEMBER_OF_HOUSEHOLD |
      | state             | MT                                  |
      | phone number      |                                     |
    And Click on Let's start button
    And Complete the matching questions with the following options
      | seek help reason                   | I'm feeling anxious or panicky |
      | got it                             |                                |
      | provider gender preference         | I'm not sure yet               |
      | have you been to a provider before | No                             |
      | sleeping habits                    | Good                           |
      | physical health                    | Fair                           |
      | your gender                        | Female                         |
      | state                              | Continue with prefilled state  |

  @smoke
  Scenario: Flow 19 - Humana - Therapy
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
      | plan name                               | Humana EAP 5 Sessions Messaging Only Voucher |
      | credit description                      | credit amount                                |
      | 1 x Complimentary live session (10 min) | 1                                            |
    And Payment and Plan - Waiting to be matched text is displayed for the first room
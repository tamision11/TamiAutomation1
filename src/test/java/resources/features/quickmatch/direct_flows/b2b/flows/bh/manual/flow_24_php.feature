Feature: QM - B2B - Manual BH
  Leads to flow 2

  Background:
    Given Navigate to flow24
    When Complete shared validation form for primary user
      | age               | 18                                  |
      | Member ID         | COPAY_0                             |
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

  Rule: Therapy

    @smoke @sanity
    Scenario: Flow 24 - PHP - Therapy
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                           | Magellan BH 10 Sessions Messaging or Live Session |
        | credit description                  | credit amount                                     |
        | 10 x Therapy live sessions (45 min) | 1                                                 |
      And Payment and Plan - Waiting to be matched text is displayed for the first room

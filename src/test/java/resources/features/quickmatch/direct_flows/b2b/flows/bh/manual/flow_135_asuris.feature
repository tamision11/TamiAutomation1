Feature: QM - B2B - Manual BH
  Leads to flow 2
  for BH manual flow the copay can only be validated via DB which is currently not possible on automation,
  so our tests only use it as a valid member ID

  Background:
    Given Navigate to flow135

  Rule: Therapy

    Background:
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_0  |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
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
        | state                              | Continue with prefilled state  |

    Scenario: Flow 135 - Asuris - Therapy
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                                     | Asuris Unlimited Sessions Messaging or Live Session |
        | credit description                            | credit amount                                       |
        | 30 x Therapy live sessions (60, 45 or 30 min) | 1                                                   |
      And Payment and Plan - Waiting to be matched text is displayed for the first room

  Rule: Couples therapy

    Background:
      When Complete shared validation form for primary user
        | age               | 18              |
        | Member ID         | COPAY_25        |
        | service type      | COUPLES_THERAPY |
        | Email             | PRIMARY         |
        | employee Relation | EMPLOYEE        |
        | state             | MT              |
        | phone number      |                 |
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

    Scenario: Flow 135 - Asuris - Couples therapy
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                           | Asuris BH Couples Messaging or Live v2 |
        | credit description                  | credit amount                          |
        | 30 x Therapy live sessions (45 min) | 1                                      |
      And Payment and Plan - Waiting to be matched text is displayed for the first room

  Rule: Psychiatry

    Background:
      When Complete shared validation form for primary user
        | age               | 18         |
        | Member ID         | COPAY_25   |
        | service type      | PSYCHIATRY |
        | Email             | PRIMARY    |
        | employee Relation | EMPLOYEE   |
        | state             | NY         |
        | phone number      |            |
      And Click on Let's start button
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | Anxiety                       |
        | state                                              | Continue with prefilled state |

    Scenario: Flow 135 - Asuris - Psychiatry
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                                        | Asuris BH 30 sessions psychiatry |
        | credit description                               | credit amount                    |
        | 30 x Psychiatry live sessions (15, 30 or 45 min) | 1                                |
      And Payment and Plan - Waiting to be matched text is displayed for the first room
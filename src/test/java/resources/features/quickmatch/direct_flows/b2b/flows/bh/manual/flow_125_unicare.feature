@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2864
Feature: QM - B2B - Manual BH

  Background:
    Given Navigate to flow125

  Rule: Therapy

    Background:
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_25 |
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

    Scenario: Flow 125 - Unicare - Therapy
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                                     | Unicare Unlimited Sessions Messaging or Live Session |
        | credit description                            | credit amount                                        |
        | 30 x Therapy live sessions (30, 45 or 60 min) | 1                                                    |
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

    Scenario: Flow 125 - Unicare - Psychiatry
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                              | Unicare BH 30 sessions psychiatry |
        | credit description                     | credit amount                     |
        | 29 x Psychiatry live sessions (30 min) | 1                                 |
        | 1 x Psychiatry live session (60 min)   | 1                                 |
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

    Scenario: Flow 125 - Unicare - Couples therapy
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                           | Unicare BH Couples Messaging or Live Session |
        | credit description                  | credit amount                                |
        | 30 x Therapy live sessions (45 min) | 1                                            |
      And Payment and Plan - Waiting to be matched text is displayed for the first room
@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2788
Feature: QM - B2B - Manual BH

  Background:
    Given Navigate to flow111

  Rule: Therapy

    Background:
      When Complete shared validation form for primary user
        | age               | 18        |
        | Member ID         | GATORCARE |
        | service type      | THERAPY   |
        | Email             | PRIMARY   |
        | employee Relation | EMPLOYEE  |
        | state             | MT        |
        | phone number      |           |
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

    Scenario: Flow 111 - Gatorcare - Therapy
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                           | RTE Gatorcare BH Unlimited Sessions Messaging or Live Session Voucher |
        | credit description                  | credit amount                                                         |
        | 30 x Therapy live sessions (45 min) | 1                                                                     |
      And Payment and Plan - Waiting to be matched text is displayed for the first room

  Rule: Psychiatry

    Background:
      When Complete shared validation form for primary user
        | age               | 18         |
        | Member ID         | GATORCARE  |
        | service type      | PSYCHIATRY |
        | Email             | PRIMARY    |
        | employee Relation | EMPLOYEE   |
        | state             | NY         |
        | phone number      |            |
      And Click on Let's start button
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | Anxiety                       |
        | state                                              | Continue with prefilled state |

    Scenario: Flow 111 - Gatorcare - Psychiatry
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                              | RTE Gatorcare BH Psychiatry Unlimited Live Sessions |
        | credit description                     | credit amount                                       |
        | 29 x Psychiatry live sessions (30 min) | 1                                                   |
        | 1 x Psychiatry live session (60 min)   | 1                                                   |
      And Payment and Plan - Waiting to be matched text is displayed for the first room

@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2635
Feature: QM - B2B - Manual BH
  Leads to flow 2
  for BH manual flow the copay can only be validated via DB which is currently not possible on automation,
  so our tests only use it as a valid member ID

  Background:
    Given Navigate to flow95

  Rule: Therapy

    Background:
      When Complete shared validation form for primary user
        | age               | 18             |
        | Member ID         | UMR_BH_COPAY_0 |
        | service type      | THERAPY        |
        | Email             | PRIMARY        |
        | employee Relation | EMPLOYEE       |
        | state             | MT             |
        | phone number      |                |
      And Click on Let's start button
      And Complete the matching questions with the following options
        | seek help reason                   | I'm feeling anxious or panicky |
        | got it                             |                                |
        | provider gender preference         | Male                           |
        | have you been to a provider before | Yes                            |
        | sleeping habits                    | Excellent                      |
        | physical health                    | Excellent                      |
        | your gender                        | Male                           |
        | state                              | Continue with prefilled state  |

    Scenario: Flow 95 - Optum UMR - Therapy
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                           | UMR BH Unlimited Sessions Messaging or Live Session v2 Voucher |
        | credit description                  | credit amount                                                  |
        | 30 x Therapy live sessions (45 min) | 1                                                              |
      And Payment and Plan - Waiting to be matched text is displayed for the first room

  Rule: Psychiatry

    Background:
      When Complete shared validation form for primary user
        | age               | 18              |
        | Member ID         | UMR_BH_COPAY_25 |
        | service type      | PSYCHIATRY      |
        | Email             | PRIMARY         |
        | employee Relation | EMPLOYEE        |
        | state             | NY              |
        | phone number      |                 |
      And Click on Let's start button
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | Anxiety                       |
        | state                                              | Continue with prefilled state |

    Scenario: Flow 95 - Optum UMR - Psychiatry
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                                        | UMR BH Psychiatry v2 |
        | credit description                               | credit amount        |
        | 30 x Psychiatry live sessions (15, 30 or 45 min) | 1                    |
      And Payment and Plan - Waiting to be matched text is displayed for the first room
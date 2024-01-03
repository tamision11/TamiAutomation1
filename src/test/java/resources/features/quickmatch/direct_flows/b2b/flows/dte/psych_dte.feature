Feature: QM - B2B - DTE
  Leads to flow 2

  Background:
    Given Navigate to redemption

  Rule: Therapy

    Background:
      And Landing page - Submit DTE form with THERAPY service type for primary user
      Then Click on Let's start button
      And Complete the matching questions with the following options
        | age                                | 18                             |
        | seek help reason                   | I'm feeling anxious or panicky |
        | got it                             |                                |
        | provider gender preference         | Male                           |
        | have you been to a provider before | Yes                            |
        | sleeping habits                    | Good                           |
        | physical health                    | Good                           |
        | your gender                        | Male                           |
        | state                              | MT                             |

    Scenario: Psychiatry DTE - Therapy
      And Click on secure your match button
      And Create account for primary user with
        | email        | PRIMARY |
        | password     | STRONG  |
        | nickname     | VALID   |
        | phone number |         |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                               | Northwestern Mutual Unlimited Messaging with 1 Monthly Live Session Voucher |
        | credit description                      | credit amount                                                               |
        | 1 x Complimentary live session (10 min) | 1                                                                           |
        | 1 x Therapy live session (30 min)       | 1                                                                           |
      And Payment and Plan - Waiting to be matched text is displayed for the first room

  Rule: Psychiatry

    Background:
      And Landing page - Submit DTE form with PSYCHIATRY service type for primary user
      And Click on Let's start button

      And Complete the matching questions with the following options
        | age                                                | 18      |
        | why you thought about getting help from a provider | Anxiety |
        | state                                              | NY      |

    @smoke
    Scenario: Psychiatry DTE - Psychiatry
      And Click on secure your match button
      And Create account for primary user with
        | email        | PRIMARY |
        | password     | STRONG  |
        | nickname     | VALID   |
        | phone number |         |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                              | PSYCH-DTE Ongoing psychiatry 12 Sessions Voucher |
        | credit description                     | credit amount                                    |
        | 1 x Psychiatry live session (60 min)   | 1                                                |
        | 11 x Psychiatry live sessions (30 min) | 1                                                |
      And Payment and Plan - Waiting to be matched text is displayed for the first room
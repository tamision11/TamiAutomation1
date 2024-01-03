Feature: QM - B2B - DTE
  Leads to flow 2

  Background:
    Given Navigate to flow69

  Rule: Elizabeth using keyword
  the keyword is a workaround to emulating the geolocation

    Background:
      And Enter RANDOM email
      And Click on check eligibility button
      And Click on continue
      And Enter "elizabeth" access code
      And Click on continue
      Then Click on Let's start button
      And Complete the matching questions with the following options
        | seek help reason                   | I'm feeling anxious or panicky |
        | got it                             |                                |
        | provider gender preference         | Male                           |
        | have you been to a provider before | Yes                            |
        | sleeping habits                    | Good                           |
        | physical health                    | Good                           |
        | your gender                        | Male                           |
        | age                                | 18                             |
        | state                              | MT                             |

    Scenario: Flow 69 (Location Based DTE) - Elizabeth - Therapy using keyword
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
        | plan name                               | City of Elizabeth Unlimited Messaging with 1 Monthly Live Session Voucher |
        | credit description                      | credit amount                                                             |
        | 1 x Complimentary live session (10 min) | 1                                                                         |
        | 1 x Therapy live session (30 min)       | 1                                                                         |
      And Payment and Plan - Waiting to be matched text is displayed for the first room

  Rule: Elizabeth with geolocation

    Background:
      Given Location is set to ELIZABETH
      And Enter RANDOM email
      And Click on check eligibility button
      Then Click on Let's start button
      And Complete the matching questions with the following options
        | seek help reason                   | I'm feeling anxious or panicky |
        | got it                             |                                |
        | provider gender preference         | Male                           |
        | have you been to a provider before | Yes                            |
        | sleeping habits                    | Good                           |
        | physical health                    | Good                           |
        | your gender                        | Male                           |
        | age                                | 18                             |
        | state                              | MT                             |

    @smoke @sanity
    Scenario: Flow 69 (Location Based DTE) - Elizabeth - Therapy using geolocation
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
        | plan name                               | City of Elizabeth Unlimited Messaging with 1 Monthly Live Session Voucher |
        | credit description                      | credit amount                                                             |
        | 1 x Complimentary live session (10 min) | 1                                                                         |
        | 1 x Therapy live session (30 min)       | 1                                                                         |
      And Payment and Plan - Waiting to be matched text is displayed for the first room
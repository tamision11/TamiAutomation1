Feature: QM - B2B - EAP
  Leads to flow 2

  Background:
    Given Navigate to flow78

  Rule: With video

    Background:
      When Complete cigna eap validation form for primary user
        | age                           | 18          |
        | authorization code            | MOCK_CIGNA  |
        | session number                | 5           |
        | service type                  | THERAPY     |
        | Email                         | PRIMARY     |
        | employee Relation             | EMPLOYEE    |
        | state                         | MT          |
        | phone number                  |             |
        | authorization code expiration | future date |
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

    @smoke @sanity
    Scenario: Flow 78 - Cigna - Therapy - with video
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
        | plan name                          | Cigna EAP 5 Sessions Messaging and Live Session Voucher |
        | credit description                 | credit amount                                           |
        | 5 x Therapy live sessions (45 min) | 1                                                       |
      And Payment and Plan - Waiting to be matched text is displayed for the first room
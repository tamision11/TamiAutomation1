Feature: QM - B2B - DTE
  Leads to flow 2.

  Background:
    Given Navigate to flow11
    Given Complete google validation form for primary user
      | age               | 18       |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | phone number      |          |
    And Click on Let's start button
    Then Complete the matching questions with the following options
      | seek help reason                   | I'm feeling anxious or panicky |
      | got it                             |                                |
      | provider gender preference         | Male                           |
      | have you been to a provider before | Yes                            |
      | sleeping habits                    | Excellent                      |
      | physical health                    | Excellent                      |
      | your gender                        | Male                           |
      | state                              | MT                             |

  Rule: Therapy

    @smoke @sanity
    Scenario: Flow 11 - Google - Therapy
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                               | Google Unlimited Messaging Only Voucher |
        | credit description                      | credit amount                           |
        | 1 x Complimentary live session (10 min) | 1                                       |
      And Payment and Plan - Waiting to be matched text is displayed for the first room
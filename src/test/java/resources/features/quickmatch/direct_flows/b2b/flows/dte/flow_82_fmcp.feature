Feature: QM - B2B - DTE
  Leads to flow 2.
  fmcp = eligibility based on file (Member ID + birthdate)

  Background:
    Given Navigate to flow82
    Then Options of the second dropdown are
      | Employee                            |
      | Spouse/partner                      |
      | Adult dependent/Member of household |
      | Student                             |
    When Complete shared validation form for primary user
      | Member ID         | FMCP     |
      | birthdate         | fmcp     |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
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
      | state                              | Continue with prefilled state  |

  Rule: Therapy

    @smoke
    Scenario: Flow 82 - FMCP - Therapy
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                               | FMCP Unlimited messaging + 1 Live Session v3 Voucher |
        | credit description                      | credit amount                                        |
        | 1 x Complimentary live session (10 min) | 1                                                    |
        | 1 x Therapy live session (30 min)       | 1                                                    |
      And Payment and Plan - Waiting to be matched text is displayed for the first room
@owner=tami_sion
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2901
Feature: QM - B2B - Automatic BH

  Background:
    Given Navigate to flow105

  Rule: Therapy

    Background:
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | FCH      |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
        | phone number      |          |
      And Click on next button to approve you are ready to begin
      And Complete the matching questions with the following options
        | seek help reason                   | I'm feeling anxious or panicky |
        | got it                             |                                |
        | provider gender preference         | I'm not sure yet               |
        | have you been to a provider before | No                             |
        | sleeping habits                    | Good                           |
        | physical health                    | Fair                           |
        | your gender                        | Female                         |
        | state                              | Continue with prefilled state  |

    Scenario: Flow 105 - FCH - Therapy
      And Click on secure your match button
      And Click on continue on coverage verification
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
        | checkbox |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | First Choice BH Unlimited Sessions Messaging or Live Session |
      And Payment and Plan - Waiting to be matched text is displayed for the first room


  Rule: Psychiatry

    Background:
      When Complete shared validation form for primary user
        | age               | 18         |
        | Member ID         | FCH        |
        | service type      | PSYCHIATRY |
        | Email             | PRIMARY    |
        | employee Relation | EMPLOYEE   |
        | state             | NY         |
        | phone number      |            |
      And Click on next button to approve you are ready to begin
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | Anxiety                       |
        | state                                              | Continue with prefilled state |

    Scenario: Flow 105 - FCH - Psychiatry
      And Click on secure your match button
      And Click on continue to checkout button
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
        | checkbox |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | First Choice BH Psychiatry |
      And Payment and Plan - Waiting to be matched text is displayed for the first room


  Rule: Couples therapy

    Background:
      When Complete shared validation form for primary user
        | age               | 18              |
        | Member ID         | FCH             |
        | service type      | COUPLES_THERAPY |
        | Email             | PRIMARY         |
        | employee Relation | EMPLOYEE        |
        | state             | MT              |
        | phone number      |                 |
      And Click on next button to approve you are ready to begin
      And Complete the matching questions with the following options
        | seek help reason                   | I'm feeling anxious or panicky |
        | got it                             |                                |
        | provider gender preference         | Male                           |
        | have you been to a provider before | Yes                            |
        | sleeping habits                    | Excellent                      |
        | physical health                    | Excellent                      |
        | your gender                        | Male                           |
        | state                              | Continue with prefilled state  |

    Scenario: Flow 105 - FCH - Couples therapy
      And Click on secure your match button
      And Click on continue on coverage verification
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
        | checkbox |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | First Choice BH + Video - Couples |
      And Payment and Plan - Waiting to be matched text is displayed for the first room
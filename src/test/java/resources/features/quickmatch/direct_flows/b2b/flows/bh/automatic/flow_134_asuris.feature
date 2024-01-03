Feature: QM - B2B - Automatic BH
  Leads to flow 7

  Background:
    Given Navigate to flow134


  Rule: Therapy

    Background:
      And Set primary user last name to Automation
      When Complete shared validation form for primary user
        | age               | 18                                  |
        | Member ID         | COPAY_0                             |
        | service type      | THERAPY                             |
        | Email             | PRIMARY                             |
        | employee Relation | ADULT_DEPENDENT_MEMBER_OF_HOUSEHOLD |
        | state             | MT                                  |
        | phone number      |                                     |
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

    Scenario: Flow 134 - Asuris - Therapy
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
        | plan name | Asuris BH Unlimited Sessions Messaging or Live Session |
      And Payment and Plan - Waiting to be matched text is displayed for the first room


  Rule: Couples therapy

    Background:
      And Set primary user last name to Automation
      When Complete shared validation form for primary user
        | age               | 18              |
        | Member ID         | COPAY_25        |
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

    Scenario: Flow 134 - Asuris - Couples therapy
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
        | plan name | Asuris BH Couples Messaging or Live |
      And Payment and Plan - Waiting to be matched text is displayed for the first room

  Rule: Psychiatry

    Background:
      And Set primary user last name to Automation
      When Complete shared validation form for primary user
        | age               | 18         |
        | Member ID         | COPAY_0    |
        | service type      | PSYCHIATRY |
        | Email             | PRIMARY    |
        | employee Relation | EMPLOYEE   |
        | state             | NY         |
        | phone number      |            |
      And Click on next button to approve you are ready to begin
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | Anxiety                       |
        | state                                              | Continue with prefilled state |

    @smoke
    Scenario: Flow 134 - Asuris - Psychiatry
    check vouchers availability:
    select if (maximum_allowed_vouchers >= usage_count , "vouchers available", "no available vouchers") from commercial.access_code_definitions where access_code_type = 'voucher_premera_bh_psychiatry';
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
        | plan name | Asuris BH Psychiatry |
      And Payment and Plan - Waiting to be matched text is displayed for the first room
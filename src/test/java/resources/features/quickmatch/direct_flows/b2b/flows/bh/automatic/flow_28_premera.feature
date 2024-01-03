Feature: QM - B2B - Automatic BH
  Leads to flow 7

  Background:
    Given Navigate to flow28

  @tmsLink=talktala.atlassian.net/browse/CVR-96
  Scenario: "How Did You Hear About Us?" BH dropdown options
    Then Options of referral dropdown are
      | Podcast              |
      | Email                |
      | Search Engine        |
      | App Store            |
      | School/university    |
      | Facebook             |
      | Instagram            |
      | Twitter              |
      | Tik Tok              |
      | Online article       |
      | Cable TV             |
      | Digital/Streaming TV |
      | My Insurance         |
      | My Employer/Work     |
      | Radio                |
      | Friend               |
      | Online ad            |
      | Zocdoc               |
      | Other                |


  Rule: Therapy

    Background:
      And Set primary user last name to Automation
      When Complete shared validation form for primary user
        | age               | 13                                  |
        | Member ID         | COPAY_0                             |
        | service type      | THERAPY                             |
        | Email             | PRIMARY                             |
        | employee Relation | ADULT_DEPENDENT_MEMBER_OF_HOUSEHOLD |
        | state             | MT                                  |
        | phone number      |                                     |
      And Click on next button to approve you are ready to begin
      And Complete the matching questions with the following options
        | what do you need support with      | Anxiety or worrying           |
        | got it                             |                               |
        | provider gender preference         | Male                          |
        | have you been to a provider before | Yes                           |
        | sleeping habits                    | Excellent                     |
        | physical health                    | Excellent                     |
        | your gender                        | Male                          |
        | Parental consent                   | Yes                           |
        | state                              | Continue with prefilled state |

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-3004
    @issue=talktala.atlassian.net/browse/MEMBER-3240
    Scenario: Flow 28 - Premera - Therapy
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
        | plan name | Premera BH Unlimited Sessions Messaging or Live Session |
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

    Scenario: Flow 28 - Premera - Couples therapy
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
        | plan name | Premera BH Unlimited Sessions Messaging or Live Session Couples |
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
    Scenario: Flow 28 - Premera - Psychiatry
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
        | plan name | Premera BH Psychiatry |
      And Payment and Plan - Waiting to be matched text is displayed for the first room
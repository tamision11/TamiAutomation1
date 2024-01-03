@owner=nir_tal
Feature: QM - BH no insurance

  Background:
    Given Navigate to flow90

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2872
  Rule: Trizetto timeout flow

  Background:
    When Select THERAPY service
    And Select to pay through insurance provider
    And Continue with "Premera" insurance provider

  @tmsLink=talktala.atlassian.net/browse/MEMBER-2422
  Scenario Outline: Start from flow 90 - Trizetto timeout flow
  The “retry” and direct photo upload flow is only intended for trizetto time out.
    Then Current url should contain "/flow/132/step/101"
    And Complete upfront coverage verification validation form for primary user
      | age       | 18          |
      | state     | MT          |
      | Member ID | <Member ID> |
    And Unified eligibility page - Click on retry button 2 times
    Then BH no insurance - User is redirected to the “Let's help you figure this out” page
    Examples:
      | Member ID                         |
      | REDIRECT_TO_MANUAL_DUE_TO_TIMEOUT |

  @tmsLink=talktala.atlassian.net/browse/MEMBER-2422
  Scenario Outline: Start from flow 90 - Other Trizetto errors
  The “retry” and direct photo upload flow is only intended for trizetto time out.
    And Complete upfront coverage verification validation form for primary user
      | age       | 18          |
      | state     | MT          |
      | Member ID | <Member ID> |
    Then Current url should contain "/flow/132/step/102"
    Examples:
      | Member ID                                   |
      | REDIRECT_TO_MANUAL_DUE_TO_SERVER_ERROR      |
      | REDIRECT_TO_MANUAL_DUE_TO_UNABLE_TO_RESPOND |

  Rule: Therapy

    Background:
      When Select THERAPY service
      And Select to pay through insurance provider
      And Continue with "Premera" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18           |
        | state     | MT           |
        | Member ID | NOT_ELIGIBLE |

    @visual
    Scenario: Start from flow 90 - Options screen
    all options are available
      And Shoot baseline

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2868
    Scenario: Start from flow 90 - Switch to organization flow
      And BH no insurance - Click on continue with EAP button
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | state                                              | Continue with prefilled state  |
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      And Write "test" in organization name
      And Click on next button
      And Enter RANDOM email
      And Click on next button
      And Click on I have a keyword or access code button
      And Enter "kga" access code
      And Click on next button
      And Unified eligibility page - enter MOCK_KGA authorization code
      And Complete shared after upfront coverage verification validation form for primary user
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | phone number      |          |
      And Click on continue on coverage verification
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                               | KGA EAP 3 Sessions with Live Sessions Voucher |
        | credit description                      | credit amount                                 |
        | 1 x Complimentary live session (10 min) | 1                                             |
        | 3 x Therapy live sessions (45 min)      | 1                                             |
      And Payment and Plan - Waiting to be matched text is displayed for the first room

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2871
    @tmsLink=talktala.atlassian.net/browse/MEMBER-1422
    @smoke @sanity
    Scenario: Start from flow 90 - I’m sure my plan covers Talkspace
      And BH no insurance - Click on I’m sure my plan covers Talkspace
      And BH no insurance - upload insurance card image
      And BH no insurance - upload id card image
      And Unified eligibility page - Click on continue button
      And Enter PRIMARY email
      And BH no insurance - Insert PRIMARY email in email confirmation
      And Unified eligibility page - Click on submit button
      Then BH no insurance - We’ve received your request text is displayed

    Scenario: Start from flow 90 - I’m sure my plan covers Talkspace - Unable to continue with missing information
      And BH no insurance - Click on I’m sure my plan covers Talkspace
      And BH no insurance - upload insurance card image
      And BH no insurance - upload id card image
      And BH no insurance - Delete front of the card
      And Unified eligibility page - Continue button is disabled

    @visual
    Scenario: BH no insurance - We will assign an agent for you
      And BH no insurance - Click on I’m sure my plan covers Talkspace
      And BH no insurance - upload insurance card image
      And BH no insurance - upload id card image
      And Unified eligibility page - Click on continue button
      Then Shoot baseline

    @visual
    Scenario: BH no insurance - We’ve received your request
      And BH no insurance - Click on I’m sure my plan covers Talkspace
      And BH no insurance - upload insurance card image
      And BH no insurance - upload id card image
      And Unified eligibility page - Click on continue button
      And Enter PRIMARY email
      And BH no insurance - Insert PRIMARY email in email confirmation
      And Unified eligibility page - Click on submit button
      Then Shoot baseline and ignore
        | email input |

    @visual
    Scenario Outline: I’m sure my plan covers Talkspace - Email errors
      And BH no insurance - Click on I’m sure my plan covers Talkspace
      And BH no insurance - upload insurance card image
      And BH no insurance - upload id card image
      And Unified eligibility page - Click on continue button
      And Enter <email> email
      And BH no insurance - Insert <confirmation> email in email confirmation
      Then Shoot baseline "<baseLineName>" and ignore
        | email input                |
        | confirm update email input |
      Examples:
        | email   | confirmation | baseLineName                                                                                                       |
        | INVALID | INVALID      | QM - BH no insurance - Start from flow 90 - I’m sure my plan covers Talkspace - Invalid email error                |
        | PRIMARY | NEW          | QM - BH no insurance - Start from flow 90 - I’m sure my plan covers Talkspace - Different email confirmation error |

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2869
    Scenario: Start from flow 90 - Check that my information is correct and resubmit
      And BH no insurance - Click on check my coverage is correct button
      And Unified eligibility page - Enter COPAY_0 member id
      And Unified eligibility page - Click on continue button
      And Click on continue on coverage verification
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | state                                              | Continue with prefilled state  |
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      And Complete shared after upfront coverage verification validation form for primary user
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | phone number      |          |
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

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2870
    Scenario: Start from flow 90 - Switch to B2C therapy flow
      And BH no insurance - Click on continue without insurance
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | state                                              | Continue with prefilled state  |
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      When Select the second plan
      And Continue with "Monthly" billing period
      And Apply free coupon if running on prod
      And Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password     | STRONG |
        | nickname     | VALID  |
        | phone number |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Messaging Only Therapy - Monthly |
      And No credits exist in the first room
      And Payment and Plan - Waiting to be matched text is displayed for the first room

  Rule: Psychiatry

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2870
    Scenario: Start from flow 90 - Switch to B2C psychiatry flow
      When Select PSYCHIATRY service
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider       | Anxiety |
        | prescribed medication to treat a mental health condition | Yes     |
        | your gender                                              | Female  |
        | provider gender                                          | Male    |
        | age                                                      | 18      |
        | state                                                    | MT      |
      And Continue with "Premera" insurance provider
      And Click on secure your match button
      And Complete shared validation form for primary user
        | age               | 18           |
        | Member ID         | NOT_ELIGIBLE |
        | Email             | PRIMARY      |
        | employee Relation | EMPLOYEE     |
        | state             | MT           |
        | phone number      |              |
      And BH no insurance - Click on continue without insurance
      And Select the first plan
      When Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Psychiatry - Initial Evaluation + 1 follow up session |
      And No credits exist in the first room
      And Payment and Plan - Waiting to be matched text is displayed for the first room
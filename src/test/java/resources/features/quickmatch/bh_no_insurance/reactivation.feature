@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2877
Feature: QM - BH no insurance

  Background:
    Given Therapist API - Login to therapist provider
    Given Client API - Create THERAPY BH room for primary user with therapist provider with visa card
      | flowId            | 28        |
      | age               | 18        |
      | Member ID         | COPAY_25  |
      | keyword           | premerabh |
      | employee Relation | EMPLOYEE  |
      | state             | MT        |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Dismiss modal
    And Client API - Cancel a non paying subscription of primary user in the first room
    And Navigate to payment and plan URL
    And Click on Undo cancellation
    And Click on continue
    And Reactivation - Select THERAPY service
    And Select to pay through insurance provider
    And Continue with "Premera" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18           |
      | Member ID | NOT_ELIGIBLE |

  Scenario: Reactivation - Switch to B2C flow
    And BH no insurance - Click on continue without insurance
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    When Click on Match with a new provider
    And Click on secure your match button
    When Select the second plan
    And Continue with "Monthly" billing period
    And Apply free coupon if running on prod
    And Payment - Click on continue
    And Reactivation B2C Payment - Complete purchase using visa card with stripe link false
    And Reactivation - Click on continue to room button
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    And Payment and Plan - Waiting to be matched text is displayed for the first room
    Then Plan details for the first room are
      | plan name | Messaging Only Therapy - Monthly |
    And No credits exist in the first room
    And Payment and Plan - Waiting to be matched text is displayed for the first room

  Scenario: Reactivation - Switch to organization flow
    And BH no insurance - Click on continue with EAP button
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    When Click on Match with a new provider
    And Click on secure your match button
    When Reactivation - Write "mines" in organization name
    When Click on next button
    And Enter RANDOM email
    And Click on next button
    And Complete eap validation form for primary user
      | age               | 18       |
      | employee Relation | EMPLOYEE |
    And Click on continue on coverage verification
    And Eligibility Widget - Click on start treatment button
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Mines EAP 5 Sessions Messaging or Live Session Voucher |

  Scenario: Reactivation - Check that my information is correct and resubmit
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
    When Click on Match with a new provider
    And Click on secure your match button
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
    And Payment - Complete purchase using "visa" card for primary user
    And Reactivation - Click on continue to room button
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Premera BH Unlimited Sessions Messaging or Live Session |

  Scenario: Reactivation - I’m sure my plan covers Talkspace
    And BH no insurance - Click on I’m sure my plan covers Talkspace
    And BH no insurance - upload insurance card image
    And BH no insurance - upload id card image
    And Unified eligibility page - Click on continue button
    And Enter PRIMARY email
    And BH no insurance - Insert PRIMARY email in email confirmation
    And Unified eligibility page - Click on submit button
    And BH no insurance - Click on return to my account
    Then Room is available

  @visual
  Scenario: Reactivation - I’m sure my plan covers Talkspace - return to my account
    And BH no insurance - Click on I’m sure my plan covers Talkspace
    And BH no insurance - upload insurance card image
    And BH no insurance - upload id card image
    And Unified eligibility page - Click on continue button
    And Enter PRIMARY email
    And BH no insurance - Insert PRIMARY email in email confirmation
    And Unified eligibility page - Click on submit button
    And Shoot baseline "Reactivation - I’m sure my plan covers Talkspace - return to my account"
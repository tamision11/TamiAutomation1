@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2877
Feature: QM - BH no insurance

  Background:
    Given Therapist API - Login to therapist provider
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Client API - Subscribe to offer 62 of plan 160 with visa card of primary user in the first room
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Open account menu
    And Account Menu - Select update my coverage
    And Update my coverage - Select THERAPY plan to update
    And Update my coverage - Click on continue button
    And Update my coverage - Select to pay through insurance provider
    And Continue with "Premera" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18           |
      | state     | MT           |
      | Member ID | NOT_ELIGIBLE |

  Scenario: Client web - Update my coverage - Check that my information is correct and resubmit
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
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
    And B2B Payment - Complete purchase using visa card with stripe link false
    And Update my coverage - Click on go to my new room
    And Onboarding - Dismiss modal
    And Update my coverage - Welcome message for old B2C room with no sessions left appears in new room
    And Navigate to payment and plan URL
    Then Plan details for the second room are
      | plan name | Premera BH Unlimited Sessions Messaging or Live Session |
    And Client API - The second room status of primary user is ACTIVE
    And Client API - The first room status of primary user is NOT_RENEW

  Scenario: Client web - Update my coverage - I’m sure my plan covers Talkspace
    And BH no insurance - Click on I’m sure my plan covers Talkspace
    And BH no insurance - upload insurance card image
    And BH no insurance - upload id card image
    And Unified eligibility page - Click on continue button
    And Enter PRIMARY email
    And BH no insurance - Insert PRIMARY email in email confirmation
    And Unified eligibility page - Click on submit button
    And BH no insurance - Click on return to my account
    Then Room is available

  Scenario: Client web - Update my coverage - Switch to B2C flow
    And BH no insurance - Click on continue without insurance
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    When Select the second plan
    And Continue with "Monthly" billing period
    And Apply free coupon if running on prod
    When Payment - Click on continue
    And Payment - Complete purchase using "visa" card for primary user
    And Update my coverage - Click on go to my new room
    And Onboarding - Dismiss modal
    And Update my coverage - Welcome message for old B2C room with no sessions left appears in new room
    And Navigate to payment and plan URL
    Then Plan details for the second room are
      | plan name | Messaging Only Therapy - Monthly |
    And Client API - The first room status of primary user is NOT_RENEW
    And Client API - The second room status of primary user is ACTIVE

  @issue=talktala.atlassian.net/browse/MEMBER-3286
  Scenario: Client web - Update my coverage - Switch to organization flow
    And BH no insurance - Click on continue with EAP button
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Write "test" in organization name
    And Click on next button
    And Enter RANDOM email
    And Click on next button
    And Click on I have a keyword or access code button
    And Enter "kga" access code
    And Click on next button
    And Complete kga eap validation form for primary user
      | authorization code | MOCK_KGA |
      | age                | 18       |
      | service type       | THERAPY  |
      | Email              | PRIMARY  |
      | employee Relation  | EMPLOYEE |
      | state              | MT       |
    And Click on continue on coverage verification
    And Update my coverage - Click on go to my new room
    And Onboarding - Dismiss modal
    And Update my coverage - Welcome message for old B2C room with no sessions left appears in new room
    And Navigate to payment and plan URL
    Then Plan details for the second room are
      | plan name                               | KGA EAP 3 Sessions with Live Sessions Voucher |
      | credit description                      | credit amount                                 |
      | 1 x Complimentary live session (10 min) | 1                                             |
      | 3 x Therapy live sessions (45 min)      | 1                                             |
    And Client API - The second room status of primary user is ACTIVE
    And Client API - The first room status of primary user is NOT_RENEW
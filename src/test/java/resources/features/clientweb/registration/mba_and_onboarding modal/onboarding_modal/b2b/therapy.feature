@owner=nir_tal
Feature: Client web - Registration - MBA and Onboarding

  @tmsLink=https://talktala.atlassian.net/browse/AUTOMATION-2736
  @admin
  Scenario: Onboarding - QUEUE match - Book Live first session - BH - Live and Messaging plan - Non-Live state - Live preference - I'll book later
  On queue match, booking experience will be the same regardless of choosing Live preference choice during QM
    Given Navigate to flow70
    When Complete shared validation form for primary user
      | age               | 18       |
      | Member ID         | COPAY_25 |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | STUDENT  |
      | state             | WY       |
      | phone number      |          |
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
    And Click on secure your match button
    And Click on continue on coverage verification
    And QM - Select VIDEO as first Live booking modality for B2B_BH plan
    And Payment - Complete purchase using "visa" card for primary user
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click continue on book first session
    And Onboarding - Click continue on duration selection
    And In-room scheduler - Click on Next available button if present
    And Onboarding - Click None of these times work for me
    And Onboarding - Click i'll book later
    And Onboarding - Click continue on your all done screen
    And Admin API - Execute MATCH_ROOMS_FROM_QUEUE_WITH_PROVIDER cron
    And Onboarding - Click on meet your provider button
    And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with BH_MESSAGING_AND_LIVE plan and NON_LIVE state
    Then Onboarding - Click on close button
    And “Next Live session is scheduled for“ banner appears

  @admin
  Scenario: Onboarding - QUEUE match - Start Messaging session - BH - Live and Messaging plan - Non-Live state - Messaging preference
    Given Navigate to flow70
    When Complete shared validation form for primary user
      | age               | 18       |
      | Member ID         | COPAY_25 |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | STUDENT  |
      | state             | WY       |
      | phone number      |          |
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
    And Click on secure your match button
    And Click on continue on coverage verification
    And QM - Select Async messaging as first session
    And Payment - Complete purchase using "visa" card for primary user
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Admin API - Execute MATCH_ROOMS_FROM_QUEUE_WITH_PROVIDER cron
    And Onboarding - Click on meet your provider button
    And Start async messaging session with B2B_BH plan and MESSAGING_PREFERENCE selection
    And “Messaging Session in progress“ banner appears

  @admin
  Scenario: Onboarding - QUEUE match - Book Live first session - EAP - Messaging only plan - Live state - I'll book later
    Given Navigate to flow44
    When Complete shared validation form for primary user
      | age               | 18                 |
      | organization      | aetnaMessagingOnly |
      | service type      | THERAPY            |
      | Email             | PRIMARY            |
      | employee Relation | EMPLOYEE           |
      | state             | MT                 |
      | phone number      |                    |
    Then Click on Let's start button
    And Complete the matching questions with the following options
      | seek help reason                   | I'm feeling anxious or panicky |
      | got it                             |                                |
      | provider gender preference         | Male                           |
      | have you been to a provider before | Yes                            |
      | sleeping habits                    | Excellent                      |
      | physical health                    | Excellent                      |
      | your gender                        | Male                           |
      | state                              | Continue with prefilled state  |
    And Click on secure your match button
    And Click on continue on coverage verification
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click continue on book first session
    And Onboarding - Click continue on modality selection
    And Onboarding - Click continue on duration selection
    And In-room scheduler - Click on Next available button if present
    And Onboarding - Click None of these times work for me
    And Onboarding - Click i'll book later
    And Onboarding - Click continue on your all done screen
    And Wait 3 seconds
    And Admin API - Execute MATCH_ROOMS_FROM_QUEUE_WITH_PROVIDER cron
    And Onboarding - Click on meet your provider button
    And in-room scheduler - Book THERAPY live VIDEO session of TEN minutes with EAP_MESSAGING_ONLY plan and LIVE state
    Then Onboarding - Click on close button
    And “Next Live session is scheduled for“ banner appears

  Rule: Reactivation

    Background:
      Given Therapist API - Login to therapist provider
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click continue on book first session
      And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with B2C_MESSAGING_AND_LIVE plan and IGNORE state
      And Onboarding - Click on close button
      And Client API - Cancel Subscription of primary user in the first room
      And Client API - Refund Charge of primary user
      And Navigate to payment and plan URL
      And Click on Subscribe button

    Scenario: Onboarding - Reactivation - Match with same provider - Book live first session - BH - Live + messaging plan - Non-Live state - Live preferences
    it is mandatory to sign 2fa in order to get only 1 task banner
      And Click on continue
      And Reactivation - Select THERAPY service
      And Select to pay through insurance provider
      And Continue with "Premera" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18      |
        | state     | MT      |
        | Member ID | COPAY_0 |
      And Click on continue on coverage verification
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | state                                              | WY                             |
      When Click on Continue with same provider
      And Complete shared after upfront coverage verification validation form for primary user
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
      And QM - Select VIDEO as first Live booking modality for B2B_BH plan
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And in-room scheduler - Book THERAPY live VIDEO session of FORTY_FIVE minutes with BH_MESSAGING_AND_LIVE plan and NON_LIVE state
      And Onboarding - Click on close button
      And “Next Live session is scheduled for“ banner appears

  Rule: Switch provider

    Background:
      Given Navigate to flow28
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_25 |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | STUDENT  |
        | state             | MT       |
        | phone number      |          |
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
      And Click on secure your match button
      And Click on continue on coverage verification
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on continue button
      And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      When Navigate to payment and plan URL
      And Click on Change provider button

    Scenario: Onboarding - Switch provider - Book live first session - BH - Live + Messaging plan - Live state
    it is mandatory to sign 2fa in order to get only 1 task banner
      When Click on begin button
      And Rate provider with 2 stars
      And Click on next button
      And Select from list the option "I couldn't form a strong connection with my provider"
      When Click on next button
      And Select multiple focus
        | Anger Control Problems |
      When Click on next button
      And Change provider - Select MT state
      When Click on next button
      And Change provider - Click on No preferences
      And Client Web - Select the first provider from the list
      When Click on confirm button
      And Click on continue with therapist button
      And Onboarding - Click on meet your provider button
      And in-room scheduler - Book THERAPY live VIDEO session of FORTY_FIVE minutes with BH_MESSAGING_AND_LIVE plan and LIVE state
      And Onboarding - Click on close button
      And “Next Live session is scheduled for“ banner appears

    Scenario: Onboarding - Switch provider - Start Messaging session - BH - Live + Messaging plan - non-Live state
    it is mandatory to sign 2fa in order to get only 1 task banner
      When Click on begin button
      And Rate provider with 2 stars
      And Click on next button
      And Select from list the option "I couldn't form a strong connection with my provider"
      When Click on next button
      And Select multiple focus
        | Anger Control Problems |
      When Click on next button
      And Change provider - Select WY state
      When Click on next button
      And Wait 5 seconds
      Then Options of the first dropdown are
        | Male   |
        | Female |
      And Change provider - Click on No preferences
      And Client Web - Select the first provider from the list
      When Click on confirm button
      And Click on continue with therapist button
      And Onboarding - Click on meet your provider button
      And Start async messaging session with B2B_BH plan and NO_LIVE_PREFERENCE selection
      And In-room scheduler - Click on Go to session room button
      Then Onboarding - Click on close button
      And “Messaging Session in progress“ banner appears

  Rule: Update my coverage

    Background:
      Given Therapist API - Login to therapist provider
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | MT |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click continue on book first session
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      When Open account menu
      And Account Menu - Select update my coverage
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button

    Scenario: Onboarding - Update my coverage - Book live first session - BH - Live + Messaging plan - Live state
    it is mandatory to sign 2fa in order to get only 1 task banner
      And Update my coverage - Select to pay through insurance provider
      And Continue with "Premera" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18      |
        | state     | MT      |
        | Member ID | COPAY_0 |
      And Click on continue on coverage verification
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | state                                              | Continue with prefilled state  |
      And Complete shared after upfront coverage verification validation form for primary user
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
      And Payment - Complete purchase using "visa" card for primary user
      And Update my coverage - Click on check out my new room
      And in-room scheduler - Book THERAPY live VIDEO session of SIXTY minutes with BH_MESSAGING_AND_LIVE plan and LIVE state
      And Onboarding - Click on close button
      And “Next Live session is scheduled for“ banner appears
      And Navigate to payment and plan URL
      Then Plan details for the second room are
        | plan name                                   | Premera BH Unlimited Sessions Messaging or Live Session |
        | credit description                          | credit amount                                           |
        | 1 x Therapy live session (60, 45 or 30 min) | 1                                                       |
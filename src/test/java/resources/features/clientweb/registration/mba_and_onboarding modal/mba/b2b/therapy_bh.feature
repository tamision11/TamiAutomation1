@owner=tami
Feature: Client web - Registration - MBA and Onboarding

  Rule: Live + messaging plan - Non-Live state

    Background:
      Given Navigate to flow70
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_0  |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | WY       |
        | phone number      |          |
      And Click on next button to approve you are ready to begin
      And Complete the matching questions with the following options
        | seek help reason                   | I'm feeling anxious or panicky |
        | got it                             |                                |
        | provider gender preference         | I'm not sure yet               |
        | have you been to a provider before | No                             |
        | sleeping habits                    | Good                           |
        | physical health                    | Fair                           |
        | your gender                        | Male                           |
        | state                              | Continue with prefilled state  |

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2773
    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2756
    @smoke @sanity
    Scenario: MBA - Before match - Book live first session - BH - Therapy - Live + messaging plan - Non-Live state - Messaging preferences
      And Click on secure your match button
      And Click on continue on coverage verification
      And QM - Select Async messaging as first session
      And B2B Payment - Complete purchase using visa card with stripe link false
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
        | checkbox |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Room is available
      And Client API - The first room status of primary user is WAITING_TO_BE_MATCHED_QUEUE

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2779
    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2756
    Scenario: MBA - Before match - Book live first session - BH - Therapy - Live + messaging plan - Non-Live state - Live preferences
    it is mandatory to sign 2fa in order to get only 1 task banner
      And Click on secure your match button
      And Click on continue on coverage verification
      And QM - Select VIDEO as first Live booking modality for B2B_BH plan
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
        | checkbox |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on continue button
      And MBA - Book first THERAPY live VIDEO session with LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And “Next Live session is scheduled for“ banner appears
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                                   | Aetna BH Unlimited Sessions Messaging or Live Session |
        | credit description                          | credit amount                                         |
        | 1 x Therapy live session (60, 45 or 30 min) | 1                                                     |

    Scenario: MBA - Before match - Book live first session - BH - Therapy - None of these times work for me
      And Click on secure your match button
      And Click on continue on coverage verification
      And QM - Select VIDEO as first Live booking modality for B2B_BH plan
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
        | checkbox |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click continue on book first session
      And Onboarding - Click continue on duration selection
      And In-room scheduler - Click on Next available button if present
      And Onboarding - Click None of these times work for me
      And Onboarding - Click i'll book later
      And Onboarding - Click continue on your all done screen
      And Room is available
      And Client API - The first room status of primary user is WAITING_TO_BE_MATCHED_QUEUE

  Rule: Live + messaging plan - Live state

    Scenario: MBA - Before match - Book live first session - BH - Therapy - Live + messaging plan - Live state
      Given Navigate to flow70
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_0  |
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
        | your gender                        | Male                           |
        | state                              | Continue with prefilled state  |
      And Click on secure your match button
      And Click on continue on coverage verification
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
        | checkbox |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on continue button
      And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And “Next Live session is scheduled for“ banner appears
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                                   | Aetna BH Unlimited Sessions Messaging or Live Session |
        | credit description                          | credit amount                                         |
        | 1 x Therapy live session (60, 45 or 30 min) | 1                                                     |

  Rule: Live + messaging plan - Non-Live state - no capacity

    Background:
      Given Navigate to flow70
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_0  |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | MO       |
        | phone number      |          |
      And Click on next button to approve you are ready to begin
      And Complete the matching questions with the following options
        | seek help reason                   | I'm feeling anxious or panicky |
        | got it                             |                                |
        | provider gender preference         | I'm not sure yet               |
        | have you been to a provider before | No                             |
        | sleeping habits                    | Good                           |
        | physical health                    | Fair                           |
        | your gender                        | Male                           |
        | state                              | Continue with prefilled state  |

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2758
    Scenario: MBA - Before match - Book live first session - BH - Therapy - Live + messaging plan - Non-Live state - Live preferences - No capacity
      And Click on secure your match button
      And Click on continue on coverage verification
      And QM - Select VIDEO as first Live booking modality for B2B_BH plan
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
        | checkbox |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Room is available
      And Client API - The first room status of primary user is WAITING_TO_BE_MATCHED_QUEUE

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
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Client API - Cancel Subscription of primary user in the first room
      And Client API - Refund Charge of primary user
      And Navigate to payment and plan URL
      And Click on Subscribe button

    Scenario: MBA - Before match - Book live first session - Reactivation - Match with a new provider - BH - Live + messaging plan - Non-Live state - Live preferences
    it is mandatory to sign 2fa in order to get only 1 task banner
      And Click on continue
      And Reactivation - Select THERAPY service
      And Select to pay through insurance provider
      And Continue with "Premera" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18      |
        | state     | WY      |
        | Member ID | COPAY_0 |
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
      And QM - Select VIDEO as first Live booking modality for B2B_BH plan
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Onboarding - Click continue on book first session
      And MBA - Book first THERAPY live VIDEO session with LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And “Next Live session is scheduled for“ banner appears
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                                   | Premera BH Unlimited Sessions Messaging or Live Session |
        | credit description                          | credit amount                                           |
        | 1 x Therapy live session (60, 45 or 30 min) | 1                                                       |

  Rule: add a new service

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
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      When Open account menu
      Then Account Menu - Select add a new service

    Scenario: MBA - Before match - Book live first session - add a new service - BH - Live + messaging plan - Non-Live state - Live preferences
    it is mandatory to sign 2fa in order to get only 1 task banner
      And Select THERAPY service
      And Select to pay through insurance provider
      And Continue with "Premera" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18      |
        | state     | WY      |
        | Member ID | COPAY_0 |
      And Click on continue on coverage verification
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | state                                              | Continue with prefilled state  |
      And Click on secure your match button
      And Complete shared after upfront coverage verification validation form for primary user
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
      And QM - Select VIDEO as first Live booking modality for B2B_BH plan
      And Payment - Complete purchase using "visa" card for primary user
      And Click on continue to room button
      And Onboarding - Click continue on book first session
      And MBA - Book first THERAPY live VIDEO session with LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And “Next Live session is scheduled for“ banner appears
      And Navigate to payment and plan URL
      Then Plan details for the second room are
        | plan name                                   | Premera BH Unlimited Sessions Messaging or Live Session |
        | credit description                          | credit amount                                           |
        | 1 x Therapy live session (60, 45 or 30 min) | 1                                                       |
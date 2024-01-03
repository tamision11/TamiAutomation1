@owner=tami_sion
Feature: Client web - Update my coverage

  Rule: No credits in old B2C room

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

    Scenario: Current provider NOT available - No credits in old room - Go back to my room (old B2C to new DTE room)
      And Account Menu - Select update my coverage
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay through an organization
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | MO                             |
      And Click on secure your match button
      And Write "google" in organization name
      And Click on next button
      And Enter RANDOM email
      And Click on next button
      And Complete google validation form for primary user
        | age               | 18       |
        | employee Relation | EMPLOYEE |
      And Update my coverage - Click on continue on confirmation
      And Update my coverage - Click on go back to my room
      And Update my coverage - System message appears in old room
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Google Unlimited Messaging Only Voucher |
      And Client API - The second room status of primary user is WAITING_TO_BE_MATCHED_QUEUE
      And Client API - The first room status of primary user is NOT_RENEW

    Scenario: Current provider NOT available - No credits in old room - Go back to my room (old B2C to new BH room)
      And Account Menu - Select update my coverage
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay through insurance provider
      And Continue with "Premera" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18      |
        | state     | MO      |
        | Member ID | COPAY_0 |
      And Click on continue on coverage verification
      And Update my coverage - Complete the matching questions with the following options
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
      And Update my coverage - Click on continue on confirmation
      And Update my coverage - Click on go back to my room
      And Update my coverage - System message appears in old room
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Premera BH Unlimited Sessions Messaging or Live Session |
      And Client API - The second room status of primary user is WAITING_TO_BE_MATCHED_QUEUE
      And Client API - The first room status of primary user is NOT_RENEW

    @visual
    Scenario: ACKP - Current provider available - No credits in old room - Go to my new room
      And Account Menu - Select update my coverage
      And Shoot baseline "Select update my coverage screen"
      And Update my coverage - Select THERAPY plan to update
      And Shoot baseline "What to expect screen"
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay through an organization
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | MT                             |
      When Write "kga" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      When Complete kga eap validation form for primary user
        | authorization code | MOCK_KGA |
        | age                | 18       |
        | service type       | THERAPY  |
        | Email              | PRIMARY  |
        | employee Relation  | EMPLOYEE |
        | state              | MT       |
      And Click on continue on coverage verification
      And Shoot baseline "Current provider available - No credits in old room - Go to my new room"

    @visual
    Scenario: ACKP - Current provider NOT available - No credits in old room - Confirmation screen
      And Account Menu - Select update my coverage
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay through an organization
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | MO                             |
      And Click on secure your match button
      And Write "google" in organization name
      And Click on next button
      And Enter RANDOM email
      And Click on next button
      And Complete google validation form for primary user
        | age               | 18       |
        | employee Relation | EMPLOYEE |
      And Shoot baseline "Current provider NOT available - No credits in old room - Confirmation screen"

    @visual
    Scenario: ACKP - Current provider NOT available - No credits in old room - Go back to my room screen
      And Account Menu - Select update my coverage
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay through insurance provider
      And Continue with "Premera" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18      |
        | state     | MO      |
        | Member ID | COPAY_0 |
      And Click on continue on coverage verification
      And Update my coverage - Complete the matching questions with the following options
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
      And Update my coverage - Click on continue on confirmation
      And Shoot baseline "Current provider NOT available - No credits in old room - Go back to my room screen"

    @visual
    Scenario: ACKP - Current provider available - No credits in old room - Welcome message for old B2C room with no sessions left
      And Account Menu - Select update my coverage
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay through an organization
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | MT                             |
      When Write "kga" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      When Complete kga eap validation form for primary user
        | authorization code | MOCK_KGA |
        | age                | 18       |
        | service type       | THERAPY  |
        | Email              | PRIMARY  |
        | employee Relation  | EMPLOYEE |
        | state              | MT       |
      And Click on continue on coverage verification
      And Update my coverage - Click on go to my new room
      And Onboarding - Dismiss modal
      And Shoot baseline "Current provider available - No credits in old room - Welcome message for old B2C room with no sessions left"

    @visual
    Scenario: ACKP - Current provider NOT available - No credits in old room - Go back to my room - System message in old room
      And Account Menu - Select update my coverage
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay through an organization
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | MO                             |
      And Click on secure your match button
      And Write "google" in organization name
      And Click on next button
      And Enter RANDOM email
      And Click on next button
      And Complete google validation form for primary user
        | age               | 18       |
        | employee Relation | EMPLOYEE |
      And Update my coverage - Click on continue on confirmation
      And Update my coverage - Click on go back to my room
      And Shoot baseline "Current provider available - No credits in old room - Go back to my room - System message in old room"

  Rule: Available credits in old BH room

    Background:
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 70                      |
        | age               | 18                      |
        | Member ID         | COPAY_25                |
        | keyword           | aetnabhtherapyvideoonly |
        | employee Relation | EMPLOYEE                |
        | state             | MT                      |
        | isPendingMatch    |                         |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on continue button
      And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And Open account menu

    Scenario: Current provider NOT available - Credits available in old room - Go back to my room (old BH to new EAP room)
      And Account Menu - Select update my coverage
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay through an organization
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | MO                             |
      And Click on secure your match button
      When Write "kga" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      When Complete kga eap validation form for primary user
        | authorization code | MOCK_KGA |
        | age                | 18       |
        | service type       | THERAPY  |
        | Email              | PRIMARY  |
        | employee Relation  | EMPLOYEE |
        | state              | MO       |
      And Click on continue on coverage verification
      And QM - Select VIDEO as first Live booking modality for B2B_EAP plan
      And Update my coverage - Click on continue on confirmation
      And Update my coverage - Click on go back to my room
      And Update my coverage - System message appears in old room
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | KGA EAP 3 Sessions with Live Sessions Voucher |
      And Client API - The second room status of primary user is WAITING_TO_BE_MATCHED_QUEUE
      And Client API - The first room status of primary user is ACTIVE

    Scenario: Current provider NOT available - Credits available in old room - Go back to my room (old BH to new B2C room)
      And Account Menu - Select update my coverage
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay out of pocket
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | MO                             |
      And Click on secure your match button
      And Select the first plan
      And Continue with "Monthly" billing period
      And Apply free coupon if running on prod
      When Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Update my coverage - Click on continue on confirmation
      And Update my coverage - Click on go back to my room
      And Update my coverage - System message appears in old room
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Messaging and Live Therapy - Monthly |
      And Client API - The second room status of primary user is WAITING_TO_BE_MATCHED_QUEUE
      And Client API - The first room status of primary user is ACTIVE

    @smoke
    Scenario: Current provider is available - Credits available in old room - Finish services in my old room (old BH to new DTE room)
      And Account Menu - Select update my coverage
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay through an organization
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | Continue with prefilled state  |
      When Write "google" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      When Complete google validation form for primary user
        | age               | 18       |
        | employee Relation | EMPLOYEE |
      And Update my coverage - Click on finish services in my old room
      And Update my coverage - System message appears in old room
      And Navigate to payment and plan URL
      Then Plan details for the second room are
        | plan name | Google Unlimited Messaging Only Voucher |
      And Client API - The first room status of primary user is ACTIVE
      And Client API - The second room status of primary user is ACTIVE

    Scenario: Current provider is available - Credits available in old room - Go to my new room (old BH to new B2C room)
      And Account Menu - Select update my coverage
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay out of pocket
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | Continue with prefilled state  |
      And Select the first plan
      And Continue with "Monthly" billing period
      And Apply free coupon if running on prod
      When Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Update my coverage - Click on check out my new room
      And Onboarding - Dismiss modal
      And Update my coverage - Welcome message for old B2B room with sessions left appears in new room
      And Navigate to payment and plan URL
      Then Plan details for the second room are
        | plan name | Messaging and Live Therapy - Monthly |
      And Client API - The first room status of primary user is ACTIVE
      And Client API - The second room status of primary user is ACTIVE

    Scenario: Open ACKP wizard from room
      And Account Menu - Select payment and plan
      And Payment and Plan - Click on the update my coverage button
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay through an organization
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | Continue with prefilled state  |
      When Write "kga" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      When Complete kga eap validation form for primary user
        | authorization code | MOCK_KGA |
        | age                | 18       |
        | service type       | THERAPY  |
        | Email              | PRIMARY  |
        | employee Relation  | EMPLOYEE |
        | state              | MT       |
      And Click on continue on coverage verification
      And Update my coverage - Click on check out my new room
      And Onboarding - Dismiss modal
      And Update my coverage - Welcome message for old B2B room with sessions left appears in new room
      And Navigate to payment and plan URL
      Then Plan details for the second room are
        | plan name | KGA EAP 3 Sessions with Live Sessions Voucher |
      And Client API - The second room status of primary user is ACTIVE
      And Client API - The first room status of primary user is ACTIVE

    @visual
    Scenario: Current provider NOT available - Credits available in old room - Confirmation screen
      And Account Menu - Select update my coverage
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay through an organization
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | MO                             |
      And Click on secure your match button
      When Write "kga" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      When Complete kga eap validation form for primary user
        | authorization code | MOCK_KGA |
        | age                | 18       |
        | service type       | THERAPY  |
        | Email              | PRIMARY  |
        | employee Relation  | EMPLOYEE |
        | state              | MO       |
      And Click on continue on coverage verification
      And QM - Select VIDEO as first Live booking modality for B2B_EAP plan
      And Shoot baseline "Current provider NOT available - Credits available in old room - Confirmation screen"

    @visual
    Scenario: Current provider NOT available - Credits available in old room - Go back to my room
      And Account Menu - Select update my coverage
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay through an organization
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | MO                             |
      And Click on secure your match button
      When Write "kga" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      When Complete kga eap validation form for primary user
        | authorization code | MOCK_KGA |
        | age                | 18       |
        | service type       | THERAPY  |
        | Email              | PRIMARY  |
        | employee Relation  | EMPLOYEE |
        | state              | MO       |
      And Click on continue on coverage verification
      And QM - Select VIDEO as first Live booking modality for B2B_EAP plan
      And Update my coverage - Click on continue on confirmation
      And Shoot baseline "Current provider NOT available - Credits available in old room - Go back to my room"

    @visual
    Scenario: Current provider NOT available - Credits available in old room - Go back to my room - System message in old room
      And Account Menu - Select update my coverage
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay through an organization
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | MO                             |
      And Click on secure your match button
      When Write "kga" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      When Complete kga eap validation form for primary user
        | authorization code | MOCK_KGA |
        | age                | 18       |
        | service type       | THERAPY  |
        | Email              | PRIMARY  |
        | employee Relation  | EMPLOYEE |
        | state              | MO       |
      And Click on continue on coverage verification
      And QM - Select VIDEO as first Live booking modality for B2B_EAP plan
      And Update my coverage - Click on continue on confirmation
      And Update my coverage - Click on go back to my room
      And Shoot baseline "Current provider NOT available - Credits available in old room - System message in old room"

    @visual
    Scenario: Current provider is available - Credits available in old room - Finish services in my old room
      And Account Menu - Select update my coverage
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay through an organization
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | MT                             |
      When Write "google" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      When Complete google validation form for primary user
        | age               | 18       |
        | employee Relation | EMPLOYEE |
      And Shoot baseline "Current provider is available - Credits available in old room - Finish services in my old room"

    @visual
    Scenario: Current provider is available - Credits available in old room - Go to my new room - Welcome message for old BH room with sessions left
      And Account Menu - Select update my coverage
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay out of pocket
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | MT                             |
      And Select the first plan
      And Continue with "Monthly" billing period
      And Apply free coupon if running on prod
      When Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Update my coverage - Click on check out my new room
      And Onboarding - Dismiss modal
      And Shoot baseline "Current provider is available - Credits available in old room - Go to my new room - Welcome message for old BH room with sessions left"

  Rule: Open the correct service type flow

    Scenario: Open the correct service type flow - Psychiatry
      And Client API - Create PSYCHIATRY room for primary user with psychiatrist
        | state | NY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      When Client API - Subscribe to offer 61 of plan 138 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first PSYCHIATRY live VIDEO session with IGNORE state
      And Open account menu
      And Account Menu - Select update my coverage
      And Update my coverage - Select PSYCHIATRY plan to update
      And Update my coverage - Click on continue button
      Then Current url should contain "serviceType=psychiatry"
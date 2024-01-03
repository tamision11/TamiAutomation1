@owner=tami
Feature: Client web - Registration - MBA and Onboarding

  Rule: Messaging only - Live video state

    Background:
      Given Navigate to flow90
      When Select THERAPY service
      And Select to pay out of pocket
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Male                           |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | MT                             |
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2762
    Scenario: MBA - Before match - Book live first session - B2C - Therapy - Messaging only - Live state
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
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on continue button
      And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And Room is available
      And Client API - The first room status of primary user is ACTIVE

  Rule: Messaging only - non-live video state

    Background:
      Given Navigate to flow90
      When Select THERAPY service
      And Select to pay out of pocket
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Male                           |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | WY                             |
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email

    Scenario: MBA - Before match - B2C - Therapy - Messaging only - Non-Live state
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
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on continue button
      And Room is available
      And Client API - The first room status of primary user is WAITING_TO_BE_MATCHED_QUEUE

  Rule: Live video plan

    Background:
      Given Navigate to flow90
      When Select THERAPY service
      And Select to pay out of pocket
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Male                           |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | WY                             |
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2757
    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2756
    Scenario: MBA - Before match - Book live first session- B2C - Therapy - Live plan - Non-Live state
      When Select the first plan
      And Continue with "6 Months" billing period
      And Apply free coupon if running on prod
      And Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password     | STRONG |
        | nickname     | VALID  |
        | phone number |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on continue button
      And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And Room is available
      And Client API - The first room status of primary user is ACTIVE

  Rule: Live video plan - no capacity

    Background:
      Given Navigate to flow90
      When Select THERAPY service
      And Select to pay out of pocket
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Male                           |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | MO                             |
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2757
    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2756
    Scenario: MBA - Before match - Book live first session - B2C - Therapy - Live plan - Non-Live state - no capacity
      When Select the first plan
      And Continue with "6 Months" billing period
      And Apply free coupon if running on prod
      And Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password     | STRONG |
        | nickname     | VALID  |
        | phone number |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Room is available
      And Client API - The first room status of primary user is WAITING_TO_BE_MATCHED_QUEUE

  Rule: Live + messaging plan

    Background:
      Given Navigate to flow90
      When Select THERAPY service
      And Select to pay out of pocket
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Male                           |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | WY                             |
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2779
    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2756
    @smoke
    Scenario: MBA - Before match - Book live first session - B2C - Therapy - Live + messaging plan - Non-Live state
      When Select the first plan
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
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on continue button
      And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And Room is available
      And Client API - The first room status of primary user is ACTIVE

    Scenario: MBA - Before match - Book live first session - B2C - Therapy - Go back to booking
      When Select the third plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      And Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password     | STRONG |
        | nickname     | VALID  |
        | phone number |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click continue on book first session
      And Onboarding - Click continue on modality selection
      And Onboarding - Click continue on duration selection
      And In-room scheduler - Click on Next available button if present
      And Onboarding - Click i'll book later
      And Onboarding - Click go back to booking
      And Onboarding - Click continue on slot selection
      And In-room scheduler - Click on reserve session button
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And Room is available
      And Client API - The first room status of primary user is ACTIVE

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2771
    Scenario: MBA - Before match - Book live first session - B2C - Therapy - i'll book later
      When Select the third plan
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
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click continue on book first session
      And Onboarding - Click continue on modality selection
      And Onboarding - Click continue on duration selection
      And In-room scheduler - Click on Next available button if present
      And Onboarding - Click i'll book later
      And Onboarding - Click i'll book later
      And Onboarding - Click continue on your all done screen
      And Room is available
      And Client API - The first room status of primary user is WAITING_TO_BE_MATCHED_QUEUE

  Rule: add a new service

    Background:
      Given Therapist API - Login to therapist provider
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      When Open account menu
      Then Account Menu - Select add a new service

    Scenario: MBA - Before match - Book live first session - add a new service - B2C - Live + messaging plan - Non-Live state
      And Select THERAPY service
      And Select to pay out of pocket
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | WY                             |
      And Click on secure your match button
      And Select the first plan
      And Continue with "Monthly" billing period
      And Apply free coupon if running on prod
      When Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Click on continue to room button
      And Onboarding - Click continue on book first session
      And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And Room is available
      And Client API - The first room status of primary user is ACTIVE
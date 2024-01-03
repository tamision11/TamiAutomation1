Feature: Client web - In-Room LVS Scheduler

  Rule: BH Therapy - One-time sessions

    Background:
      Given Therapist API - Login to therapist3 provider
      Given Client API - Create THERAPY BH room for primary user with therapist3 provider with visa card
        | flowId            | 28        |
        | age               | 18        |
        | Member ID         | COPAY_25  |
        | keyword           | premerabh |
        | employee Relation | EMPLOYEE  |
        | state             | MT        |
      And Browse to the email verification link for primary user
      And Client API - Switch to therapist3 provider in the first room for primary user
      And Sign two factor authentication for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      Given Therapist API - Schedule 30 minutes one-time session as therapist3 provider with primary user in the first room

    Scenario: BH - Therapy - Member declines provider session schedule
      And Click on decline session button
      And In-room scheduler - Click on continue button
    # TODO: update after https://talktala.atlassian.net/browse/MEMBER-2444
      And Click on done button
      And Client API - There are 0 scheduled booking for primary user in the first room

    Scenario: BH - Therapy - Member confirms provider one-time session
      And Click on confirm session button
      And In-room scheduler - Click on I agree button
      And Click on confirm session button
      And Click on done button
      And Client API - There is 1 scheduled booking for primary user in the first room

  Rule: BH Therapy - Recurring sessions

    Background:
      Given LaunchDarkly - REPEATING_SESSIONS_FULL_2 feature flag activation status is true
      Given Therapist API - Login to therapist3 provider
      Given Client API - Create THERAPY BH room for primary user with therapist3 provider with visa card
        | flowId            | 28        |
        | age               | 18        |
        | Member ID         | COPAY_25  |
        | keyword           | premerabh |
        | employee Relation | EMPLOYEE  |
        | state             | MT        |
      And Browse to the email verification link for primary user
      And Client API - Switch to therapist3 provider in the first room for primary user
      And Sign two factor authentication for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      Given Therapist API - Schedule 45 minutes 4 recurring session as therapist3 provider with primary user in the first room

    @visual
    Scenario: BH - Therapy - Recurring sessions - Your sessions were previously declined
      And Click on confirm or decline sessions button
      And Click on decline session button
      And Shoot baseline "BH - Therapy - Recurring sessions - Sessions decline screen"
      And In-room scheduler - Click on continue button
    # TODO: update after https://talktala.atlassian.net/browse/MEMBER-2444
      And Shoot baseline "BH - Therapy - Recurring sessions - Sessions decline confirmation screen"
      And Click on done button
      And Click on confirm session button
      And Shoot baseline

    @visual
    Scenario: BH - Therapy - Recurring sessions - Your sessions were previously confirmed
      And Click on confirm or decline sessions button
      And Click on confirm sessions button
      And In-room scheduler - Click on I agree button
      And In-room scheduler - Click on confirm session button
      And Click on done button
      And Click on confirm or decline sessions button
      And Shoot baseline

    Scenario: BH - Therapy - Recurring sessions - Member confirms all sessions via chat
      And Click on confirm or decline sessions button
      And Click on confirm sessions button
      And In-room scheduler - Click on I agree button
      And In-room scheduler - Click on confirm session button
      And Click on done button
      And Client API - There are between 2 to 5 scheduled bookings for primary user in the first room

    Scenario: BH - Therapy - Recurring sessions - Member reschedule a single session via room details menu
      When Open the Room details menu
      And In-room scheduler - Edit existing booking
      And Click on reschedule session radio button
      And In-room scheduler - Click on continue button
      And In-room scheduler - Click on Next available button if present
      And In-room scheduler - Click on continue button
      And In-room scheduler - Click on I agree button
      And In-room scheduler - Click on confirm session button
      And Click on done button
      Then Room is available

    Scenario: BH - Therapy - Recurring sessions - Member declines a single session via room details menu
      And Client API - Store booking amount for primary user in the first room
      When Open the Room details menu
      And In-room scheduler - Edit existing booking
      And Click on cancel session radio button
      And In-room scheduler - Click on continue button
      And Click on done button
      And Client API - There is 1 less scheduled booking for primary user in the first room

    Scenario: BH - Therapy - Recurring sessions - Member declines all sessions via chat on sessions details screen
      And Click on confirm or decline sessions button
      And Click on decline session button
      And In-room scheduler - Click on continue button
      And Click on done button
      And Client API - There are 0 scheduled booking for primary user in the first room

    Scenario: BH - Therapy - Recurring sessions - Member declines all sessions via chat on checkout screen
      And Click on confirm or decline sessions button
      And In-room scheduler - Click on I agree button
      And Click on decline session button
      And In-room scheduler - Click on continue button
      And Click on done button
      And Client API - There are 0 scheduled booking for primary user in the first room

    Scenario: BH - Therapy - Recurring sessions - Member confirms all sessions provider via room details menu
      And Open the Room details menu
      And Account menu - Click on the first confirm the sessions button
      And In-room scheduler - Click on I agree button
      And In-room scheduler - Click on confirm sessions button
      And Click on done button
      And Client API - There are between 2 to 5 scheduled bookings for primary user in the first room

    @visual
    Scenario: BH - Therapy - Recurring sessions - Your sessions were previously canceled
      And Click on confirm or decline sessions button
      And Shoot baseline "BH - Therapy - Recurring sessions - Sessions details screen"
      And In-room scheduler - Click on I agree button
      And Shoot baseline "BH - Therapy - Recurring sessions - Checkout screen"
      And In-room scheduler - Click on confirm session button
      And Shoot baseline "BH - Therapy - Recurring sessions - Sessions confirmation screen"
      And Click on done button
      And Therapist API - Cancel booking as therapist3 provider with primary user in the first room, batch mode true
      And Click on confirm session button
      And Shoot baseline
      And Click on Close button
      Then Room is available

    Scenario: BH - Therapy - Recurring sessions - Provider decline all sessions
      And Click on confirm or decline sessions button
      And In-room scheduler - Click on I agree button
      And In-room scheduler - Click on confirm session button
      And Click on done button
      And Therapist API - Cancel booking as therapist3 provider with primary user in the first room, batch mode true
      And Client API - There are 0 scheduled booking for primary user in the first room
      And Sendgrid API - primary user has the following email subjects at his inbox
        | notifyClientTherapistCancelledRecurringBookingEmail | 1 |

    Scenario: BH - Therapy - Recurring sessions - Provider decline a single session
      And Click on confirm or decline sessions button
      And In-room scheduler - Click on I agree button
      And In-room scheduler - Click on confirm session button
      And Click on done button
      And Client API - Store booking amount for primary user in the first room
      And Therapist API - Cancel booking as therapist3 provider with primary user in the first room, batch mode false
      And Client API - There is 1 less scheduled booking for primary user in the first room

  Rule: BH Psychiatry

    Scenario: BH - Psychiatry - Member confirms provider session schedule
      And Therapist API - Login to psychiatrist provider
      Given Client API - Create PSYCHIATRY BH room for primary user with psychiatrist with visa card
        | flowId            | 28                  |
        | age               | 18                  |
        | keyword           | premerabhpsychiatry |
        | Member ID         | COPAY_0             |
        | employee Relation | EMPLOYEE            |
        | state             | WY                  |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Dismiss modal
      And Client API - Switch to psychiatrist provider in the first room for primary user
      And Client API - Get rooms info of primary user
      Given Therapist API - Schedule 60 minutes one-time session as psychiatrist provider with primary user in the first room
      And Click on confirm session button
      And In-room scheduler - Click on I agree button
      And In-room scheduler - Click on confirm session button
      And Click on done button
      And Client API - There is 1 scheduled booking for primary user in the first room

  Rule: EAP Therapy

    Background:
      Given Therapist API - Login to therapist3 provider
      Given Client API - Create EAP room to primary user with therapist provider
        | flowId            | 62                      |
        | age               | 18                      |
        | keyword           | optumwellbeingprogram16 |
        | employee Relation | EMPLOYEE                |
        | state             | MT                      |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And Client API - Switch to therapist3 provider in the first room for primary user
      Given Therapist API - Schedule 45 minutes one-time session as therapist3 provider with primary user in the first room

    Scenario: EAP - Therapy - Member confirms provider session schedule
      And Click on confirm session button
      And In-room scheduler - Click on reserve session button
      And Click on done button
      And Client API - There is 1 scheduled booking for primary user in the first room

  Rule: DTE Therapy

    Background:
      Given Therapist API - Login to therapist3 provider
      Given Client API - Create DTE room to primary user with therapist3 provider
        | flowId            | 41       |
        | age               | 18       |
        | keyword           | manh     |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
      And Browse to the email verification link for primary user
      And Client API - Switch to therapist3 provider in the first room for primary user
      And Sign two factor authentication for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And Client API - Get rooms info of primary user
      Given Therapist API - Schedule 30 minutes one-time session as therapist3 provider with primary user in the first room

    Scenario: DTE - Therapy - Member confirms provider session schedule
      And Click on confirm session button
      And In-room scheduler - Click on reserve session button
      And Click on done button
      And Client API - There is 1 scheduled booking for primary user in the first room
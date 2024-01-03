Feature: Client web - In-Room LVS Scheduler

  Rule: Therapy 30 minutes live session

    Background:
      And Therapist API - Login to therapist4 provider
      Given Client API - Create THERAPY room for primary user with therapist4 provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Client API - Subscribe to offer 62 of plan 162 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      Given Therapist API - Schedule 30 minutes one-time session as therapist4 provider with primary user in the first room

    Scenario: B2C - Therapy - Member declines provider session schedule
      And Click on decline session button
      And In-room scheduler - Click on continue button
    # TODO: update after https://talktala.atlassian.net/browse/MEMBER-2444
      And Click on done button
      And Client API - There are 0 scheduled booking for primary user in the first room

    Scenario: B2C - Therapy - Member confirms provider session schedule
      And Click on confirm session button
      And In-room scheduler - Click on reserve session button
      And Click on done button
      And Client API - There is 1 scheduled booking for primary user in the first room

  Rule: Psychiatry 60 minutes live session
  no IC pooping up on onboarding modal since we are creating a psych room via API (slug) which is not a real scenario anymore
  We are cancelling the booking done via Onboarding modal first so we can check the In-Room scheduler functionality

    Background:
      And Client API - Create PSYCHIATRY room for primary user with psychiatrist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Client API - Subscribe to offer 120 of plan 717 with visa card of primary user in the first room
      And Onboarding - Dismiss modal

    Scenario: B2C - Psychiatry - Member confirms provider session schedule
      And Therapist API - Login to psychiatrist provider
      Given Therapist API - Schedule 60 minutes one-time session as psychiatrist provider with primary user in the first room
      And Click on confirm session button
      And In-room scheduler - Click on reserve session button
      And Click on done button
      And Client API - There is 1 scheduled booking for primary user in the first room

  Rule: Scheduling Live session when no credits available

    Scenario: B2C - Therapy - Member confirms provider session schedule including credit purchase
      Given Client API - Create THERAPY room for primary user with therapist4 provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Client API - Subscribe to offer 62 of plan 160 with visa card of primary user in the first room
      And Therapist API - Login to therapist4 provider
      Given Therapist API - Schedule 30 minutes one-time session as therapist4 provider with primary user in the first room
      And Click on confirm session button
      And In-room scheduler - Click on reserve session button
          # TODO: update after https://talktala.atlassian.net/browse/MEMBER-2445
      And In-room scheduler - Click on confirm session button
      And Click on done button
      And Client API - There is 1 scheduled booking for primary user in the first room
@visual @ignore
#ignored till https://talktala.atlassian.net/browse/MEMBER-973 is figured out.
Feature: Client web - Client Dashboard
  The client dashboard should be hidden for users who have only one room, and this room is with a CT.

  Rule: Register with therapist

    Background:
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state

    Scenario: Single room with PT - Visible client dashboard
      Then Shoot client dashboard element with scenario name as baseline

    Scenario: Client Dashboard - 2 rooms with PT - Visible client dashboard
      Given Therapist API - Login to therapist provider
      When Therapist API - Add another THERAPY room to primary user with therapist provider
      Then Shoot client dashboard element with scenario name as baseline

  Rule: Register with psychiatrist

    Background:
      And Client API - Create THERAPY room for primary user with psychiatrist
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      When Client API - Subscribe to offer 61 of plan 138 with visa card of primary user in the first room
      And Refresh the page

    Scenario: Client Dashboard - Single room with psychiatrist - Visible client dashboard
      Then Shoot client dashboard element with scenario name as baseline
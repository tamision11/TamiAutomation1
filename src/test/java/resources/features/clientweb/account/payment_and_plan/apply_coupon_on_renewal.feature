@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2565
Feature: Client web - Apply coupon on renewal

  Background:
    And Therapist API - Login to therapist3 provider
    Given Client API - Create THERAPY room for primary user with therapist3 provider
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
    When Client API - Cancel Subscription of primary user in the first room
    And Client API - The first room status of primary user is NOT_RENEW

  Scenario: Apply fixed amount coupon on renewal twice
    And Apply coupon on renewal - fixed
    And Redeemed coupon text appears
    And Click on done button
    And Apply coupon on renewal - fixed
    And Redeemed coupon not valid

  Scenario: Apply coupon on renewal - Percentage amount
    And Apply coupon on renewal - percentage
    And Redeemed coupon appears

  @visual
  Scenario: Apply coupon on renewal - Next renewal validation
    And Apply coupon on renewal - percentage
    And Click on done button
    And Navigate to payment and plan URL
    And Click on Undo cancellation
    And Click on continue
    And Click on done button
    And Client API - The first room status of primary user is ACTIVE
    And Click on view details button
    Then Shoot next renewal dialog element with scenario name as baseline
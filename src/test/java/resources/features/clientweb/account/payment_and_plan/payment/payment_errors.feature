Feature: Client web - Payment
  added IL as country step in order to always get offer 62 original plans

  Background:
    And Therapist API - Login to therapist provider
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Therapist API - Set primary user Information with therapist provider
      | country | IL |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button

  Rule: Subscription Plans

    Background:
      And Navigate to payment and plan URL
      And Click on Subscribe button

    @visual
    Scenario: Payment errors - Visual regression
      When Select the second plan
      And Continue with "Monthly" billing period
      And Click on continue to checkout button
      When Payment - page - Click on complete purchase
      Then Shoot baseline "Client Web - Payment errors - cardholder name error"
      When Payment - Enter cardholder name of visa card
      When Payment - page - Click on complete purchase
      Then Shoot baseline "Client Web - Payment errors - Input fields errors"
      When Payment - Complete purchase using "insufficientFunds" card for primary user
      Then Shoot baseline "Client Web - Payment errors - Subscription Plans - Insufficient funds"

  Rule: LVS credit purchase

    @visual
    Scenario: Payment errors - LVS credit purchase - Insufficient funds
      Given Therapist API - Login to therapist provider
      When Therapist API - Send offer 69 of plan 247 to primary user from therapist provider in the first room
      And Click on the "Get a Live Session" offer button
      And Click on select plan button
      And Apply free coupon if running on prod
      And Click on continue to checkout button
      When Payment - Complete purchase using "insufficientFunds" card for primary user
      Then Shoot baseline
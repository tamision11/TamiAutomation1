Feature: Client web - Payment
  added IL as country step in order to always get offer 62 original plans

  Scenario: Checkout Page - Change payment details without stripe link
    And Therapist API - Login to therapist2 provider
    Given Client API - Create THERAPY room for primary user with therapist2 provider
      | state | MT |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Therapist API - Set primary user Information with therapist2 provider
      | country | IL |
    And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
    And Refresh the page
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    And Navigate to payment and plan URL
    And Click on change plan
    When Select the second plan
    And Continue with "Monthly" billing period
    When Click on change button for payment
    And Payment - Complete purchase using "masterCard" card for primary user
    When Click on Close button
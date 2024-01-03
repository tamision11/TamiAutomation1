Feature: Client web - Coupons
  added IL as country step in order to always get offer 62 original plans

  Background:
    When Therapist API - Login to therapist provider
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Therapist API - Set primary user Information with therapist provider
      | country | IL |
    And Therapist API - Send offer 62 of plan 161 to primary user from therapist provider in the first room

  Rule: US coupons

    Background:
      When Click on the "Choose your plan" offer button
      When Select the second plan
      And Continue with "Monthly" billing period

    @visual
    Scenario: Checkout Page - invalid coupon
    Coupon error should be available
      And Apply EXPIRED coupon with space false
      Then Shoot baseline

    Scenario: Checkout Page - $45 off coupon
      And Apply DOLLAR_45 coupon with space false
      Then Coupon - Coupon DOLLAR_45 "fix" applied
      And Coupon - Savings for coupon DOLLAR_45 "fix" are available

    Scenario Outline: Checkout Page - 25% off coupon
    covers also the trimming tests for coupons - in case there are spaces in coupon it should work and trim them
      And Apply PERCENT_25 coupon with space <space>
      Then Coupon - Coupon PERCENT_25 "percent" applied
      And Coupon - Savings for coupon PERCENT_25 "percent" are available
      Examples:
        | space |
        | false |
        | true  |

    Scenario: Checkout Page - 100% off coupon - Purchase plan
    this is an E2E test that covers both the 100% Coupon and the Purchase of a plan with a Coupon
      And Apply PERCENT_100 coupon with space false
      Then Coupon - Coupon PERCENT_100 "percent" applied
      And Coupon - Savings for coupon PERCENT_100 "percent" are available
      And Click on continue to checkout button
      When Payment - Complete purchase using "visa" card for primary user
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Messaging Only Therapy - Monthly |

  Rule: UK plans

    Background:
      And Therapist API - Set primary user Information with therapist provider
        | country | GB |
      When Click on the "Choose your plan" offer button
      When Select the first plan
      And Continue with "3 Months" billing period

    @visual
    Scenario: Checkout Page - 100% off Coupon
      And Apply PERCENT_100 coupon with space false
      Then Shoot baseline

    @visual
    Scenario: Checkout Page - invalid Coupon - USD only
      And Apply DOLLAR_45 coupon with space false
      Then Shoot baseline

    @visual
    Scenario Outline: Checkout Page - valid GBP Coupon
    covers also the trimming tests for coupons - in case there are spaces in coupon it should work and trim them
      And Apply UK coupon with space <space>
      Then Shoot baseline
      Examples:
        | space |
        | false |
        | true  |

    @visual
    Scenario: Checkout Page - valid USD coupon mapped to UK coupon
    covers also the trimming tests for coupons - in case there are spaces in coupon it should work and trim them
      And Apply DOLLAR_65 coupon with space false
      Then Shoot baseline
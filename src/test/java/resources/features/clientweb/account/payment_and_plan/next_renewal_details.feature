Feature: Client web - Next Renewal Details
  added IL as country step in order to always get offer 62 original plans

  Rule: Register via therapist slug

    Background:
      When Therapist API - Login to therapist2 provider
      Given Client API - Create THERAPY room for primary user with therapist2 provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Therapist API - Set primary user Information with therapist2 provider
        | country | IL |

    @visual
    Scenario: Next Renewal Details - Visual regression
      And Navigate to payment and plan URL
      And Click on Subscribe button
      And Select the first plan
      And Continue with "Monthly" billing period
      When Apply AUTOMATION_PERCENT_25 coupon with space false
      And Click on continue to checkout button
      And Payment - Complete purchase using "visa" card for primary user
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL
      Then Shoot Payment and plan panel element as "Client Web - Next Renewal Details - Recurring Coupon" baseline and ignore
        | therapist avatar |
        | therapist name   |
      And Click on view details button
      Then Shoot next renewal dialog element as "Client Web - Next Renewal Details - Recurring Coupon - View details screen" baseline

    @visual
    Scenario: Next Renewal Details - Cancellation wizard discount - View details screen
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL
      When Click on Cancel subscription
      And Rate provider with 2 stars
      And Cancel Subscription - Click on submit review button
      And Cancel Subscription - Click on button Apply discount
      And Cancel Subscription - Click Done button
      And Click on view details button
      Then Shoot next renewal dialog element with scenario name as baseline

    @visual
    Scenario: Next Renewal Details - Free Trial - View details screen
      Given Therapist API - Login to therapist provider
      And Therapist API - Send offer 72 of plan 161 to primary user from therapist2 provider in the first room
      When Click on the "Choose your plan" offer button
      And Select the first plan
      And Continue with "Monthly" billing period
      And Click on continue to checkout button
      And Payment - Complete purchase using "visa" card for primary user
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL
      And Click on view details button
      Then Shoot next renewal dialog element with scenario name as baseline

    @visual
    Scenario: Next Renewal Details - Credit balance - Downgrade Plan - Visual regression
      And Navigate to payment and plan URL
      And Click on Subscribe button
      And Select the third plan
      And Continue with "Monthly" billing period
      And Click on continue to checkout button
      And Payment - Complete purchase using "visa" card for primary user
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL
      When Click on change plan
      And Select the second plan
      And Continue with "Monthly" billing period
      And Click on Confirm plan change button
      And Click on Close button
      Then Shoot Payment and plan panel element as "Client Web - Next Renewal Details - Credit balance - Downgrade Plan" baseline and ignore
        | therapist avatar |
        | therapist name   |
      And Click on view details button
      Then Shoot next renewal dialog element as "Client Web - Next Renewal Details - Credit balance - Downgrade Plan - View details screen" baseline

  Rule: Register via QuickMatch

    @visual
    Scenario: Next Renewal Details - Out of Network Insurance
      Given Client API - Create Out of Network room for primary user with therapist2 provider with visa card
        | state     | WY             |
        | age       | 18             |
        | Member ID | OUT_OF_NETWORK |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      And Click on view details button
      Then Shoot next renewal dialog element with scenario name as baseline
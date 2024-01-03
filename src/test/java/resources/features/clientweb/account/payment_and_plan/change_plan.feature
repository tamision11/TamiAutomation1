Feature: Client web - Change plan
  added IL as country step in order to always get offer 62 original plans

  Background:
    And Therapist API - Login to therapist4 provider
    Given Client API - Create THERAPY room for primary user with therapist4 provider
      | state | MT |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Therapist API - Set primary user Information with therapist4 provider
      | country | IL |

  Rule: US plans

    Background:
    at first we are subscribing to message premium monthly
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL

    @visual
    Scenario: Change plan - Visual regression
      And Click on change plan
      When Select the third plan
      And Continue with "Monthly" billing period
      Then Shoot baseline "Client Web - Change plan - Change plan screen"
      When Click on Change button for plan
      Then Shoot baseline "Client Web - Change plan - Change plan screen - after clicking on Change button for plan"

    @visual
    Scenario: Change plan - Change plan screen - Successful change screen
      And Click on change plan
      When Select the third plan
      And Continue with "Monthly" billing period
      When Click on Confirm plan change button
      Then Shoot baseline

    Scenario Outline: Change plan
      And Click on change plan
      When Select the <planName> plan
      And Continue with "<billingTime>" billing period
      When Click on Confirm plan change button
      Then Click on Close button
      Examples:
        | planName | billingTime |
        #same plan different billing time
        | first    | 3 Months    |
        #different plan same billing time
        | second   | Monthly     |
        #different plan different billing time
        | third    | 3 Months    |

  Rule: UK plans

    Background:
      Given Therapist API - Login to therapist4 provider
      And Therapist API - Set primary user Information with therapist4 provider
        | country | GB |
      And Client API - Subscribe to offer 62 of plan 412 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL

    @visual
    Scenario: Change plan - UK - change plan screen - Visual regression
      And Click on change plan
      When Select the first plan
      And Continue with "3 Months" billing period
      Then Shoot baseline "Client Web - Change plan - UK - change plan screen"
      When Click on Change button for plan
      Then Shoot baseline "Client Web - Change plan - UK - change plan screen - after clicking on Change button for plan"

    Scenario: UK - change plan - same plan different billing time
      And Click on change plan
      When Select the first plan
      And Continue with "3 Months" billing period
      When Click on Confirm plan change button
      Then Click on Close button
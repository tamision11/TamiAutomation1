Feature: Client web - Purchase plan from provider chat offer
  added IL as country step in order to always get offer 62 original plans

  Background:
    And Therapist API - Login to therapist3 provider
    Given Client API - Create THERAPY room for primary user with therapist3 provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Therapist API - Set primary user Information with therapist3 provider
      | country | IL |

  Rule: US plans

    Background:
      And Therapist API - Send offer 62 of plan 160 to primary user from therapist3 provider in the first room

    @visual
    Scenario: bundle-a - Visual regression
      Then Shoot baseline "Client Web - bundle-a - offer in chat"
      When Click on the "Choose your plan" offer button
      Then Shoot baseline "Client Web - bundle-a - Choose subscription screen"

    @visual
    Scenario Outline: 2019-bundle-a - Plan options
      When Click on the "Choose your plan" offer button
      When Select the <plan> plan
      Then Shoot baseline "<baseLineName>"
      Examples:
        | baseLineName                                      | plan  |
        | Client Web - 2019-bundle-a - Premium plan options | first |

    @visual
    Scenario Outline: 2019-bundle-a - plan details
      When Click on the "Choose your plan" offer button
      When Select the <plan> plan
      And Continue with "<time>" billing period
      Then Shoot baseline "<baseLineName>"
      Examples:
        | baseLineName                                             | plan   | time    |
        | Client Web - 2019-bundle-a - Plus plan details - Monthly | second | Monthly |

    @visual
    Scenario Outline: 2019-bundle-a - plan checkout
      When Click on the "Choose your plan" offer button
      When Select the <plan> plan
      And Continue with "<time>" billing period
      And Click on continue
      Then Shoot baseline "<baseLineName>"
      Examples:
        | baseLineName                                                   | plan  | time     |
        | Client Web - 2019-bundle-a - LiveTalk plan checkout - 6 Months | third | 6 Months |

    Scenario: bundle-a - Purchase plan and verify credits - US
      When Click on the "Choose your plan" offer button
      When Select the second plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      And Click on continue to checkout button
      When Payment - Complete purchase using "visa" card for primary user
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Messaging Only Therapy - Quarterly |

  Rule: UK plans

    Background:
      And Therapist API - Set primary user Information with therapist3 provider
        | country | GB |
      And Therapist API - Send offer 62 of plan 411 to primary user from therapist3 provider in the first room

    @visual
    Scenario: UK - bundle-a - Visual regression
      When Click on the "Choose your plan" offer button
      When Click on select plan button
      Then Shoot baseline "Client Web - UK - bundle-a - Premium plan options"
      And Click on continue
      Then Shoot baseline "Client Web - UK - bundle-a - plan details"
      And Apply free coupon if running on prod
      And Click on continue to checkout button
      Then Shoot baseline "Client Web - UK - bundle-a - plan checkout"

    Scenario: bundle-a - Purchase plan and verify credits - UK
      When Click on the "Choose your plan" offer button
      When Select the first plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      And Click on continue to checkout button
      When Payment - Complete purchase using "visa" card for primary user
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                                      | Messaging Therapy Premium - Quarterly |
        | credit description                             | credit amount                         |
        | 1 of 1 Therapy live session (30 min) - expires | 1                                     |
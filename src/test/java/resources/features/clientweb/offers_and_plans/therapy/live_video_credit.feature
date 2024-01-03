Feature: Client web - Purchase plan from provider chat offer
  one time purchase (LVS credits)

  Background:
    When Therapist API - Login to therapist3 provider
    Given Client API - Create THERAPY room for primary user with therapist3 provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button

  Rule: US plans

    Background:
      And Therapist API - Send offer 69 of plan 247 to primary user from therapist3 provider in the first room

    @visual
    Scenario: Purchase LVS credit - Visual regression
      Then Shoot baseline "Client Web - Live-video-credit - offer in chat"
      When Click on the "Get a Live Session" offer button
      Then Shoot baseline "Client Web - Live-video-credit - Choose subscription screen"
      When Click on select plan button
      Then Shoot baseline "Client Web - Live-video-credit - plan details"
      And Click on continue to checkout button
      Then Shoot baseline "Client Web - Live-video-credit - plan checkout"

    @devRun @smoke
    Scenario: Purchase LVS credit - US
      When Click on the "Get a Live Session" offer button
      When Click on select plan button
      And Apply free coupon if running on prod
      And Click on continue to checkout button
      When Payment - Complete purchase using "visa" card for primary user
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                         | Messaging Therapy - Free |
        | credit description                | credit amount            |
        | 1 x Therapy live session (30 min) | 1                        |

  Rule: UK plans

    Background:
      And Therapist API - Set primary user Information with therapist3 provider
        | country | GB |
      And Therapist API - Send offer 69 of plan 247 to primary user from therapist3 provider in the first room

    @visual
    Scenario: Purchase LVS credit - Visual regression - UK
      When Click on the "Get a Live Session" offer button
      Then Shoot baseline "Client Web - Live-video-credit - Choose subscription screen - UK"
      When Click on select plan button
      Then Shoot baseline "Client Web - Live-video-credit - Plan details - UK"
      And Click on continue to checkout button
      Then Shoot baseline "Client Web - Live-video-credit - Plan checkout - UK"

    Scenario: Purchase LVS credit - UK
      When Click on the "Get a Live Session" offer button
      When Click on select plan button
      And Apply free coupon if running on prod
      And Click on continue to checkout button
      When Payment - Complete purchase using "visa" card for primary user
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                         | Messaging Therapy - Free |
        | credit description                | credit amount            |
        | 1 x Therapy live session (30 min) | 1                        |
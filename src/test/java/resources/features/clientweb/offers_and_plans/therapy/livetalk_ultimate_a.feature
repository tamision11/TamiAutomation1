Feature: Client web - Purchase plan from provider chat offer

  Background:
    When Therapist API - Login to therapist2 provider
    Given Client API - Create THERAPY room for primary user with therapist2 provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Therapist API - Send offer 68 of plan 162 to primary user from therapist2 provider in the first room

  @visual
  Scenario: 2019-live-talk-ultimate-A - Visual regression
    Then Shoot baseline "Client Web - 2019-live-talk-ultimate-A - offer in chat"
    When Click on the "Get LiveTalk Therapy Ultimate" offer button
    Then Shoot baseline "Client Web - 2019-live-talk-ultimate-A - Choose subscription screen"
    When Click on select plan button
    Then Shoot baseline "Client Web - 2019-live-talk-ultimate-A - plan details"
    And Click on continue to checkout button
    Then Shoot baseline "Client Web - 2019-live-talk-ultimate-A - plan checkout"

  Scenario: 2019-live-talk-ultimate-A - Purchase plan and verify credits
    When Click on the "Get LiveTalk Therapy Ultimate" offer button
    When Click on select plan button
    And Click on continue to checkout button
    When Payment - Complete purchase using "visa" card for primary user
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                                       | LiveTalk Therapy Ultimate - Monthly |
      | credit description                              | credit amount                       |
      | 4 of 4 Therapy live sessions (30 min) - expires | 1                                   |
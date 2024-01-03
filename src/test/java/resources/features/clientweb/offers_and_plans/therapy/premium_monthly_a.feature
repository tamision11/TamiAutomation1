Feature: Client web - Purchase plan from provider chat offer

  Background:
    When Therapist API - Login to therapist3 provider
    Given Client API - Create THERAPY room for primary user with therapist3 provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Therapist API - Send offer 67 of plan 161 to primary user from therapist3 provider in the first room

  @visual
  Scenario: 2019-messaging-premium-monthly-A - Visual regression
    Then Shoot baseline "Client Web - 2019-messaging-premium-monthly-A - offer in chat"
    When Click on the "Get Messaging Therapy Premium" offer button
    Then Shoot baseline "Client Web - 2019-messaging-premium-monthly-A - Choose subscription screen"
    When Click on select plan button
    Then Shoot baseline "Client Web - 2019-messaging-premium-monthly-A - plan details"
    And Click on continue to checkout button
    Then Shoot baseline "Client Web - 2019-messaging-premium-monthly-A - plan checkout"

  Scenario: 2019-messaging-premium-monthly-A - Purchase plan and verify credits
    When Click on the "Get Messaging Therapy Premium" offer button
    When Click on select plan button
    And Click on continue to checkout button
    When Payment - Complete purchase using "visa" card for primary user
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                                      | Messaging Therapy Premium - Monthly |
      | credit description                             | credit amount                       |
      | 1 of 1 Therapy live session (30 min) - expires | 1                                   |
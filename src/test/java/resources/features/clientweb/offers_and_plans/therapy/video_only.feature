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
    And Therapist API - Send offer 71 of plan 305 to primary user from therapist3 provider in the first room

  @visual
  Scenario: Video Only Therapy 30 minutes - Visual regression
    Then Shoot baseline "Client Web - Video Only Therapy 30 minutes - offer in chat"
    When Click on the "Get a Live Session" offer button
    Then Shoot baseline "Client Web - Video Only Therapy 30 minutes - Choose subscription screen"
    When Click on select plan button
    Then Shoot baseline "Client Web - Video Only Therapy 30 minutes - plan details"
    And Click on continue to checkout button
    Then Shoot baseline "Client Web - Video Only Therapy 30 minutes - plan checkout"

  Scenario: Video Only Therapy 30 minutes - Purchase plan and verify credits
  this scenario also checks Payment and plan navigation
    When Click on the "Get a Live Session" offer button
    When Click on select plan button
    And Click on continue to checkout button
    When Payment - Complete purchase using "visa" card for primary user
    When Open account menu
    And Account Menu - Select payment and plan
    Then Plan details for the first room are
      | plan name                         | Live Session Only |
      | credit description                | credit amount     |
      | 1 x Therapy live session (30 min) | 1                 |
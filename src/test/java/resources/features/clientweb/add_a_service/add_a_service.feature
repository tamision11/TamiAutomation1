Feature: Client web - Add a service

  Background:
    And Therapist API - Login to therapist provider
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button

  @visual
  Scenario: Message available in chat
    And Therapist API - Send eligibility with therapist provider to primary user in the first room
    Then Shoot baseline

  Scenario: Open eligibility via room message
    And Therapist API - Send eligibility with therapist provider to primary user in the first room
    And Chat - Click on the first Get started button
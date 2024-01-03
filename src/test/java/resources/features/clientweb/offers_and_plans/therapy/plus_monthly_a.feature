Feature: Client web - Purchase plan from provider chat offer

  Background:
  this test is expected to break when onboarding modal FF=0
    When Therapist API - Login to therapist provider
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Therapist API - Send offer 66 of plan 160 to primary user from therapist provider in the first room

  @visual
  Scenario: 2019-plus-monthly-A - Visual regression
    Then Shoot baseline "Client Web - 2019-plus-monthly-A - offer in chat"
    When Click on the "Get Messaging Therapy Plus" offer button
    Then Shoot baseline "Client Web - 2019-plus-monthly-A - Choose subscription screen"
    When Click on select plan button
    Then Shoot baseline "Client Web - 2019-plus-monthly-A - plan details"
    And Click on continue to checkout button
    Then Shoot baseline "Client Web - 2019-plus-monthly-A - plan checkout"

  Scenario: 2019-plus-monthly-A - Purchase plan and verify credits
    When Click on the "Get Messaging Therapy Plus" offer button
    When Click on select plan button
    And Click on continue to checkout button
    When Payment - Complete purchase using "visa" card for primary user
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Messaging Therapy Plus - Monthly |
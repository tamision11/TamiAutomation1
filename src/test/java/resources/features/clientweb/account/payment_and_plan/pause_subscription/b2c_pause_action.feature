Feature: Client web - Pause Subscription

  Background:
    Given Client API - Create THERAPY room for primary user with therapist2 provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
    And Refresh the page
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    And Navigate to payment and plan URL
    When Click on pause Therapy

  Scenario: B2C - Closing pause Therapy modal
    Then Pause Therapy - Click on cancel button
    Then Paused therapy button is available

  Scenario: B2C - Pause Room
    Then Click on pause therapy button modal
    Then Resume therapy button is available
    Then Description above the resume therapy button appears

  Scenario: B2C - Closing resume therapy modal
    Then Click on pause therapy button modal
    And Click on resume therapy
    And Click on cancel until resume button is displayed

  @visual
  Scenario: Pause Subscription Action - B2C - Resume therapy - Visual regression
    Then Click on pause therapy button modal
    And Click on resume therapy
    Then Shoot Payment and plan panel element as "Client Web - Pause Subscription Action - B2C - Resume therapy - ready to resume therapy" baseline and ignore
      | therapist will be notified text |
      | therapist avatar                |
      | therapist name                  |
    And Click on continue
    Then Shoot dialog element as "Client Web - Pause Subscription Action - B2C - Resume therapy modal" baseline

  Scenario: B2C - Resume paused room
    Then Click on pause therapy button modal
    And Click on resume therapy
    And Click on continue
    And Click on done button
    Then Paused therapy button is available
@tmsLink=talktala.atlassian.net/browse/PLATFORM-4188
Feature: Client web - Pause Subscription

  Background:
  this test is expected to break when onboarding modal FF=0
    Given Client API - Create DTE room to primary user with therapist provider
      | flowId            | 11       |
      | age               | 18       |
      | keyword           | google   |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
    And Browse to the email verification link for primary user
    And Sign two factor authentication for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    When Navigate to payment and plan URL
    When Click on pause Therapy

  Scenario: DTE - Closing pause Therapy modal
    Then Pause Therapy - Click on cancel button
    Then Paused therapy button is available

  Scenario: DTE - Pause Room
    Then Click on pause therapy button modal
    Then Resume therapy button is available
    Then Description above the resume therapy button appears

  Scenario: DTE - Closing resume therapy modal
    Then Click on pause therapy button modal
    And Click on resume therapy
    And Click on cancel until resume button is displayed

  @visual
  Scenario: Pause Subscription - DTE - Resume therapy - Visual regression
    Then Click on pause therapy button modal
    And Click on resume therapy
    Then Shoot Payment and plan panel element as "Client Web - Pause Subscription - DTE - Resume therapy - ready to resume therapy" baseline and ignore
      | therapist will be notified text |
      | therapist avatar                |
      | therapist name                  |
    And Click on continue
    Then Shoot dialog element as "Client Web - Pause Subscription - DTE - Resume therapy modal" baseline

  Scenario: DTE - Resume paused room
    Then Click on pause therapy button modal
    And Click on resume therapy
    And Click on continue
    And Click on done button
    Then Paused therapy button is available
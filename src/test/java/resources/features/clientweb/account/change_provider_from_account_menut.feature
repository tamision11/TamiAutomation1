@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2880
Feature: Client web - Change provider

  Background:
    Given Therapist API - Login to therapist provider
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | MT |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
    And Refresh the page
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state

  Scenario: Change therapist from account menu
    When Open account menu
    And Account Menu - Select change provider
    And Change provider - Select the first room
    When Click on begin button
    And Rate provider with 2 stars
    And Click on next button
    And Select from list the option "I couldn't form a strong connection with my provider"
    When Click on next button
    And Select multiple focus
      | Anger Control Problems |
      | Anxiety                |
    When Click on next button
    And Change provider - Select MT state
    When Click on next button
    And Change provider - Click on No preferences
    And Client Web - Select the first provider from the list
    When Click on confirm button
    And Click on continue with therapist button
    And Onboarding - Click on meet your provider button
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    Then Room is available
    And therapist is not the provider in the first room for primary user
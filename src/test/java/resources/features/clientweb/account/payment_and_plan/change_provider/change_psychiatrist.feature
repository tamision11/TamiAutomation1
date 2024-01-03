@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2505
Feature: Client web - Change provider

  Background:
    And Client API - Create PSYCHIATRY room for primary user with psychiatrist
      | state | MT |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    When Client API - Subscribe to offer 61 of plan 138 with visa card of primary user in the first room
    And Refresh the page
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first PSYCHIATRY live VIDEO session with IGNORE state
    When Navigate to payment and plan URL
    And Click on Change provider button

  Scenario: Change Psychiatrist - No rate provider question
    When Click on begin button
    And Select from list the option "I couldn't form a strong connection with my provider"
    When Click on next button
    And Select multiple focus
      | Anger Control Problems |
    When Click on next button
    # skipping therapist state question - state is MT
    When Click on next button
    When Click on next button
    And Change provider - Click on No preferences
    And Client Web - Select the first provider from the list
    When Click on confirm button
    And Click on continue with therapist button
    And Onboarding - Click on meet your provider button
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first PSYCHIATRY live VIDEO session with IGNORE state
    Then Room is available
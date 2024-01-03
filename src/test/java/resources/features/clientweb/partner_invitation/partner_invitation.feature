@owner=nir_tal
Feature: Client web - Couples therapy - Partner invitation

  Background:
    Given Client API - Create THERAPY room for primary user with therapist3 provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Client API - Subscribe to offer 103 of plan 406 with visa card of primary user in the first room
    And Refresh the page
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state

  Rule: Unregistered partner

    @visual
    Scenario: Couples therapy - Partner invitation - Visual regression
      When Open the Room details menu
      And Click on add your Partner button
      Then Shoot baseline "Client Web - Couples Therapy - Partner invitation - Add Your Partner button screen - Before invitation"
      And Insert PARTNER email in the email input
      And Insert PARTNER email in email confirmation
      And Click on the invite partner button
      Then Shoot baseline "Client Web - Couples Therapy - Partner invitation - Add Your Partner button screen - After invitation"

    Scenario: Couples therapy - Non registered Partner - Room details invitation
      When Open the Room details menu
      And Click on add your Partner button
      And Insert PARTNER email in the email input
      And Insert PARTNER email in email confirmation
      And Click on the invite partner button
      And Switch to a new tab
      And Mailinator API - Go to link on partner user email
        | subject          | Join your partner on Talkspace |
        | surrounding text | Accept invitation              |
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
        | state    | MT     |
      And Browse to the email verification link for partner user and
        | phone number | true |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      Then Talkspace message "testauto has joined the room." is available in chat

    @visual
    Scenario: Couples therapy - Partner invitation Page
      Then Click on add your partner to the room banner
      Then Shoot baseline

    Scenario: Couples therapy - Non registered Partner - Banner invitation
    it is mandatory to sign 2fa in order to get only 1 task banner
      Then Click on add your partner to the room banner
      And Insert PARTNER email in the email input
      And Insert PARTNER email in email confirmation
      And Click on the invite partner button
      And Switch to a new tab
      And Mailinator API - Go to link on partner user email
        | subject          | Join your partner on Talkspace |
        | surrounding text | Accept invitation              |
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
        | state    | MT     |
      And Browse to the email verification link for partner user and
        | phone number | true |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      Then Switch focus to the second tab
      And Talkspace message "testauto has joined the room." is available in chat

    @visual
    Scenario: Couples therapy - Revoke invitation screen
      Then Click on add your partner to the room banner
      And Insert PARTNER email in the email input
      And Insert PARTNER email in email confirmation
      And Click on the invite partner button
      And Click on revoke invitation button
      Then Shoot baseline

    Scenario: Couples therapy - Revoke Partner invitation
    it is mandatory to sign 2fa in order to get only 1 task banner
      Then Click on add your partner to the room banner
      And Insert PARTNER email in the email input
      And Insert PARTNER email in email confirmation
      And Click on the invite partner button
      And Switch to a new tab
      And Mailinator API - Go to link on partner user email
        | subject          | Join your partner on Talkspace |
        | surrounding text | Accept invitation              |
      Then Switch focus to the first tab
      And Click on revoke invitation button
      And Switch focus to the second tab
      And Refresh the page
      Then Current url should contain "invite-error/invalid"

  Rule: Registered partner

    Background:
      When Switch to a new tab
      And Client API - Create THERAPY room for partner user with therapist provider
        | state | WY |
      And Browse to the email verification link for partner user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      Then Room is available
      And close current tab

    Scenario: Couples therapy - Registered partner - Room details invitation
      Then Switch focus to the first tab
      Then Open the Room details menu
      Then Click on add your Partner button
      And Insert PARTNER email in the email input
      And Insert PARTNER email in email confirmation
      And Click on the invite partner button
      And Switch to a new tab
      And Mailinator API - Go to link on partner user email
        | subject          | Join your partner on Talkspace |
        | surrounding text | Accept invitation              |
      And Registration Page - Click on Login link
      And Log in with partner user and
        | remember me   | false |
        | 2fa activated | true  |
      And Switch focus to the second tab
      And Talkspace message "testauto has joined the room." is available in chat
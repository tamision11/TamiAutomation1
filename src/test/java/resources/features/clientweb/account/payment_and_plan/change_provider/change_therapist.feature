Feature: Client web - Change provider

  Background:
    Given Client API - Create THERAPY room for primary user with therapist provider
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
    When Navigate to payment and plan URL
    And Click on Change provider button

  @visual
  Scenario: Change therapist - Visual regression
    When Click on begin button
    And Rate provider with 2 stars
    Then Shoot baseline "Client Web - Change therapist - Rate your therapist question"
    Then Click on next button
    Then Shoot baseline "Client Web - Change therapist - Reasons for switch therapist page"
    And Select from list the option "I couldn't form a strong connection with my provider"
    Then Click on next button
    And Select multiple focus
      | Anger Control Problems |
      | Anxiety                |
    When Click on next button
    Then Shoot baseline "Client Web - Change therapist - Select state question - US"
    When Change provider - Click on Live in or outside US
    Then Shoot baseline "Client Web - Change therapist - Select state question - non-US"

  @visual
  Scenario Outline: Change therapist - Select reasons for switch therapist
  should validate heading "What would you like your new provider to focus on?" is available
    When Click on begin button
    And Rate provider with 2 stars
    Then Click on next button
    And Select from list the option "<reason>"
    Then Click on next button
    Then Shoot baseline
    Examples:
      | reason                                               |
      | I couldn't form a strong connection with my provider |
      | I don't feel that my provider was responsive enough  |
      | I just want to try someone new                       |
      | I want to select a provider with a different gender  |
      | I was unsatisfied with the quality of care           |

  @visual
  Scenario: Change therapist - Focus on question
    When Click on begin button
    And Rate provider with 2 stars
    Then Click on next button
    And Select from list the option "I couldn't form a strong connection with my provider"
    Then Click on next button
    Then Shoot baseline

  @visual
  Scenario: Change therapist - Visual regression
  this scenario also verify the no preference option exists for gender by clicking on it
    When Click on begin button
    And Rate provider with 2 stars
    Then Click on next button
    And Select from list the option "I couldn't form a strong connection with my provider"
    When Click on next button
    And Select multiple focus
      | Anger Control Problems |
    When Click on next button
    And Change provider - Select MT state
    When Click on next button
    And Change provider - Click on No preferences
    And Client Web - Select the first provider from the list
    Then Shoot baseline "Client Web - Change therapist - Privacy screen"

  @smoke
  Scenario: Change therapist
  Also verify Select provider gender list values
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
    And Wait 5 seconds
    Then Options of the first dropdown are
      | Male   |
      | Female |
    And Change provider - Click on No preferences
    And Client Web - Select the first provider from the list
    When Click on confirm button
    And Click on continue with therapist button
    And Onboarding - Click on meet your provider button
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    Then Room is available
    And therapist is not the provider in the first room for primary user

  @visual
  Scenario: Change therapist - therapist not found screen - visual
  Also verify Select provider gender list values
    When Click on begin button
    And Rate provider with 2 stars
    And Click on next button
    And Select from list the option "I couldn't form a strong connection with my provider"
    When Click on next button
    And Select multiple focus
      | Anger Control Problems |
      | Anxiety                |
    When Click on next button
    And Change provider - Select MO state
    When Click on next button
    And Wait 5 seconds
    And Change provider - Click on No preferences
    And Wait 5 seconds
    Then Shoot baseline "Client Web - Change therapist - therapist not found screen"


  Scenario: Change therapist - therapist not found
  Also verify Select provider gender list values
    When Click on begin button
    And Rate provider with 2 stars
    And Click on next button
    And Select from list the option "I couldn't form a strong connection with my provider"
    When Click on next button
    And Select multiple focus
      | Anger Control Problems |
      | Anxiety                |
    When Click on next button
    And Change provider - Select MO state
    When Click on next button
    And Wait 5 seconds
    And Change provider - Click on No preferences
    And Change provider - No matches screen shows


  @tms=talktala.atlassian.net/browse/AUTOMATION-3052
  Scenario: Change therapist - skip provider rating
  Also verify Select provider gender list values
    When Click on begin button
    And Skip rate provider question
    And Select from list the option "I couldn't form a strong connection with my provider"
    When Click on next button
    And Select multiple focus
      | Anger Control Problems |
      | Anxiety                |
    When Click on next button
    And Change provider - Select MT state
    When Click on next button
    And Wait 5 seconds
    Then Options of the first dropdown are
      | Male   |
      | Female |
    And Change provider - Click on No preferences
    And Client Web - Select the first provider from the list
    When Click on confirm button
    And Click on continue with therapist button
    And Onboarding - Click on meet your provider button
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    Then Room is available
    And therapist is not the provider in the first room for primary user
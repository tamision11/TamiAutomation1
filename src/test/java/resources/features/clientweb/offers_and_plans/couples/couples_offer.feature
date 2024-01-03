Feature: Client web - Purchase plan from provider chat offer
  added IL as country step in order to always get offer 62 original plans

  Background:
    And Therapist API - Login to therapist3 provider
    Given Client API - Create THERAPY room for primary user with therapist3 provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Therapist API - Set primary user Information with therapist3 provider
      | country | IL |
    And Therapist API - Send offer 103 of plan 406 to primary user from therapist3 provider in the first room

  @visual
  Scenario: Couples - Visual regression
    Then Shoot baseline "Client Web - Couples - offer in chat"
    When Click on the "Get Couples Therapy" offer button
    Then Shoot baseline "Client Web - Couples - Choose subscription screen"

  @visual
  Scenario: Couples - Plan options
    When Click on the "Get Couples Therapy" offer button
    When Select the first plan
    Then Shoot baseline "Client Web - Couples - Plan options"

  @visual
  Scenario Outline: Couples - plan details
    When Click on the "Get Couples Therapy" offer button
    When Select the first plan
    And Continue with "<time>" billing period
    Then Shoot baseline "<baseLineName>"
    Examples:
      | baseLineName                                              | time    |
      | Client Web - 2019-bundle-a - Plus plan details - 3 Months | 3 Month |

  @visual
  Scenario Outline: Couples - plan checkout
    When Click on the "Get Couples Therapy" offer button
    When Select the first plan
    And Continue with "<time>" billing period
    And Click on continue to checkout button
    Then Shoot baseline "<baseLineName>"
    Examples:
      | baseLineName                                              | time    |
      | Client Web - 2019-bundle-a - Plus plan checkout - Monthly | Monthly |

  Scenario: Couples - Purchase plan and verify credits - US
    When Click on the "Get Couples Therapy" offer button
    When Select the first plan
    And Continue with "Monthly" billing period
    And Click on continue to checkout button
    When Payment - Complete purchase using "visa" card for primary user
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                                       | Couples Therapy with Live Session - Monthly |
      | credit description                              | credit amount                               |
      | 4 of 4 Therapy live sessions (30 min) - expires | 1                                           |
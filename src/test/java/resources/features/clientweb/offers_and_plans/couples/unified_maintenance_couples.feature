Feature: Client web - Purchase plan from provider chat offer

  Background:
    And Therapist API - Login to therapist4 provider
    Given Client API - Create THERAPY room for primary user with therapist4 provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button

  @visual
  Scenario Outline: Unified Maintenance Couples Plan - Plan details - Monday to sunday
    When Therapist API - Send offer <offerID> of plan 20 to primary user from therapist4 provider in the first room
    And Click on the "Get Talkspace Couples Therapy" offer button
    And Select the first plan
    Then Shoot baseline "<baseLineName>"
    Examples:
      | offerID | baseLineName                                                                   |
      | 97      | Client Web - Unified Maintenance Couples Plan - Plan details - Monday offer 97 |

  @visual
  Scenario Outline: Unified Maintenance Couples Plan - Plan checkout - Monday to sunday
    When Therapist API - Send offer <offerID> of plan 20 to primary user from therapist4 provider in the first room
    And Click on the "Get Talkspace Couples Therapy" offer button
    And Select the first plan
    And Continue with "<time>" billing period
    And Click on continue to checkout button
    Then Shoot baseline "<baseLineName>"
    Examples:
      | offerID | baseLineName                                                                             | time    |
      | 98      | Client Web - Unified Maintenance Couples Plan - Plan checkout - Tuesday offer 98 Monthly | Monthly |

  Scenario Outline: Unified Maintenance Couples Plan - Purchase plan and verify credit - Monday to sunday
    When Therapist API - Send offer <offerID> of plan 20 to primary user from therapist4 provider in the first room
    And Click on the "Get Talkspace Couples Therapy" offer button
    And Select the first plan
    And Continue with "<time>" billing period
    And Click on continue to checkout button
    And Payment - Complete purchase using "visa" card for primary user
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Couple <day> Maintenance Therapy Maintenance Plan |
    Examples:
      | offerID | time    | day       |
      | 99      | Monthly | Wednesday |
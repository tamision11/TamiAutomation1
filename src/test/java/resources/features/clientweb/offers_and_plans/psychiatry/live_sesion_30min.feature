Feature: Client web - Purchase plan from provider chat offer
  added IL as country step in order to always get offer 60 original plans
  currently we have a bug here: https://talktala.atlassian.net/browse/MEMBER-1007

  Background:
    When Therapist API - Login to psychiatrist provider
    And Client API - Create PSYCHIATRY room for primary user with psychiatrist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Therapist API - Set primary user Information with psychiatrist provider
      | country | IL |
    And Therapist API - Send offer 60 of plan 137 to primary user from psychiatrist provider in the first room

  @visual
  Scenario: Psychiatry live sessions 30 minutes - Visual regression
    Then Shoot baseline "Client Web - Psychiatry live sessions 30 minutes - offer in chat"
    When Click on the "Purchase Video Session" offer button
    Then Shoot baseline "Client Web - Psychiatry live sessions 30 minutes - Choose subscription screen"

  @visual
  Scenario Outline: Psychiatry live sessions 30 minutes - plan details
    When Click on the "Purchase Video Session" offer button
    When Select the <planName> plan
    Then Shoot baseline "<baseLineName>"
    Examples:
      | planName | baseLineName                                                                                                                              |
      | fourth   | Client Web - Psychiatry live sessions 30 minutes - Plan details - Psychiatry live sessions 30 minutes - Psychiatry - 9 follow up sessions |

  @visual
  Scenario Outline: Psychiatry live sessions 30 minutes - plan checkout
    When Click on the "Purchase Video Session" offer button
    When Select the <planName> plan
    Then Shoot baseline "<baseLineName>"
    Examples:
      | planName | baseLineName                                                                            |
      | second   | Client Web - Psychiatry live sessions 30 minutes - Plan checkout - 3 follow up sessions |

  Scenario Outline: Psychiatry live sessions 30 minutes - Purchase plan and verify credits
    When Click on the "Purchase Video Session" offer button
    When Select the <planName> plan
    And Click on continue to checkout button
    When Payment - Complete purchase using "visa" card for primary user
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                            | Psychiatry    |
      | credit description                   | credit amount |
      | 1 x Psychiatry live session (30 min) | <rows>        |
    Examples:
      | planName | rows |
      | third    | 6    |

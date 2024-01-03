Feature: Client web - Purchase plan from provider chat offer
  all follow ups are 30 minutes
  added IL as country step in order to always get offer 61 original plans

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
    And Therapist API - Send offer 61 of plan 138 to primary user from psychiatrist provider in the first room

  @visual
  Scenario: Psychiatry live sessions 60 minutes - Visual regression
    Then Shoot baseline "Client Web - Psychiatry live sessions 60 minutes - offer in chat"
    When Click on the "Purchase Video Session" offer button
    Then Shoot baseline "Client Web - Psychiatry live sessions 60 minutes - Choose subscription screen"

  @visual
  Scenario Outline: Psychiatry live sessions 60 minutes - plan details
    When Click on the "Purchase Video Session" offer button
    When Select the <planName> plan
    Then Shoot baseline "<baseLineName>"
    Examples:
      | planName | baseLineName                                                                         |
      | first    | Client Web - Psychiatry live sessions 60 minutes - Plan details - Initial Evaluation |

  @visual
  Scenario Outline: Psychiatry live sessions 60 minutes - plan checkout
    When Click on the "Purchase Video Session" offer button
    When Select the <planName> plan
    Then Shoot baseline "<baseLineName>"
    Examples:
      | planName | baseLineName                                                                                                |
      | first    | Client Web - Psychiatry live sessions 60 minutes - Plan details - Initial Evaluation + 1 follow up sessions |

  Scenario Outline: Psychiatry live sessions 60 minutes - Purchase plan and verify credits
    When Click on the "Purchase Video Session" offer button
    When Select the <planName> plan
    And Click on continue to checkout button
    When Payment - Complete purchase using "visa" card for primary user
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first PSYCHIATRY live VIDEO session with IGNORE state
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                            | Psychiatry    |
      | credit description                   | credit amount |
      | 1 x Psychiatry live session (60 min) | <60>          |
      | 1 x Psychiatry live session (30 min) | <30>          |
    Examples:
      | planName | 60 | 30 |
      | first    | 1  | 1  |
      | second   | 1  | 0  |
      | third    | 1  | 3  |

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
  Scenario Outline: Unified Maintenance Plan - offer in chat - Monday to sunday
    When Therapist API - Send offer <offerID> of plan 8 to primary user from therapist4 provider in the first room
    Then Shoot baseline "<baseLineName>"
    Examples:
      | offerID | baseLineName                                                            |
      | 90      | Client Web - Unified Maintenance Plan - offer in chat - Monday offer 90 |

  @visual
  Scenario Outline: Unified Maintenance Plan - Choose subscription screen - Monday to sunday
    When Therapist API - Send offer <offerID> of plan 8 to primary user from therapist4 provider in the first room
    And Click on the "Get Unlimited Messaging Therapy" offer button
    Then Shoot baseline "<baseLineName>"
    Examples:
      | offerID | baseLineName                                                                          |
      | 91      | Client Web - Unified Maintenance Plan - Choose subscription screen - Tuesday offer 91 |

  @visual
  Scenario Outline: Unified Maintenance Plan - Plan details - Monday to sunday
    When Therapist API - Send offer <offerID> of plan 8 to primary user from therapist4 provider in the first room
    And Click on the "Get Unlimited Messaging Therapy" offer button
    And Select the first plan
    Then Shoot baseline "<baseLineName>"
    Examples:
      | offerID | baseLineName                                                              |
      | 92      | Client Web - Unified Maintenance Plan - Plan details - Wednesday offer 92 |

  @visual
  Scenario Outline: Unified Maintenance Plan - Plan checkout - Monday to sunday
    When Therapist API - Send offer <offerID> of plan 8 to primary user from therapist4 provider in the first room
    And Click on the "Get Unlimited Messaging Therapy" offer button
    And Select the first plan
    And Continue with "<time>" billing period
    And Click on continue to checkout button
    Then Shoot baseline "<baseLineName>"
    Examples:
      | offerID | baseLineName                                                                       | time     |
      | 95      | Client Web - Unified Maintenance Plan - Plan checkout - Saturday offer 95 3 Months | 3 Months |

  @visual
  Scenario Outline: Unified Maintenance Plan - Plan name in Payment and plan - Monday to sunday
    When Therapist API - Send offer <offerID> of plan 8 to primary user from therapist4 provider in the first room
    And Click on the "Get Unlimited Messaging Therapy" offer button
    And Select the first plan
    And Continue with "<time>" billing period
    And Click on continue to checkout button
    And Payment - Complete purchase using "visa" card for primary user
    And Navigate to payment and plan URL
    Then Shoot baseline "<baseLineName>"
    Examples:
      | offerID | baseLineName                                                                                    | time    |
      | 90      | Client Web - Unified Maintenance Plan - Plan name in Payment and plan - Monday offer 90 Monthly | Monthly |

  Scenario Outline: Unified Maintenance Plan - Purchase plan and verify credit - Monday to sunday
    When Therapist API - Send offer <offerID> of plan 8 to primary user from therapist4 provider in the first room
    And Click on the "Get Unlimited Messaging Therapy" offer button
    And Select the first plan
    And Continue with "<time>" billing period
    And Click on continue to checkout button
    And Payment - Complete purchase using "visa" card for primary user
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Messaging Therapy <day> Maintenance Plan |
    Examples:
      | offerID | time    | day    |
      | 90      | Monthly | Monday |

  Rule: UK plans

    Background:
      And Therapist API - Set primary user Information with therapist4 provider
        | country | GB |
      When Therapist API - Send offer 90 of plan 8 to primary user from therapist4 provider in the first room

    Scenario: Unified Maintenance Plan - Purchase plan and verify credits - UK
      And Click on the "Get Unlimited Messaging Therapy" offer button
      When Click on select plan button
      And Apply free coupon if running on prod
      And Click on continue to checkout button
      When Payment - Complete purchase using "visa" card for primary user
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Messaging Therapy Monday Maintenance Plan |
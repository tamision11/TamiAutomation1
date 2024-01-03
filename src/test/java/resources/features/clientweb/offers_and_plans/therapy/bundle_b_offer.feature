Feature: Client web - Purchase plan from provider chat offer

  Background:
    When Therapist API - Login to therapist4 provider
    Given Client API - Create THERAPY room for primary user with therapist4 provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Therapist API - Send offer 70 of plan 273 to primary user from therapist4 provider in the first room

  @visual
  Scenario: 2019-bundle-B - offer in chat
    Then Shoot baseline

  @visual
  Scenario Outline: bundle-B - Plan options
    When Click on the "Choose your plan" offer button
    When Select the <plan> plan
    Then Shoot baseline "<baseLineName>"
    Examples:
      | baseLineName                                 | plan  |
      | Client Web - bundle-B - Premium plan options | first |

  @visual
  Scenario Outline: bundle-B - plan details
    When Click on the "Choose your plan" offer button
    When Select the <plan> plan
    And Continue with "<time>" billing period
    Then Shoot baseline "<baseLineName>"
    Examples:
      | baseLineName                                        | plan   | time    |
      | Client Web - bundle-B - Plus plan details - Monthly | second | Monthly |

  @visual
  Scenario Outline: bundle-B - plan checkout
    When Click on the "Choose your plan" offer button
    When Select the <plan> plan
    And Continue with "<time>" billing period
    And Click on continue
    Then Shoot baseline "<baseLineName>"
    Examples:
      | baseLineName                                             | plan  | time    |
      | Client Web - bundle-B - LiveTalk plan checkout - Monthly | third | Monthly |

  Scenario Outline: Purchase plan and verify credits - message plus plan
    When Click on the "Choose your plan" offer button
    When Select the second plan
    And Continue with "<time>" billing period
    And Click on continue to checkout button
    When Payment - Complete purchase using "visa" card for primary user
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Messaging Therapy Plus - <billingPeriod> |
    Examples:
      | time     | billingPeriod |
      | Monthly  | Monthly       |
      | 3 Months | Quarterly     |
      | 6 Months | Biannual      |

  Scenario Outline: Purchase plan and verify credits - message premium plan
    When Click on the "Choose your plan" offer button
    When Select the first plan
    And Continue with "<time>" billing period
    And Click on continue to checkout button
    When Payment - Complete purchase using "visa" card for primary user
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                                      | Messaging Therapy Premium - <billingPeriod> |
      | credit description                             | credit amount                               |
      | 1 of 1 Therapy live session (30 min) - expires | 1                                           |
    Examples:
      | time     | billingPeriod |
      | Monthly  | Monthly       |
      | 3 Months | Quarterly     |
      | 6 Months | Biannual      |

  Scenario Outline: Purchase plan and verify credits - live talk plan
    When Click on the "Choose your plan" offer button
    When Select the third plan
    And Continue with "<time>" billing period
    And Click on continue to checkout button
    When Payment - Complete purchase using "visa" card for primary user
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                                       | LiveTalk Therapy Ultimate - <billingPeriod> |
      | credit description                              | credit amount                               |
      | 4 of 4 Therapy live sessions (30 min) - expires | 1                                           |
    Examples:
      | time     | billingPeriod |
      | Monthly  | Monthly       |
      | 3 Months | Quarterly     |
      | 6 Months | Biannual      |
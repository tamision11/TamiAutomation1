Feature: Client web - Purchase plan from provider chat offer

  Background:
    When Therapist API - Login to therapist3 provider
    Given Client API - Create THERAPY room for primary user with therapist3 provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Therapist API - Send offer 72 of plan 161 to primary user from therapist3 provider in the first room

  @visual
  Scenario: 2019-bundle-A-Trial - Visual regression
    Then Shoot baseline "Client Web - 2019-bundle-A-Trial - offer in chat"
    When Click on the "Choose your plan" offer button
    Then Shoot baseline "Client Web - 2019-bundle-A-Trial - Choose subscription screen"

  @visual
  Scenario Outline: 2019-bundle-A-Trial - Plan options
    When Click on the "Choose your plan" offer button
    When Select the <plan> plan
    Then Shoot baseline "<baseLineName>"
    Examples:
      | baseLineName                                         | plan   |
      | Client Web - 2019-bundle-A-Trial - Plus plan options | second |

  @visual
  Scenario Outline: 2019-bundle-A-Trial - plan details
    When Click on the "Choose your plan" offer button
    When Select the <plan> plan
    And Continue with "<time>" billing period
    Then Shoot baseline "<baseLineName>"
    Examples:
      | baseLineName                                                       | plan  | time     |
      | Client Web - 2019-bundle-A-Trial - Premium plan details - 6 Months | first | 6 Months |

  @visual
  Scenario Outline: 2019-bundle-A-Trial - plan checkout
    When Click on the "Choose your plan" offer button
    When Select the <plan> plan
    And Continue with "<time>" billing period
    And Click on continue
    Then Shoot baseline "<baseLineName>"
    Examples:
      | baseLineName                                                        | plan  | time    |
      | Client Web - 2019-bundle-A-Trial - LiveTalk plan checkout - 3 Month | third | 3 Month |

  Scenario Outline: 2019-bundle-A-Trial - Purchase plan and verify credits message plus plan
    When Click on the "Choose your plan" offer button
    When Select the second plan
    And Continue with "<time>" billing period
    And Click on continue to checkout button
    When Payment - Complete purchase using "visa" card for primary user
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Messaging Therapy Plus - Monthly |
    Examples:
      | time    |
      | Monthly |

  Scenario Outline: 2019-bundle-A-Trial - Purchase message premium plan and verify credits
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

  Scenario Outline: 2019-bundle-A-Trial - Purchase live talk plan and verify credits
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

  Rule: UK plans

    Background:
      And Therapist API - Set primary user Information with therapist3 provider
        | country | GB |

    Scenario: 2019-bundle-A-Trial - Purchase plan and verify credits - UK
    Amir says offer 72 (free trial) has all plans intentionally - other uk offers has only 1 plan
      When Click on the "Choose your plan" offer button
      When Select the first plan
      And Click on continue
      And Apply free coupon if running on prod
      And Click on continue to checkout button
      When Payment - Complete purchase using "visa" card for primary user
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                                      | Messaging Therapy Premium - Monthly |
        | credit description                             | credit amount                       |
        | 1 of 1 Therapy live session (30 min) - expires | 1                                   |
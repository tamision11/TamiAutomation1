@tmslink=talktala.atlassian.net/browse/CVR-931
Feature: Client web - Purchase plan from Payment and plan
  purchase via Payment and plan > Subscribe button
  added IL as country step in order to always get offer 62 original plans

  Background:
    And Therapist API - Login to therapist provider
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | MT |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Therapist API - Set primary user Information with therapist provider
      | country | IL |
    And Navigate to payment and plan URL

  Rule: US plans

    Background:
      And Click on Subscribe button

    @visual
    Scenario: Payment and plan - Plan options
      Then Shoot baseline

    @smoke @sanity
    Scenario: Payment and plan - Purchase Messaging Only Therapy monthly plan and verify credits
      When Select the second plan
      And Continue with "Monthly" billing period
      And Apply free coupon if running on prod
      And Click on continue to checkout button
      When Complete purchase using visa card with stripe link false
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                               | Messaging Only Therapy - Monthly |
        | credit description                      | credit amount                    |
        | 1 x Complimentary live session (10 min) | 1                                |

    Scenario Outline: Payment and plan - Purchase Messaging Only Therapy plan and verify credits
      When Select the second plan
      And Continue with "<time>" billing period
      And Apply free coupon if running on prod
      And Click on continue to checkout button
      When Payment - Complete purchase using "visa" card for primary user
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                               | Messaging Only Therapy - <billingPeriod> |
        | credit description                      | credit amount                            |
        | 1 x Complimentary live session (10 min) | 1                                        |
      Examples:
        | time     | billingPeriod |
        | 3 Months | Quarterly     |
        | 6 Months | Biannual      |

    Scenario Outline: Payment and plan - Purchase Messaging and Live Therapy and verify credits
      When Select the first plan
      And Continue with "<time>" billing period
      And Apply free coupon if running on prod
      And Click on continue to checkout button
      When Payment - Complete purchase using "visa" card for primary user
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                                       | Messaging and Live Therapy - <billingPeriod> |
        | credit description                              | credit amount                                |
        | 4 of 4 Therapy live sessions (30 min) - expires | 1                                            |
      Examples:
        | time     | billingPeriod |
        | Monthly  | Monthly       |
        | 3 Months | Quarterly     |
        | 6 Months | Biannual      |

    Scenario Outline: Payment and plan - Purchase Messaging, Live and workshops plan and verify credits
      When Select the third plan
      And Continue with "<time>" billing period
      And Apply free coupon if running on prod
      And Click on continue to checkout button
      When Payment - Complete purchase using "visa" card for primary user
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                                       | Messaging, Live and workshops - <billingPeriod> |
        | credit description                              | credit amount                                   |
        | 4 of 4 Therapy live sessions (30 min) - expires | 1                                               |
      Examples:
        | time     | billingPeriod |
        | Monthly  | Monthly       |
        | 3 Months | Quarterly     |
        | 6 Months | Biannual      |

  Rule: UK plans

    Background:
      When Therapist API - Login to therapist provider
      And Therapist API - Set primary user Information with therapist provider
        | country | GB |
      And Click on Subscribe button

    Scenario: Purchase Messaging Therapy - UK
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
Feature: Client web - Cancel Subscription
  we are using different backgrounds because we are unable to purchase via API on sanity tests

  Rule: B2C Plans

    Background:
      And Therapist API - Login to therapist3 provider
      Given Client API - Create THERAPY room for primary user with therapist3 provider
        | state | MT |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL
      And Click on Cancel subscription

    @visual
    Scenario: B2C - Visual regression
      Then Shoot baseline "Client Web - Cancel Subscription - Rate provider question"
      And Rate provider with 2 stars
      When Cancel Subscription - Click on submit review button
      Then Shoot baseline "Client Web - Cancel Subscription - Discount question"
      And Cancel Subscription - Click on button Apply discount
      Then Shoot baseline "Client Web - Cancel Subscription - Discount applied"

    @visual
    Scenario: B2C - Visual regression
      And Rate provider with 2 stars
      When Cancel Subscription - Click on submit review button
      When Cancel Subscription - Click on no thanks button
      Then Shoot baseline "Client Web - Cancel Subscription - Pause question"
      When Cancel Subscription - Click on pause subscription button
      Then Shoot baseline "Client Web - Cancel Subscription - Pause question - thinking about taking a break"

    @visual
    Scenario: B2C - Visual regression
      And Rate provider with 2 stars
      When Cancel Subscription - Click on submit review button
      When Cancel Subscription - Click on no thanks button
      When Cancel Subscription - Click on button don't pause Subscription
      Then Shoot baseline "Client Web - Cancel Subscription - New provider question"
      And Cancel Subscription - Click on not interested in new provider button
      Then Shoot baseline "Client Web - Cancel Subscription - Get maintenance question"
      When Cancel Subscription - Click on Switch to maintenance plan button
      Then Shoot baseline "Client Web - Cancel Subscription - Your subscription has changed page"

    @visual
    Scenario: B2C - Visual regression
      And Rate provider with 2 stars
      When Cancel Subscription - Click on submit review button
      And Cancel Subscription - Click on no thanks button
      When Cancel Subscription - Click on button don't pause Subscription
      And Cancel Subscription - Click on not interested in new provider button
      And Cancel Subscription - Click on not interested in plan button
      Then Shoot baseline "Client Web - Cancel Subscription - Tell us why question"
      When Select from list the option "My provider was not responsive to my messages"
      Then Cancel Subscription - Click on next button to select reason
      Then Shoot baseline "Client Web - Cancel Subscription - Sorry to hear page"
      And Cancel Subscription - Click on cancel renewal button
      Then Shoot baseline "Client Web - Cancel Subscription - Subscription canceled page"
      And Cancel Subscription - Click on Close button
      When Click on Undo cancellation
      Then Shoot baseline "Client Web - Cancel Subscription - Undo cancellation UI"
      And Click on continue
      Then Shoot dialog element as "Client Web - Cancel Subscription - Undo cancellation UI - Click on continue button" baseline

    Scenario: B2C - Undo cancellation
      And Rate provider with 2 stars
      And Cancel Subscription - Click on submit review button
      And Cancel Subscription - Click on no thanks button
      And Cancel Subscription - Click on button don't pause Subscription
      And Cancel Subscription - Click on not interested in new provider button
      And Cancel Subscription - Click on not interested in plan button
      And Select from list the option "My provider was not responsive to my messages"
      And Cancel Subscription - Click on next button to select reason
      And Cancel Subscription - Click on cancel renewal button
      When Cancel Subscription - Click on Close button
      Then Click on Undo cancellation
      And Click on continue
      And Click on done button
      And Click on Cancel subscription

    Scenario: B2C - Apply discount
      And Rate provider with 2 stars
      And Wait 5 seconds
      When Cancel Subscription - Click on submit review button
      And Cancel Subscription - Click on button Apply discount
      When Cancel Subscription - Click Done button

    Scenario: B2C - Freeze subscription
      And Rate provider with 2 stars
      And Wait 5 seconds
      When Cancel Subscription - Click on submit review button
      When Cancel Subscription - Click on no thanks button
      When Cancel Subscription - Click on pause subscription button
      When Cancel Subscription - Click on pause Therapy button
      When Cancel Subscription - Click Done button
      And Resume therapy button is available
      And Sendgrid API - primary user has the following email subjects at his inbox
        | subscriptionOnHoldSentToCustomer | 1 |

    Scenario: B2C - Change provider
      And Rate provider with 2 stars
      When Cancel Subscription - Click on submit review button
      When Cancel Subscription - Click on no thanks button
      When Cancel Subscription - Click on button don't pause Subscription
      When Cancel Subscription - Click on new provider button
      When Click on begin button
      And Select from list the option "I couldn't form a strong connection with my provider"
      When Click on next button
      And Select multiple focus
        | Anger Control Problems |
      When Click on next button
      When Click on next button
      And Change provider - Click on No preferences
      And Client Web - Select the first provider from the list
      When Click on confirm button
      And Click on continue with therapist button
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                                      | Messaging Therapy Premium - Monthly |
        | credit description                             | credit amount                       |
        | 1 of 1 Therapy live session (30 min) - expires | 1                                   |

    Scenario: B2C - Switch to maintenance
    Maintenance Monday is the default plan for the cancellation wizard
      And Rate provider with 2 stars
      When Cancel Subscription - Click on submit review button
      When Cancel Subscription - Click on no thanks button
      When Cancel Subscription - Click on button don't pause Subscription
      And Cancel Subscription - Click on not interested in new provider button
      When Cancel Subscription - Click on Switch to maintenance plan button
      When Cancel Subscription - Click Done button
      Then Plan details for the first room are
        | plan name | Messaging Therapy Maintenance Plan |
      And No credits exist in the first room

  Rule: B2C Plans that are included in sanity run

    Background:
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Navigate to payment and plan URL
      And Click on Subscribe button
      And Select the first plan
      And Continue with "Monthly" billing period
      And Apply free coupon if running on prod
      And Click on continue to checkout button
      And Complete purchase using visa card with stripe link false
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL
      When Click on Cancel subscription

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2627
    @smoke @sanity
    Scenario: B2C - Cancel subscription
      And Rate provider with 2 stars
      And Wait 5 seconds
      When Cancel Subscription - Click on submit review button
      And Cancel Subscription - Click on no thanks button
      When Cancel Subscription - Click on button don't pause Subscription
      And Cancel Subscription - Click on not interested in new provider button
      And Cancel Subscription - Click on not interested in plan button
      When Select from list the option "My provider was not responsive to my messages"
      Then Cancel Subscription - Click on next button to select reason
      And Cancel Subscription - Click on cancel renewal button
      When Cancel Subscription - Click on Close button
      And Undo Cancel button is available
      And Sendgrid API - primary user has the following email subjects at his inbox
        | selfServiceRequestToDischargeAndCancelCustomer_var1 | 1 |

  Rule: B2C Plans - UK

    Background:
      And Therapist API - Login to therapist4 provider
      Given Client API - Create THERAPY room for primary user with therapist4 provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Client API - Subscribe to offer 62 of plan 412 with visa card of primary user in the first room
      And Therapist API - Set primary user Information with therapist4 provider
        | country | GB |
        | state   |    |
      And Refresh the page
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL
      And Click on Cancel subscription

    @visual
    Scenario: B2C - UK - Visual regression
      And Rate provider with 2 stars
      When Cancel Subscription - Click on submit review button
      Then Shoot baseline "Client Web - Cancel Subscription - UK - Discount question"
      And Cancel Subscription - Click on button Apply discount
      Then Shoot baseline "Client Web - Cancel Subscription - UK - Discount applied"

    @visual
    Scenario: B2C - UK - Visual regression
      And Rate provider with 2 stars
      When Cancel Subscription - Click on submit review button
      When Cancel Subscription - Click on no thanks button
      Then Shoot baseline "Client Web - Cancel Subscription - UK - Pause question"
      When Cancel Subscription - Click on button don't pause Subscription
      And Cancel Subscription - Click on not interested in new provider button
      Then Shoot baseline "Client Web - Cancel Subscription - UK - Get maintenance question"

    Scenario: B2C - UK - Undo cancellation
    first we Cancel subscription then undo the cancellation
      And Rate provider with 2 stars
      And Wait 5 seconds
      And Cancel Subscription - Click on submit review button
      And Cancel Subscription - Click on no thanks button
      And Cancel Subscription - Click on button don't pause Subscription
      And Cancel Subscription - Click on not interested in new provider button
      And Cancel Subscription - Click on not interested in plan button
      And Select from list the option "My provider was not responsive to my messages"
      And Cancel Subscription - Click on next button to select reason
      And Cancel Subscription - Click on cancel renewal button
      When Cancel Subscription - Click on Close button
      Then Click on Undo cancellation
      And Click on continue
      And Click on done button
      And Click on Cancel subscription

    Scenario: B2C - UK - Apply discount
      And Rate provider with 2 stars
      When Cancel Subscription - Click on submit review button
      And Cancel Subscription - Click on button Apply discount
      When Cancel Subscription - Click Done button

    Scenario: B2C - UK - Freeze subscription
      And Rate provider with 2 stars
      When Cancel Subscription - Click on submit review button
      When Cancel Subscription - Click on no thanks button
      When Cancel Subscription - Click on pause subscription button
      When Cancel Subscription - Click on pause Therapy button
      When Cancel Subscription - Click Done button
      And Resume therapy button is available

    Scenario: B2C - UK - Change provider
      And Rate provider with 2 stars
      When Cancel Subscription - Click on submit review button
      When Cancel Subscription - Click on no thanks button
      When Cancel Subscription - Click on button don't pause Subscription
      When Cancel Subscription - Click on new provider button
      When Click on begin button
      And Select from list the option "I couldn't form a strong connection with my provider"
      When Click on next button
      And Select multiple focus
        | Anger Control Problems |
      When Click on next button
      When Click on next button
      And Change provider - Click on No preferences
      And Client Web - Select the first provider from the list
      When Click on confirm button
      And Click on continue with therapist button
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                                      | Messaging Therapy Premium - Monthly |
        | credit description                             | credit amount                       |
        | 1 of 1 Therapy live session (30 min) - expires | 1                                   |

    Scenario: B2C - UK - Switch to maintenance
    Maintenance Monday is the default plan for the cancellation wizard
      And Rate provider with 2 stars
      When Cancel Subscription - Click on submit review button
      When Cancel Subscription - Click on no thanks button
      When Cancel Subscription - Click on button don't pause Subscription
      And Cancel Subscription - Click on not interested in new provider button
      When Cancel Subscription - Click on Switch to maintenance plan button
      When Cancel Subscription - Click Done button
      Then Plan details for the first room are
        | plan name | Messaging Therapy Monday Maintenance Plan |
      And No credits exist in the first room

  Rule: B2C Subscription with scheduled Live session outside of billing cycle

    Background:
      And Therapist API - Login to therapist3 provider
      Given Client API - Create THERAPY room for primary user with therapist3 provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Therapist API - Set primary user Information with therapist3 provider
        | country | IL |
      And Refresh the page
      And Onboarding - Click on continue button
      And In-room scheduler - Reserve a session on a future date
      And Onboarding - Click on close button
      And Navigate to payment and plan URL
      And Click on Cancel subscription

    Scenario: B2C - Live Session outside of billing cycle - Continue with cancellation - Cancel subscription
      And Cancel Subscription - Click on continue with cancellation button
      And Rate provider with 2 stars
      When Cancel Subscription - Click on submit review button
      And Cancel Subscription - Click on no thanks button
      When Cancel Subscription - Click on button don't pause Subscription
      And Cancel Subscription - Click on not interested in new provider button
      And Cancel Subscription - Click on not interested in plan button
      When Select from list the option "My provider was not responsive to my messages"
      Then Cancel Subscription - Click on next button to select reason
      And Cancel Subscription - Click on cancel renewal button
      When Cancel Subscription - Click on Close button
      And Undo Cancel button is available
      And Sendgrid API - primary user has the following email subjects at his inbox
        | selfServiceRequestToDischargeAndCancelCustomer_var1 | 1 |

    Scenario: B2C - Live Session outside of billing cycle - Keep my sessions - Go back to room
      And Cancel Subscription - Click on keep my sessions button
      And Cancel Subscription - Click on go back to room button
      And Client API - The first room status of primary user is ACTIVE

    @visual
    Scenario: B2C - Live Session outside of billing cycle
      Then Shoot baseline "Client Web - Cancel Subscription - B2C - Live Session outside of billing cycle - Keep my sessions"

    @visual
    Scenario: B2C - Live Session outside of billing cycle - Go back to room
      And Cancel Subscription - Click on keep my sessions button
      Then Shoot baseline
@tmsLink=talktala.testrail.net/index.php?/cases/view/12714
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2651
Feature: Client web - Refund Wizard
  added IL as country step in order to always get offer 62 original plans
  with copay at time of service feature ON, BH copay charge are not refundable anymore.

  Rule: B2C Plans - Subscription charge - via URL

    Background:
      Given Therapist API - Login to therapist2 provider
      Given Client API - Create THERAPY room for primary user with therapist2 provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Therapist API - Set primary user Information with therapist2 provider
        | country | IL |
      And Client API - Cancel Subscription of primary user in the first room
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And Navigate to refund wizard

    @visual
    Scenario: via URL - Subscription charge - Visual regression
      Then Shoot baseline "Client Web - Refund Wizard - Subscription charge - plan selection"
      And Select from list the option "Messaging Therapy Premium - Monthly"
      And Click on next button
      Then Shoot baseline "Client Web - Refund Wizard - Subscription charge - Refund eligible"
      And Click on confirm button
      Then Shoot baseline "Client Web - Refund Wizard - Subscription charge - Refund confirmation"

    @visual
    Scenario: via URL - Subscription charge - Contact support - Visual regression
      And Select from list the option "Messaging Therapy Premium - Monthly"
      And Click on next button
      And Click on contact Support
      Then Shoot baseline "Client Web - Refund Wizard - Subscription charge - Contact support page"
      And Click on confirm button
      Then Shoot baseline "Client Web - Refund Wizard - Subscription charge - Contact support confirmation"

    Scenario: via URL - Subscription charge - Contact support
      And Refund wizard - Select from list the option "Messaging Therapy Premium - Monthly"
      And Click on next button
      And Click on contact Support
      And Click on confirm button
      And Click on done button
      Then Room is available
      And Client API - The first room status of primary user is NOT_RENEW
      And Client API - 1 refundable charges exist for primary user

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2627
    Scenario: via URL - Subscription charge - Refund charge
      And Refund wizard - Select from list the option "Messaging Therapy Premium - Monthly"
      And Click on next button
      And Click on confirm button
      And Click on done button
      Then Room is available
      Then Client API - The first room status of primary user is CANCELLED
      And Client API - 0 refundable charges exist for primary user
      And Sendgrid API - primary user has the following email subjects at his inbox
        | cancelSubscription_39             | 1 |
        | canary-notifyclientrefundpurchase | 1 |

  Rule: B2C Plans - Subscription charge via My Account

    Scenario: via My Account - Subscription charge - Refund charge
      Given Therapist API - Login to therapist2 provider
      Given Client API - Create THERAPY room for primary user with therapist2 provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Therapist API - Set primary user Information with therapist2 provider
        | country | IL |
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Client API - Cancel Subscription of primary user in the first room
      And Navigate to payment and plan URL
      And Click on need more help button
      And Select from list the option "Messaging Therapy Premium - Monthly"
      And Click on next button
      And Click on confirm button
      And Click on done button
      Then Client API - The first room status of primary user is CANCELLED
      And Client API - 0 refundable charges exist for primary user

  Rule: B2C Plans - LVS charge via My Account

    Background:
      Given Client API - Create THERAPY room for primary user with therapist2 provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      When Client API - Subscribe to offer 69 of plan 247 with visa card of primary user in the first room
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Navigate to refund wizard
      And Refund wizard - Select from list the option "$65 - 30 min Live Video Session"
      And Click on next button

    @visual
    Scenario: Refund wizard via URL - LVS charge - Visual regression
      Then Shoot baseline "Client Web - Refund Wizard - LVS charge - Refund reason"
      And Select from list the option "I’m not going to use this session credit"
      And Click on next button
      Then Shoot baseline "Client Web - Refund Wizard - LVS charge - Refund eligible"

    @visual
    Scenario: Refund wizard via URL - LVS charge - Refund confirmation
      And Refund wizard - Select from list the option "I’m not going to use this session credit"
      And Click on next button
      And Click on confirm button
      Then Shoot baseline

    Scenario: via URL - LVS charge - Refund charge - not using the credit option
      And Refund wizard - Select from list the option "I’m not going to use this session credit"
      And Click on next button
      And Click on confirm button
      And Click on done button
      And Navigate to payment and plan URL
      Then No credits exist in the first room
      And Client API - 0 refundable charges exist for primary user
      And Sendgrid API - primary user has the following email subjects at his inbox
        | canary-notifyclientrefundpurchase | 1 |

    Scenario: via URL - LVS charge - Refund charge - other option
      And Refund wizard - Select from list the option "Other"
      And Click on next button
      And Refund Wizard - Enter refund reason
      And Click on next button
      And Click on confirm button
      And Click on done button
      And Navigate to payment and plan URL
      Then No credits exist in the first room
      And Client API - 0 refundable charges exist for primary user
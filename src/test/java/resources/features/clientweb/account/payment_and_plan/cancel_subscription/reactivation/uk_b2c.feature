@owner=tami
Feature: Client web - Reactivation

  Background:
    And Therapist API - Login to therapist provider
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Client API - Subscribe to offer 62 of plan 412 with visa card of primary user in the first room
    And Refresh the page
    And Onboarding - Click on meet your provider button
    And Onboarding - Dismiss modal
    And Therapist API - Set primary user Information with therapist provider
      | country                   | GB         |
      | gender                    | male       |
      | dateOfBirth               | 1991-11-11 |
      | therapistGenderPreference | male       |
    And Client API - Cancel Subscription of primary user in the first room
    And Client API - Refund Charge of primary user
    And Refresh the page

  Rule: Start from payment and plan page

    Background:
      And Navigate to payment and plan URL
      And Click on Subscribe button

    Scenario: Reactivate from payment and plan - UK - Current provider available - Continue with current provider (from B2C to B2C therapy room)
      And Click on continue
      And Reactivation - Select THERAPY service
      And Select to pay out of pocket
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
      And Click on the I live outside of the US button
      And Select from list the option "United Kingdom"
      And QM - Click on continue button
      When Click on Continue with same provider
      Then Reactivation - Select the first plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      When Reactivation payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Client API - The first room status of primary user is ACTIVE
      And therapist is the provider in the first room for primary user
      Then Plan details for the first room are
        | plan name | Messaging Therapy Premium - Quarterly |

    @issue=talktala.atlassian.net/browse/MEMBER-3222
    Scenario: Reactivate from payment and plan - UK - Current provider available - Match with new provider (from B2C to B2C therapy room)
      And Click on continue
      And Reactivation - Select THERAPY service
      And Select to pay out of pocket
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
      And Click on the I live outside of the US button
      And Select from list the option "United Kingdom"
      And QM - Click on continue button
      When Click on Match with a new provider
      And Click on secure your match button
      Then Reactivation - Select the first plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      When Reactivation payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      And Payment and Plan - Waiting to be matched text is displayed for the first room
      Then Plan details for the first room are
        | plan name | Messaging Therapy Premium - Quarterly |
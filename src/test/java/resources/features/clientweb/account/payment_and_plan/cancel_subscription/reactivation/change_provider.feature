@owner=tami
@ignore
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2182
Feature: Client web - Reactivation

  Background:
    Given Therapist API - Login to therapist provider
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | MT |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    And Therapist API - Set primary user Information with therapist provider
      | country                   | US         |
      | state                     | WY         |
      | gender                    | male       |
      | dateOfBirth               | 1991-11-11 |
      | therapistGenderPreference | male       |
    And Client API - Cancel Subscription of primary user in the first room
    And Client API - Refund Charge of primary user
    And Navigate to payment and plan URL
    And Click on Subscribe button

  Scenario: Change provider from payment page
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
      | state                                              | Continue with prefilled state  |
    When Click on Continue with same provider
    Then Reactivation - Select the first plan
    And Continue with "3 Months" billing period
    And Reactivation Payment - Click on change provider
    And Reactivation - Click on continue
    When Click on Match with a new provider
    And Click on secure your match button
    Then Reactivation - Select the first plan
    And Continue with "3 Months" billing period
    And Apply free coupon if running on prod
    When Reactivation payment - Click on continue
    And Payment - Complete purchase using "visa" card for primary user
    And Reactivation - Click on continue to room button
    And Navigate to payment and plan URL
    And therapist is not the provider in the first room for primary user
Feature: Client web - Payment
  added IL as country step in order to always get offer 62 original plans

  Background:
    And Therapist API - Login to therapist provider
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Therapist API - Set primary user Information with therapist provider
      | country | IL |

  Rule: Before plan Purchase

    Background:
      And Navigate to payment and plan URL

    @tmsLink=talktala.atlassian.net/browse/PLATFORM-1028
    Scenario: Payment - Update information with valid card - Before plan purchase
    The option to update stripe link before purchase does not exists - see attached ticket
      When Payment and Plan - Click on the update button
      When Update payment details to masterCard card with stripe link false
      When Payment and Plan - Click on save button
      When Click on done button

  Rule: After plan Purchase

    Background:
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL

    @smoke
    Scenario: Payment - Update information with valid card - After plan Purchase
      When Payment and Plan - Click on the update button
      When Update payment details to masterCard card with stripe link false
      When Payment and Plan - Click on save button
      When Click on done button

    @visual
    Scenario: Payment - Visual regression
      When Payment and Plan - Click on the update button
      Then Shoot dialog element as "Client Web - Payment - Payment modal components" baseline
      When Payment and Plan - Click on save button
      Then Shoot dialog element as "Client Web - Payment - Input fields errors" baseline
      When Update payment details to masterCard card with stripe link false
      When Payment and Plan - Click on save button
      Then Shoot dialog element as "Client Web - Payment - Details change confirmation popup" baseline
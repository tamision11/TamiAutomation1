@owner=tami
Feature: Client web - Registration - MBA and Onboarding

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2762
  Scenario: MBA - Before match - Book live first session - DTE - Therapy - Messaging only - Live video state
    Given Navigate to flow11
    Given Complete google validation form for primary user
      | age               | 18       |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | phone number      |          |
    And Click on Let's start button
    Then Complete the matching questions with the following options
      | seek help reason                   | I'm feeling anxious or panicky |
      | got it                             |                                |
      | provider gender preference         | Male                           |
      | have you been to a provider before | Yes                            |
      | sleeping habits                    | Excellent                      |
      | physical health                    | Excellent                      |
      | your gender                        | Male                           |
      | state                              | MT                             |
    And Click on secure your match button
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on continue button
    And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
    And Onboarding - Click on meet your provider button
    And Onboarding - Click on close button
    And Room is available
    And Client API - The first room status of primary user is ACTIVE

  Scenario: MBA - Before match - DTE - Therapy - Messaging only - non-Live video state
    Given Navigate to flow11
    Given Complete google validation form for primary user
      | age               | 18       |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | phone number      |          |
    And Click on Let's start button
    Then Complete the matching questions with the following options
      | seek help reason                   | I'm feeling anxious or panicky |
      | got it                             |                                |
      | provider gender preference         | Male                           |
      | have you been to a provider before | Yes                            |
      | sleeping habits                    | Excellent                      |
      | physical health                    | Excellent                      |
      | your gender                        | Male                           |
      | state                              | WY                             |
    And Click on secure your match button
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Room is available
    And Client API - The first room status of primary user is WAITING_TO_BE_MATCHED_QUEUE
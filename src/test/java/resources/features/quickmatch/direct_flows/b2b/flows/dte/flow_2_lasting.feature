@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2498
Feature: QM - B2B - DTE

  Background:
    Given Navigate to redemption
    And Landing page - Submit DTE form with THERAPY service type for primary user
    Then Click on Let's start button
    And Enter adult customer's date of birth
    And Click on "I'm having difficulty in my relationship" button

  Scenario: Flow 2 - Try lasting
    When Click on "Try Lasting" button
    Then Current url should match "https://apps.apple.com/us/app/lasting-marriage-couples/id1225049619?mt=8"

  Scenario: Flow 2 - Try lasting later - Therapy
    When Click on "Maybe later" button
    And Click on GOT IT!
    And Complete the matching questions with the following options
      | provider gender preference         | Male      |
      | have you been to a provider before | No        |
      | sleeping habits                    | Excellent |
      | physical health                    | Excellent |
      | your gender                        | Male      |
      | state                              | MT        |
    And Click on secure your match button
    And Create account for primary user with
      | email        | PRIMARY |
      | password     | STRONG  |
      | nickname     | VALID   |
      | phone number |         |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                               | Northwestern Mutual Unlimited Messaging with 1 Monthly Live Session Voucher |
      | credit description                      | credit amount                                                               |
      | 1 x Complimentary live session (10 min) | 1                                                                           |
      | 1 x Therapy live session (30 min)       | 1                                                                           |
@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-3010
@tmsLink=talktala.atlassian.net/browse/PLATFORM-4354
Feature: QM - EAP duplicate info

  Scenario Outline: New auth code validation - Registration - Direct flow - Cigna
  this flow verifies real unique cigna authorization code
    Given Navigate to flow78
    And Set primary user last name to Automation
    When Complete cigna eap validation form for primary user
      | birthdate                     | consumer    |
      | authorization code            | <authCode>  |
      | session number                | 3           |
      | service type                  | THERAPY     |
      | Email                         | PRIMARY     |
      | employee Relation             | EMPLOYEE    |
      | state                         | MT          |
      | phone number                  |             |
      | authorization code expiration | future date |
    Then Click on Let's start button
    And Complete the matching questions with the following options
      | seek help reason                   | I'm feeling anxious or panicky |
      | got it                             |                                |
      | provider gender preference         | Male                           |
      | have you been to a provider before | Yes                            |
      | sleeping habits                    | Excellent                      |
      | physical health                    | Excellent                      |
      | your gender                        | Male                           |
      | state                              | Continue with prefilled state  |
    And Click on secure your match button
    And Click on continue on coverage verification
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                          | Cigna EAP 3 Sessions Messaging and Live Session Voucher |
      | credit description                 | credit amount                                           |
      | 3 x Therapy live sessions (45 min) | 1                                                       |
    And Payment and Plan - Waiting to be matched text is displayed for the first room
    Examples:
      | authCode       |
      | CIGNA_OPTION_1 |
      | CIGNA_OPTION_2 |

@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2794
Feature: Client web - Registration

  Background:
    Given Navigate to therapist slug
    And Create account for primary user with
      | email    | PRIMARY |
      | password | STRONG  |
      | nickname | VALID   |
      | state    | MT      |
    When Click on change email

  @visual
  Scenario: Email update - Visual regression
    Then Shoot baseline

  Scenario: Email update - Email edit
    And Registration - Email update - Update email of primary user
    And Registration - Email update - Click on save button
    And Mailinator API - Verify primary user Email
    And 2FA - Fill phone number of primary user
    And 2FA - Click on continue button
    And 2FA - Send dummy verification code 1 times
    And Update primary user credentials
    And Onboarding - Click on meet your provider button
    And Onboarding - Dismiss modal
    And Log out
    And Log in with primary user old email
    Then Log in error message is displayed
    And Revoke access token for primary user

  @visual
  Scenario Outline: Registration - Email update - Email errors
    And Registration - Email update - Insert <emailType> email in the email input
    And Registration - Email update - Click on save button
    Then Shoot baseline "<baseLineName>" and ignore
      | update email input         |
      | confirm update email input |
    Examples:
      | emailType | baseLineName                                                         |
      | INVALID   | Client Web - Registration - Email update - Invalid email error       |
      | NEW       | Client Web - Registration - Email update - Confirm email empty error |

  @visual
  Scenario: Email update - Missing email error
    And Registration - Email update - Click on save button
    Then Shoot baseline

  @visual
  Scenario: Email update - Different email confirmation error
    And Registration - Email update - Insert NEW email in the email input
    And Registration - Email update - Insert PARTNER email in email confirmation
    And Registration - Email update - Click on save button
    Then Shoot baseline and ignore
      | update email input         |
      | confirm update email input |

  @visual
  Scenario: Email update - Same old email error
    And Registration - Email update - Insert PRIMARY email in the email input
    And Registration - Email update - Insert PRIMARY email in email confirmation
    And Registration - Email update - Click on save button
    Then Shoot baseline and ignore
      | update email input         |
      | confirm update email input |
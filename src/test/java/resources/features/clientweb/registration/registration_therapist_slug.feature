@tmsLink=talktala.testrail.net/index.php?/tests/view/473437&group_by=cases:section_id&group_order=asc&group_id=1543
Feature: Client web - Registration
  Provider slug is created in admin backoffice.

  Background:
    Given Navigate to therapist slug

  Scenario: Registration From provider slug
    And Create account for primary user with
      | email    | PRIMARY |
      | password | STRONG  |
      | nickname | VALID   |
      | state    | MT      |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    Then Room is available
    And therapist is the provider in the first room for primary user

  @smoke @sanity
  Scenario: Registration from provider slug - Perform a valid Registration from US and Re-login after registration
    And Create account for primary user with
      | email    | PRIMARY |
      | password | STRONG  |
      | nickname | VALID   |
      | state    | MT      |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    Then Room is available
    And Switch to a new window
    Given Navigate to client-web
    And Log in with primary user and
      | remember me   | false |
      | 2fa activated | true  |
    Then Room is available

  Scenario: Registration from provider slug - Perform a valid Registration from UK
    And Create account for primary user with
      | email    | PRIMARY        |
      | password | STRONG         |
      | nickname | VALID          |
      | country  | United Kingdom |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    Then Room is available

  @visual
  Scenario: Registration from provider slug - Visual regression
    Then Shoot baseline "Client Web - Registration from Client-Web - Sign up page"
    And Registration Page - Click on Create your account button
    Then Shoot baseline "Client Web - Registration from Client-Web - Empty credentials error"
    And Create account for primary user with
      | email    | PRIMARY |
      | password | SHORT   |
      | nickname | VALID   |
      | state    | MT      |
    Then Shoot baseline "Client Web - Registration from Client-Web - Password too short error" and ignore
      | email input |

  Scenario: Registration from provider slug - Already registered user
  Already registered user receives an email to sign in to his account.
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Switch to a new window
    And Navigate to therapist slug
    And Create account for primary user with
      | email    | PRIMARY |
      | password | STRONG  |
      | nickname | VALID   |
      | state    | MT      |
    And Sendgrid API - primary user has the following email subjects at his inbox
      | notifyclientregisterattempt | 1 |

  @visual
  Scenario: Registration from provider slug - No nickname error
    When Sign in - Enter PRIMARY email
    And Insert STRONG password
    And Select MT state
    And Registration Page - Click on Create your account button
    Then Shoot baseline and ignore
      | email input |

  @visual
  Scenario Outline: Registration from provider slug - Nickname errors
    And Create account for primary user with
      | email    | PRIMARY    |
      | password | STRONG     |
      | nickname | <nickname> |
      | state    | MT         |
    Then Shoot baseline "<baseLineName>" and ignore
      | email input |
    Examples:
      | nickname           | baseLineName                                                                        |
      | SHORT              | Client Web - Registration from Client-Web - Nickname too short error                |
      | TOO_LONG           | Client Web - Registration from Client-Web - Nickname too long error                 |
      | START_WITH_NUMBER  | Client Web - Registration from Client-Web - Nickname must start with a letter error |
      | SPECIAL_CHARACTERS | Client Web - Registration from Client-Web - Nickname Special character error        |
      | SAME_AS_PASSWORD   | Client Web - Registration from Client-Web - Nickname same as password error         |
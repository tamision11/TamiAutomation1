@owner=nir_tal
Feature: Client web - Login and security

  Background:
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Open account menu
    And Account Menu - Select login and security

  @visual
  Scenario: Login and security panel
    Then Shoot Login and security panel element with scenario name as baseline

  Rule: Nickname edit

    Background:
      When Click on change nickname

    @visual
    Scenario: Nickname change confirmation popup
      Then Shoot dialog element as "Client Web - Login and security - nickname change confirmation popup" baseline

    @visual
    Scenario: Nickname edit confirmation success popup
      Then Clear input Nickname
      And Insert RANDOM_VALID in nickname input for primary user
      And My account - Click on save button
      Then Shoot dialog element as "Client Web - Login and security - Nickname edit confirmation success popup" baseline

    @visual
    Scenario: Nickname edit - Empty nickname error
      Then Clear input Nickname
      And My account - Click on save button
      Then Shoot dialog element as "Client Web - Login and security - empty nickname error" baseline

    @visual
    Scenario Outline: Nickname edit - Nickname errors
      Then Clear input Nickname
      And Insert <nickname> in nickname input for primary user
      And My account - Click on save button
      Then Shoot dialog element as "<baseLineName>" baseline and ignore
        | nickname input |
      Examples:
        | nickname           | baseLineName                                                              |
        | SHORT              | Client Web - Login and security - nickname too short error                |
        | TOO_LONG           | Client Web - Login and security - nickname too long error                 |
        | START_WITH_NUMBER  | Client Web - Login and security - nickname must start with a letter error |
        | SPECIAL_CHARACTERS | Client Web - Login and security - nickname Special character error        |

    Scenario: Nickname edit
      Then Clear input Nickname
      And Insert RANDOM_VALID in nickname input for primary user
      And My account - Click on save button
      When Click on done button
      Then Nickname is updated for primary user

  Rule: Email edit

    Background:
      When Click on change email

    @visual
    Scenario: Visual regression
      Then Enter the current password of primary user
      And My account - Click on continue on verify password button
      Then Shoot dialog element as "Client Web - Login and security - Email change - confirmation popup" baseline
      And My account - Click on save button
      Then Shoot dialog element as "Client Web - Login and security - Email change - Email empty error" baseline
      And My account - Update email of primary user
      And My account - Click on save button
      Then Shoot baseline "Client Web - Login and security - Email change - email popup"

    Scenario: Email edit
      Then Enter the current password of primary user
      And My account - Click on continue on verify password button
      And My account - Update email of primary user
      And My account - Click on save button
      When extract email
      And Browse to the email verification link for primary user
      When Open account menu
      And Account Menu - Select login and security
      Then New email is verified for primary user

    @visual
    Scenario Outline: Email errors
      Then Enter the current password of primary user
      And My account - Click on continue on verify password button
      And My account - Insert <emailType> email in the email input
      And My account - Click on save button
      Then Shoot dialog element as "<baseLineName>" baseline
      Examples:
        | emailType | baseLineName                                                |
        | INVALID   | Client Web - Login and security - Invalid email error       |
        | NEW       | Client Web - Login and security - Confirm email empty error |

    @visual
    Scenario Outline: Email confirmation errors
      Then Enter the current password of primary user
      And My account - Click on continue on verify password button
      And My account - Insert <input> email in the email input
      And My account - Insert <confirmation> email in email confirmation
      And My account - Click on save button
      Then Shoot dialog element as "<baseLineName>" baseline
      Examples:
        | input | confirmation | baseLineName                                                         |
        | NEW   | PARTNER      | Client Web - Login and security - Different email confirmation error |

    @visual
    Scenario: Same old email error
      Then Enter the current password of primary user
      And My account - Click on continue on verify password button
      And My account - Insert PRIMARY email in the email input
      And My account - Insert PRIMARY email in email confirmation
      And My account - Click on save button
      Then Shoot dialog element and ignore
        | email verification |

  Rule: Password edit

    Background:
      When Click on change password

    Scenario: Password edit
      Then Enter the current password of primary user
      And My account - Click on continue on verify password button
      And My account - Update the password of primary user
      And My account - Click on save button
      When Click on done button
      When Log out
      Given Navigate to client-web
      And Log in with primary user and
        | remember me   | false |
        | 2fa activated | true  |
      Then Room is available

    @visual
    Scenario: Password edit - old password should not work
    login via the api on the last step in order to refresh the user login token
      Then Enter the current password of primary user
      And My account - Click on continue on verify password button
      And My account - Update the password of primary user
      And My account - Click on save button
      When Click on done button
      When Log out
      Given Navigate to client-web
      And Sign in - Enter PRIMARY email
      And Enter initial password of primary user
      And Click on login button
      Then Shoot baseline and ignore
        | email input |
      And Revoke access token for primary user

    @visual
    Scenario: Visual regression
      Then Enter the current password of primary user
      And My account - Click on continue on verify password button
      And My account - Click on save button
      Then Shoot dialog element as "Client Web - Login and security - Empty password error" baseline
      And My account - Write STRONG password in the new password field for primary user
      And My account - Click on save button
      Then Shoot dialog element as "Client Web - Login and security - Empty confirmation password error" baseline
      And My account - Write STRONG password in the confirm new password field
      And My account - Click on save button
      Then Shoot dialog element as "Client Web - Login and security - Password change confirmation popup" baseline

    @visual
    Scenario Outline: Password error
      Then Enter the current password of primary user
      And My account - Click on continue on verify password button
      And My account - Write <newPassword> password in the new password field for primary user
      And My account - Write <confirmationPassword> password in the confirm new password field
      And My account - Click on save button
      Then Shoot dialog element as "<baseLineName>" baseline
      Examples:
        | newPassword   | confirmationPassword | baseLineName                                                                     |
        | STRONG        | SHORT                | Client Web - Login and security - Update password - Passwords do not match error |
        | SHORT         | SHORT                | Client Web - Login and security - Update password - Password too short error     |
        | WEAK          | WEAK                 | Client Web - Login and security - Update password - Weak password error          |
        | SO_SO         | SO_SO                | Client Web - Login and security - Update password - So-So password error         |
        | SAME_AS_EMAIL | SAME_AS_EMAIL        | Client Web - Login and security - Update password - Password same as email error |

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2711
    Rule: Phone edit

    Background:
      And Therapist API - Login to therapist provider
      Given Skip scenario if 2fa is disabled for primary user
      When Click on change phone number
      Then Enter the current password of primary user
      And My account - Click on continue on verify password button

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2722
    @tmsLink=talktala.atlassian.net/browse/PLATFORM-1618
    Scenario: Phone edit
      And 2FA - Fill phone number of primary user
      And My account - Click on save button
      And 2FA - Send verification code of primary user
      And Click on done button

    @visual
    Scenario: Phone edit - Visual regression
      Then Shoot dialog element as "Client Web - Login and security - Update phone number dialog" baseline
      And 2FA - Fill phone number of primary user
      And My account - Click on save button
      Then Shoot dialog element as "Client Web - Login and security - 2fa verification" baseline
      And 2FA - Send verification code of primary user
      Then Shoot dialog element as "Client Web - Login and security - Dialog after 2fa verification" baseline
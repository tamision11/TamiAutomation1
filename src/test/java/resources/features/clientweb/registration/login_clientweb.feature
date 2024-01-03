Feature: Client web - Log In
  successful login covered in Scenario: "Perform a valid registration and Re-login after registration"

  Rule: User with verified email

    Background:
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And Log out

    Scenario: Lock\Unlock user
    After 6 failing attempts account should be temporarily locked.
    This scenario also verify locked user error
      When Sign in - Enter PRIMARY email
      And Insert SHORT password
      And Click on login button
      And Click on login button
      And Click on login button
      And Click on login button
      And Click on login button
      And Click on login button
      Then The error "Multiple failed login attempts. Your Account is temporarily locked." is displayed
      When Wait 300 seconds
      And Refresh the page
      And Log in with primary user and
        | remember me   | false |
        | 2fa activated | true  |
      Then Room is available

    Scenario: Remember me
      And Log in with primary user and
        | remember me   | true |
        | 2fa activated | true |
      Then Room is available
      And Switch to a new window
      And Navigate to client-web
      Then Room is available

    @visual
    Scenario: Forgot password - Visual regression
      When Click on the forgot password link
      Then Shoot baseline "Client Web - Log In - Forgot password - Reset Page"
      And Sign in - Enter PRIMARY email
      And Click on reset password button
      Then Shoot baseline "Client Web - Log In - Forgot password - Reset Page - Link sent"
      And Mailinator API - Go to link on primary user email
        | subject          | Reset your Talkspace password |
        | surrounding text | Reset password                |
      Then Shoot baseline "Client Web - Log In - Forgot password - Reset password page"
      And Revoke access token for primary user

    Scenario: Reset password
    testing that after log out and forget password OTP code is required while if user did not log out
    and go through forget password, OTP isn't required
      When Click on the forgot password link
      When Sign in - Enter PRIMARY email
      And Click on reset password button
      And Mailinator API - Go to link on primary user email
        | subject          | Reset your Talkspace password |
        | surrounding text | Reset password                |
      And Forgot password - Update the password of primary user
      When Click on save button
      And 2FA - Send verification code of primary user
      Then Room is available
      And Switch to a new tab
      And Navigate to client-web
      When Click on the forgot password link
      When Sign in - Enter PRIMARY email
      And Click on reset password button
      And Mailinator API - Go to link on primary user email
        | subject          | Reset your Talkspace password |
        | surrounding text | Reset password                |
      And Forgot password - Update the password of primary user
      When Click on save button

    @visual
    Scenario Outline: Forgot password - password error
      When Click on the forgot password link
      When Sign in - Enter PRIMARY email
      And Click on reset password button
      And Mailinator API - Go to link on primary user email
        | subject          | Reset your Talkspace password |
        | surrounding text | Reset password                |
      And Forgot password - Write <newPassword> password in the new password field for primary user
      And Forgot password - Write <confirmationPassword> password in the confirm new password field
      When Click on save button
      Then Shoot baseline "<baseLineName>"
      And Revoke access token for primary user
      Examples:
        | newPassword   | confirmationPassword | baseLineName                                                  |
        | STRONG        | SHORT                | Client Web - Forgot password - Passwords does not match error |
        | SHORT         | SHORT                | Client Web - Forgot password - Too short password error       |
        | WEAK          | WEAK                 | Client Web - Forgot password - Weak password error            |
        | SO_SO         | SO_SO                | Client Web - Forgot password - SO-SO password error           |
        | SAME_AS_EMAIL | SAME_AS_EMAIL        | Client Web - Forgot password - Same as email password error   |

    @visual
    Scenario: Wrong password error
      When Sign in - Enter PRIMARY email
      When Insert SHORT password
      And Click on login button
      Then Shoot baseline and ignore
        | email input |
      And Revoke access token for primary user

  Rule: Unverified User

    Background:
      Given Navigate to client-web

    @visual
    @tmsLink=talktala.atlassian.net/browse/CUSTOMER-4955
    Scenario: Unverified User - Visual regression
      When Click on login button
      Then Shoot baseline "Client Web - Log In - Empty credentials error"
      When Sign in - Enter INVALID email
      And Insert STRONG password
      When Click on login button
      Then Shoot baseline "Client Web - Log In - Invalid email error"

    @tmsLink=talktala.atlassian.net/browse/PLATFORM-1404
    Scenario: Unverified User - Validation
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      When Sign in - Enter PRIMARY email
      And Insert STRONG password
      When Click on login button
      Then Current url should contain "email-verification"
      And Sendgrid API - primary user has the following email subjects at his inbox
        | canary-clientemailverificationafterregistration | 2 |
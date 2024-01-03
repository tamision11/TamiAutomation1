@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2710
Feature: Client web - 2FA
  The background create 1 initial otp message for the scenario.

  Background:
    And Client API - Login to 2faUs user
    And Skip scenario if 2fa is disabled for 2faUs user

  Rule: Activation

    @smoke @sanity
    Scenario: 2FA Activation - Registration from provider slug - Redirected to room after successful OTP code
    user that does not have a phone number
      Given Navigate to therapist slug
      And Create account for primary user with
        | email    | PRIMARY |
        | password | STRONG  |
        | nickname | VALID   |
        | state    | MT      |
      And Browse to the email verification link for primary user
      And Sign two factor authentication for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      Then Room is available

    @smoke @sanity
    Scenario: 2FA Activation - Registration from provider slug - Skip 2FA
    user that does not have a phone number
      Given Navigate to therapist slug
      And Create account for primary user with
        | email    | PRIMARY |
        | password | STRONG  |
        | nickname | VALID   |
        | state    | MT      |
      And Browse to the email verification link for primary user
      And 2FA - Skip 2FA
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      Then Room is available

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2724
    Scenario: 2FA Activation - Registration from provider slug - Change phone number on 2FA activation
    user that does not have a phone number
      Given Navigate to therapist slug
      And Create account for primary user with
        | email    | PRIMARY |
        | password | STRONG  |
        | nickname | VALID   |
        | state    | MT      |
      And Browse to the email verification link for primary user
      And 2FA - Fill phone number of primary user
      And 2FA - Click on continue button
      And 2FA - Click on change phone number button
      And 2FA - Fill phone number of 2faUs user
      And Mailinator API - Count incoming SMS to US phone
      And 2FA - Click on continue button
      And 2FA - Send dummy verification code 1 time
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      Then Room is available
      Then Mailinator API - US phone has 1 more OTP message after the last count

    @visual
    Scenario: 2FA Activation - Registration from provider slug - Visual regression
    user that does not have a phone number
      Given Navigate to therapist slug
      And Create account for primary user with
        | email    | PRIMARY |
        | password | STRONG  |
        | nickname | VALID   |
        | state    | MT      |
      And Browse to the email verification link for primary user
      Then Shoot baseline "Client Web - 2FA - Update phone number dialog"
      When 2FA - Click on continue button
      Then Shoot baseline "Client Web - 2FA - Empty phone error"
      And 2FA - Fill phone number of primary user
      When 2FA - Click on continue button
      Then Shoot baseline "Client Web - 2FA - 2fa verification"

    Scenario: 2FA Activation - Registration from QM Automatic BH - Redirected to room after successful OTP code
    user that already has a phone number
      Given Navigate to flow28
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_25 |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
        | phone number      |          |
      And Click on next button to approve you are ready to begin
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
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user
      And Sign two factor authentication for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      Then Room is available
      And Sendgrid API - primary user has the following email subjects at his inbox
        | clientenabled2fa | 1 |

    Scenario: 2FA Activation - Registration from QM Automatic BH - Resend code
    user that already has a phone number
      And Set primary user phone number to US number
      Given Navigate to flow28
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_25 |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
        | phone number      |          |
      And Click on next button to approve you are ready to begin
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
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user
      And 2FA - Click on continue button
      And Mailinator API - Count incoming SMS to US phone
      And 2FA - Resend verification code 1 time to phone
      And Revoke access token for primary user
      Then Mailinator API - US phone has 1 more OTP message after the last count

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2718
    Scenario: 2FA Activation - Registration from QM Automatic BH - Redirect back to change phone screen after 4 resend 2fa to phone
    user that already has a phone number
      Given Navigate to flow28
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_25 |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
        | phone number      |          |
      And Click on next button to approve you are ready to begin
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
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user
      And 2FA - Click on continue button
      And 2FA - Resend verification code 4 times to phone
      Then Current url should contain "change-number"

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2586
    Rule: Authentication

    @smoke @sanity
    Scenario: 2FA Authentication - Redirected to room after successful OTP code
      Given Navigate to client-web
      And Log in with 2faUs user and
        | remember me   | false |
        | 2fa activated | true  |
      Then Room is available

    @visual
    Scenario: 2FA Authentication - OTP code error message
      Given Navigate to client-web
      And Log in with 2faUs user, remember me false
      And 2FA - Send dummy verification code 1 time
      Then Shoot baseline "Client Web - 2FA - OTP code error message"

    Scenario: 2FA Authentication - Redirect back to login screen after 4 OTP errors
      Given Navigate to client-web
      And Log in with 2faUs user, remember me false
      And 2FA - Send dummy verification code 4 times
      Then Current url should contain "login"

    Scenario: 2FA Authentication - Redirect back to login screen after 4 resend 2fa code to email
      Given Navigate to client-web
      And Log in with 2faUs user, remember me false
      And 2FA - Resend verification code 4 times to email
      Then Current url should contain "login"

    Scenario: 2FA Authentication - Redirect back to login screen after 4 resend 2fa to phone
      Given Navigate to client-web
      And Log in with 2faUs user, remember me false
      And 2FA - Resend verification code 4 times to phone
      Then Current url should contain "login"

    Scenario: 2FA Authentication - Resend to email
    we create a new user to assure only a single template is received
      When Therapist API - Login to therapist provider
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Log out
      And Log in with primary user, remember me false
      And 2FA - Resend verification code 1 time to email
      And Revoke access token for primary user
      And Sendgrid API - primary user has the following email subjects at his inbox
        | canary-send2facode | 1 |

    Scenario: 2FA Authentication - Resend to phone - Confirm OTP message on Twilio
      Given Navigate to client-web
      And Log in with 2faUs user, remember me false
      And Mailinator API - Count incoming SMS to US phone
      And 2FA - Resend verification code 1 time to phone
      Then Mailinator API - US phone has 1 more OTP message after the last count

  Rule: My account - Phone edit

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2715
    Scenario: My account - Phone edit - Resend code to phone
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Open account menu
      And Account Menu - Select login and security
      When Click on change phone number
      Then Enter the current password of primary user
      And My account - Click on continue on verify password button
      And 2FA - Fill phone number of 2faUs user
      And My account - Click on save button
      And Mailinator API - Count incoming SMS to US phone
      And 2FA - Resend verification code 1 time to phone
      Then Mailinator API - US phone has 1 more OTP message after the last count

    @visual
    Scenario: My account - Phone edit - Redirect back to login screen after 4 resend 2fa to phone
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And Open account menu
      And Account Menu - Select login and security
      When Click on change phone number
      Then Enter the current password of primary user
      And My account - Click on continue on verify password button
      And 2FA - Fill phone number of 2faUs user
      And My account - Click on save button
      And 2FA - Resend verification code 4 times to phone
      Then Shoot dialog element as "Client Web - Login and security - Update phone number dialog" baseline

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2721
    Scenario: My account - Phone edit - Successful phone edit
    without emergency contact update
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Open account menu
      And Account Menu - Select login and security
      When Click on change phone number
      Then Enter the current password of primary user
      And My account - Click on continue on verify password button
      And 2FA - Fill phone number of 2faUs user
      And Mailinator API - Count incoming SMS to US phone
      And My account - Click on save button
      And 2FA - Send verification code of primary user
      And Click on done button
      And Phone "(567) 405-2822" is updated
      Then Mailinator API - US phone has 1 more OTP message after the last count
      And Sendgrid API - primary user has the following email subjects at his inbox
        | clientupdatedphonenumber2fa | 1 |

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2723
    Scenario: My account - Phone edit - Change phone number from my account > change phone number
    without emergency contact update
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Open account menu
      And Account Menu - Select login and security
      When Click on change phone number
      Then Enter the current password of primary user
      And My account - Click on continue on verify password button
      And 2FA - Fill phone number of primary user
      And My account - Click on save button
      And 2FA - Click on change phone number button
      And 2FA - Fill phone number of 2faUs user
      And Mailinator API - Count incoming SMS to US phone
      And My account - Click on save button
      And 2FA - Send verification code of primary user
      And Click on done button
      And Phone "(567) 405-2822" is updated
      Then Mailinator API - US phone has 1 more OTP message after the last count
      And Sendgrid API - primary user has the following email subjects at his inbox
        | clientupdatedphonenumber2fa | 1 |

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2720
    @visual
    Scenario: My account - Phone edit - OTP code error message
      Given Navigate to client-web
      And Log in with 2faUs user and
        | remember me   | false |
        | 2fa activated | true  |
      And Open account menu
      And Account Menu - Select login and security
      When Click on change phone number
      Then Enter the current password of 2faUs user
      And My account - Click on continue on verify password button
      And 2FA - Fill phone number of 2faUs user
      And My account - Click on save button
      And 2FA - Send dummy verification code 1 times
      Then Shoot dialog element as "Client Web - 2FA - change phone number - OTP code error message" baseline

    @visual
    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2720
    Scenario: My account - Phone edit - Redirect back to Change phone number screen after 4 invalid OTP codes
      Given Navigate to client-web
      And Log in with 2faUs user and
        | remember me   | false |
        | 2fa activated | true  |
      And Open account menu
      And Account Menu - Select login and security
      When Click on change phone number
      Then Enter the current password of 2faUs user
      And My account - Click on continue on verify password button
      And 2FA - Fill phone number of 2faUs user
      And My account - Click on save button
      And 2FA - Send dummy verification code 4 times
      Then Shoot dialog element as "Client Web - Login and security - Update phone number dialog" baseline
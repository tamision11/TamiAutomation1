@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2583
Feature: Client web - Superbills
  added IL as country step in order to always get offer 62 original plans
  no onboarding modal dismissal since we are not showing it anymore for older rooms.

  Rule: Register with new user

    Background:
      And Therapist API - Login to therapist provider
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL

    @visual
    Scenario: Superbills - Not available for new user
      Then Shoot Payment and plan panel element and ignore
        | therapist avatar |
        | therapist name   |

  Rule: User with superbills with updated personal details

    Background:
      Given Navigate to client-web
      And Log in with userWithSuperbills user and
        | remember me   | false |
        | 2fa activated | true  |
      And Navigate to payment and plan URL

    @visual
    Scenario: Superbills - Visual regression
      And Click on view superbills button
      Then Shoot superbills intro text element as "Client Web - Superbills - intro text" baseline
      And Superbills - Click on the first superbill in list
      Then Shoot superbills name confirmation intro element as "Client Web - Superbills - name confirmation intro text" baseline
      Then Shoot name on superbill intro element as "Client Web - Superbills - name on superbill intro text" baseline

    Scenario: Superbills - Choose first superbill and Generate pdf
      And Click on view superbills button
      And Superbills - Verify at least 2 superbills are displayed
      And Superbills - Click on the first superbill in list
      And Superbills - Click on confirm name button
      And Superbills - Verify pdf generated and showing

    Scenario: Superbills - Choose second superbill and Generate pdf
      And Click on view superbills button
      And Superbills - Verify at least 2 superbills are displayed
      And Superbills - Click on the first superbill in list
      And Superbills - Click on confirm name button
      And Superbills - Click on close button
      And Superbills - Click on the second superbill in list
      And Superbills - Verify pdf generated and showing

    Scenario: Superbills - Download PDF
      And Click on view superbills button
      And Superbills - Verify at least 2 superbills are displayed
      And Superbills - Click on the first superbill in list
      And Superbills - Click on confirm name button
      And Superbills - Click on close button
      And Superbills - Click on the first superbill in list
      And Superbills - Download PDF and verify file existence

  Rule: User with superbills without updated personal details

    Background:
      Given Navigate to client-web
      And Log in with userWithSuperbills2 user and
        | remember me   | false |
        | 2fa activated | false |
        | skip 2fa      | true  |
      And Navigate to payment and plan URL
      And Click on view superbills button
      And Superbills - Verify at least 2 superbills are displayed
      And Superbills - Click on the first superbill in list

    @visual
    Scenario: Superbills - User with superbills without personal details
    the user details should be empty. to clear it use: select * from emergency_contact_information
    where user_id=5052263; and set use first_name + last_name to Null
      Then Shoot baseline
Feature: Client web - Personal Information

  Background:
    Given Therapist API - Login to therapist provider
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button

  Scenario: Update Emergency contact - View Emergency contact details after update on treatment intake
    When Open account menu
    And Account Menu - Select personal Information
    Then primary user Emergency contact details are
      | Name                                | Automation Emergency Contact |
      | Relationship with emergency contact | Parent                       |

  Rule: Details are updated from personal information form

    Background:
      Given Open account menu
      When Account Menu - Select personal Information

    Scenario: Update Emergency contact - View Emergency contact details after update from personal information form
      And Click on the change emergency contact button
      And Update emergency contact details of primary user
      And Personal information - Click on save button
      And Refresh the page
      Then primary user Emergency contact details are
        | Name                                | Automation Emergency Contact |
        | Relationship with emergency contact | Parent                       |
Feature: Client web - Personal Information

  Background:
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Open account menu
    And Account Menu - Select personal Information

  @visual
  Scenario: Personal information - My information - Personal details form - Visual regression
    Then Shoot My information section element as "Client Web - Personal information - My information section - Empty" baseline
    When Personal information - Click on change my details button
    Then Shoot form element as "Client Web - Personal information - My information - Personal details form" baseline
    And Personal information - Click on save button
    Then Shoot form element as "Client Web - Personal information - My information - Personal details form - missing required fields errors" baseline
    And Update personal Information
    And Personal information - Click on save button
    Then Shoot My information section element as "Client Web - Personal information - My information section - After filling details" baseline

  Scenario: Update personal Information
    When Personal information - Click on change my details button
    And Update personal Information
    And Personal information - Click on save button
    And Refresh the page
    Then Personal information details are
      | Name         | test Automation                             |
      | Birthdate    | 11/11/2000                                  |
      | Home Address | 4941 King Arthur Way, Cheyenne WY, 82009 US |
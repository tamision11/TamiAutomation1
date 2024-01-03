@admin
Feature: Client web - BH book next session


  Background:
    Given Therapist API - Login to therapist provider
    Given Set primary user last name to Automation

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2684
  Scenario: Book BH next session from room's message
    And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
      | flowId            | 28              |
      | age               | 18              |
      | Member ID         | CLAIM_BH_CHARGE |
      | keyword           | premerabh       |
      | employee Relation | EMPLOYEE        |
      | state             | MT              |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Client API - Login to primary user
    And Client API - Switch to therapist provider in the first room for primary user
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Dismiss modal
    And Client API - Start async messaging session for primary user
      | roomIndex  | 0    |
      | isPurchase | true |
    And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
    And Wait 30 seconds
    And DB - Store case id for primary user in the first room
    And DB - Store session report id for primary user in the first room
    And DB - Store customer id for primary user
    And DB - Get past time from database last 10 days back as "service_start_date"
    And DB - Get past time from database last 1 days back as "service_end_date"
    And Therapist API - Submit BH messaging session summary notes
      | cpt code | 5 |
    And DB - Set BH primary user to be permanently ineligible in grace period
    And BH next session - Click on Book a session button

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-3110
  Scenario: Ineligible cusotmer - open ACKP from error screen
    And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
      | flowId            | 28              |
      | age               | 18              |
      | Member ID         | CLAIM_BH_CHARGE |
      | keyword           | premerabh       |
      | employee Relation | EMPLOYEE        |
      | state             | MT              |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Client API - Login to primary user
    And Client API - Switch to therapist provider in the first room for primary user
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Dismiss modal
    And Client API - Start async messaging session for primary user
      | roomIndex  | 0    |
      | isPurchase | true |
    And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
    And Wait 30 seconds
    And DB - Store case id for primary user in the first room
    And DB - Store session report id for primary user in the first room
    And DB - Store customer id for primary user
    And DB - Get past time from database last 10 days back as "service_start_date"
    And DB - Get past time from database last 1 days back as "service_end_date"
    And Therapist API - Submit BH messaging session summary notes
      | cpt code | 5 |
    And DB - Set BH primary user to be permanently ineligible in grace period
    And BH next session - Click on Book a session button
    And BH next session - Click on check your eligibility error link
    And Current url should contain "eligibility-widget"



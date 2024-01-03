Feature: Client web - Add a service
  Leads to flow 67

  Background:
    Given Client API - Create THERAPY room for primary user with therapist2 provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Dismiss modal
    When Open account menu
    Then Account Menu - Select add a new service
    When Select COUPLES_THERAPY service
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider - multi select | Decide whether we should separate |
      | looking for a provider that will                                  | Teach new skills                  |
      | have you been to a provider before                                | Yes                               |
      | live with your partner                                            | Yes                               |
      | type of relationship                                              | Straight                          |
      | domestic violence                                                 | No                                |
      | ready                                                             | We're ready now                   |
      | your gender                                                       | Female                            |
      | provider gender                                                   | Male                              |
      | age                                                               | 18                                |
      | state                                                             | MT                                |
    And Continue without insurance provider after selecting "I’ll pay out of pocket"

  @smoke
  Scenario: Couples therapy - B2C
    And Click on secure your match button
    And Select the first plan
    And Continue with "3 Months" billing period
    And Apply free coupon if running on prod
    And Payment - Click on continue
    And Payment - Complete purchase using "visa" card for primary user
    And Click on continue to room button
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Couples Therapy with Live Session - Quarterly |
    And No credits exist in the first room
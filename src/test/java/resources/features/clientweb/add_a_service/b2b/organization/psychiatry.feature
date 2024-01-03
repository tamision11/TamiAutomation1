Feature: Client web - Add a service
  Leads to flow 68

  Background:
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | MT |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Dismiss modal
    When Open account menu
    Then Account Menu - Select add a new service
    When Select PSYCHIATRY service
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider       | Anxiety                       |
      | prescribed medication to treat a mental health condition | Yes                           |
      | your gender                                              | Female                        |
      | provider gender                                          | Male                          |
      | age                                                      | 18                            |
      | state                                                    | Continue with prefilled state |
    And Click on I have talkspace through an organization

  Rule: Unsupported service

    Scenario: Psychiatry - DTE - Unsupported service
      When Write "google" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      And Click on secure your match button
      And Select the first plan
      When Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Click on continue to room button
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Psychiatry - Initial Evaluation + 1 follow up session |

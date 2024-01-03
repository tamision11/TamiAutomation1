@owner=tami
Feature: Client web - Registration - MBA and Onboarding

  Background:
    Given Navigate to flow90
    When Select PSYCHIATRY service
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider       | Anxiety |
      | prescribed medication to treat a mental health condition | Yes     |
      | your gender                                              | Male    |
      | provider gender                                          | Male    |
      | age                                                      | 18      |
      | state                                                    | MT      |
    And Continue without insurance provider after selecting "I’ll pay out of pocket"
    And Click on secure your match button
    And Email wall - Click on continue after Inserting PRIMARY email

  Scenario: MBA - Before match - Book live first session - B2C - Psychiatry - Non-Live state
    And Select the first plan
    When Payment - Click on continue
    And Payment - Complete purchase using "visa" card for primary user
    And Create account for primary user with
      | password     | STRONG |
      | nickname     | VALID  |
      | checkbox     |        |
      | phone number |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click continue on book first session
    And MBA - Book first PSYCHIATRY live VIDEO session with NO_LIVE_PREFERENCE selection
    And Onboarding - Click on meet your provider button
    And Onboarding - Click on close button
    And Room is available
    And Client API - The first room status of primary user is FREE

  @visual
  Scenario: MBA - Before match - Book live first session - B2C - Psychiatry - You're all done page
    And Select the second plan
    When Payment - Click on continue
    And Payment - Complete purchase using "visa" card for primary user
    And Create account for primary user with
      | password     | STRONG |
      | nickname     | VALID  |
      | checkbox     |        |
      | phone number |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click continue on book first session
    And Onboarding - Click continue on duration selection
    And In-room scheduler - Click on Next available button if present
    And In-room scheduler - Click on a timeslot
    And Onboarding - Click continue on slot selection
    And In-room scheduler - Click on reserve session button
    And Onboarding - Click on meet your provider button
    And Shoot baseline
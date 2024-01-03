Feature: QM - Flow 90
  Leads to flow 68

  Background:
    Given Navigate to flow90
    When Select PSYCHIATRY service
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider       | Anxiety |
      | prescribed medication to treat a mental health condition | Yes     |
      | your gender                                              | Female  |
      | provider gender                                          | Male    |
      | age                                                      | 18      |
      | state                                                    | MT      |
    And Continue without insurance provider after selecting "I’ll pay out of pocket"
    And Click on secure your match button
    And Email wall - Click on continue after Inserting PRIMARY email

  @smoke
  Scenario: B2C - Psychiatry
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
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Psychiatry - Initial Evaluation + 1 follow up session |
    And No credits exist in the first room
    And Payment and Plan - Waiting to be matched text is displayed for the first room

  @ignore
  @tmslink=talktala.atlassian.net/browse/AUTOMATION-2694
  Scenario: B2C - Psychiatry - Recover session
  ignored until https://talktala.atlassian.net/browse/CVR-755 is fixed
    And Wait 10 seconds
    And Switch to a new window
    And Navigate to recover-session
    And Current url should contain "flow/68/step/23"
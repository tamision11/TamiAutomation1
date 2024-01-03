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

  Rule: Unsupported service
  Customers are not offered Psychiatry through this organization

    Scenario: Psychiatry - DTE - Unsupported service (organization code flow)
      And Click on I have talkspace through an organization
      When Write "google" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
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

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2829
    Scenario: Psychiatry - EAP - Unsupported service (authorization code flow)
      And Click on I have talkspace through an organization
      And Write "test" in organization name
      And Click on next button
      And Enter RANDOM email
      And Click on next button
      And Click on I have a keyword or access code button
      When Enter EXISTING authorization code
      When Click on next button
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
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
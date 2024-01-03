@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2584
Feature: QM - B2B - EAP
  Leads to flow 2

  Background:
    Given Navigate to flow89

  @smoke
  Scenario: Flow 89 - KGA - Therapy
    When Complete kga eap validation form for primary user
      | authorization code | MOCK_KGA |
      | age                | 18       |
      | organization       | kga      |
      | service type       | THERAPY  |
      | Email              | PRIMARY  |
      | employee Relation  | EMPLOYEE |
      | state              | MT       |
      | phone number       |          |
    Then Click on Let's start button
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
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                               | KGA EAP 3 Sessions with Live Sessions Voucher |
      | credit description                      | credit amount                                 |
      | 1 x Complimentary live session (10 min) | 1                                             |
      | 3 x Therapy live sessions (45 min)      | 1                                             |
    And Payment and Plan - Waiting to be matched text is displayed for the first room
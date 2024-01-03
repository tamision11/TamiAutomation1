@tmsLink=talktala.atlassian.net/browse/AUTOMATION-3004
Feature: QM - B2B - EAP
  Leads to flow 2


  Background:
    Given Navigate to flow41
    When Complete eap validation form for primary user
      | age               | 13      |
      | organization      | mines   |
      | service type      | THERAPY |
      | Email             | PRIMARY |
      | employee Relation | STUDENT |
      | phone number      |         |
    And Click on Let's start button
    And Complete the matching questions with the following options
      | what do you need support with      | Anxiety or worrying |
      | got it                             |                     |
      | provider gender preference         | Male                |
      | have you been to a provider before | Yes                 |
      | sleeping habits                    | Excellent           |
      | physical health                    | Excellent           |
      | your gender                        | Male                |
      | Parental consent                   | Yes                 |
      | state                              | MT                  |

  @smoke @sanity
  Scenario: Flow 41 (EAP with Teen Support) - Therapy
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
      | plan name                                | Mines EAP 5 Sessions Messaging or Live Session Voucher |
      | credit description                       | credit amount                                          |
      | 5 x Therapy live sessions (30 or 45 min) | 1                                                      |
    And Payment and Plan - Waiting to be matched text is displayed for the first room
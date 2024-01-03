Feature: QM - Flow 90
  Leads to flow 67

  Background:
    Given Navigate to flow90
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

  Rule: Unsupported service
  DTE Customers are not offered Couples therapy through this organization

    Scenario: Couples therapy - DTE - Unsupported service
      And Click on I have talkspace through an organization
      When Write "google" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      And Select the first plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      And Payment - Click on continue
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
        | plan name | Couples Therapy with Live Session - Quarterly |
      And No credits exist in the first room
      And Payment and Plan - Waiting to be matched text is displayed for the first room

  Rule: Supported service
  EAP customers are offered Couples therapy

    Scenario: Couples therapy - EAP
      And Click on I have talkspace through an organization
      When Write "humana" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      And Complete shared validation form for primary user
        | age               | 18       |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
        | phone number      |          |
      And Click on continue on coverage verification
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                               | Humana EAP 5 Sessions Messaging Only Voucher |
        | credit description                      | credit amount                                |
        | 1 x Complimentary live session (10 min) | 1                                            |
      And Payment and Plan - Waiting to be matched text is displayed for the first room
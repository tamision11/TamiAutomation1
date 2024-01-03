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

  Rule: Supported service
  Customers are offered couples therapy through this insurance company

    @issue=talktala.atlassian.net/browse/MEMBER-3297
    @smoke @sanity
    Scenario: Couples Therapy - BH - Cigna
      And Continue with "Cigna" insurance provider
      And Click on secure your match button
      And Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_0  |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
        | phone number      |          |
      And Click on continue on coverage verification
      And B2B Payment - Complete purchase using visa card with stripe link false
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
        | checkbox |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Cigna BH Couples Messaging or Live Session |
      And Payment and Plan - Waiting to be matched text is displayed for the first room

    Scenario: Couples therapy - AARP (Out of Network)
      And Continue with "AARP" insurance provider
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      And Complete out of network validation form for primary user
        | age       | 18             |
        | state     | MT             |
        | Member ID | OUT_OF_NETWORK |
      And Select the first plan
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
        | plan name | Couples Therapy with Live Session - Monthly |
      And No credits exist in the first room
      And Payment and Plan - Waiting to be matched text is displayed for the first room

    @visual
    Scenario: Couples therapy - AARP (Out of Network) - Offer page
      And Continue with "AARP" insurance provider
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      And Complete out of network validation form for primary user
        | age       | 18             |
        | state     | MT             |
        | Member ID | OUT_OF_NETWORK |
      Then Shoot baseline

  Rule: Unsupported service
  Customers are not offered Couples therapy through this insurance company

    Scenario: Couples therapy - BH - Unsupported service
      When Continue with "UMR" insurance provider
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
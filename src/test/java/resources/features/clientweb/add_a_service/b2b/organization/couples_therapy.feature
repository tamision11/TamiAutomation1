Feature: Client web - Add a service
  Leads to flow 67

  Background:
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | MT |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    When Open account menu
    Then Account Menu - Select add a new service
    And Select COUPLES_THERAPY service
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
      | state                                                             | Continue with prefilled state     |
    And Click on I have talkspace through an organization

  Scenario: Couples therapy - DTE - Unsupported service
    When Write "google" in organization name
    When Click on next button
    And Enter RANDOM email
    And Click on next button
    And Click on secure your match button
    And Select the first plan
    And Continue with "3 Months" billing period
    And Apply free coupon if running on prod
    And Payment - Click on continue
    And Payment - Complete purchase using "visa" card for primary user
    And Click on continue to room button
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Couples Therapy with Live Session - Quarterly |

  Scenario: Couples therapy - EAP - Mines (Teens)
    When Write "mines" in organization name
    When Click on next button
    And Enter RANDOM email
    And Click on next button
    And Complete eap validation form for primary user
      | age               | 18       |
      | employee Relation | EMPLOYEE |
    And Click on continue on coverage verification
    And Click on secure your match button
    And Eligibility Widget - Click on start treatment button
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                                | Mines EAP 5 Sessions Messaging or Live Session Voucher |
      | credit description                       | credit amount                                          |
      | 5 x Therapy live sessions (30 or 45 min) | 1                                                      |

  Scenario: Couples therapy - EAP - Cigna
  on test environments (dev/canary):
  - "cignawellbeingprogram3" organization keyword is mapped to 3 sessions and is automatically sent when the organization keyword is not sent.
  - "cigna" organization keyword is mapped to 5 sessions.
  - selecting a different number of sessions from the session selection dropdown will have no affect, only these organization keywords will affect the number of sessions.
  - not using onboarding dismiss modal on ORG flows background since it messes up plan\credits assignment later
    When Write "cigna" in organization name
    When Click on next button
    And Enter RANDOM email
    And Click on next button
    And Complete cigna eap validation form for primary user
      | age                           | 18          |
      | authorization code            | MOCK_CIGNA  |
      | employee Relation             | EMPLOYEE    |
      | state                         | MT          |
      | session number                | 5           |
      | authorization code expiration | future date |
    And Click on continue on coverage verification
    And Click on secure your match button
    And Eligibility Widget - Click on start treatment button
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                          | Cigna EAP 5 Sessions Messaging and Live Session Voucher |
      | credit description                 | credit amount                                           |
      | 5 x Therapy live sessions (45 min) | 1                                                       |
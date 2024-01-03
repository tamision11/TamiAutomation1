@owner=tami
Feature: Client web - Registration - MBA and Onboarding

  Scenario: MBA - Before match - Book live first session - Therapy - EAP - Live + messaging plan - Non-Live state - Live preferences
  it is mandatory to sign 2fa in order to get only 1 task banner
    Given Navigate to flow44
    When Complete shared validation form for primary user
      | age               | 18       |
      | organization      | aetna    |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | state             | WY       |
      | phone number      |          |
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
    And QM - Select VIDEO as first Live booking modality for B2B_EAP plan
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on continue button
    And MBA - Book first THERAPY live VIDEO session with LIVE_PREFERENCE selection
    And Onboarding - Click on meet your provider button
    And Onboarding - Click on close button
    And “Next Live session is scheduled for“ banner appears
    And Client API - The first room status of primary user is ACTIVE

  Scenario: MBA - Before match - Book live first session - Therapy - EAP - Messaging only plan - Live state
  it is mandatory to sign 2fa in order to get only 1 task banner
    Given Navigate to flow44
    When Complete shared validation form for primary user
      | age               | 18                 |
      | organization      | aetnaMessagingOnly |
      | service type      | THERAPY            |
      | Email             | PRIMARY            |
      | employee Relation | EMPLOYEE           |
      | state             | MT                 |
      | phone number      |                    |
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
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on continue button
    And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
    And Onboarding - Click on meet your provider button
    And Onboarding - Click on close button
    And “Next Live session is scheduled for“ banner appears
    And Client API - The first room status of primary user is ACTIVE

  Rule: add a new service

    Background:
      Given Therapist API - Login to therapist provider
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | MT |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click continue on book first session
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Client API - Cancel Subscription of primary user in the first room
      And Client API - Refund Charge of primary user
      When Open account menu
      Then Account Menu - Select add a new service

    Scenario: MBA - Before match - Book live first session - add a new service - EAP - Live + messaging plan - Live state
    it is mandatory to sign 2fa in order to get only 1 task banner
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
      And Onboarding - Click continue on book first session
      And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And “Next Live session is scheduled for“ banner appears
      And Client API - The first room status of primary user is ACTIVE
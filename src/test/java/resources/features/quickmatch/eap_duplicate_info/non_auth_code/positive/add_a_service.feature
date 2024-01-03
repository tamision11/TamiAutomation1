Feature: QM - EAP duplicate info

  Background:
    Given Navigate to flow44
    When Complete shared validation form for primary user
      | age               | 18       |
      | organization      | aetna    |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
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
    When Open account menu

  Scenario: Existing member information - Add a service of different payer (from Aetna EAP to Cigna EAP)
  Aetna member can add non Aetna service with existing member information
    Then Account Menu - Select add a new service
    And Select THERAPY service
    And Select to pay through an organization
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | age                                                | 18                             |
      | state                                              | Continue with prefilled state  |
    And Click on secure your match button
    When Write "cigna" in organization name
    When Click on next button
    And Enter RANDOM email
    And Click on next button
    Given Set primary user last name to Automation
    And Complete cigna eap validation form for primary user
      | birthdate                     | consumer    |
      | authorization code            | MOCK_CIGNA  |
      | employee Relation             | EMPLOYEE    |
      | session number                | 5           |
      | state                         | MT          |
      | authorization code expiration | future date |
    And Click on continue on coverage verification
    And Eligibility Widget - Click on start treatment button
    Then Client API - The room count of primary user is 2

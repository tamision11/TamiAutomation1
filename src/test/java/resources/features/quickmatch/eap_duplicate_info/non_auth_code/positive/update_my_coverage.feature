@owner=tami_sion
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

  Scenario: Existing member information - Update coverage of different payer (from Aetna EAP to Premera BH)
  Aetna member can update BH coverage with existing member information
    And Account Menu - Select payment and plan
    And Payment and Plan - Click on the update my coverage button
    And Update my coverage - Click on continue button
    And Update my coverage - Select to pay through insurance provider
    And Continue with "Premera" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | birthdate | consumer |
      | state     | MT       |
      | age       | 18       |
      | Member ID | COPAY_0  |
    And Click on continue on coverage verification
    And Update my coverage - Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    Given Set primary user last name to Automation
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
    And Payment - Complete purchase using "visa" card for primary user
    And Update my coverage - Click on go to my new room
    Then Client API - The room count of primary user is 2
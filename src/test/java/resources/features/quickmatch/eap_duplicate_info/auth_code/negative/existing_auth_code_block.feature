@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-3007
Feature: QM - EAP duplicate info

  Scenario: Existing auth code validation - Registration - Direct flow - Optum
    Given Navigate to flow62
    When Complete optum eap validation form for primary user
      | age                           | 18          |
      | authorization code            | EXISTING    |
      | session number                | 12+         |
      | service type                  | THERAPY     |
      | Email                         | PRIMARY     |
      | employee Relation             | EMPLOYEE    |
      | state                         | MT          |
      | phone number                  |             |
      | authorization code expiration | future date |
    And Click on Let's start button
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
    Then Invalid auth code message is displayed

  Scenario: Existing auth code validation - Registration - Flow 90 - Cigna - Validation with auth code via access code page
    Given Navigate to flow90
    When Select THERAPY service
    And Select to pay through an organization
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | age                                                | 18                             |
      | state                                              | MT                             |
    And Click on secure your match button
    And Email wall - Click on continue after Inserting PRIMARY email
    And Write "test" in organization name
    And Click on next button
    And Enter RANDOM email
    And Click on next button
    And Click on I have a keyword or access code button
    When Enter EXISTING authorization code
    When Click on next button
    When Complete cigna eap validation form for primary user
      | age                           | 18                                  |
      | session number                | 3                                   |
      | Email                         | PRIMARY                             |
      | employee Relation             | ADULT_DEPENDENT_MEMBER_OF_HOUSEHOLD |
      | state                         | MT                                  |
      | phone number                  |                                     |
      | authorization code expiration | future date                         |
    And Click on continue on coverage verification
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
    Then Invalid auth code message is displayed

  Scenario: Existing auth code validation - Registration - Flow 90 - Optum - Validation With organization name
    Given Navigate to flow90
    When Select THERAPY service
    And Select to pay through an organization
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | age                                                | 18                             |
      | state                                              | MT                             |
    And Click on secure your match button
    And Email wall - Click on continue after Inserting PRIMARY email
    When Write "optumEAPWithVideo" in organization name
    When Click on next button
    And Enter RANDOM email
    And Click on next button
    When Complete optum eap validation form for primary user
      | age                           | 18          |
      | authorization code            | EXISTING    |
      | session number                | 12+         |
      | service type                  | THERAPY     |
      | Email                         | PRIMARY     |
      | employee Relation             | EMPLOYEE    |
      | state                         | MT          |
      | phone number                  |             |
      | authorization code expiration | future date |
    And Click on continue on coverage verification
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
    Then Invalid auth code message is displayed

  Scenario: Existing auth code validation - Registration - Eligibility questions on landing page - Optum
    Given Navigate to Eligibility questions landing page
    And Landing page - Select THERAPY service
    And Landing page - Select MT state
    And Landing page - Select "I have Talkspace through an organization"
    And Landing page - Click getting started button
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | provider gender                                    | Male                           |
      | your gender                                        | Female                         |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | age                                                | 18                             |
    And Write "test" in organization name
    And Click on next button
    And Enter RANDOM email
    And Click on next button
    And Click on I have a keyword or access code button
    When Enter EXISTING authorization code
    When Click on next button
    When Complete optum eap validation form for primary user
      | age                           | 18          |
      | session number                | 12+         |
      | service type                  | THERAPY     |
      | Email                         | PRIMARY     |
      | employee Relation             | EMPLOYEE    |
      | state                         | MT          |
      | phone number                  |             |
      | authorization code expiration | future date |
    And Click on continue on coverage verification
    And Click on secure your match button
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
    Then Invalid auth code message is displayed

  Scenario: Existing auth code validation - Reactivation - Optum
    Given Therapist API - Login to therapist provider
    Given Client API - Create EAP room to primary user with therapist provider
      | flowId            | 9                                 |
      | age               | 18                                |
      | keyword           | nottinghamhealthandrehabilitation |
      | employee Relation | EMPLOYEE                          |
      | state             | MT                                |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Dismiss modal
    And Client API - Cancel a non paying subscription of primary user in the first room
    And Navigate to payment and plan URL
    And Click on Undo cancellation
    And Click on continue
    And Reactivation - Select THERAPY service
    And Select to pay through an organization
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Male                           |
      | provider gender                                    | Male                           |
      | age                                                | 18                             |
      | state                                              | Continue with prefilled state  |
    When Click on Match with a new provider
    And Click on secure your match button
    When Reactivation - Write "optumEAPWithVideo" in organization name
    When Click on next button
    And Enter RANDOM email
    And Click on next button
    When Complete optum eap validation form for primary user
      | age                           | 18          |
      | authorization code            | EXISTING    |
      | session number                | 12+         |
      | employee Relation             | EMPLOYEE    |
      | state                         | MT          |
      | authorization code expiration | future date |
    And Click on continue on coverage verification
    And Eligibility Widget - Click on start treatment button
    Then Invalid auth code message is displayed

  Scenario: Existing auth code validation - Add a service - Cigna
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | MT |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Dismiss modal
    When Open account menu
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
    And Complete cigna eap validation form for primary user
      | age                           | 18          |
      | authorization code            | EXISTING    |
      | employee Relation             | EMPLOYEE    |
      | state                         | MT          |
      | session number                | 5           |
      | authorization code expiration | future date |
    Then Invalid auth code message is displayed

  Scenario: Existing auth code validation - Update my coverage - Optum
    Given Navigate to flow70
    When Complete shared validation form for primary user
      | age               | 18       |
      | Member ID         | COPAY_25 |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
      | phone number      |          |
    And Click on next button to approve you are ready to begin
    And Complete the matching questions with the following options
      | seek help reason                   | I'm feeling anxious or panicky |
      | got it                             |                                |
      | provider gender preference         | I'm not sure yet               |
      | have you been to a provider before | No                             |
      | sleeping habits                    | Good                           |
      | physical health                    | Fair                           |
      | your gender                        | Male                           |
      | state                              | Continue with prefilled state  |
    And Click on secure your match button
    And Click on continue on coverage verification
    And Payment - Complete purchase using "visa" card for primary user
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
      | checkbox |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on continue button
    And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
    And Onboarding - Click on meet your provider button
    And Onboarding - Click on close button
    And Open account menu
    And Account Menu - Select payment and plan
    And Payment and Plan - Click on the update my coverage button
    And Update my coverage - Click on continue button
    And Update my coverage - Select to pay through an organization
    And Update my coverage - Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | age                                                | 18                             |
      | state                                              | Continue with prefilled state  |
    When Write "optumEAPWithVideo" in organization name
    When Click on next button
    And Enter RANDOM email
    And Click on next button
    When Complete optum eap validation form for primary user
      | age                           | 18          |
      | authorization code            | EXISTING    |
      | session number                | 12+         |
      | service type                  | THERAPY     |
      | Email                         | PRIMARY     |
      | employee Relation             | EMPLOYEE    |
      | state                         | MT          |
      | authorization code expiration | future date |
    And Click on continue on coverage verification
    Then Invalid auth code message is displayed

  @visual
  Scenario: Existing auth code validation - Update my coverage - Optum - error screen
    Given Navigate to flow70
    When Complete shared validation form for primary user
      | age               | 18       |
      | Member ID         | COPAY_25 |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
      | phone number      |          |
    And Click on next button to approve you are ready to begin
    And Complete the matching questions with the following options
      | seek help reason                   | I'm feeling anxious or panicky |
      | got it                             |                                |
      | provider gender preference         | I'm not sure yet               |
      | have you been to a provider before | No                             |
      | sleeping habits                    | Good                           |
      | physical health                    | Fair                           |
      | your gender                        | Male                           |
      | state                              | Continue with prefilled state  |
    And Click on secure your match button
    And Click on continue on coverage verification
    And Payment - Complete purchase using "visa" card for primary user
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
      | checkbox |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on continue button
    And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
    And Onboarding - Click on meet your provider button
    And Onboarding - Click on close button
    And Open account menu
    And Account Menu - Select payment and plan
    And Payment and Plan - Click on the update my coverage button
    And Update my coverage - Click on continue button
    And Update my coverage - Select to pay through an organization
    And Update my coverage - Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | age                                                | 18                             |
      | state                                              | Continue with prefilled state  |
    When Write "optumEAPWithVideo" in organization name
    When Click on next button
    And Enter RANDOM email
    And Click on next button
    When Complete optum eap validation form for primary user
      | age                           | 18          |
      | authorization code            | EXISTING    |
      | session number                | 12+         |
      | service type                  | THERAPY     |
      | Email                         | PRIMARY     |
      | employee Relation             | EMPLOYEE    |
      | state                         | MT          |
      | authorization code expiration | future date |
    And Click on continue on coverage verification
    Then Shoot baseline

  @visual
  Scenario: Existing auth code validation - Registration - Optum - error screen
    Given Navigate to flow62
    When Complete optum eap validation form for primary user
      | age                           | 18          |
      | authorization code            | EXISTING    |
      | session number                | 12+         |
      | service type                  | THERAPY     |
      | Email                         | PRIMARY     |
      | employee Relation             | EMPLOYEE    |
      | state                         | MT          |
      | phone number                  |             |
      | authorization code expiration | future date |
    And Click on Let's start button
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
    Then Shoot baseline


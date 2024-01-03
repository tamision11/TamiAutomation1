@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-3009
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-3010
Feature: QM - EAP duplicate info

  Rule: Non Auth code - Add a service + Update my coverage + Reactivation - Aetna

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

    Scenario: Existing member information - Add a service (from Aetna EAP to Aetna EAP)
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
      When Write "aetna" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      Given Set primary user last name to Automation
      When Complete shared validation form for primary user
        | birthdate         | consumer |
        | organization      | aetna    |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
      And Click on continue on coverage verification
      And Eligibility Widget - Click on start treatment button
      Then Invalid auth code message is displayed

    Scenario: Existing member information - Update my coverage (from Aetna EAP to Aetna EAP)
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
      When Write "aetna" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      Given Set primary user last name to Automation
      When Complete shared validation form for primary user
        | birthdate         | consumer |
        | organization      | aetna    |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
      And Click on continue on coverage verification
      Then Invalid auth code message is displayed

    Scenario: Existing member information - Reactivation (from Aetna EAP to Aetna EAP)
      And Client API - Cancel a non paying subscription of primary user in the first room
      And Refresh the page
      When Click on Resubscribe to continue therapy
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
      When Reactivation - Write "aetna" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      Given Set primary user last name to Automation
      When Complete shared validation form for primary user
        | birthdate         | consumer |
        | organization      | aetna    |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
      And Click on continue on coverage verification
      And Eligibility Widget - Click on start treatment button
      Then Invalid auth code message is displayed

    @visual
    Scenario: Existing member information - Update my coverage (from Aetna EAP to Aetna EAP) - error screen
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
      When Write "aetna" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      Given Set primary user last name to Automation
      When Complete shared validation form for primary user
        | birthdate         | consumer |
        | organization      | aetna    |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
      And Click on continue on coverage verification
      Then Shoot baseline


  Rule: Non Auth code - Update my coverage - Carelon

    Background:
      Given Navigate to flow98
      When Complete carelon eap validation form for primary user
        | age               | 18       |
        | organization      | carelon  |
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

    Scenario: Existing member information - Update my coverage (from Carelon EAP to Carelon EAP)
      When Open account menu
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
        | state                                              | MT                             |
      And Write "carelon" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      Given Set primary user last name to Automation
      When Complete carelon eap validation form for primary user
        | birthdate         | consumer |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
      And Click on continue on coverage verification
      Then Invalid auth code message is displayed

  Rule: Non Auth code - Registration

    Background:
      Given Set primary user last name to Automation

    Scenario: Existing member information - Registration - Direct flow - Aetna
      Given Navigate to flow44
      When Complete shared validation form for primary user
        | birthdate         | consumer |
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
        | state                              | MT                             |
      And Click on secure your match button
      And Click on continue on coverage verification
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      Then Invalid auth code message is displayed

    @issue=talktala.atlassian.net/browse/PLATFORM-4159
    Scenario: Existing member information - Registration - Flow 90 - Carelon
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
      And Write "carelon" in organization name
      And Click on next button
      And Enter RANDOM email
      When Click on next button
      When Complete carelon eap validation form for primary user
        | birthdate         | consumer |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | phone number      |          |
        | state             | MT       |
      And Click on continue on coverage verification
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      Then Invalid auth code message is displayed

    @issue=talktala.atlassian.net/browse/PLATFORM-3909
    Scenario: Existing member information - Registration - Eligibility questions on landing page - Carelon
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
      And Write "carelon" in organization name
      And Click on next button
      And Enter RANDOM email
      When Click on next button
      When Complete carelon eap validation form for primary user
        | birthdate         | consumer |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
        | phone number      |          |
      And Click on continue on coverage verification
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      Then Invalid auth code message is displayed

    @visual
    Scenario: Existing member information - Registration - Direct flow - Aetna - error screen
      Given Navigate to flow44
      When Complete shared validation form for primary user
        | birthdate         | consumer |
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
        | state                              | MT                             |
      And Click on secure your match button
      And Click on continue on coverage verification
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      Then Shoot baseline
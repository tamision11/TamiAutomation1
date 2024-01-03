@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2750
Feature: QM - B2B - EAP
  Leads to flow 2

  Background:
    Given Navigate to flow98

  @smoke @sanity
  Scenario: Flow 98 - Carelon - Employee - Therapy
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
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                          | Carelon Wellbeing 6 Sessions with Live Sessions Voucher |
      | credit description                 | credit amount                                           |
      | 6 x Therapy live sessions (45 min) | 1                                                       |
    And Payment and Plan - Waiting to be matched text is displayed for the first room

  Scenario: Flow 98 - Carelon - Spouse or dependent - address is the same as mine - Therapy
    When Complete carelon eap validation form for primary user
      | age                                    | 18             |
      | organization                           | carelon        |
      | service type                           | THERAPY        |
      | Email                                  | PRIMARY        |
      | employee Relation                      | SPOUSE_PARTNER |
      | state                                  | MT             |
      | first name                             |                |
      | last name                              |                |
      | Employee’s address is the same as mine |                |
      | phone number                           |                |
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
      | plan name                          | Carelon Wellbeing 6 Sessions with Live Sessions Voucher |
      | credit description                 | credit amount                                           |
      | 6 x Therapy live sessions (45 min) | 1                                                       |
    And Payment and Plan - Waiting to be matched text is displayed for the first room

  Scenario: Flow 98 - Carelon - Spouse or dependent - Therapy
    Then Options of the second dropdown are
      | Employee                            |
      | Spouse/partner                      |
      | Adult dependent/Member of household |
    When Complete carelon eap validation form for primary user
      | age               | 18                                  |
      | organization      | carelon                             |
      | service type      | THERAPY                             |
      | Email             | PRIMARY                             |
      | employee Relation | ADULT_DEPENDENT_MEMBER_OF_HOUSEHOLD |
      | state             | MT                                  |
      | first name        |                                     |
      | last name         |                                     |
      | phone number      |                                     |
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
      | plan name                          | Carelon Wellbeing 6 Sessions with Live Sessions Voucher |
      | credit description                 | credit amount                                           |
      | 6 x Therapy live sessions (45 min) | 1                                                       |
    And Payment and Plan - Waiting to be matched text is displayed for the first room
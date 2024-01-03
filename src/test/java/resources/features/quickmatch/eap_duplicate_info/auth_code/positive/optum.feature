@owner=nir_tal
Feature: QM - EAP duplicate info

  Background:
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

  Scenario: New auth code validation - Registration - Flow 90 - Optum EAP
  this flow verifies real unique optum authorization code
    When Write "optumEAPWithVideo" in organization name
    When Click on next button
    And Enter RANDOM email
    And Click on next button
    When Complete optum eap validation form for primary user
      | age                           | 18          |
      | authorization code            | OPTUM       |
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
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                           | Optum EAP 16 Sessions With Live Session |
      | credit description                  | credit amount                           |
      | 16 x Therapy live sessions (45 min) | 1                                       |
    And Payment and Plan - Waiting to be matched text is displayed for the first room
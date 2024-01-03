@owner=tami_sion
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2819
@visual
Feature: QM - plan clarification
  relevant for EAP and BH (automatic) flows only (Flow 90 and direct flows)

  Background:
    Given Navigate to flow90
    When Select THERAPY service

  Scenario: EAP - plan clarification
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
    When Enter MOCK_OPTUM authorization code
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
    Then Shoot baseline "EAP - plan clarification"

  Scenario: BH - plan clarification
    And Select to pay through insurance provider
    And Continue with "Premera" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18      |
      | state     | MT      |
      | Member ID | COPAY_0 |
    Then Shoot baseline "BH - plan clarification"
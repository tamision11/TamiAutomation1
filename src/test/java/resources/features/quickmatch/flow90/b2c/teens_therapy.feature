@owner=nir_tal
@tmslink=talktala.atlassian.net/browse/AUTOMATION-3039
Feature: QM - Flow 90
  Leads to flow 97

  Background:
    Given Navigate to flow90
    When Select TEEN_THERAPY service
    And Complete the matching questions with the following options
      | does your school or city offer talkspace for free | I’ll use a different form of coverage |
    And Select to pay out of pocket
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | age                                                | 13                             |
      | Parental consent                                   | Yes                            |
      | state                                              | MT                             |
    And Click on secure your match button
    And Email wall - Click on continue after Inserting PRIMARY email

  @smoke @sanity
  @issue=talktala.atlassian.net/browse/MEMBER-3075
  Scenario: B2C - Teen therapy - US
  this scenario also verify that SMS checkbox on registration is not mandatory by not checking it.
    When Select the second plan
    And Continue with "Monthly" billing period
    And Apply free coupon if running on prod
    And Payment - Click on continue
    And B2C Payment - Complete purchase using visa card with stripe link false
    And Create account for primary user with
      | password     | STRONG |
      | nickname     | VALID  |
      | phone number |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Messaging Only Therapy - Monthly |
    And No credits exist in the first room
    And Payment and Plan - Waiting to be matched text is displayed for the first room
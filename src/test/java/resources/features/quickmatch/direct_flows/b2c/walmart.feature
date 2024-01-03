@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2793
Feature: QM - B2C - Walmart flow

  @visual
  Scenario: B2C - Walmart flow - Walmart coupon applied
    Given Navigate to flow106
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Excellent                      |
      | your gender                                        | Male                           |
      | provider gender preference                         | Female                         |
      | age                                                | 18                             |
      | state                                              | MT                             |
    And Click on secure your match button
    When Click on show results after Inserting PRIMARY email
    When Select the second plan
    And Continue with "6 Months" billing period
    And Apply WALMART coupon
    And Shoot baseline

  @smoke @sanity
  Scenario: Walmart flow
    Given Navigate to flow106
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Excellent                      |
      | your gender                                        | Male                           |
      | provider gender preference                         | Female                         |
      | age                                                | 18                             |
      | state                                              | MT                             |
    And Click on secure your match button
    When Click on show results after Inserting PRIMARY email
    When Select the second plan
    And Continue with "6 Months" billing period
    And Apply WALMART coupon
    Then Payment - Click on continue
    And B2C Payment - Complete purchase using visa card with stripe link false
    And Create account for primary user with
      | password     | STRONG |
      | nickname     | VALID  |
      | checkbox     |        |
      | phone number |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Messaging Only Therapy - Biannual |
    And No credits exist in the first room
    And Payment and Plan - Waiting to be matched text is displayed for the first room
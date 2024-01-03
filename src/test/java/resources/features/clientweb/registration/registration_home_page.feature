Feature: Client web - Registration

  Background:
    Given Navigate to home page
    When Registration Home Page - Click on get started button

  @smoke
  Example: Home Page - Couples registration
    When Select COUPLES_THERAPY service
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider - multi select | Decide whether we should separate |
      | looking for a provider that will                                  | Teach new skills                  |
      | have you been to a provider before                                | Yes                               |
      | live with your partner                                            | Yes                               |
      | type of relationship                                              | Straight                          |
      | domestic violence                                                 | No                                |
      | ready                                                             | We're ready now                   |
      | your gender                                                       | Male                              |
      | provider gender                                                   | Male                              |
      | age                                                               | 18                                |
      | state                                                             | MT                                |
    And Continue without insurance provider after selecting "I’ll pay out of pocket"
    And Click on secure your match button
    And Email wall - Click on continue after Inserting PRIMARY email
    And Select the first plan
    And Continue with "3 Months" billing period
    And Apply free coupon if running on prod
    And Payment - Click on continue
    And Payment - Complete purchase using "visa" card for primary user
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
      | plan name | Couples Therapy with Live Session - Quarterly |
    And No credits exist in the first room
    And Payment and Plan - Waiting to be matched text is displayed for the first room

  @sanity @smoke
  Example: Home Page - Therapy registration
    When Select THERAPY service
    And Select to pay out of pocket
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Male                           |
      | provider gender                                    | Male                           |
      | age                                                | 18                             |
      | state                                              | MT                             |
    And Click on secure your match button
    And Email wall - Click on continue after Inserting PRIMARY email
    When Select the second plan
    And Continue with "Monthly" billing period
    And Apply free coupon if running on prod
    And Payment - Click on continue
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
      | plan name | Messaging Only Therapy - Monthly |
    And No credits exist in the first room
    And Payment and Plan - Waiting to be matched text is displayed for the first room

  @issue=talktala.atlassian.net/browse/MEMBER-3075
  Example: Home Page - Teen therapy registration
    Given Create "parent" user
    When Select TEEN_THERAPY service
    And Complete the matching questions with the following options
      | does your school or city offer talkspace for free | I’ll use a different form of coverage |
    And Select to pay out of pocket
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Male                           |
      | provider gender                                    | Male                           |
      | age                                                | 13                             |
      | Parental consent                                   | Yes                            |
      | state                                              | WY                             |
    And Click on secure your match button
    And Email wall - Click on continue after Inserting PRIMARY email
    When Select the second plan
    And Continue with "Monthly" billing period
    And Apply free coupon if running on prod
    And Payment - Click on continue
    And Payment - Complete purchase using "visa" card for primary user
    And Create account for primary user with
      | password     | STRONG |
      | nickname     | VALID  |
      | checkbox     |        |
      | phone number |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Complete treatment intake for teen primary user with "parent" parental consent
    And Onboarding - Click on close button
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Messaging Only Therapy - Monthly |
    And No credits exist in the first room
    And Payment and Plan - Waiting to be matched text is displayed for the first room

  @smoke
  Example: Home Page - Psychiatry registration
    When Select PSYCHIATRY service
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider       | Anxiety |
      | prescribed medication to treat a mental health condition | Yes     |
      | your gender                                              | Male    |
      | provider gender                                          | Male    |
      | age                                                      | 18      |
      | state                                                    | MT      |
    And Continue without insurance provider after selecting "I’ll pay out of pocket"
    And Click on secure your match button
    And Email wall - Click on continue after Inserting PRIMARY email
    And Select the first plan
    When Payment - Click on continue
    And Payment - Complete purchase using "visa" card for primary user
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
      | plan name | Psychiatry - Initial Evaluation + 1 follow up session |
    And No credits exist in the first room
    And Payment and Plan - Waiting to be matched text is displayed for the first room
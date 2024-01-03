@owner=nir_tal
@tmslink=talktala.atlassian.net/browse/AUTOMATION-3039
Feature: QM - Flow 90

  Background:
    Given Navigate to flow90
    When Select TEEN_THERAPY service
    And Complete the matching questions with the following options
      | does your school or city offer talkspace for free | Yes, I think so |

  Scenario: Therapy - Organization - Broadway - Eligible for voucher
    And Complete broadway validation form for primary user
      | age     | 13      |
      | Email   | PRIMARY |
      | address | NYC     |
    And Teens NYC - Click on continue button
    And Teens NYC - Click on continue button
    And Complete the matching questions with the following options
      | how often do you feel stressed | Very often          |
      | what do you need support with  | Anxiety or worrying |
    And Teens NYC - Click on continue button
    And Complete the matching questions with the following options
      | have you talked to your parent or guardian about doing therapy | Yes |
    And Teens NYC - Click on continue button
    And Complete the matching questions with the following options
      | how do you feel about doing therapy | Nervous, Calm |
      | your gender                         | Male          |
      | provider gender preference          | Male          |
    And Select non-english as preferred language
    And Select non-english as soft filter
    And Teens NYC - Click on continue button
    And Create account for primary user with
      | password     | STRONG |
      | nickname     | VALID  |
      | phone number |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                         | Unlimited messaging + 1 live session per month |
      | credit description                | credit amount                                  |
      | 1 x Therapy live session (30 min) | 1                                              |
    And Payment and Plan - Waiting to be matched text is displayed for the first room

  @issue=talktala.atlassian.net/browse/MEMBER-3075
  Scenario: Therapy - Organization - Broadway - Not eligible for voucher due to address - Switch to B2C flow
    And Complete broadway validation form for primary user
      | age     | 13      |
      | Email | PRIMARY |
      | state | MT      |
    And Select to pay out of pocket
    And Complete the matching questions with the following options
      | what do you need support with | Anxiety or worrying           |
      | sleeping habits               | Good                          |
      | physical health               | Fair                          |
      | your gender                   | Female                        |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Click on secure your match button
    And Email wall - Click on continue button
    When Select the second plan
    And Continue with "Monthly" billing period
    And Apply free coupon if running on prod
    And Payment - Click on continue
    And Payment - Complete purchase using "visa" card for primary user
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

  @issue=talktala.atlassian.net/browse/MEMBER-3075
  Scenario: Therapy - Organization - Broadway - Not eligible for voucher due to age - Switch to B2C flow
    And Complete broadway validation form for primary user
      | age     | 18      |
      | Email   | PRIMARY |
      | address | NYC     |
    And Select to pay out of pocket
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits               | Good                          |
      | physical health               | Fair                          |
      | your gender                   | Female                        |
      | provider gender                                    | Male                           |
      | state                                              | MT                             |
    And Click on secure your match button
    And Email wall - Click on continue button
    When Select the second plan
    And Continue with "Monthly" billing period
    And Apply free coupon if running on prod
    And Payment - Click on continue
    And Payment - Complete purchase using "visa" card for primary user
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
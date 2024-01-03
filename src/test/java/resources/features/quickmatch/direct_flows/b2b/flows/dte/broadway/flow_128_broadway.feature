@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-3039
Feature: QM - B2B - DTE

  Background:
    Given Navigate to flow128

  @visual
  Scenario: Flow 128 - Broadway - Visual regression
    And Shoot baseline "Flow 128 - Broadway - Validation Form"
    And Complete broadway validation form for primary user
      | age     | 13      |
      | Email   | PRIMARY |
      | address | NYC     |
    And Shoot baseline "Flow 128 - Broadway - You Got free therapy through NYC"
    And Teens NYC - Click on continue button
    And Shoot baseline "Flow 128 - Broadway - le'ts learn more about you"
    And Teens NYC - Click on continue button
    And Shoot baseline "Flow 128 - Broadway - how often do you feel stressed?"
    And Complete the matching questions with the following options
      | how often do you feel stressed | Very often |
    And Shoot baseline "Flow 128 - Broadway - what do you need support with?"
    And Complete the matching questions with the following options
      | what do you need support with | Anxiety or worrying |
    And Shoot baseline "Flow 128 - Broadway - your not alone"
    And Teens NYC - Click on continue button
    And Shoot baseline "Flow 128 - Broadway - have you talked to your parent or guardian about doing therapy?"
    And Complete the matching questions with the following options
      | have you talked to your parent or guardian about doing therapy | Yes |
    And Shoot baseline "Flow 128 - Broadway - you may need consent to start"
    And Teens NYC - Click on continue button
    And Shoot baseline "Flow 128 - Broadway - how do you feel about doing therapy?"
    And Complete the matching questions with the following options
      | how do you feel about doing therapy | Nervous |

  Rule: Eligible for voucher - School from list

    Background:
      And Complete broadway validation form for primary user
        | age     | 13          |
        | Email   | PRIMARY     |
        | address | NYC         |
        | school  | Home school |
      And Teens NYC - Click on continue button
      And Teens NYC - Click on continue button
      And Complete the matching questions with the following options
        | how often do you feel stressed | Very often                                 |
        | what do you need support with  | Anxiety or worrying, Sadness or depression |
      And Teens NYC - Click on continue button
      And Complete the matching questions with the following options
        | have you talked to your parent or guardian about doing therapy | Yes |

    Scenario: Flow 128 - Broadway - See consent exceptions
    waiting for redirect URL to be fixed
      And Teens NYC - Click on See consent exceptions
      And Switch focus to the second tab
      Then Current url should match "https://help.talkspace.com/hc/en-us/articles/18167691776027"

    @smoke @sanity
    Scenario: Flow 128 - Broadway - Eligible for voucher
      And Teens NYC - Click on continue button
      And Complete the matching questions with the following options
        | how do you feel about doing therapy | Nervous |
        | your gender                         | Male    |
        | provider gender preference          | Male    |
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

  Rule: Not eligible for voucher

    @issue=talktala.atlassian.net/browse/MEMBER-3057
    Scenario: Flow 128 - Broadway - Not eligible for voucher due to address - Switch to B2C teens flow
      And Complete broadway validation form for primary user
        | age   | 13      |
        | Email | PRIMARY |
        | state | MT      |
      And Select to pay out of pocket
      And Complete the matching questions with the following options
        | what do you need support with | Anxiety or worrying           |
        | sleeping habits               | Good                          |
        | physical health               | Fair                          |
        | your gender                   | Female                        |
        | provider gender               | Male                          |
        | state                         | Continue with prefilled state |
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

    Scenario: Flow 128 - Broadway - Not eligible for voucher due to age - Switch to B2C teens flow
      And Complete broadway validation form for primary user
        | age     | 18      |
        | Email   | PRIMARY |
        | address | NYC     |
      And Select to pay out of pocket
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
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
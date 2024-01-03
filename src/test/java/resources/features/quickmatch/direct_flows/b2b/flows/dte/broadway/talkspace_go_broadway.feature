@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-3086
Feature: QM - B2B - DTE

  Background:
    Given Navigate to talkspace go

  Rule: Learn the fundamentals first

    Background:
      And Talkslace Go - Click on Learn the fundamentals first

    Scenario: Talkspace Go - Broadway - Not eligible for voucher - Continue without coverage
      And Talkslace Go - Complete validation form for primary user
        | age     | 18  |
        | address | NYC |
      And Talkslace Go - Click on I wasn't given a keyword
      And Talkslace Go - Complete validation form for primary user
        | age   | 13 |
        | state | MT |
      And Talkslace Go - Click on I wasn't given a keyword
      And Talkslace Go - Complete validation form for primary user
        | age     | 13  |
        | address | NYC |
      And Current url should contain "https://go.dev.talkspace.com/confirm"

    @issue=talktala.atlassian.net/browse/TSG-349
    @sanity
    Scenario: Talkspace Go - Broadway - Eligible for voucher - Create TSG account
      And Talkslace Go - Complete validation form for primary user
        | age     | 13  |
        | address | NYC |
      And Talkslace Go - Click on Continue
      And Talkslace Go - Create account
        | password | STRONG  |
        | Email    | PRIMARY |
      And Talkslace Go - Click on Continue
      And Talkslace Go - Complete the matching questions
      And Current url should contain "talkspace.com/quiz/results"

  Rule: Get matched with a therapist

    Background:
      And Talkslace Go - Click on Get matched with a therapist
      And Complete broadway validation form for primary user
        | age     | 13      |
        | Email   | PRIMARY |
        | address | NYC     |
        | school  | other   |
      And Teens NYC - Click on continue button
      And Teens NYC - Click on continue button
      And Complete the matching questions with the following options
        | how often do you feel stressed | Very often                                 |
        | what do you need support with  | Anxiety or worrying, Sadness or depression |
      And Teens NYC - Click on continue button
      And Complete the matching questions with the following options
        | have you talked to your parent or guardian about doing therapy | Yes |

    Scenario: Talkslace Go - Broadway - Eligible for voucher - Other school
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
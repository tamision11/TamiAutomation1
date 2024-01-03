@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2781
Feature: Landing pages

  Background:
    Given Navigate to Eligibility by email landing page
    And Landing page - Click getting started after entering primary user email

  @visual
  Scenario: B2B - Eligibility by email via landing page - Visual regression
    And Shoot baseline

  @smoke @sanity
  Scenario: B2B - Eligibility by email via landing page
    And Mailinator API - Go to link on primary user email
      | subject          | Hello from Talkspace! |
      | surrounding text | Get started           |
    And Click on Let's start button
    And Complete the matching questions with the following options
      | age                                | 18                             |
      | seek help reason                   | I'm feeling anxious or panicky |
      | got it                             |                                |
      | provider gender preference         | I'm not sure yet               |
      | have you been to a provider before | No                             |
      | sleeping habits                    | Good                           |
      | physical health                    | Fair                           |
      | your gender                        | Female                         |
      | state                              | MT                             |
    And Click on secure your match button
    And Create account for primary user with
      | email        | PRIMARY |
      | password     | STRONG  |
      | nickname     | VALID   |
      | phone number |         |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                               | Allan Myers 3 Months Messaging Only Voucher |
      | credit description                      | credit amount                               |
      | 1 x Complimentary live session (10 min) | 1                                           |
    And Payment and Plan - Waiting to be matched text is displayed for the first room
@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2823
Feature: QM - B2B - Manual BH

  Background:
    Given Navigate to flow119

  Rule: Psychiatry

    Background:
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | TYSON    |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | NY       |
        | phone number      |          |
      And Click on Let's start button
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | Anxiety                       |
        | state                                              | Continue with prefilled state |

    Scenario: Flow 119 - Tyson - Psychiatry
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                              | Tyson BH 30 sessions psychiatry |
        | credit description                     | credit amount                   |
        | 29 x Psychiatry live sessions (30 min) | 1                               |
        | 1 x Psychiatry live session (60 min)   | 1                               |
      And Payment and Plan - Waiting to be matched text is displayed for the first room
@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2823
Feature: QM - B2B - Automatic BH

  Background:
    Given Navigate to flow120

  Rule: Psychiatry

    Background:
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | TYSON    |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | NY       |
        | phone number      |          |
      And Click on next button to approve you are ready to begin
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | Anxiety                       |
        | state                                              | Continue with prefilled state |

    Scenario: Flow 120 - Tyson - Psychiatry
      And Click on secure your match button
      And Click on continue to checkout button
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
        | checkbox |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Tyson BH Psychiatry |
      And Payment and Plan - Waiting to be matched text is displayed for the first room
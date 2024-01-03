Feature: QM - Flow 90
  Leads to flow 68

  Background:
    Given Navigate to flow90
    When Select PSYCHIATRY service
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider       | Anxiety |
      | prescribed medication to treat a mental health condition | Yes     |
      | your gender                                              | Female  |
      | provider gender                                          | Male    |
      | age                                                      | 18      |
      | state                                                    | MT      |

  @smoke
  @issue=talktala.atlassian.net/browse/MEMBER-3284
  Scenario: Psychiatry - BH - Optum
    And Continue with "Optum" insurance provider
    And Click on secure your match button
    And Complete shared validation form for primary user
      | age               | 18                                  |
      | Member ID         | COPAY_0                             |
      | Email             | PRIMARY                             |
      | employee Relation | ADULT_DEPENDENT_MEMBER_OF_HOUSEHOLD |
      | state             | MT                                  |
      | phone number      |                                     |
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
      | plan name | Optum BH Psychiatry |
    And Payment and Plan - Waiting to be matched text is displayed for the first room
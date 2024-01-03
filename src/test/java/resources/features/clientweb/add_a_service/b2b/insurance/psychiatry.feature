Feature: Client web - Add a service
  Leads to flow 68

  Background:
    Given Client API - Create THERAPY room for primary user with therapist3 provider
      | state | MT |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Dismiss modal
    When Open account menu
    Then Account Menu - Select add a new service
    When Select PSYCHIATRY service
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider       | Anxiety                       |
      | prescribed medication to treat a mental health condition | Yes                           |
      | your gender                                              | Female                        |
      | provider gender                                          | Male                          |
      | age                                                      | 18                            |
      | state                                                    | Continue with prefilled state |

  @issue=talktala.atlassian.net/browse/MEMBER-3284
  Scenario: Psychiatry - BH
    And Continue with "Premera" insurance provider
    And Click on secure your match button
    And Complete shared validation form for primary user
      | age               | 18       |
      | Member ID         | COPAY_0  |
      | state             | MT       |
      | employee Relation | EMPLOYEE |
    And Click on continue to checkout button
    And Payment - Complete purchase using "visa" card for primary user
    And Click on continue to room button
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Premera BH Psychiatry |
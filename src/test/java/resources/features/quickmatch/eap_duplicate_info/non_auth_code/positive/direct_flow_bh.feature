@tmsLink=talktala.atlassian.net/browse/AUTOMATION-3010
Feature: QM - EAP duplicate info

  Background:
    Given Navigate to flow28
    And Set primary user last name to Automation

  Rule: Therapy

    Background:
      Then Options of the second dropdown are
        | Employee                            |
        | Spouse/partner                      |
        | Adult dependent/Member of household |
        | Student                             |
      When Complete shared validation form for primary user
        | birthdate         | consumer |
        | Member ID         | COPAY_25 |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | STUDENT  |
        | state             | MT       |
        | phone number      |          |
      And Click on next button to approve you are ready to begin
      And Complete the matching questions with the following options
        | seek help reason                   | I'm feeling anxious or panicky |
        | got it                             |                                |
        | provider gender preference         | Male                           |
        | have you been to a provider before | Yes                            |
        | sleeping habits                    | Excellent                      |
        | physical health                    | Excellent                      |
        | your gender                        | Male                           |
        | state                              | Continue with prefilled state  |

    @tmsLink=talktala.atlassian.net/browse/MEMBER-648
    Scenario: Existing member information - Registration through BH flow
    this scenario also verify that BH members CAN still go through registration with existing info
    this scenario also verify that SMS checkbox on registration is not mandatory by not checking it.
      And Click on secure your match button
      And Click on continue on coverage verification
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Premera BH Unlimited Sessions Messaging or Live Session |
      And Payment and Plan - Waiting to be matched text is displayed for the first room
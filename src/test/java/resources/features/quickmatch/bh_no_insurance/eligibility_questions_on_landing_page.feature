@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2878
Feature: QM - BH no insurance

  Background:
    Given Navigate to Eligibility questions landing page

  Rule: Trizetto timeout flow

    Scenario: Start from Eligibility questions on landing page - Trizetto timeout flow
      And Landing page - Select THERAPY service
      And Landing page - Select MT state
      And Landing page - Select "Premera" insurance provider
      And Landing page - Click getting started button
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | provider gender                                    | Male                           |
        | your gender                                        | Female                         |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | age                                                | 18                             |
      And Click on secure your match button
      And Complete shared validation form for primary user
        | age               | 18                                        |
        | Member ID         | REDIRECT_TO_MANUAL_DUE_TO_TIMEOUT_CARELON |
        | Email             | PRIMARY                                   |
        | employee Relation | EMPLOYEE                                  |
        | state             | MT                                        |
        | phone number      |                                           |
      And Unified eligibility page - Click on retry button 2 times
      Then BH no insurance - User is redirected to the “Let's help you figure this out” page

  Rule: Couple therapy

    Scenario: Start from Eligibility questions on landing page - I’m sure my plan covers Talkspace
      And Landing page - Select COUPLES_THERAPY service
      And Landing page - Select MT state
      And Landing page - Select "Premera" insurance provider
      And Landing page - Click getting started button
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider - multi select | Decide whether we should separate |
        | looking for a provider that will                                  | Teach new skills                  |
        | have you been to a provider before                                | Yes                               |
        | live with your partner                                            | Yes                               |
        | type of relationship                                              | Straight                          |
        | domestic violence                                                 | No                                |
        | ready                                                             | We're ready now                   |
        | your gender                                                       | Female                            |
        | provider gender                                                   | Male                              |
        | age                                                               | 18                                |
      And Click on secure your match button
      And Complete shared validation form for primary user
        | age               | 18           |
        | Member ID         | NOT_ELIGIBLE |
        | Email             | PRIMARY      |
        | employee Relation | EMPLOYEE     |
        | state             | MT           |
        | phone number      |              |
      And BH no insurance - Click on I’m sure my plan covers Talkspace
      And BH no insurance - upload insurance card image
      And Unified eligibility page - Click on continue button
      And BH no insurance - upload id card image
      And Unified eligibility page - Click on continue button
      And Enter PRIMARY email
      And BH no insurance - Insert PRIMARY email in email confirmation
      And Unified eligibility page - Click on submit button
      Then BH no insurance - We’ve received your request text is displayed

  Rule: Therapy

    Background:
      And Landing page - Select THERAPY service
      And Landing page - Select MT state
      And Landing page - Select "Premera" insurance provider
      And Landing page - Click getting started button
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | provider gender                                    | Male                           |
        | your gender                                        | Female                         |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | age                                                | 18                             |
      And Click on secure your match button
      And Complete shared validation form for primary user
        | age               | 18           |
        | Member ID         | NOT_ELIGIBLE |
        | Email             | PRIMARY      |
        | employee Relation | EMPLOYEE     |
        | state             | MT           |
        | phone number      |              |

    @visual
    Scenario: Start from Eligibility questions on landing page - Options screen
    no EAP option
      Then Shoot baseline

    Scenario: Start from Eligibility questions on landing page - Switch to B2C therapy flow
      And BH no insurance - Click on continue without insurance
      When Select the second plan
      And Continue with "Monthly" billing period
      And Apply free coupon if running on prod
      And Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Messaging Only Therapy - Monthly |
      And No credits exist in the first room
      And Payment and Plan - Waiting to be matched text is displayed for the first room

    Scenario: Start from Eligibility questions on landing page - Check that my information is correct and resubmit
      And BH no insurance - Click on check my coverage is correct button
      And Unified eligibility page - Enter COPAY_0 member id
      And Unified eligibility page - Click on continue button
      And Click on continue on coverage verification
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
        | plan name | Premera BH Unlimited Sessions Messaging or Live Session |
      And Payment and Plan - Waiting to be matched text is displayed for the first room

  Rule: Psychiatry

    Scenario: Start from Eligibility questions on landing page - Switch to B2C psychiatry flow
      And Landing page - Select PSYCHIATRY service
      And Landing page - Select NY state
      And Landing page - Select "Optum"
      And Landing page - Click getting started button
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider       | Anxiety |
        | prescribed medication to treat a mental health condition | Yes     |
        | your gender                                              | Female  |
        | provider gender                                          | Male    |
        | age                                                      | 18      |
      And Click on secure your match button
      And Complete shared validation form for primary user
        | age               | 18                                  |
        | Member ID         | NOT_ELIGIBLE                        |
        | Email             | PRIMARY                             |
        | employee Relation | ADULT_DEPENDENT_MEMBER_OF_HOUSEHOLD |
        | state             | MT                                  |
        | phone number      |                                     |
      And BH no insurance - Click on continue without insurance
      And Select the first plan
      When Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Psychiatry - Initial Evaluation + 1 follow up session |
      And No credits exist in the first room
      And Payment and Plan - Waiting to be matched text is displayed for the first room
@owner=nir_tal
Feature: QM - BH no insurance
  In direct flows the “continue without insurance” button will lead to flow 90 instead of the offer page
  see https://talktala.atlassian.net/browse/MEMBER-1704

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2869
  Scenario: Start from direct flow - Check that my information is correct and resubmit
    Given Navigate to flow28
    When Complete shared validation form for primary user
      | age               | 18           |
      | Member ID         | NOT_ELIGIBLE |
      | service type      | THERAPY      |
      | Email             | PRIMARY      |
      | employee Relation | STUDENT      |
      | state             | MT           |
      | phone number      |              |
    And BH no insurance - Click on check my coverage is correct button
    And Unified eligibility page - Enter COPAY_0 member id
    And Unified eligibility page - Click on continue button
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

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2872
  Scenario: Start from direct flow - Trizetto timeout flow
    Given Navigate to flow28
    When Complete shared validation form for primary user
      | age               | 18                                        |
      | Member ID         | REDIRECT_TO_MANUAL_DUE_TO_TIMEOUT_CARELON |
      | service type      | PSYCHIATRY                                |
      | Email             | PRIMARY                                   |
      | employee Relation | EMPLOYEE                                  |
      | state             | MT                                        |
      | phone number      |                                           |
    And Unified eligibility page - Click on retry button 2 times
    And BH no insurance - User is redirected to the “Let's help you figure this out” page

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2871
  Scenario: Start from direct flow - I’m sure my plan covers Talkspace
    Given Navigate to flow70
    When Complete shared validation form for primary user
      | age               | 18              |
      | Member ID         | NOT_ELIGIBLE    |
      | service type      | COUPLES_THERAPY |
      | Email             | PRIMARY         |
      | employee Relation | EMPLOYEE        |
      | state             | MT              |
      | phone number      |                 |
    And BH no insurance - Click on I’m sure my plan covers Talkspace
    And BH no insurance - upload insurance card image
    And Unified eligibility page - Click on continue button
    And BH no insurance - upload id card image
    And Unified eligibility page - Click on continue button
    And Enter PRIMARY email
    And BH no insurance - Insert PRIMARY email in email confirmation
    And Unified eligibility page - Click on submit button
    Then BH no insurance - We’ve received your request text is displayed

  Scenario: Start from direct flow - Switch to B2C couples flow
    Given Navigate to flow28
    When Complete shared validation form for primary user
      | age               | 18              |
      | Member ID         | NOT_ELIGIBLE    |
      | service type      | COUPLES_THERAPY |
      | Email             | PRIMARY         |
      | employee Relation | STUDENT         |
      | state             | MT              |
      | phone number      |                 |
    And BH no insurance - Click on continue without insurance
    When Select COUPLES_THERAPY service
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
      | age                                                               | Continue with prefilled age       |
      | state                                                             | Continue with prefilled state     |
    And Continue without insurance provider after selecting "I’ll pay out of pocket"
    And Click on secure your match button
    And Email wall - Click on continue button
    And Select the first plan
    And Continue with "3 Months" billing period
    And Apply free coupon if running on prod
    And Payment - Click on continue
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
      | plan name | Couples Therapy with Live Session - Quarterly |
    And No credits exist in the first room
    And Payment and Plan - Waiting to be matched text is displayed for the first room
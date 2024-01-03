@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2877
Feature: QM - BH no insurance

  Background:
    Given Client API - Create THERAPY room for primary user with therapist3 provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    When Open account menu
    Then Account Menu - Select add a new service

  Rule: Couple therapy

    Background:
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
        | age                                                               | 18                                |
        | state                                                             | MT                                |

    @issue=talktala.atlassian.net/browse/MEMBER-3297
    Scenario: Add a service - Couples therapy - Check that my information is correct and resubmit
      When Continue with "Premera" insurance provider
      And Click on secure your match button
      And Complete shared validation form for primary user
        | age               | 18           |
        | Member ID         | NOT_ELIGIBLE |
        | state             | MT           |
        | employee Relation | EMPLOYEE     |
      And BH no insurance - Click on check my coverage is correct button
      And Unified eligibility page - Enter COPAY_0 member id
      And Unified eligibility page - Click on continue button
      And Click on continue on coverage verification
      And Payment - Complete purchase using "visa" card for primary user
      And Click on continue to room button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Premera BH Unlimited Sessions Messaging or Live Session Couples |

  Rule: Psychiatry

    Background:
      When Select PSYCHIATRY service
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider       | Anxiety |
        | prescribed medication to treat a mental health condition | Yes     |
        | your gender                                              | Female  |
        | provider gender                                          | Male    |
        | age                                                      | 18      |
        | state                                                    | MT      |

    Scenario: Add a service - Psychiatry - I’m sure my plan covers Talkspace
      And Continue with "Premera" insurance provider
      And Click on secure your match button
      And Complete shared validation form for primary user
        | age               | 18           |
        | Member ID         | NOT_ELIGIBLE |
        | state             | NY           |
        | employee Relation | EMPLOYEE     |
      And BH no insurance - Click on I’m sure my plan covers Talkspace
      And BH no insurance - upload insurance card image
      And Unified eligibility page - Click on continue button
      And BH no insurance - upload id card image
      And Unified eligibility page - Click on continue button
      And Enter PRIMARY email
      And BH no insurance - Insert PRIMARY email in email confirmation
      And Unified eligibility page - Click on submit button
      And BH no insurance - Click on return to my account
      Then Room is available

  Rule: Therapy

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-3010
    Scenario: Add a service - Therapy - Switch to organization flow
    this scenario also verify non-Aetna EAP members CAN still go through add a service with existing info
      And Select THERAPY service
      And Select to pay through insurance provider
      And Continue with "Premera" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18           |
        | state     | MT           |
        | Member ID | NOT_ELIGIBLE |
      And BH no insurance - Click on continue with EAP button
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | state                                              | Continue with prefilled state  |
      And Click on secure your match button
      And Write "test" in organization name
      And Click on next button
      And Enter RANDOM email
      And Click on next button
      And Click on I have a keyword or access code button
      And Enter "kga" access code
      And Click on next button
      And Complete kga eap validation form for primary user
        | authorization code | MOCK_KGA |
        | age                | 18       |
        | service type       | THERAPY  |
        | Email              | PRIMARY  |
        | employee Relation  | EMPLOYEE |
        | state              | MT       |
      And Click on continue on coverage verification
      And Eligibility Widget - Click on start treatment button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                               | KGA EAP 3 Sessions with Live Sessions Voucher |
        | credit description                      | credit amount                                 |
        | 1 x Complimentary live session (10 min) | 1                                             |
        | 3 x Therapy live sessions (45 min)      | 1                                             |

    Scenario: Add a service - Therapy - Switch to B2C flow
      And Select THERAPY service
      And Select to pay through insurance provider
      And Continue with "Premera" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18           |
        | state     | MT           |
        | Member ID | NOT_ELIGIBLE |
      And BH no insurance - Click on continue without insurance
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | state                                              | Continue with prefilled state  |
      And Click on secure your match button
      When Select the second plan
      And Continue with "Monthly" billing period
      And Apply free coupon if running on prod
      And Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Click on continue to room button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Messaging Only Therapy - Monthly |
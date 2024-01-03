@owner=tami
Feature: Client web - Reactivation
  On these tests we are only checking Match with new provider since creating B2B room is switching us to random provider for test users.
  Upon reactivating a non-B2C room, we are creating another room instead od re-using the old room.
  Room status verification (via API) and plan details verification (via UI) will NOT point to the same roomIndex in case there is
  more that 1 room.

  Rule: Reactivate from BH to other plans

    Background:
      Given Therapist API - Login to therapist provider
      Given Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28        |
        | age               | 18        |
        | Member ID         | COPAY_25  |
        | keyword           | premerabh |
        | employee Relation | EMPLOYEE  |
        | state             | MT        |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And Client API - Cancel a non paying subscription of primary user in the first room
      And Navigate to payment and plan URL
      And Click on Undo cancellation

    @issue=talktala.atlassian.net/browse/PLATFORM-4680
    Scenario: Reactivate from payment and plan - Match with new provider (from BH therapy to BH therapy room)
      And Click on continue
      And Reactivation - Select THERAPY service
      And Select to pay through insurance provider
      And Continue with "Premera" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18      |
        | state     | MT      |
        | Member ID | COPAY_0 |
      And Click on continue on coverage verification
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | state                                              | Continue with prefilled state  |
      When Click on Match with a new provider
      And Click on secure your match button
      And Complete shared after upfront coverage verification validation form for primary user
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Premera BH Unlimited Sessions Messaging or Live Session |

    Scenario: Reactivate from payment and plan - Match with new provider (from BH therapy to EAP couples room)
      And Click on continue
      And Reactivation - Select COUPLES_THERAPY service
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider - multi select | Decide whether we should separate |
        | looking for a provider that will                                  | Teach new skills                  |
        | have you been to a provider before                                | Yes                               |
        | live with your partner                                            | Yes                               |
        | type of relationship                                              | Straight                          |
        | domestic violence                                                 | No                                |
        | ready                                                             | We're ready now                   |
        | your gender                                                       | Male                              |
        | provider gender                                                   | Male                              |
        | age                                                               | 18                                |
        | state                                                             | Continue with prefilled state     |
      And Click on I have talkspace through an organization
      When Reactivation - Write "mines" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      And Complete eap validation form for primary user
        | age               | 18       |
        | employee Relation | EMPLOYEE |
      And Click on continue on coverage verification
      When Click on Match with a new provider
      And Click on secure your match button
      And Eligibility Widget - Click on start treatment button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Mines EAP 5 Sessions Messaging or Live Session Voucher |

    Scenario: Reactivate from payment and plan - Match with new provider (from BH therapy to B2C therapy room)
      And Click on continue
      And Reactivation - Select THERAPY service
      And Select to pay out of pocket
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Male                           |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | Continue with prefilled state  |
      When Click on Match with a new provider
      And Click on secure your match button
      Then Reactivation - Select the second plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      When Reactivation payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Messaging Only Therapy - Quarterly |

  Rule: Reactivate from non billable EAP to other plans

    Background:
      Given Therapist API - Login to therapist provider
      Given Client API - Create EAP room to primary user with therapist provider
        | flowId            | 9                                 |
        | age               | 18                                |
        | keyword           | nottinghamhealthandrehabilitation |
        | employee Relation | EMPLOYEE                          |
        | state             | MT                                |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And Client API - Cancel a non paying subscription of primary user in the first room
      And Navigate to payment and plan URL
      And Click on Undo cancellation

    @issue=talktala.atlassian.net/browse/MEMBER-3284
    Scenario: Reactivate from payment and plan - Match with new provider (from non billable EAP therapy to BH psychiatry room)
      And Click on continue
      And Reactivation - Select PSYCHIATRY service
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider       | Anxiety |
        | prescribed medication to treat a mental health condition | Yes     |
        | your gender                                              | Male    |
        | provider gender                                          | Male    |
        | age                                                      | 18      |
        | state                                                    | MT      |
      And Continue with "Premera" insurance provider
      When Click on Match with a new provider
      And Click on secure your match button
      And Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_0  |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
      And Reactivation - Click on continue to checkout button
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Premera BH Psychiatry |

    Scenario: Reactivate from payment and plan - Match with new provider (from non billable EAP therapy to B2C therapy)
      And Click on continue
      And Reactivation - Select THERAPY service
      And Select to pay out of pocket
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | Continue with prefilled state  |
      When Click on Match with a new provider
      And Click on secure your match button
      Then Reactivation - Select the second plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      When Reactivation payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Messaging Only Therapy - Quarterly |
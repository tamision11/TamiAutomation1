@owner=tami
Feature: Client web - Reactivation
  Upon reactivating a B2C plan room to the same room_type, we are re-using the old room.
  Upon reactivating a B2C plan room to a different room_type, we are creating another room.
  Room status verification (via API) and plan details verification (via UI) will NOT point to the same roomIndex in case there is
  more that 1 room.

  Background:
    Given Therapist API - Login to therapist provider
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | MT |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
    And Client API - Cancel Subscription of primary user in the first room
    And Client API - Refund Charge of primary user
    And Onboarding - Dismiss modal
    And Refresh the page

  Rule: Start from payment and plan page

    Background:
      And Navigate to payment and plan URL
      And Click on Subscribe button

    Scenario: Reactivate from payment and plan - Current provider available - Continue with current provider (from B2C to B2C therapy room)
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
      When Click on Continue with same provider
      Then Reactivation - Select the first plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      When Reactivation payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Navigate to payment and plan URL
      Then Client API - The first room status of primary user is ACTIVE
      Then Plan details for the first room are
        | plan name | Messaging and Live Therapy - Quarterly |
      And therapist is the provider in the first room for primary user

    Scenario: Reactivate from payment and plan - Current provider available - Match with new provider (from B2C to B2C couples room)
    we expect a new room to open after re-activation when new service (room_type) is different from the original's room
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
        | your gender                                                       | Female                            |
        | provider gender                                                   | Male                              |
        | age                                                               | 18                                |
        | state                                                             | Continue with prefilled state     |
      And Continue without insurance provider after selecting "I’ll pay out of pocket"
      When Click on Match with a new provider
      And Click on secure your match button
      Then Reactivation - Select the first plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      When Reactivation payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      And Payment and Plan - Waiting to be matched text is displayed for the first room
      Then Plan details for the first room are
        | plan name | Couples Therapy with Live Session - Quarterly |

    Scenario: Reactivate from payment and plan - Current provider isn't available - Match with new provider (from B2C to B2C psychiatry room)
      And Click on continue
      And Reactivation - Select PSYCHIATRY service
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider       | Anxiety |
        | prescribed medication to treat a mental health condition | Yes     |
        | your gender                                              | Female  |
        | provider gender                                          | Male    |
        | age                                                      | 18      |
        | state                                                    | MT      |
      And Continue without insurance provider after selecting "I’ll pay out of pocket"
      When Click on Match with a new provider
      And Click on secure your match button
      And Reactivation - Select the first plan
      When Reactivation payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      And Payment and Plan - Waiting to be matched text is displayed for the first room
      Then Plan details for the first room are
        | plan name | Psychiatry - Initial Evaluation + 1 follow up session |

    Scenario: Reactivate from payment and plan - Current provider available - Continue with current provider (from B2C to BH therapy room)
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
      When Click on Continue with same provider
      And Complete shared after upfront coverage verification validation form for primary user
        | Email             | PRIMARY                             |
        | employee Relation | ADULT_DEPENDENT_MEMBER_OF_HOUSEHOLD |
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Navigate to payment and plan URL
      Then Client API - The first room status of primary user is ACTIVE
      Then Plan details for the first room are
        | plan name | Premera BH Unlimited Sessions Messaging or Live Session |
      And therapist is the provider in the first room for primary user

    Scenario: Reactivate from payment and plan - Current provider available - Continue with current provider (from B2C to DTE therapy room)
      And Click on continue
      And Reactivation - Select THERAPY service
      And Select to pay through an organization
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | Continue with prefilled state  |
      When Click on Continue with same provider
      And Reactivation - Write "google" in organization name
      And Click on next button
      And Enter RANDOM email
      And Click on next button
      And Complete google validation form for primary user
        | age               | 18       |
        | employee Relation | EMPLOYEE |
      And Eligibility Widget - Click on start treatment button
      And Navigate to payment and plan URL
      Then Client API - The first room status of primary user is ACTIVE
      Then therapist is the provider in the first room for primary user
      Then Plan details for the first room are
        | plan name | Google Unlimited Messaging Only Voucher |

    @visual
    Scenario: Reactivation - Visual regression
      Then Shoot baseline "Client Web - Reactivation - Welcome Back Page"
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
      Then Shoot baseline "Client Web - Reactivation - choose same or new provider"

    @visual
    Scenario: Reactivation - Visual regression
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
      Then Shoot baseline "Client Web - Reactivation - Current provider isn't available"

  Rule: Start from reactivation chat banner

    Background:
      And Wait 8 seconds
      And Refresh the page

    Scenario: Reactivate from banner - Current provider available - Continue with current provider (from B2C to B2C therapy room)
    it is mandatory to sign 2fa in order to get only 1 task banner
    with test users, we will not get back to same provider since the code switches test users to random test providers
      When Click on Resubscribe to continue therapy
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
      When Click on Continue with same provider
      Then Reactivation - Select the first plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      When Reactivation payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Navigate to payment and plan URL
      Then Client API - The first room status of primary user is ACTIVE
      Then Plan details for the first room are
        | plan name | Messaging and Live Therapy - Quarterly |
      And therapist is the provider in the first room for primary user

    @smoke
    Scenario: Reactivate from banner - Current provider available - Match with new provider (from B2C to B2C therapy room)
    it is mandatory to sign 2fa in order to get only 1 task banner
      When Click on Resubscribe to continue therapy
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
      Then Reactivation - Select the first plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      When Reactivation payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Navigate to payment and plan URL
      And Payment and Plan - Waiting to be matched text is displayed for the first room
      Then Plan details for the first room are
        | plan name | Messaging and Live Therapy - Quarterly |
    Scenario: Verify Reactivation banner text
    it is mandatory to sign 2fa in order to get only 1 task banner
      Then Resubscribe banner text appears

    Scenario: Verify Resubscribe system message
      Then System message "Your subscription is cancelled and this room is not being monitored. Resubscribe to continue therapy." appears

  Rule: Start after login

    Background:
      Given Log out
      And Log in with primary user and
        | remember me   | false |
        | 2fa activated | true  |

    Scenario: Reactivate After Login - Current provider available - Continue with current provider (from B2C to B2C therapy room)
    with test users, we will not get back to same provider since the code switches test users to random test providers
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
      When Click on Continue with same provider
      Then Reactivation - Select the first plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      When Reactivation payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Client API - The first room status of primary user is ACTIVE
      Then Plan details for the first room are
        | plan name | Messaging and Live Therapy - Quarterly |
      And therapist is the provider in the first room for primary user

    Scenario: Reactivate After Login - Current provider available - Match with new provider (from B2C to B2C therapy room)
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
      Then Reactivation - Select the first plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      When Reactivation payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      And Payment and Plan - Waiting to be matched text is displayed for the first room
      Then Plan details for the first room are
        | plan name | Messaging and Live Therapy - Quarterly |
      And therapist is not the provider in the first room for primary user

  Rule: Two cancelled PT rooms

    Background:
    We send a message from the PT in the first room to make it the default room for reactivation
      Given Therapist API - Add another THERAPY room to primary user with therapist provider
      And Client API - Switch to therapist2 provider in the second room for primary user
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the second room
      And Refresh the page
      And Client API - Cancel Subscription of primary user in the second room
      And Client API - Refund Charge of primary user
      And Therapist API - Send 1 VALID_RANDOM message as therapist provider to primary user in the first room
      And Log out
      And Log in with primary user and
        | remember me   | false |
        | 2fa activated | true  |
      And Onboarding - Dismiss modal

    Scenario: Two Cancelled Rooms - After login - Current provider available - Continue with same provider in default room (from B2C to B2C therapy room)
    with test users, we will not get back to same provider since the code switches test users to random test providers also the first room will be always reactivated.
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
      When Click on Continue with same provider
      Then Reactivation - Select the first plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      When Reactivation payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Client API - The first room status of primary user is ACTIVE
      And therapist is the provider in the first room for primary user
      Then Plan details for the first room are
        | plan name | Messaging and Live Therapy - Quarterly |

    Scenario: Two Cancelled Rooms - After login - Current provider available - Continue with same provider in other room
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
      When Click on unchecked radio button
      When Click on Continue with same provider
      Then Reactivation - Select the first plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      When Reactivation payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Client API - The second room status of primary user is ACTIVE
      Then Plan details for the first room are
        | plan name | Messaging and Live Therapy - Quarterly |
      And therapist2 is the provider in the second room for primary user

    Scenario: Two Cancelled Rooms - After login - Current provider available - Match with new provider in default room (from B2C to B2C therapy room)
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
        | state                                              | MT                             |
      When Click on Match with a new provider
      And Click on secure your match button
      Then Reactivation - Select the first plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      When Reactivation payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      And Payment and Plan - Waiting to be matched text is displayed for the first room
      Then Plan details for the first room are
        | plan name | Messaging and Live Therapy - Quarterly |

    Scenario: Two Cancelled Rooms - After login - Current provider available - Match with new provider in other room
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
      When Click on unchecked radio button
      When Click on Match with a new provider
      And Click on secure your match button
      Then Reactivation - Select the first plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      When Reactivation payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      And Payment and Plan - Waiting to be matched text is displayed for the first room
      Then Plan details for the first room are
        | plan name | Messaging and Live Therapy - Quarterly |

    @visual
    Scenario: Reactivation - Two Rooms - Choose room
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
      Then Shoot baseline "Client Web - Reactivation - Choose room to activate"
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2568
Feature: Client web - Cancel plan

  Rule: B2C subscription with cancel option (no-matches)

    Background:
      Given Navigate to flow90
      And Select THERAPY service
      And Select to pay out of pocket
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Male                           |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | MO                             |
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      And Select the first plan
      And Click on continue
      And Apply free coupon if running on prod
      When Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password     | STRONG |
        | nickname     | VALID  |
        | checkbox     |        |
        | phone number |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL

    @visual
    Scenario: B2C - Visual regression
      Given Cancel Subscription - Click on cancel subscription renewal
      Then Shoot baseline "Client Web - Cancel plan - Tell us why you are cancelling your plan"
      When Select from list the option "I feel better"
      And Cancel Subscription - Click on next button to select reason
      Then Shoot baseline "Client Web - Cancel plan - Anything we can do to improve your experience"
      And Cancel Subscription - Click on cancel my plan
      Then Shoot baseline "Client Web - Your plan has been cancelled"

    Scenario: B2C subscription cancellation (no-matches)
    after undo cancellation room is back to status 15
      Given Cancel Subscription - Click on cancel subscription renewal
      When Select from list the option "I feel better"
      And Cancel Subscription - Click on next button to select reason
      And Cancel Subscription - Click on cancel my plan
      And Cancel Subscription - Click on Close button
      And Payment and Plan - Not yet matched text is displayed for the first room
      And Client API - The first room status of primary user is CANCELLED
      Then Click on Undo cancellation
      And Click on continue
      And Click on done button
      And Payment and Plan - Waiting to be matched text is displayed for the first room
      And Client API - The first room status of primary user is WAITING_TO_BE_MATCHED_QUEUE
      And Sendgrid API - primary user has the following email subjects at his inbox
        | canary-cancelb2bplan | 1 |

  Rule: Psychiatry - No cancellation option

    Background:
      And Client API - Create PSYCHIATRY room for primary user with psychiatrist
        | state | MO |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      When Client API - Subscribe to offer 61 of plan 138 with visa card of primary user in the first room
      And Navigate to payment and plan URL

    Scenario: B2C - No cancel plan option with psychiatry
      And Cancel Subscription - Cancel plan button not available

  Rule: B2B Plans (no matches)

    Background:
      Given Client API - Create DTE room to primary user with therapist provider
        | flowId            | 11       |
        | age               | 18       |
        | keyword           | google   |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
        | isPendingMatch    |          |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL

    Scenario: B2B - DTE - Undo cancellation (no matches)
    this scenario cancel subscription and undo cancellation
      Given Cancel Subscription - Click on cancel subscription renewal
      When Select from list the option "I feel better"
      And Cancel Subscription - Click on next button to select reason
      And Cancel Subscription - Click on cancel my plan
      And Cancel Subscription - Click on Close button
      And Payment and Plan - Not yet matched text is displayed for the first room
      And Client API - The first room status of primary user is CANCELLED
      Then Click on Undo cancellation
      And Click on continue
      And Click on done button
      And Payment and Plan - Waiting to be matched text is displayed for the first room
      And Client API - The first room status of primary user is WAITING_TO_BE_MATCHED_QUEUE

  Rule: B2B Plans

    Background:
      Given Client API - Create EAP room to primary user with therapist provider
        | flowId            | 9                                 |
        | age               | 18                                |
        | keyword           | nottinghamhealthandrehabilitation |
        | employee Relation | EMPLOYEE                          |
        | state             | WY                                |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      When Navigate to payment and plan URL
      And Click on Cancel my plan

    @visual
    Scenario: B2B - EAP - Visual regression
      And Rate provider with 2 stars
      And Cancel Subscription - Click on submit review button
      And Cancel Subscription - Click on not interested in new provider button
      And Select from list the option "My provider was not responsive to my messages"
      And Cancel Subscription - Click on next button to select reason
      And Cancel Subscription - Click on Cancel my plan
      And Cancel Subscription - Click on Close button
      Then Shoot Payment and plan panel element and ignore
        | therapist avatar |
        | therapist name   |

    Scenario: B2B - EAP - Cancellation action
      And Rate provider with 2 stars
      And Cancel Subscription - Click on submit review button
      And Cancel Subscription - Click on not interested in new provider button
      And Select from list the option "My provider was not responsive to my messages"
      And Cancel Subscription - Click on next button to select reason
      And Cancel Subscription - Click on Cancel my plan
      And Cancel Subscription - Click on Close button
      And Undo Cancel button is available
      And Sendgrid API - primary user has the following email subjects at his inbox
        | canary-cancelb2bplan | 1 |
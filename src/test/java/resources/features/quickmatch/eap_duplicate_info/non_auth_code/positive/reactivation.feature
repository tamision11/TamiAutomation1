@owner=tami
@issue=talktala.atlassian.net/browse/PLATFORM-4353
Feature: QM - EAP duplicate info

  Rule: Reactivate from billable EAP to other plans

    Background:
      Given Therapist API - Login to therapist provider
      Given Client API - Create EAP room to primary user with therapist provider
        | flowId            | 44       |
        | age               | 18       |
        | keyword           | icuba    |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And Client API - Cancel a non paying subscription of primary user in the first room
      And Navigate to payment and plan URL
      And Click on Undo cancellation

    Scenario: Existing member information - Reactivation to different payer - billable plans (from athena EAP therapy to beacon EAP therapy room)
    switch from non billable eap to non billable eap should be allowed
      And Click on continue
      And Reactivation - Select THERAPY service
      And Select to pay through an organization
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
      And Reactivation - Write "carelon" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      When Complete carelon eap validation form for primary user
        | birthdate         | consumer |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
      And Click on continue on coverage verification
      And Eligibility Widget - Click on start treatment button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                          | Carelon Wellbeing 6 Sessions with Live Sessions Voucher |
        | credit description                 | credit amount                                           |
        | 6 x Therapy live sessions (45 min) | 1                                                       |

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

    Scenario: Existing member information - Reactivation to different payer - non-billable plans (from non billable EAP therapy to another non billable EAP therapy room)
    switch from non billable eap to another non billable eap should be allowed
      And Click on continue
      And Reactivation - Select THERAPY service
      And Select to pay through an organization
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
      When Reactivation - Write "mines" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      And Complete eap validation form for primary user
        | age               | 18       |
        | employee Relation | EMPLOYEE |
      And Click on continue on coverage verification
      And Eligibility Widget - Click on start treatment button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Mines EAP 5 Sessions Messaging or Live Session Voucher |
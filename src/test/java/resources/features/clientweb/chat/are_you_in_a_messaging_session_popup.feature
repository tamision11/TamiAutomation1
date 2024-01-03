@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2785
Feature: Client web - Chat - Start async messaging session from “Are you in a Messaging Session?” popup

  Rule: BH therapy room - popup is displayed

    Background:
      Given Therapist API - Login to therapist provider
      Given Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28        |
        | age               | 18        |
        | Member ID         | COPAY_25  |
        | keyword           | premerabh |
        | employee Relation | EMPLOYEE  |
        | state             | WY        |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And Client API - Switch to therapist4 provider in the first room for primary user
      Given Therapist API - Login to therapist4 provider
      And Therapist API - Send 2 VALID_RANDOM message as therapist4 provider to primary user in the first room
      And Client API - Send 2 VALID_RANDOM message as primary user in the first room
      And Send the following messages and verify they are present in chat
        | VALID_RANDOM |

    Scenario: Start async messaging session from “Are you in a Messaging Session?” - BH Therapy room
    it is mandatory to sign 2fa in order to get only 1 task banner
      And In-room scheduler - Click on Start Messaging Session button
      And in-room scheduler - Book THERAPY live MESSAGING session of NONE minutes with BH_MESSAGING_AND_LIVE plan and IGNORE state
      And In-room scheduler - Click on Go to session room button
      And “Messaging Session in progress“ banner appears

    @visual
    Scenario: Chat - “Are you in a Messaging Session?” popup displayed for BH Therapy room - Visual regression
      Then Shoot are you in a messaging session dialog element as "Client Web - Chat - “Are you in a Messaging Session?” popup" baseline

  Rule: BH psychiatry room - popup is not displayed

    Background:
      Given Therapist API - Login to psychiatrist provider

    Scenario: “Are you in a Messaging Session?” popup is not displayed for BH psychiatry room
      Given Client API - BH - Create manual psychiatry room for primary user with psychiatrist
        | flowId            | 25                            |
        | age               | 18                            |
        | Member ID         | COPAY_0                       |
        | keyword           | premerabhmanualpsychiatrytest |
        | employee Relation | EMPLOYEE                      |
        | state             | WY                            |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And Client API - Get rooms info of primary user
      And Therapist API - Send 2 VALID_RANDOM message as psychiatrist provider to primary user in the first room
      And Client API - Send 2 VALID_RANDOM message as primary user in the first room
      And Send the following messages and verify they are present in chat
        | VALID_RANDOM |
      Then “Are you in a Messaging Session?” popup does not appear

  Rule: EAP therapy room - popup is displayed

    Background:
      Given Therapist API - Login to therapist provider
      Given Client API - Create EAP room to primary user with therapist provider
        | flowId            | 9                                 |
        | age               | 18                                |
        | keyword           | nottinghamhealthandrehabilitation |
        | employee Relation | EMPLOYEE                          |
        | state             | WY                                |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Client API - Switch to therapist provider in the first room for primary user
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And Therapist API - Send 2 VALID_RANDOM message as therapist provider to primary user in the first room
      And Client API - Send 2 VALID_RANDOM message as primary user in the first room
      And Send the following messages and verify they are present in chat
        | VALID_RANDOM |

    Scenario: Start async messaging session from “Are you in a Messaging Session?” - EAP Therapy room
    it is mandatory to sign 2fa in order to get only 1 task banner
      And In-room scheduler - Click on Start Messaging Session button
      And in-room scheduler - Book THERAPY live MESSAGING session of NONE minutes with EAP_MESSAGING_AND_LIVE plan and IGNORE state
      And In-room scheduler - Click on Go to session room button
      And “Messaging Session in progress“ banner appears

    @visual
    Scenario: Chat - “Messaging Session in progress“ banner
      Then “Are you in a Messaging Session?” popup appears
      And In-room scheduler - Click on Start Messaging Session button
      And in-room scheduler - Book THERAPY live MESSAGING session of NONE minutes with EAP_MESSAGING_AND_LIVE plan and IGNORE state
      And In-room scheduler - Click on Go to session room button
      Then Shoot baseline "“Messaging Session in progress“ banner"

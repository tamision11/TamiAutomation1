Feature: Client web - In-Room LVS Scheduler

  Rule: BH Therapy

    Background:
      Given Therapist API - Login to therapist2 provider
      Given Client API - Create THERAPY BH room for primary user with therapist3 provider with visa card
        | flowId            | 28        |
        | age               | 18        |
        | Member ID         | COPAY_25  |
        | keyword           | premerabh |
        | employee Relation | EMPLOYEE  |
        | state             | WY        |
      And Browse to the email verification link for primary user
      And Client API - Switch to therapist2 provider in the first room for primary user
      And Sign two factor authentication for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And in-room scheduler - Skip book first THERAPY live VIDEO session with NON_LIVE state

    @smoke
    Scenario Outline: BH - Therapy - Book 45 minutes session
      When Open the Room details menu
      And In-room scheduler - Click on book session button
      And in-room scheduler - Book THERAPY live <modality> session of THIRTY minutes with BH_MESSAGING_AND_LIVE plan and IGNORE state
      Then Room is available
      And Client API - There is 1 scheduled booking for primary user in the first room
      Examples:
        | modality  |
        | VIDEO     |
        | AUDIO     |
        | LIVE_CHAT |

    Scenario: BH - Therapy - Reschedule 30 minutes video session
      When Open the Room details menu
      And In-room scheduler - Click on book session button
      And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with BH_MESSAGING_AND_LIVE plan and IGNORE state
      Then Room is available
      When Open the Room details menu
      And In-room scheduler - Edit existing booking
      And in-room scheduler - Reschedule live session with BH_MESSAGING_AND_LIVE plan
      And Client API - There is 1 scheduled booking for primary user in the first room

    Scenario: BH - Therapy - Cancel 60 minutes video session
      When Open the Room details menu
      And In-room scheduler - Click on book session button
      And in-room scheduler - Book THERAPY live VIDEO session of SIXTY minutes with BH_MESSAGING_AND_LIVE plan and IGNORE state
      Then Room is available
      When Open the Room details menu
      And In-room scheduler - Edit existing booking
      And in-room scheduler - Cancel live session
      Then Room is available
      And Client API - There are 0 scheduled booking for primary user in the first room

    Scenario: BH - Therapy - Cancel video session and switch provider
      When Open the Room details menu
      And In-room scheduler - Click on book session button
      And in-room scheduler - Book THERAPY live VIDEO session of SIXTY minutes with BH_MESSAGING_AND_LIVE plan and IGNORE state
      Then Room is available
      When Open the Room details menu
      And In-room scheduler - Edit existing booking
      And in-room scheduler - Cancel live session and Switch provider
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And therapist2 is not the provider in the first room for primary user
      And Client API - There are 0 scheduled booking for primary user in the first room

    @issue=talktala.atlassian.net/browse/MEMBER-2348
    Scenario: BH - Therapy - Cancel and Reschedule 30 minutes video session
      When Open the Room details menu
      And In-room scheduler - Click on book session button
      And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with BH_MESSAGING_AND_LIVE plan and IGNORE state
      When Open the Room details menu
      And In-room scheduler - Edit existing booking
      And in-room scheduler - Cancel and Reschedule live session with BH_MESSAGING_AND_LIVE plan
      And Client API - There is 1 scheduled booking for primary user in the first room

  Rule: BH - I can't find a time that works for me - Live plan

    Background:
      Given Therapist API - Login to therapist2 provider
      Given Client API - Create THERAPY BH room for primary user with therapist3 provider with visa card
        | flowId            | 28        |
        | age               | 18        |
        | Member ID         | COPAY_25  |
        | keyword           | premerabh |
        | employee Relation | EMPLOYEE  |
        | state             | WY        |
      And Browse to the email verification link for primary user
      And Client API - Switch to therapist2 provider in the first room for primary user
      And Sign two factor authentication for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2679
    Scenario: BH - I can't find a time that works for me - Live plan
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And Ask for alternative live session time with BH_MESSAGING_AND_LIVE plan
      And Click I can't find a time that works for me
      And Wait 5 seconds
      And Click on send
      And Prefilled text "but cannot meet during the times you have on your calendar. Are there any other times that work for you? Some times that might work for me are:" appears

  Rule: BH - Request Alternative Times - Live plan - Time blocks

    Background:
      Given Therapist API - Login to therapist2 provider
      Given Client API - Create THERAPY BH room for primary user with therapist3 provider with visa card
        | flowId            | 28        |
        | age               | 18        |
        | Member ID         | COPAY_25  |
        | keyword           | premerabh |
        | employee Relation | EMPLOYEE  |
        | state             | WY        |
      And Browse to the email verification link for primary user
      And Client API - Switch to noAvailabilityTherapist provider in the first room for primary user
      And Sign two factor authentication for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal

    Scenario: BH - Request Alternative Times - Live plan - Member available at any time
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And Ask for alternative live session time with BH_MESSAGING_AND_LIVE plan
      And No availability - Click on im available any time
      And Prefilled text "I’d like to book my 60 minute live session. I am available at any time." appears

    Scenario: BH - Request Alternative Times - Live plan - Select under 3 preferred times
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And Ask for alternative live session time with BH_MESSAGING_AND_LIVE plan
      And No availability - Click 2 timeRange options and submit

    Scenario: BH - Request Alternative Times - Live plan - One time booking - Select 3 preferred times
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And Ask for alternative live session time with BH_MESSAGING_AND_LIVE plan
      And No availability - Click 3 timeRange options and submit
      And Prefilled text "I’d like to book my 60 minute live session. My preferred times are:" appears

    Scenario: BH - Request Alternative Times - Live plan - Recurring booking - Select 3 preferred times
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And Ask for alternative live session time with BH_MESSAGING_AND_LIVE plan
      And No availability - Select option "Prefer recurring booking"
      And No availability - Click 3 timeRange options and submit
      And Prefilled text "I’m interested in discussing your availability for recurring bookings." appears

  Rule: BH Psychiatry

    Background:
      Given Client API - Create PSYCHIATRY BH room for primary user with psychiatrist with visa card
        | flowId            | 28                  |
        | age               | 18                  |
        | keyword           | premerabhpsychiatry |
        | Member ID         | COPAY_0             |
        | employee Relation | EMPLOYEE            |
        | state             | MT                  |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on continue button
      And MBA - Book first PSYCHIATRY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button

    Scenario: BH - Psychiatry - Book 60 minutes video session
      When Open the Room details menu
      And In-room scheduler - Click on book session button
      And in-room scheduler - Book PSYCHIATRY live VIDEO session of SIXTY minutes with BH_MESSAGING_AND_LIVE plan and IGNORE state
      Then Room is available
      And Client API - Get rooms info of primary user
      And Client API - There are 2 scheduled bookings for primary user in the first room

  Rule: BH Psychiatry

    Background:
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

    @issue=talktala.atlassian.net/browse/PLATFORM-4129
    Scenario: BH - Psychiatry manual - Book 60 minutes video session
      When Open the Room details menu
      And In-room scheduler - Click on book session button
      And in-room scheduler - Book PSYCHIATRY live VIDEO session of SIXTY minutes with BH_MANUAL plan and IGNORE state
      Then Room is available
      And Client API - Get rooms info of primary user
      And Client API - There is 1 scheduled booking for primary user in the first room

  Rule: EAP Therapy

    Background:
      Given Client API - Create EAP room to primary user with therapist2 provider
        | flowId            | 9                                 |
        | age               | 18                                |
        | keyword           | nottinghamhealthandrehabilitation |
        | employee Relation | EMPLOYEE                          |
        | state             | WY                                |
      And Browse to the email verification link for primary user
      And Client API - Switch to therapist2 provider in the first room for primary user
      And Sign two factor authentication for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And in-room scheduler - Skip book first THERAPY live VIDEO session with NON_LIVE state

    Scenario: EAP - Therapy - Book 30 minutes video session
      When Open the Room details menu
      And In-room scheduler - Click on book session button
      And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with EAP_MESSAGING_AND_LIVE plan and IGNORE state
      Then Room is available
      And Client API - There is 1 scheduled booking for primary user in the first room

    Scenario: EAP - Therapy - Reschedule 30 minutes video session
      When Open the Room details menu
      And In-room scheduler - Click on book session button
      And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with EAP_MESSAGING_AND_LIVE plan and IGNORE state
      Then Room is available
      When Open the Room details menu
      And In-room scheduler - Edit existing booking
      And in-room scheduler - Reschedule live session with EAP_MESSAGING_AND_LIVE plan
      And Client API - There is 1 scheduled booking for primary user in the first room

    Scenario: EAP - Therapy - Cancel 30 minutes video session
      When Open the Room details menu
      And In-room scheduler - Click on book session button
      And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with EAP_MESSAGING_AND_LIVE plan and IGNORE state
      Then Room is available
      When Open the Room details menu
      And In-room scheduler - Edit existing booking
      And in-room scheduler - Cancel live session
      Then Room is available
      And Client API - There are 0 scheduled booking for primary user in the first room

    Scenario: EAP - Therapy - Cancel video session and switch provider
      When Open the Room details menu
      And In-room scheduler - Click on book session button
      And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with EAP_MESSAGING_AND_LIVE plan and IGNORE state
      Then Room is available
      When Open the Room details menu
      And In-room scheduler - Edit existing booking
      And in-room scheduler - Cancel live session and Switch provider
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And therapist2 is not the provider in the first room for primary user
      And Client API - There are 0 scheduled booking for primary user in the first room

    Scenario: EAP - Therapy - Cancel and Reschedule 30 minutes video session
      When Open the Room details menu
      And In-room scheduler - Click on book session button
      And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with EAP_MESSAGING_AND_LIVE plan and IGNORE state
      When Open the Room details menu
      And In-room scheduler - Edit existing booking
      And in-room scheduler - Cancel and Reschedule live session with EAP_MESSAGING_AND_LIVE plan
      And Client API - There is 1 scheduled booking for primary user in the first room

  Rule: EAP - I can't find a time that works for me - Live plan

    Background:
      Given Therapist API - Login to therapist2 provider
      Given Client API - Create EAP room to primary user with therapist3 provider
        | flowId            | 9                                 |
        | age               | 18                                |
        | keyword           | nottinghamhealthandrehabilitation |
        | employee Relation | EMPLOYEE                          |
        | state             | WY                                |
      And Browse to the email verification link for primary user
      And Client API - Switch to therapist2 provider in the first room for primary user
      And Sign two factor authentication for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2679
    Scenario: EAP - I can't find a time that works for me - Live plan
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And Ask for alternative live session time with EAP_MESSAGING_AND_LIVE plan
      And Click I can't find a time that works for me
      And Wait 5 seconds
      And Click on send
      And Prefilled text "but cannot meet during the times you have on your calendar. Are there any other times that work for you? Some times that might work for me are:" appears

  Rule: EAP - Ask about availability - Messaging only plan

    Background:
      Given Client API - Create EAP room to primary user with therapist2 provider
        | flowId            | 9                          |
        | age               | 18                         |
        | keyword           | alternativeseaptestkeyword |
        | employee Relation | EMPLOYEE                   |
        | state             | WY                         |
      And Browse to the email verification link for primary user
      And Client API - Switch to noAvailabilityTherapist provider in the first room for primary user
      And Sign two factor authentication for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal

    Scenario: EAP - Ask about availability - messaging only plan
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And Ask for alternative live session time with EAP_MESSAGING_ONLY plan
      And No availability - Click on ask about availability
      And Wait 5 seconds
      And Click on send
      And Prefilled text "What days and times work for you? Here are some times that work for me" appears

  Rule: EAP - Request Alternative Times - Live plan

    Background:
      Given Client API - Create EAP room to primary user with therapist2 provider
        | flowId            | 9                                 |
        | age               | 18                                |
        | keyword           | nottinghamhealthandrehabilitation |
        | employee Relation | EMPLOYEE                          |
        | state             | WY                                |
      And Browse to the email verification link for primary user
      And Client API - Switch to noAvailabilityTherapist provider in the first room for primary user
      And Sign two factor authentication for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal

    Scenario: EAP - Request Alternative Times - Live plan - One time booking - Select 3 preferred times
      And Open the Room details menu
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And Ask for alternative live session time with BH_MESSAGING_AND_LIVE plan
      And No availability - Select option "Prefer recurring booking"
      And No availability - Click 3 timeRange options and submit
      And Prefilled text "I’m interested in discussing your availability for recurring bookings." appears

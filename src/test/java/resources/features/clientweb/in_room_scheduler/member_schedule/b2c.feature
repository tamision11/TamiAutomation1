Feature: Client web - In-Room LVS Scheduler

  Rule: B2C - 30 minutes video therapy session

    Background:
      Given Client API - Create THERAPY room for primary user with therapist4 provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2648
    Scenario: B2C -Therapy - Book 30 minutes video session - Default time slot
      When Open the Room details menu
      And In-room scheduler - Click on book session button
      And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with B2C_MESSAGING_AND_LIVE plan and IGNORE state
      Then Room is available
      And Client API - There is 1 scheduled booking for primary user in the first room

    Scenario: B2C - Therapy - Reschedule 30 minutes video session - Default time slot
      When Open the Room details menu
      And In-room scheduler - Click on book session button
      And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with B2C_MESSAGING_AND_LIVE plan and IGNORE state
      Then Room is available
      When Open the Room details menu
      And In-room scheduler - Edit existing booking
      And in-room scheduler - Reschedule live session with B2C_MESSAGING_AND_LIVE plan
      And Client API - There is 1 scheduled booking for primary user in the first room

    @smoke
    Scenario: B2C - Therapy - Cancel 30 minutes video session
      Given Client API - Book 30 minutes session with therapist4 provider as primary user in the first room
      When Open the Room details menu
      And In-room scheduler - Edit existing booking
      And in-room scheduler - Cancel live session
      Then Room is available
      And Client API - There are 0 scheduled booking for primary user in the first room

    Scenario: B2C - Therapy - Cancel video session and switch provider
      Given Client API - Book 30 minutes session with therapist4 provider as primary user in the first room
      When Open the Room details menu
      And In-room scheduler - Edit existing booking
      And Click on cancel session radio button
      And In-room scheduler - Click on continue button
      And In-room scheduler - Click on cancel session button
      And Wait 10 seconds
      And Select from list the option "I do not think my provider is the right fit"
      And In-room scheduler - Click on cancel session button
      And in-room scheduler - Cancel live session - click on switch provider
      When Click on begin button
      And Rate provider with 2 stars
      And Click on next button
      And Select from list the option "I couldn't form a strong connection with my provider"
      When Click on next button
      And Select multiple focus
        | Anger Control Problems |
        | Anxiety                |
      When Click on next button
      And Change provider - Select MT state
      When Click on next button
      And Change provider - Click on No preferences
      And Client Web - Select the first provider from the list
      When Click on confirm button
      And Click on continue with therapist button
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And therapist4 is not the provider in the first room for primary user
      And Client API - There are 0 scheduled booking for primary user in the first room

    Scenario: B2C - Therapy - Cancel and Reschedule 30 minutes video session
      Given Client API - Book 30 minutes session with therapist4 provider as primary user in the first room
      When Open the Room details menu
      And In-room scheduler - Edit existing booking
      And in-room scheduler - Cancel and Reschedule live session with B2C_MESSAGING_AND_LIVE plan
      And Client API - There is 1 scheduled booking for primary user in the first room

  Rule: B2C - 45 minutes video therapy session

    Background:
      Given Client API - Create THERAPY room for primary user with therapist3 provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Client API - Subscribe to offer 127 of plan 883 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Dismiss modal

    Scenario: B2C - Therapy - Book 45 minutes video session - Default time slot
      When Open the Room details menu
      And In-room scheduler - Click on book session button
      And in-room scheduler - Book THERAPY live VIDEO session of FORTY_FIVE minutes with B2C_MESSAGING_AND_LIVE plan and IGNORE state
      Then Room is available
      And Client API - There is 1 scheduled booking for primary user in the first room

  Rule: B2C - Psychiatry - 60 minutes session
  no IC pooping up on onboarding modal since we are creating a psych room via API (slug) which is not a real scenario anymore
  We are cancelling the booking done via Onboarding modal first so we can check the In-Room scheduler functionality

    Background:
      And Client API - Create PSYCHIATRY room for primary user with psychiatrist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Client API - Subscribe to offer 120 of plan 717 with visa card of primary user in the first room
      And Onboarding - Dismiss modal

    Scenario: B2C - Psychiatry - Book 60 minutes Video session - Default time slot
      When Open the Room details menu
      And In-room scheduler - Click on book session button
      And in-room scheduler - Book PSYCHIATRY live VIDEO session of SIXTY minutes with B2C_MESSAGING_AND_LIVE plan and IGNORE state
      Then Room is available
      And Client API - There is 1 scheduled booking for primary user in the first room

  Rule: B2C - I can't find a time that works for me - Live plan

    Background:
    We are cancelling the booking done via Onboarding modal first so we can check the In-Room scheduler functionality

      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Dismiss modal

    @visual
    Scenario: B2C - I can't find a time that works for me - Live plan
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And Ask for alternative live session time with B2C_MESSAGING_AND_LIVE plan
      Then Shoot requesting alternative times element with scenario name as baseline

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2679
    Scenario: B2C - I can't find a time that works for me - Live plan
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And Ask for alternative live session time with B2C_MESSAGING_AND_LIVE plan
      And Click I can't find a time that works for me
      And Wait 5 seconds
      And Click on send
      And Prefilled text "but cannot meet during the times you have on your calendar. Are there any other times that work for you? Some times that might work for me are:" appears

  Rule: B2C - Ask about availability - Messaging only plan

    Background:
      And Client API - Create THERAPY room for primary user with noAvailabilityTherapist provider
        | state | MT |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Client API - Subscribe to offer 62 of plan 160 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Dismiss modal

    @visual
    Scenario: B2C - Ask about availability - Messaging only plan
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And Ask for alternative live session time with B2C_MESSAGING_ONLY plan
      Then Shoot baseline

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2678
    Scenario: B2C - Ask about availability - Messaging only plan
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And Ask for alternative live session time with B2C_MESSAGING_ONLY plan
      And No availability - Click on ask about availability
      And Wait 5 seconds
      And Click on send
      And Prefilled text "What days and times work for you? Here are some times that work for me" appears

  Rule: B2C - Request Alternative Times - Live plan - Time blocks

    Background:
      And Client API - Create THERAPY room for primary user with noAvailabilityTherapist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Dismiss modal

    @visual
    Scenario: B2C - Request Alternative Times - Live plan - Time blocks page
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And Ask for alternative live session time with B2C_MESSAGING_AND_LIVE plan
      Then Shoot baseline

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2725
    Scenario: B2C - Request Alternative Times - Live plan - Member available at any time
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And Ask for alternative live session time with B2C_MESSAGING_AND_LIVE plan
      And No availability - Click on im available any time
      And Prefilled text "I’d like to book my 30 minute live session. I am available at any time." appears

    Scenario: B2C - Request Alternative Times - Live plan - Select under 3 preferred times
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And Ask for alternative live session time with B2C_MESSAGING_AND_LIVE plan
      And No availability - Click 2 timeRange options and submit

    Scenario: B2C - Request Alternative Times - Live plan - one time booking - Select 3 preferred times
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And Ask for alternative live session time with B2C_MESSAGING_AND_LIVE plan
      And No availability - Click 3 timeRange options and submit
      And Prefilled text "I’d like to book my 30 minute live session. My preferred times are:" appears

    Scenario: B2C - Request Alternative Times - Live plan - recurring booking - Select 3 preferred times
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And Ask for alternative live session time with B2C_MESSAGING_AND_LIVE plan
      And No availability - Select option "Prefer recurring booking"
      And No availability - Click 3 timeRange options and submit
      And Prefilled text "I’m interested in discussing your availability for recurring bookings." appears

  Rule: B2C - Scheduling Live session when no credits available

    Scenario: B2C - Therapy - Purchase + book live session when no credits available
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Client API - Subscribe to offer 66 of plan 160 with visa card of primary user in the first room
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And in-room scheduler - Book live session with purchase
      And Client API - There is 1 scheduled booking for primary user in the first room
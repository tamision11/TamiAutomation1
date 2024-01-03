@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2564
Feature: Client web - Cancel Subscription
  added IL as country step before the purchase in order to always get offer 62 original plans
  we change it back to US after the purchase in order to be able to trigger fin aid.

  Rule: US customers

    Background:
      And Therapist API - Login to therapist4 provider
      Given Client API - Create THERAPY room for primary user with therapist4 provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Therapist API - Set primary user Information with therapist4 provider
        | country | IL |
      And Refresh the page
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Therapist API - Set primary user Information with therapist4 provider
        | country | US |
        | state   | WY |
      And Wait 5 seconds
      And Navigate to payment and plan URL
      And Click on Cancel subscription
      And Rate provider with 2 stars
      And Cancel Subscription - Click on submit review button
      And Cancel Subscription - Click on no thanks button
      And Cancel Subscription - Click on button don't pause Subscription
      And Cancel Subscription - Click on not interested in new provider button
      And Cancel Subscription - Click on not interested in plan button
      And Select from list the option "The cost doesn't fit my budget"
      And Cancel Subscription - Click on next button to select reason

    @visual
    Scenario: Financial Aid - Visual regression
      Then Shoot baseline "Client Web - Cancel Subscription - Financial Aid"
      And Cancel Subscription - Click on not interested in financial aid button
      And Cancel Subscription - Click on cancel renewal button
      Then Shoot baseline "Client Web - Cancel Subscription - Do not apply financial Aid"

    @visual
    Scenario: Financial Aid - Visual regression
      And Cancel Subscription - Click on apply financial aid button
      Then Shoot baseline "Client Web - Financial Aid - employment status"
      And Select from list the option "Unemployed"
      And Click on next button
      Then Shoot baseline "Client Web - Financial Aid - status of your spouse"
      And Select from list the option "I'm not married"
      And Click on next button
      Then Shoot baseline "Client Web - Financial Aid - annual salary"
      And Select from list the option "Under $25,000"
      And Click on next button
      Then Shoot baseline "Client Web - Financial Aid - military service"
      And Financial aid - Click yes under serving in military
      Then Shoot baseline "Client Web - Financial Aid - is veteran"
      And Financial aid - Click yes under is veteran
      Then Shoot baseline "Client Web - Financial Aid - household benefits"
      And Financial aid - Click no household benefits
      Then Shoot baseline "Client Web - Financial Aid - rural area"
      And Financial aid - Click yes living in rural area
      And Financial aid - Click check eligibility
      Then Shoot baseline "Client Web - Financial Aid - check eligibility - 40% flow"
      And Financial aid - Click apply financial aid discount
      Then Shoot baseline "Client Web - Financial Aid - apply discount"
      And Financial aid - Click done
      And Click on view details button
      Then Shoot next renewal dialog element as "Client Web - Financial Aid - plan page/next renewal" baseline

    Scenario: 40% discount flow
      And Cancel Subscription - Click on apply financial aid button
      And Select from list the option "Unemployed"
      And Click on next button
      And Select from list the option "I'm not married"
      And Click on next button
      And Select from list the option "Under $25,000"
      And Click on next button
      And Financial aid - Click yes under serving in military
      And Financial aid - Click yes under is veteran
      And Financial aid - Click no household benefits
      And Financial aid - Click yes living in rural area
      And Financial aid - Click check eligibility
      And Financial aid - Click apply financial aid discount
      And Financial aid - Click done
      And Click on view details button

    Scenario: 10% discount flow
      And Cancel Subscription - Click on apply financial aid button
      And Select from list the option "Full-time"
      And Click on next button
      And Select from list the option "Full-time"
      And Click on next button
      And Select from list the option "$25,001-$45,000"
      And Click on next button
      And Financial aid - Click no under serving in military
      And Financial aid - Click no under is veteran
      And Financial aid - Click no household benefits
      And Financial aid - Click no living in rural area
      And Financial aid - Click check eligibility
      And Financial aid - Click apply financial aid discount
      And Financial aid - Click done
      And Click on view details button

  Rule: Non US customers

    Background:
      And Therapist API - Login to therapist4 provider
      Given Client API - Create THERAPY room for primary user with therapist4 provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Client API - Subscribe to offer 62 of plan 411 with visa card of primary user in the first room
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Therapist API - Set primary user Information with therapist4 provider
        | country | GB |
      And Navigate to payment and plan URL
      And Click on Cancel subscription
      And Rate provider with 2 stars
      And Cancel Subscription - Click on submit review button
      And Cancel Subscription - Click on no thanks button
      And Cancel Subscription - Click on button don't pause Subscription
      And Cancel Subscription - Click on not interested in new provider button
      And Cancel Subscription - Click on not interested in plan button
      And Select from list the option "The cost doesn't fit my budget"
      And Cancel Subscription - Click on next button to select reason

    @visual
    Scenario: No financial aid option for non-US user
      Then Shoot baseline
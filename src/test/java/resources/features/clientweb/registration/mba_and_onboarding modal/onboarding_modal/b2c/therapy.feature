@owner=nir_tal
Feature: Client web - Registration - MBA and Onboarding

  @visual
  Scenario: Onboarding - meet your provider and scheduler - Visual regression
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    Then Shoot baseline "Client Web - Onboarding - Meet you provider"
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    Then Shoot baseline "Client Web - Onboarding - Treatment intake finished"
    And Onboarding - Click on close button
         ### Treatment intake finished ###
    Then Room is available
    And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
    And Refresh the page
    Then Shoot baseline "Client Web - Onboarding - Book your first session"
    And Onboarding - Click on continue button
    And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with B2C_MESSAGING_AND_LIVE plan and IGNORE state
    ### Onboarding finished ###
    Then Shoot baseline "Client Web - Onboarding - You’re all done! You’ve completed all the steps needed to begin treatment"

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2738
  Scenario: Onboarding - Provider slug - Book live first session - B2C - Live and Messaging plan - Live state
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | MT |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
    And Refresh the page
    And Onboarding - Click on continue button
    And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with B2C_MESSAGING_AND_LIVE plan and IGNORE state
    Then Onboarding - Click on close button
    And Room is available

  @admin
  Scenario: Onboarding - QUEUE match - No Book Live first session - B2C - Messaging only plan - Non-Live state
    Given Navigate to flow90
    When Select THERAPY service
    And Select to pay out of pocket
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Male                           |
      | provider gender                                    | Male                           |
      | age                                                | 18                             |
      | state                                              | WY                             |
    And Click on secure your match button
    And Email wall - Click on continue after Inserting PRIMARY email
    When Select the second plan
    And Continue with "Monthly" billing period
    And Apply free coupon if running on prod
    And Payment - Click on continue
    And Payment - Complete purchase using "visa" card for primary user
    And Create account for primary user with
      | password     | STRONG |
      | nickname     | VALID  |
      | phone number |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Admin API - Execute MATCH_ROOMS_FROM_QUEUE_WITH_PROVIDER cron
    And Onboarding - Click on meet your provider button
    Then Onboarding - Click on close button
    Then Room is available

  @admin
  Scenario: Onboarding - QUEUE match - Book Live first session - B2C - Messaging only plan - Live state
    Given Navigate to flow90
    When Select THERAPY service
    And Select to pay out of pocket
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Male                           |
      | provider gender                                    | Male                           |
      | age                                                | 18                             |
      | state                                              | MT                             |
    And Click on secure your match button
    And Email wall - Click on continue after Inserting PRIMARY email
    When Select the second plan
    And Continue with "Monthly" billing period
    And Apply free coupon if running on prod
    And Payment - Click on continue
    And Payment - Complete purchase using "visa" card for primary user
    And Create account for primary user with
      | password     | STRONG |
      | nickname     | VALID  |
      | phone number |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click continue on book first session
    And Onboarding - Click continue on modality selection
    And Onboarding - Click continue on duration selection
    And In-room scheduler - Click on Next available button if present
    And Onboarding - Click i'll book later
    And Onboarding - Click i'll book later
    And Onboarding - Click continue on your all done screen
    And Admin API - Execute MATCH_ROOMS_FROM_QUEUE_WITH_PROVIDER cron
    And Onboarding - Click on meet your provider button
    And Onboarding - Click continue on book first session
    And in-room scheduler - Book THERAPY live VIDEO session of TEN minutes with B2C_MESSAGING_ONLY plan and IGNORE state
    Then Onboarding - Click on close button
    Then Room is available
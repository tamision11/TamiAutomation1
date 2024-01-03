Feature: QM - Language Matching - Change provider flows

  Background:
    Given LaunchDarkly - SPANISH_LANGUAGE_MAPPING feature flag activation status is true

  Rule: Change therapist from change provider wizard

    Background:
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Client API - Subscribe to offer 62 of plan 160 with visa card of primary user in the first room
      When Navigate to payment and plan URL
      And Click on Change provider button

    Scenario: Language Matching - Change provider flows - Change therapist - non-English as hard filter - therapist found
      When Click on begin button
      And Rate provider with 2 stars
      And Click on next button
      And Select from list the option "I couldn't form a strong connection with my provider"
      When Click on next button
      And Select multiple focus
        | Anger Control Problems |
        | Anxiety                |
      When Click on next button
      And Change provider - Select LA state
      When Click on next button
      And Wait 5 seconds
      And Change provider - Click on No preferences
      And Select from list the option "Spanish"
      When Click on next button
      And Select non-english as hard filter
      And Client Web - Select the first provider from the list
      When Click on confirm button
      And Click on continue with therapist button
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      Then Room is available
      And therapistLanguage is the provider in the first room for primary user

    Scenario: Language Matching - Change provider flows - Change therapist - non-English as soft filter - therapist found
      When Click on begin button
      And Rate provider with 2 stars
      And Click on next button
      And Select from list the option "I couldn't form a strong connection with my provider"
      When Click on next button
      And Select multiple focus
        | Anger Control Problems |
        | Anxiety                |
      When Click on next button
      And Change provider - Select LA state
      When Click on next button
      And Wait 5 seconds
      And Change provider - Click on No preferences
      And Select from list the option "Spanish"
      When Click on next button
      And Select non-english as soft filter
      And Client Web - Select the first provider from the list
      When Click on confirm button
      And Click on continue with therapist button
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      Then Room is available
      And therapist is not the provider in the first room for primary user

    @visual
    Scenario: Language Matching - Change provider flows - Language matching screens - visual
      When Click on begin button
      And Rate provider with 2 stars
      And Click on next button
      And Select from list the option "I couldn't form a strong connection with my provider"
      When Click on next button
      And Select multiple focus
        | Anger Control Problems |
        | Anxiety                |
      When Click on next button
      And Change provider - Select LA state
      When Click on next button
      And Wait 5 seconds
      And Change provider - Click on No preferences
      Then Shoot baseline "CLIENT-WEB - Language matching - Change provider flows - Language selection screen"
      And Select from list the option "Spanish"
      When Click on next button
      Then Shoot baseline "CLIENT-WEB - Language matching - Change provider flows - hard\soft filter screen"


  Rule: Change psychiatrist from change provider wizard

    Background:
      And Client API - Create PSYCHIATRY room for primary user with psychiatrist
        | state | LA |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      When Client API - Subscribe to offer 61 of plan 138 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first PSYCHIATRY live VIDEO session with IGNORE state
      When Navigate to payment and plan URL
      And Click on Change provider button

    @ignore
    Scenario: Language Matching - Change provider flows - Change psychiatrist - non-English as hard filter - psychiatrist found
      When Click on begin button
      And Select from list the option "I couldn't form a strong connection with my provider"
      When Click on next button
      And Select multiple focus
        | Anger Control Problems |
      When Click on next button
      When Click on next button
      When Click on next button
      And Change provider - Click on No preferences
      And Select from list the option "Spanish"
      When Click on next button
      And Select non-english as soft filter
      And Client Web - Select the first provider from the list
      When Click on confirm button
      And Click on continue with therapist button
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first PSYCHIATRY live VIDEO session with IGNORE state
      Then Room is available
      And therapistLanguage is the provider in the first room for primary user


  Rule: Change therapist from change provider wizard opened via cancel plan wizard

    Background:
      And Therapist API - Login to therapist3 provider
      Given Client API - Create THERAPY room for primary user with therapist3 provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Client API - Subscribe to offer 62 of plan 160 with visa card of primary user in the first room
      And Navigate to payment and plan URL
      And Click on Cancel subscription

    Scenario: Language Matching - Change provider flows - Change therapist from cancel plan wizard - non-English as hard filter - therapist found
      And Rate provider with 2 stars
      When Cancel Subscription - Click on submit review button
      When Cancel Subscription - Click on no thanks button
      When Cancel Subscription - Click on button don't pause Subscription
      When Cancel Subscription - Click on new provider button
      When Click on begin button
      And Select from list the option "I couldn't form a strong connection with my provider"
      When Click on next button
      And Select multiple focus
        | Anger Control Problems |
      When Click on next button
      And Change provider - Select LA state
      When Click on next button
      When Click on next button
      And Change provider - Click on No preferences
      And Select from list the option "Spanish"
      When Click on next button
      And Select non-english as soft filter
      And Client Web - Select the first provider from the list
      When Click on confirm button
      And Click on continue with therapist button
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      Then Room is available
      And therapistLanguage is the provider in the first room for primary user
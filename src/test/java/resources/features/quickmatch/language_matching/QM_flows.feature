Feature: QM - Language Matching - QM flows

#  Background:
#    Given LaunchDarkly - SPANISH_LANGUAGE_MAPPING feature flag activation status is true

  Rule: Flow 90

    Background:
      Given Navigate to flow90

    @smoke
    @issue=talktala.atlassian.net/browse/MEMBER-3224
    Scenario: Language Matching - QM flows - Flow 90 - THERAPY - B2C - non-english as hard filter - go to MBA
    this test verifies the user is redirected to MBA bc of Live state and gets assigned to a provider that supports spanish since it's a hard filter
      Given LaunchDarkly - LANGUAGE_MATCHING_THERAPY_B2C feature flag activation status is true
      When Select THERAPY service
      And Select to pay out of pocket
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Male                           |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | LA                             |
      And Select non-english as preferred language
      And Select non-english as hard filter
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      When Select the first plan
      And Continue with "Monthly" billing period
      And Apply free coupon if running on prod
      And Payment - Click on continue
      And B2C Payment - Complete purchase using visa card with stripe link false
      And Create account for primary user with
        | password     | STRONG |
        | nickname     | VALID  |
        | phone number |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on continue button
      And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
    And Onboarding - Click on close button
    And therapistLanguage is the provider in the first room for primary user

    @issue=talktala.atlassian.net/browse/MEMBER-3224
    Scenario: Language Matching - QM flows - Flow 90 - THERAPY - BH - non-english as hard filter - Go to queue
    this test verifies the user is still redirected to queue bc of Messaging preferences and inspite of language selection.
      Given LaunchDarkly - LANGUAGE_MATCHING_THERAPY_BH feature flag activation status is true
      When Select THERAPY service
      And Select to pay through insurance provider
      And Continue with "Anthem" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18      |
        | state     | OH      |
        | Member ID | COPAY_0 |
      And Click on continue on coverage verification
      And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Male                           |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Select non-english as preferred language
    And Select non-english as hard filter
    And Click on secure your match button
    And Email wall - Click on continue after Inserting PRIMARY email
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | phone number      |          |
    And QM - Select MESSAGING as first Live booking modality for B2B_BH plan
    And QM - Modality preference - Click on messaging information next button
    And QM - Modality preference - Click on messaging information confirm session button
    And Payment - Complete purchase using "visa" card for primary user
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
      | checkbox |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Room is available
    And Client API - The first room status of primary user is WAITING_TO_BE_MATCHED_QUEUE

    @issue=talktala.atlassian.net/browse/MEMBER-3261
    Scenario: Language Matching - QM flows - Flow 90 - THERAPY - BH - Live preference - non-english as soft filter - go to MBA
    this test verifies the user is redirected to MBA bc of Live preference and won't necessarily gets assigned to a provider that supports spanish since it's a soft filter
      Given LaunchDarkly - LANGUAGE_MATCHING_THERAPY_BH feature flag activation status is true
      When Select THERAPY service
      And Select to pay through insurance provider
      And Continue with "Anthem" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18      |
        | state     | OH      |
        | Member ID | COPAY_0 |
      And Click on continue on coverage verification
      And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Male                           |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Select non-english as preferred language
    And Select non-english as soft filter
    And Click on secure your match button
    And Email wall - Click on continue after Inserting PRIMARY email
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | phone number      |          |
    And QM - Select VIDEO as first Live booking modality for B2B_BH plan
    And Payment - Complete purchase using "visa" card for primary user
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
      | checkbox |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on continue button
    And MBA - Book first THERAPY live VIDEO session with LIVE_PREFERENCE selection
    And Onboarding - Click on meet your provider button
    And Onboarding - Click on close button
    And “Next Live session is scheduled for“ banner appears

    Scenario: Language Matching - QM flows - Flow 90 - THERAPY - BH - English selected - Go to MBA
    this test verifies the user is redirected to MBA and won't necessarily gets assigned to a provider that supports spanish since English is selected as preferred language.
      Given LaunchDarkly - LANGUAGE_MATCHING_THERAPY_BH feature flag activation status is true
      When Select THERAPY service
      And Select to pay through insurance provider
      And Continue with "Anthem" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18      |
        | state     | LA      |
        | Member ID | COPAY_0 |
      And Click on continue on coverage verification
      And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Male                           |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Select english as preferred language
    And Click on secure your match button
    And Email wall - Click on continue after Inserting PRIMARY email
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | phone number      |          |
    And Payment - Complete purchase using "visa" card for primary user
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
      | checkbox |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on continue button
    And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
    And Onboarding - Click on meet your provider button
    And Onboarding - Click on close button
    And “Next Live session is scheduled for“ banner appears

    @issue=talktala.atlassian.net/browse/MEMBER-3223
    Scenario: Language Matching - QM flows - Flow 90 - THERAPY - EAP - non-english as hard filter - Go to queue
    this test verifies the language preferences screens on THERAPY EAP flow
      Given LaunchDarkly - LANGUAGE_MATCHING_DEFAULT feature flag activation status is true
      When Select THERAPY service
      And Select to pay through an organization
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Male                           |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | OH                             |
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      And Write "kga" in organization name
      And Click on next button
      And Enter RANDOM email
      And Click on next button
      When Complete kga eap validation form for primary user
        | authorization code | MOCK_KGA |
        | age                | 18       |
        | service type       | THERAPY  |
        | Email              | PRIMARY  |
        | employee Relation  | EMPLOYEE |
        | state              | ID       |
        | phone number       |          |
      And Click on continue on coverage verification
      And Select non-english as preferred language
      And Select non-english as hard filter
      And QM - Select MESSAGING as first Live booking modality for B2B_EAP plan
      And QM - Modality preference - Click on messaging information next button
      And QM - Modality preference - Click on messaging information confirm session button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Room is available
      And Client API - The first room status of primary user is WAITING_TO_BE_MATCHED_QUEUE

    @issue=talktala.atlassian.net/browse/MEMBER-3297
    Scenario: Language Matching - QM flows - Flow 90 - COUPLES - BH - non-english as hard filter - go to MBA
    this test verifies the language preferences screens on COUPLES BH flow
      Given LaunchDarkly - LANGUAGE_MATCHING_DEFAULT feature flag activation status is true
      When Select COUPLES_THERAPY service
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
      | state                                                             | LA                                |
    And Continue with "Cigna" insurance provider
    And Click on secure your match button
    And Complete shared validation form for primary user
      | age               | 18       |
      | Member ID         | COPAY_0  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | state             | LA       |
      | phone number      |          |
    And Click on continue on coverage verification
    And Select non-english as preferred language
    And Select non-english as hard filter
    And Payment - Complete purchase using "visa" card for primary user
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
      | checkbox |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on continue button
      And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      Then Click on you have some pending tasks banner
      And “Next Live session is scheduled for“ banner appears
      And therapistLanguage is the provider in the first room for primary user

    @issue=talktala.atlassian.net/browse/MEMBER-3299
    Scenario: Language Matching - Flow 90 - COUPLES - EAP - non-english as hard filter - go to MBA
      Given LaunchDarkly - LANGUAGE_MATCHING_DEFAULT feature flag activation status is true
      When Select COUPLES_THERAPY service
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
        | state                                                             | LA                                |
      And Click on I have talkspace through an organization
      When Write "humana" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      And Complete shared validation form for primary user
        | age               | 18       |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | LA       |
        | phone number      |          |
      And Select non-english as preferred language
      And Select non-english as hard filter
      And Click on continue on coverage verification
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on continue button
      And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      Then Click on you have some pending tasks banner
      And “Next Live session is scheduled for“ banner appears
      And therapistLanguage is the provider in the first room for primary user

    @issue=talktala.atlassian.net/browse/MEMBER-3299
    Scenario: Language Matching - Flow 90 - COUPLES - B2C - non-english as hard filter - go to MBA
    this test verifies the language preferences screens on THERAPY B2C flow
      Given LaunchDarkly - LANGUAGE_MATCHING_DEFAULT feature flag activation status is true
      When Select COUPLES_THERAPY service
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
        | state                                                             | LA                                |
      And Continue without insurance provider after selecting "I’ll pay out of pocket"
      And Select non-english as preferred language
      And Select non-english as hard filter
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      And Select the first plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      And Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password     | STRONG |
        | nickname     | VALID  |
        | checkbox     |        |
        | phone number |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on continue button
      And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      Then Click on you have some pending tasks banner
      And therapistLanguage is the provider in the first room for primary user

    @issue=talktala.atlassian.net/browse/MEMBER-3299
    Scenario: Language Matching - QM flows - Flow 90 - PSYCHIATRY - BH - non-english as hard filter - go to MBA
    this test verifies the language preferences screens on PSYCHIATRY BH flow
      Given LaunchDarkly - LANGUAGE_MATCHING_DEFAULT feature flag activation status is true
      When Select PSYCHIATRY service
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider       | Anxiety |
        | prescribed medication to treat a mental health condition | Yes     |
        | your gender                                              | Female  |
        | provider gender                                          | Male    |
        | age                                                      | 18      |
        | state                                                    | LA      |
      And Continue with "Optum" insurance provider
      And Click on secure your match button
      And Complete shared validation form for primary user
        | age               | 18                                  |
        | Member ID         | COPAY_0                             |
        | Email             | PRIMARY                             |
        | employee Relation | ADULT_DEPENDENT_MEMBER_OF_HOUSEHOLD |
        | state             | LA                                  |
        | phone number      |                                     |
      And Select non-english as preferred language
      And Select non-english as hard filter
      And Click on continue to checkout button
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
        | checkbox |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on continue button
      And MBA - Book first PSYCHIATRY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And psychiatristLanguage is the provider in the first room for primary user

    @issue=talktala.atlassian.net/browse/MEMBER-3299
    Scenario: Language Matching - QM flows - Flow 90 - PSYCHIATRY - B2C - non-english as hard filter - go to MBA
    this test verifies the language preferences screens on PSYCHIATRY B2C flow
      Given LaunchDarkly - LANGUAGE_MATCHING_DEFAULT feature flag activation status is true
      When Select PSYCHIATRY service
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider       | Anxiety |
        | prescribed medication to treat a mental health condition | Yes     |
        | your gender                                              | Female  |
        | provider gender                                          | Male    |
        | age                                                      | 18      |
        | state                                                    | LA      |
      And Continue without insurance provider after selecting "I’ll pay out of pocket"
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      And Select the first plan
      When Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password     | STRONG |
        | nickname     | VALID  |
        | checkbox     |        |
        | phone number |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on continue button
      And MBA - Book first PSYCHIATRY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And psychiatristLanguage is the provider in the first room for primary user

    Scenario: Language Matching - QM flows - Flow 90 - TEENS (Broadway) - non-english as hard filter - go to MBA
    this test verifies the language preferences screens on TEENS (Broadway) flow 128
      Given LaunchDarkly - LANGUAGE_MATCHING_TEEN_FLOW_128 feature flag activation status is true
      Given Create "parent" user
      When Select TEEN_THERAPY service
      And Complete the matching questions with the following options
        | does your school or city offer talkspace for free | Yes, I think so |
      And Complete broadway validation form for primary user
        | age     | 13      |
        | Email   | PRIMARY |
        | address | NYC     |
      And Teens NYC - Click on continue button
      And Teens NYC - Click on continue button
      And Complete the matching questions with the following options
        | how often do you feel stressed | Very often          |
        | what do you need support with  | Anxiety or worrying |
      And Teens NYC - Click on continue button
      And Complete the matching questions with the following options
        | have you talked to your parent or guardian about doing therapy | Yes |
      And Teens NYC - Click on continue button
      And Complete the matching questions with the following options
        | how do you feel about doing therapy | Nervous, Calm |
        | your gender                         | Male          |
        | provider gender preference          | Male          |
      And Select non-english as preferred language
      And Select non-english as hard filter
      And Teens NYC - Click on continue button
      And Create account for primary user with
        | password     | STRONG |
        | nickname     | VALID  |
        | phone number |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for teen primary user with "parent" parental consent
      And Onboarding - Click on continue button
      And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And therapistLanguage is the provider in the first room for primary user

    @issue=talktala.atlassian.net/browse/MEMBER-3129
    Scenario: Language Matching - QM flows - Flow 90 - TEENS - B2C - non-english as hard filter - go to MBA
    this test verifies the language preferences screens on TEENS flow (140)
      Given LaunchDarkly - LANGUAGE_MATCHING_THERAPY_B2C feature flag activation status is true
      Given Create "parent" user
      When Select TEEN_THERAPY service
      And Complete the matching questions with the following options
        | does your school or city offer talkspace for free | I’ll use a different form of coverage |
      And Select to pay out of pocket
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 13                             |
        | Parental consent                                   | Yes                            |
        | state                                              | LA                             |
      And Select non-english as preferred language
      And Select non-english as hard filter
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      When Select the second plan
      And Continue with "Monthly" billing period
      And Apply free coupon if running on prod
      And Payment - Click on continue
      And B2C Payment - Complete purchase using visa card with stripe link false
      And Create account for primary user with
        | password     | STRONG |
        | nickname     | VALID  |
        | phone number |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for teen primary user with "parent" parental consent
      And Onboarding - Click on continue button
      And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And therapistLanguage is the provider in the first room for primary user

    @admin
    @issue=talktala.atlassian.net/browse/MEMBER-3116
    Scenario: Language Matching - QUEUE match - Match provider with language as hard filter
    this test verifies that member selected language as hard filter and sent to queue will be matched correctly by the matching cron
      When Select THERAPY service
      And Select to pay through insurance provider
      And Continue with "Anthem" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18      |
        | state     | OH      |
        | Member ID | COPAY_0 |
      And Click on continue on coverage verification
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Male                           |
        | provider gender                                    | Male                           |
        | state                                              | Continue with prefilled state  |
      And Select non-english as preferred language
      And Select non-english as hard filter
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      And Complete shared after upfront coverage verification validation form for primary user
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | phone number      |          |
      And QM - Select MESSAGING as first Live booking modality for B2B_BH plan
      And QM - Modality preference - Click on messaging information next button
      And QM - Modality preference - Click on messaging information confirm session button
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
        | checkbox |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Room is available
      And Client API - The first room status of primary user is WAITING_TO_BE_MATCHED_QUEUE
      And Admin API - Execute MATCH_ROOMS_FROM_QUEUE_WITH_PROVIDER cron
      And Onboarding - Click on meet your provider button
      And Start async messaging session with B2B_BH plan and MESSAGING_PREFERENCE selection
      And “Messaging Session in progress“ banner appears
      And therapistLanguage is the provider in the first room for primary user

    @visual
    Scenario: Language Matching - QM - Language matching screens - visual
    this test verifies the user is redirected to MBA bc of Live state and gets assigned to a provider that supports spanish since it's a hard filter
      Given LaunchDarkly - LANGUAGE_MATCHING_THERAPY_B2C feature flag activation status is true
      When Select THERAPY service
      And Select to pay out of pocket
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Male                           |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | LA                             |
      Then Shoot baseline "QM - Language matching - Language selection screen"
      And Select non-english as preferred language
      Then Shoot baseline "QM - Language matching - hard\soft filter screen"


  Rule: Reactivation

    Background:
      Given Therapist API - Login to therapist3 provider
      Given Client API - Create THERAPY room for primary user with therapist3 provider
        | state | LA |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Client API - Subscribe to offer 62 of plan 160 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Client API - Cancel Subscription of primary user in the first room
      And Client API - Refund Charge of primary user
      And Navigate to payment and plan URL
      And Click on Subscribe button

    @issue=talktala.atlassian.net/browse/MEMBER-3224
    Scenario: Language Matching - Reactivation - THERAPY - BH - Match with new provider - non-english as hard filter - go to MBA
    this test verifies the language preferences screens are showing for reactivation when selecting to match with a new provider
      Given LaunchDarkly - LANGUAGE_MATCHING_THERAPY_BH feature flag activation status is true
      And Click on continue
      And Reactivation - Select THERAPY service
      And Select to pay through insurance provider
      And Continue with "Premera" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18      |
        | state     | LA      |
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
      And Select non-english as preferred language
      And Select non-english as hard filter
      And Click on secure your match button
      And Complete shared after upfront coverage verification validation form for primary user
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And Onboarding - Click continue on book first session
      And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And “Next Live session is scheduled for“ banner appears
      And therapistLanguage is the provider in the first room for primary user

    Scenario: Language Matching - Reactivation - Continue with current provider - new BH room - no language selection
    this test verifies the language preferences screens are not showing for reactivation when selecting to stay with current provider
      Given LaunchDarkly - LANGUAGE_MATCHING_THERAPY_BH feature flag activation status is true
      And Click on continue
      And Reactivation - Select THERAPY service
      And Select to pay through insurance provider
      And Continue with "Premera" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18      |
        | state     | LA      |
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
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
      And Payment - Complete purchase using "visa" card for primary user
      And Reactivation - Click on continue to room button
      And in-room scheduler - Book THERAPY live VIDEO session of FORTY_FIVE minutes with BH_MESSAGING_AND_LIVE plan and LIVE state
      And Onboarding - Click on close button
      And “Next Live session is scheduled for“ banner appears
      And therapist3 is the provider in the first room for primary user


  Rule: ACKP

    Background:
      Given Therapist API - Login to therapist3 provider
      Given Client API - Create THERAPY room for primary user with therapist3 provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Client API - Subscribe to offer 62 of plan 160 with visa card of primary user in the first room
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Open account menu
      And Account Menu - Select update my coverage


    Scenario: Language Matching - ACKP - THERAPY - current provider available - new BH room - no language selection
    this test verifies the language preferences screens are not showing for ACKP when current provider is available
      Given LaunchDarkly - LANGUAGE_MATCHING_THERAPY_BH feature flag activation status is true
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay through insurance provider
      And Continue with "Premera" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18      |
        | state     | LA      |
        | Member ID | COPAY_0 |
      And Click on continue on coverage verification
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | state                                              | LA                             |
      And Complete shared after upfront coverage verification validation form for primary user
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
      And Payment - Complete purchase using "visa" card for primary user
      And Update my coverage - Click on go to my new room
      And in-room scheduler - Book THERAPY live VIDEO session of SIXTY minutes with BH_MESSAGING_AND_LIVE plan and LIVE state
      And Onboarding - Click on close button
      And “Next Live session is scheduled for“ banner appears
      And therapist3 is the provider in the first room for primary user

    Scenario: Language Matching - ACKP - THERAPY - current provider NOT available - new BH room - language selection is showing
    this test verifies the language preferences screens are showing for ACKP when current provider is not available (changed state to ID so no provider available)
      Given LaunchDarkly - LANGUAGE_MATCHING_THERAPY_BH feature flag activation status is true
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay through insurance provider
      And Continue with "Premera" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18      |
        | state     | ID      |
        | Member ID | COPAY_0 |
      And Click on continue on coverage verification
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | state                                              | Continue with prefilled state  |
      And Select non-english as preferred language
      And Select non-english as hard filter
      And Click on secure your match button
      And Complete shared after upfront coverage verification validation form for primary user
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
      And Payment - Complete purchase using "visa" card for primary user
      And Update my coverage - Click on continue on confirmation
      And Client API - The second room status of primary user is WAITING_TO_BE_MATCHED_QUEUE
      And Client API - The first room status of primary user is NOT_RENEW

    Scenario: Language Matching - ACKP - Therapy - current provider NOT available - new B2C room - language selection is showing
      Given LaunchDarkly - LANGUAGE_MATCHING_THERAPY_B2C feature flag activation status is true
      And Update my coverage - Select THERAPY plan to update
      And Update my coverage - Click on continue button
      And Update my coverage - Select to pay out of pocket
      And Update my coverage - Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | ID                             |
      And Select non-english as preferred language
      And Select non-english as hard filter
      And Click on secure your match button
      And Select the first plan
      And Continue with "Monthly" billing period
      And Apply free coupon if running on prod
      When Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
      And Update my coverage - Click on continue on confirmation
      And Client API - The second room status of primary user is WAITING_TO_BE_MATCHED_QUEUE
      And Client API - The first room status of primary user is NOT_RENEW


  Rule: Add a service

    Background:
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | LA |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      When Open account menu
      Then Account Menu - Select add a new service
      And Select THERAPY service
      And Select to pay through an organization
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | Continue with prefilled state  |
      And Click on secure your match button

    Scenario: Language Matching - Add a service - THERAPY - new DTE room - non-english as hard filter - go to MBA
      Given LaunchDarkly - LANGUAGE_MATCHING_DEFAULT feature flag activation status is true
      And Write "google" in organization name
      And Click on next button
      And Enter RANDOM email
      And Click on next button
      And Complete google validation form for primary user
        | age               | 18       |
        | employee Relation | EMPLOYEE |
      And Select non-english as preferred language
      And Select non-english as hard filter
      And Eligibility Widget - Click on start treatment button
      And Onboarding - Click continue on book first session
      And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And therapistLanguage is the provider in the first room for primary user


  Rule: BH no insurance

    Background:
      Given Navigate to flow90
      When Select THERAPY service
      And Select to pay through insurance provider
      And Continue with "Premera" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18           |
        | state     | LA           |
        | Member ID | NOT_ELIGIBLE |

    @issue=talktala.atlassian.net/browse/MEMBER-3287
    Scenario: Language Matching - BH no insurance - Flow 90 - THERAPY - switch to organization flow - non-english as hard filter - go to MBA
      Given LaunchDarkly - LANGUAGE_MATCHING_DEFAULT feature flag activation status is true
      And BH no insurance - Click on continue with EAP button
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Male                           |
        | provider gender                                    | Male                           |
        | state                                              | Continue with prefilled state  |
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      And Write "test" in organization name
      And Click on next button
      And Enter RANDOM email
      And Click on next button
      And Click on I have a keyword or access code button
      And Enter "kga" access code
      And Click on next button
      And Unified eligibility page - enter MOCK_KGA authorization code
      And Complete shared after upfront coverage verification validation form for primary user
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | phone number      |          |
      And Click on continue on coverage verification
      And Select non-english as preferred language
      And Select non-english as hard filter
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on continue button
      And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And “Next Live session is scheduled for“ banner appears
      And therapistLanguage is the provider in the first room for primary user

    Scenario: Language Matching - BH no insurance - Flow 90 - Therapy - switch to B2C flow - non-english as hard filter - go to MBA
      Given LaunchDarkly - LANGUAGE_MATCHING_THERAPY_B2C feature flag activation status is true
      And BH no insurance - Click on continue without insurance
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Male                           |
        | provider gender                                    | Male                           |
        | state                                              | Continue with prefilled state  |
      And Select non-english as preferred language
      And Select non-english as hard filter
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      When Select the first plan
      And Continue with "Monthly" billing period
      And Apply free coupon if running on prod
      And Payment - Click on continue
      And B2C Payment - Complete purchase using visa card with stripe link false
      And Create account for primary user with
        | password     | STRONG |
        | nickname     | VALID  |
        | phone number |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on continue button
      And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
      And Onboarding - Click on meet your provider button
      And Onboarding - Click on close button
      And therapistLanguage is the provider in the first room for primary user
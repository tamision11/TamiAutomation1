@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2650
Feature: Client web - Payment

  Rule: Payment via client web

    Scenario: Stripe Link - Client Web - Update information with valid card and stripe link after plan Purchase - Update multiple cards
      And Therapist API - Login to therapist provider
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Therapist API - Set primary user Information with therapist provider
        | country | IL |
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      When Open account menu
      And Account Menu - Select payment and plan
      When Payment and Plan - Click on the update button
      When Update payment details to masterCard card with stripe link true
      When Payment and Plan - Click on save button
      When Click on done button
      When Payment and Plan - Click on the update button
      When Payment and Plan - Insert stripe link code
      When Payment and Plan - add new payment method
      When Update payment details to visa card with stripe link false
      When Payment and Plan - Click on save button
      When Click on done button
      When Payment and Plan - Click on the update button
      And Update payment details - Insert visa card holder name
      And Payment and Plan - change payment method
      And Payment and Plan - Credit card list has 2 cards
      When Payment and Plan - Click on save button
      When Click on done button
      And Payment and Plan - Payment method is stripe link true

    Scenario: Stripe Link - Client Web - Update information with valid card and stripe link after plan Purchase - Pay with stripe link
      And Therapist API - Login to therapist3 provider
      Given Client API - Create THERAPY room for primary user with therapist3 provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Therapist API - Set primary user Information with therapist3 provider
        | country | IL |
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      When Open account menu
      And Account Menu - Select payment and plan
      When Payment and Plan - Click on the update button
      When Update payment details to masterCard card with stripe link true
      When Payment and Plan - Click on save button
      When Click on done button
      And Payment and Plan - Payment method is stripe link true
      When Open account menu
      Then Account Menu - Select add a new service
      And Select THERAPY service
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
      Then Select the first plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      When Payment - Click on continue
      And B2C Payment - Complete purchase with masterCard card using stripe link
      And Click on continue to room button
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      And Payment and Plan - Payment method is stripe link true

    Scenario: Stripe Link - Client Web - Change Plan - Change payment details with stripe link
      And Therapist API - Login to therapist3 provider
      Given Client API - Create THERAPY room for primary user with therapist3 provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Therapist API - Set primary user Information with therapist3 provider
        | country | IL |
      And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Navigate to payment and plan URL
      And Click on change plan
      When Select the second plan
      And Continue with "Monthly" billing period
      When Click on change button for payment
      And Complete purchase using masterCard card with stripe link true
      When Click on Close button
      And Payment and Plan - Payment method is stripe link true

    Scenario: Stripe Link - Client Web - plan purchase via Chat offer
      And Therapist API - Login to therapist provider
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Therapist API - Set primary user Information with therapist provider
        | country | IL |
      And Therapist API - Send offer 62 of plan 161 to primary user from therapist provider in the first room
      When Click on the "Choose your plan" offer button
      When Select the second plan
      And Continue with "3 Months" billing period
      And Apply free coupon if running on prod
      And Click on continue to checkout button
      When Complete purchase using visa card with stripe link true
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Messaging Only Therapy - Quarterly |
      And Payment and Plan - Payment method is stripe link true

    Scenario: Stripe Link - Client Web - One time purchase (LVS credits)
      When Therapist API - Login to therapist provider
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Therapist API - Send offer 71 of plan 305 to primary user from therapist provider in the first room
      When Click on the "Get a Live Session" offer button
      When Click on select plan button
      And Click on continue to checkout button
      When Complete purchase using visa card with stripe link true
      When Open account menu
      And Account Menu - Select payment and plan
      Then Plan details for the first room are
        | plan name                         | Live Session Only |
        | credit description                | credit amount     |
        | 1 x Therapy live session (30 min) | 1                 |
      And Payment and Plan - Payment method is stripe link true

    Scenario: Stripe Link - Client Web - Change payment details via scheduler
      Given Client API - Create THERAPY room for primary user with therapist2 provider
        | state | MT |
      And Browse to the email verification link for primary user and
        | phone number | true |
      And Onboarding - Click on meet your provider button
      And Onboarding - Complete treatment intake for primary user
      And Onboarding - Click on close button
      And Client API - Subscribe to offer 62 of plan 160 with visa card of primary user in the first room
      And Refresh the page
      And Onboarding - Click on continue button
      And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
      And Open the Room details menu
      And In-room scheduler - Click on book session button
      And In-room scheduler - Click on Got it button and continue if present
      And In-room scheduler - Click on continue button
      And Click on unchecked radio button
      And In-room scheduler - Click on continue button
      And In-room scheduler - Click on Next available button if present
      And In-room scheduler - Click on continue button
      And In-room scheduler - Click on reserve session button
      When Click on change button for payment
      And Complete purchase using masterCard card with stripe link true
      And Click on done button
      And Navigate to payment and plan URL
      And Payment and Plan - Payment method is stripe link true

  Rule: Payment via QM

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2754
    @smoke @sanity
    Scenario: Stripe Link - QM - B2C flow
      Given Navigate to flow64
      When Click on continue
      And Click on continue
      And Complete the assessment questions with the following options
        | Feeling nervous, anxious, or on edge              | Not at all |
        | Not being able to stop or control worrying        | Not at all |
        | Worrying too much about different things          | Not at all |
        | Trouble relaxing                                  | Not at all |
        | Being so restless that it's hard to sit still     | Not at all |
        | Becoming easily annoyed or irritable              | Not at all |
        | Feeling afraid as if something awful might happen | Not at all |
      And Click on Submit assessment
      When Click on show results after Inserting PRIMARY email
      And Click on Get matched with a provider
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
      When Select the second plan
      And Continue with "Monthly" billing period
      And Apply free coupon if running on prod
      Then Payment - Click on continue
      And B2C Payment - Complete purchase using visa card with stripe link true
      And Create account for primary user with
        | password     | STRONG |
        | nickname     | VALID  |
        | checkbox     |        |
        | phone number |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Messaging Only Therapy - Monthly |
      And No credits exist in the first room
      And Payment and Plan - Payment method is stripe link true

    @tmsLink=talktala.atlassian.net/browse/MEMBER-648
    Scenario: Stripe Link - QM - B2B flow
    this scenario also verify that SMS checkbox on registration is not mandatory by not checking it.
      Given Navigate to flow28
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_25 |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
        | phone number      |          |
      And Click on next button to approve you are ready to begin
      And Complete the matching questions with the following options
        | seek help reason                   | I'm feeling anxious or panicky |
        | got it                             |                                |
        | provider gender preference         | Male                           |
        | have you been to a provider before | Yes                            |
        | sleeping habits                    | Excellent                      |
        | physical health                    | Excellent                      |
        | your gender                        | Male                           |
        | state                              | Continue with prefilled state  |
      And Click on secure your match button
      And Click on continue on coverage verification
      And B2B Payment - Complete purchase using visa card with stripe link true
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Premera BH Unlimited Sessions Messaging or Live Session |
      And Payment and Plan - Payment method is stripe link true
      And Payment and Plan - Waiting to be matched text is displayed for the first room
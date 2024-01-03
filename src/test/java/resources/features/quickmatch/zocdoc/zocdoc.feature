@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-4442
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-4438
@tmsLink=https://www.figma.com/file/QTZL55Wb0fvEdx0fNLTCRD/Zocdoc-Hi-Fi
Feature: Zocdoc

  Background:
    Given Zocdoc API - Login to client

  @admin
  Scenario: Providers are in VIP group
    Then Zocdoc API - Store returning therapist id
    Then DB - Zocdoc verify therapist are in VIP group

  Rule: Create patient

    Scenario Outline: Create patient
    primary user is new and should be created while 2faUs user is already existing and should not be created
      Then Zocdoc API - Create patient with details of <user> user should return <status_code> status code
      Examples:
        | user    | status_code |
        | 2faUs   | BAD_REQUEST |
        | primary | OK          |

    @admin
    Scenario: Create patient multiple times
      Then Zocdoc API - Create patient with details of primary user should return OK status code
      Then Zocdoc API - Create patient with details of primary user should return OK status code
      And DB - Zocdoc pre-register status of primary user is
        | initial |
        | deleted |

  Rule: Search patient

    Scenario: Search new patient
      Then Zocdoc API - Search patient with details of primary user should return OK status code

    Scenario: Search existing patient
      Given Client API - Create THERAPY room for primary user with therapist provider
        | state | WY |
      Then Zocdoc API - Search patient with details of primary user should return BAD_REQUEST status code
      Then Mailinator API - Go to link on primary user email
        | subject          | Regarding your request to book a session through ZocDoc |
        | surrounding text | Log in                                                  |
      And Current url should contain "talkspace.com/login"

  Rule: Create appointment

    Scenario: Create appointment with dummy patient
      Then Zocdoc API - Create appointment to therapist provider with dummy patient in WY should return BAD_REQUEST status code
    """json
      {
          "successful": false,
          "message": "Appointment failed to book. Patient ID not found"
      }
    """

    Scenario: Create appointment with dummy provider
      Then Zocdoc API - Create appointment to primary user with dummy provider in WY should return BAD_REQUEST status code
    """json
      {
          "successful": false,
          "message": "Appointment failed to book. Therapist does not exist or has no license for state."
      }
    """

    Scenario: Create appointment with dummy insurance carrier information
      Then Zocdoc API - Create appointment to therapist provider with dummy insurance carrier details for primary user in WY should return BAD_REQUEST status code
       """json
      {
          "successful": false,
          "message": "Appointment failed to book. Bad insurance carrier given."
      }
    """

    Scenario: Create appointment with invalid duration
      Then Zocdoc API - Create appointment to therapist provider with invalid duration for primary user in WY should return BAD_REQUEST status code
       """json
      {
          "successful": false,
          "message": "Bad appointment duration value."
      }
    """

    Scenario: Create appointment before minimum days limit
      Then Zocdoc API - Create appointment to therapist provider with invalid start date for primary user in WY should return BAD_REQUEST status code
       """json
      {
          "successful": false,
          "message": "Appointment starts before minimum days limit."
      }
    """

    Scenario: Create appointment with non matching state
      Then Zocdoc API - Create appointment for primary user in WY to therapist provider in HI should return BAD_REQUEST status code
       """json
      {
          "successful": false,
          "message": "Appointment failed to book. Therapist does not exist or has no license for state."
      }
    """

    Scenario: Double booking
      Then Zocdoc API - Create 2 appointment for primary user to therapist provider in WY should return BAD_REQUEST status code
    """json
       {
          "message": "Appointment failed to book. Patient already has an active booking.",
          "successful": false
        }
    """

    Scenario: Create member
      Given Zocdoc API - Create appointment to primary user with therapist provider in WY
      Then Mailinator API - Go to link on primary user email
        | subject          | Complete onboarding to keep your appointment! |
        | surrounding text | Secure my appointment                         |
      And Complete the matching questions with the following options
        | seek help reason           | I'm feeling anxious or panicky |
        | provider gender preference | Male                           |
      And Continue with pre selected "Cigna" insurance provider
      And Unified eligibility page - Enter COPAY_0 member id
      And Unified eligibility page - Enter EMPLOYEE employ relation
      And Unified eligibility page - Enter zip code of primary user
      And Unified eligibility page - Click on verification checkbox
      And Unified eligibility page - Click on continue button
      And Click on continue on coverage verification
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
        | checkbox |        |
      And 2FA - Skip 2FA
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And Client API - Login to primary user
      And therapist is the provider in the first room for primary user
      And Client API - There is 1 scheduled booking for primary user in the first room

    @visual
    Scenario: Ineligible member - Visual regression
    only 2 options should exists according to figma
      Given Zocdoc API - Create appointment to primary user with therapist provider in WY
      Then Mailinator API - Go to link on primary user email
        | subject          | Complete onboarding to keep your appointment! |
        | surrounding text | Secure my appointment                         |
      And Complete the matching questions with the following options
        | seek help reason           | I'm feeling anxious or panicky |
        | provider gender preference | Male                           |
      And Continue with pre selected "Cigna" insurance provider
      And Unified eligibility page - Click on verification checkbox
      And Unified eligibility page - Enter EMPLOYEE employ relation
      And Unified eligibility page - Enter zip code of primary user
      And Unified eligibility page - Click on continue button
      And Shoot baseline "Zocdoc - Ineligible member"

    Scenario: Ineligible member - Check that my information is correct and resubmit
      Given Zocdoc API - Create appointment to primary user with therapist provider in WY
      Then Mailinator API - Go to link on primary user email
        | subject          | Complete onboarding to keep your appointment! |
        | surrounding text | Secure my appointment                         |
      And Complete the matching questions with the following options
        | seek help reason           | I'm feeling anxious or panicky |
        | provider gender preference | Male                           |
      And Continue with pre selected "Cigna" insurance provider
      And Unified eligibility page - Click on verification checkbox
      And Unified eligibility page - Enter EMPLOYEE employ relation
      And Unified eligibility page - Enter zip code of primary user
      And Unified eligibility page - Click on continue button
      And BH no insurance - Click on check my coverage is correct button
      And Unified eligibility page - Enter COPAY_0 member id
      And Unified eligibility page - Click on continue button
      And Click on continue on coverage verification
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
        | checkbox |        |
      And 2FA - Skip 2FA
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      And Client API - Login to primary user
      And therapist is the provider in the first room for primary user
      And Client API - There is 1 scheduled booking for primary user in the first room

    Scenario: Ineligible member - I’m sure my plan covers Talkspace
      Given Zocdoc API - Create appointment to primary user with therapist provider in WY
      Then Mailinator API - Go to link on primary user email
        | subject          | Complete onboarding to keep your appointment! |
        | surrounding text | Secure my appointment                         |
      And Complete the matching questions with the following options
        | seek help reason           | I'm feeling anxious or panicky |
        | provider gender preference | Male                           |
      And Continue with pre selected "Cigna" insurance provider
      And Unified eligibility page - Click on verification checkbox
      And Unified eligibility page - Enter EMPLOYEE employ relation
      And Unified eligibility page - Enter zip code of primary user
      And Unified eligibility page - Click on continue button
      And BH no insurance - Click on I’m sure my plan covers Talkspace
      And BH no insurance - upload insurance card image
      And Unified eligibility page - Click on continue button
      And BH no insurance - upload id card image
      And Unified eligibility page - Click on continue button
      And Enter PRIMARY email
      And BH no insurance - Insert PRIMARY email in email confirmation
      And Unified eligibility page - Click on submit button
      Then BH no insurance - We’ve received your request text is displayed

  Rule: Cancel appointment

    Scenario: Cancel existing appointment
      Then Zocdoc API - Cancel existing appointment of primary user to therapist provider in WY should return OK status code
    """json
       {
          "message": "",
          "successful": true
        }
    """

    Scenario: Cancel non existing appointment
      Then Zocdoc API - Cancel "non existing" appointment for therapist provider should return BAD_REQUEST status code
    """json
      {
          "successful": false,
          "message": "Appointment failed to cancel. Appointment ID not found."
      }
    """

    Scenario: Cancel already canceled appointment
      Then Zocdoc API - Cancel "cancelled" appointment for therapist provider should return BAD_REQUEST status code
    """json
     {
    "successful": false,
    "message": "Appointment failed to cancel. The appointment status is already cancelled"
      }
    """
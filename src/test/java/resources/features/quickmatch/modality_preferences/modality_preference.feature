@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2784
Feature: QM - Modality preference

  Rule: Flow 90 - BH - Canada - Live + Messaging

    Background:
      Given Navigate to flow90
      When Select THERAPY service
      And Select to pay through insurance provider
      And Continue with "Premera" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18      |
        | address   | CANADA  |
        | Member ID | COPAY_0 |
      And Click on continue on coverage verification
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
      And Click on the I live outside of the US button
      And QM - Click on continue button
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      And Complete shared after upfront coverage verification validation form for primary user
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | address           | CANADA   |
        | phone number      |          |

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2994
    Scenario: Flow 90 - BH - Canada - Live + Messaging - Messaging session modality selected
      And QM - Select MESSAGING as first Live booking modality for B2B_BH plan
      And QM - Modality preference - Click on messaging information next button
      And QM - Modality preference - Click on messaging information confirm session button
      Then Complete purchase is displayed


  Rule: Flow 90 - BH - Non live state - Live + Messaging

    Background:
      Given Navigate to flow90
      When Select THERAPY service
      And Select to pay through insurance provider
      And Continue with "Premera" insurance provider
      And Complete upfront coverage verification validation form for primary user
        | age       | 18      |
        | state     | WY      |
        | Member ID | COPAY_0 |
      And Click on continue on coverage verification
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | state                                              | Continue with prefilled state  |
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      And Complete shared after upfront coverage verification validation form for primary user
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | phone number      |          |

    Scenario: Flow 90 - BH - Non live state - Live + Messaging - Messaging session modality selected
      And QM - Select MESSAGING as first Live booking modality for B2B_BH plan
      And QM - Modality preference - Click on messaging information next button
      And QM - Modality preference - Click on messaging information confirm session button
      Then Complete purchase is displayed

    @visual
    Scenario: BH - Messaging session modality selected - Visual regression
      Then Shoot baseline "BH Modality preferences - Select modality screen"
      And QM - Select MESSAGING as first Live booking modality for B2B_BH plan
      Then Shoot baseline "BH Modality preferences - Messaging information screen"
      And QM - Modality preference - Click on messaging information next button
      Then Shoot baseline "BH Modality preferences - Messaging information confirm session screen"

    Scenario: Flow 90 - BH - Non live state - Live + Messaging - Audio session modality selected
      And QM - Select AUDIO as first Live booking modality for B2B_BH plan
      Then Complete purchase is displayed

  Rule: Flow 90 - EAP - Non live state - Live + Messaging
  this scenario is the happy path where the organization is valid and the email is valid - non mailinator

    Background:
      Given Navigate to flow90
      When Select THERAPY service
      And Select to pay through an organization
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | WY                             |
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
        | state              | WY       |
        | phone number       |          |
      And Click on continue on coverage verification

    Scenario: Flow 90 - EAP - Non live state - Live + Messaging - Messaging session modality selected
      And QM - Select MESSAGING as first Live booking modality for B2B_EAP plan
      And QM - Modality preference - Click on messaging information next button
      And QM - Modality preference - Click on messaging information confirm session button
      Then Registration Page - Create your account button is displayed

    @visual
    Scenario: Flow 90 - EAP - Non live state - Live + Messaging - Messaging session modality selected
      And QM - Select MESSAGING as first Live booking modality for B2B_EAP plan
      Then Shoot baseline "EAP Modality preferences - Messaging information screen"
      And QM - Modality preference - Click on messaging information next button
      Then Shoot baseline "EAP Modality preferences - Messaging information confirm session screen"

    Scenario: Flow 90 -  EAP - Non live state - Live + Messaging - Video session modality selected
      And QM - Select VIDEO as first Live booking modality for B2B_EAP plan
      Then Registration Page - Create your account button is displayed

  Rule: Flow 90 - EAP - Canada - Live + Messaging

    Background:
      Given Navigate to flow90
      When Select THERAPY service
      And Select to pay through an organization
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | WY                             |
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
        | address            | CANADA   |
        | phone number       |          |
      And Click on continue on coverage verification

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2994
    Scenario: Flow 90 - EAP - Canada - Live + Messaging - Messaging session modality selected
      And QM - Select MESSAGING as first Live booking modality for B2B_EAP plan
      And QM - Modality preference - Click on messaging information next button
      And QM - Modality preference - Click on messaging information confirm session button
      Then Registration Page - Create your account button is displayed

  Rule: Flow 90 - EAP - Non live state - Messaging only

    Background:
      Given Navigate to flow90
      When Select THERAPY service
      And Select to pay through an organization
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | WY                             |
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      And Write "test" in organization name
      And Click on next button
      And Enter RANDOM email
      And Click on next button
      And Click on I have a keyword or access code button
      And Enter "aetnaMessagingOnly" access code
      When Click on next button
      When Complete shared validation form for primary user
        | age               | 18       |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | WY       |
        | phone number      |          |
      And Click on continue on coverage verification

    Scenario: Flow 90 - EAP - Non live state - Messaging only
    this scenario is the happy path where the organization is valid but mapped to messaging only plan and the email is valid
      And QM - Modality preference - Click on messaging information next button
      And QM - Modality preference - Click on messaging information confirm session button
      Then Registration Page - Create your account button is displayed

  Rule: Flow 90 - EAP - Non live state Organization name code registration - Live + Messaging
  in this scenario the organization is valid and email is not valid - using organization name as fallback

    Background:
      Given Navigate to flow90
      When Select THERAPY service
      And Select to pay through an organization
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | WY                             |
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      And Write "test" in organization name
      And Click on next button
      And Enter RANDOM email
      And Click on next button
      And Click on I have a keyword or access code button
      When Enter "kga" access code
      When Click on next button
      When Complete kga eap validation form for primary user
        | authorization code | MOCK_KGA |
        | age                | 18       |
        | service type       | THERAPY  |
        | Email              | PRIMARY  |
        | employee Relation  | EMPLOYEE |
        | state              | WY       |
        | phone number       |          |
      And Click on continue on coverage verification

    Scenario: Flow 90 - EAP - Non live state - Live + Messaging - Organization name code registration - Messaging session modality selected
      And QM - Select MESSAGING as first Live booking modality for B2B_EAP plan
      And QM - Modality preference - Click on messaging information next button
      And QM - Modality preference - Click on messaging information confirm session button
      Then Registration Page - Create your account button is displayed

    Scenario: Flow 90 - EAP - Non live state - Live + Messaging - Organization name code registration - Video session modality selected
      And QM - Select VIDEO as first Live booking modality for B2B_EAP plan
      Then Registration Page - Create your account button is displayed

  Rule: Flow 90 - EAP - Non live state - Live + Messaging - Access code registration
  in this scenario the organization is valid and email is not valid - using EAP code as fallback

    Background:
      Given Navigate to flow90
      When Select THERAPY service
      And Select to pay through an organization
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | your gender                                        | Female                         |
        | provider gender                                    | Male                           |
        | age                                                | 18                             |
        | state                                              | WY                             |
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      And Write "test" in organization name
      And Click on next button
      And Enter RANDOM email
      And Click on next button
      And Click on I have a keyword or access code button
      When Enter MOCK_OPTUM authorization code
      When Click on next button
      When Complete optum eap validation form for primary user
        | age                           | 18          |
        | session number                | 5           |
        | service type                  | THERAPY     |
        | Email                         | PRIMARY     |
        | employee Relation             | EMPLOYEE    |
        | state                         | WY          |
        | phone number                  |             |
        | authorization code expiration | future date |
      And Click on continue on coverage verification

    Scenario: Flow 90 - EAP - Non live state - Live + Messaging - Access code registration - Messaging session modality selected
      And QM - Select MESSAGING as first Live booking modality for B2B_EAP plan
      And QM - Modality preference - Click on messaging information next button
      And QM - Modality preference - Click on messaging information confirm session button
      Then Registration Page - Create your account button is displayed

    Scenario: Flow 90 - EAP - Non live state - Live + Messaging - Access code registration - Video session modality selected
      And QM - Select VIDEO as first Live booking modality for B2B_EAP plan
      Then Registration Page - Create your account button is displayed

  Rule: Direct flows - BH - Canada - Live + Messaging

    Background:
      Given Navigate to flow28
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_25 |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | STUDENT  |
        | address           | CANADA   |
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
      And Click on the I live outside of the US button
      And QM - Click on continue button
      And Click on secure your match button
      And Click on continue on coverage verification

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2994
    Scenario: Direct flows - BH - Canada - Live + Messaging - Messaging session modality selected
      And QM - Select MESSAGING as first Live booking modality for B2B_BH plan
      And QM - Modality preference - Click on messaging information next button
      And QM - Modality preference - Click on messaging information confirm session button
      Then Complete purchase is displayed

  Rule: Direct flows - BH - Non live state - Live + Messaging

    Background:
      Given Navigate to flow28
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_25 |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | STUDENT  |
        | state             | WY       |
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
        | state                              | WY                             |
      And Click on secure your match button
      And Click on continue on coverage verification

    Scenario: Direct flows - BH - Non live state - Live + Messaging - Messaging session modality selected
      And QM - Select MESSAGING as first Live booking modality for B2B_BH plan
      And QM - Modality preference - Click on messaging information next button
      And QM - Modality preference - Click on messaging information confirm session button
      Then Complete purchase is displayed

    Scenario: Direct flows - BH - Non live state - Live + Messaging - Video session modality selected
      And QM - Select VIDEO as first Live booking modality for B2B_BH plan
      Then Complete purchase is displayed

  Rule: Direct flows - EAP - Non live state - Live + Messaging

    Background:
      Given Navigate to flow78
      When Complete cigna eap validation form for primary user
        | age                           | 18          |
        | authorization code            | MOCK_CIGNA  |
        | session number                | 3           |
        | service type                  | THERAPY     |
        | Email                         | PRIMARY     |
        | employee Relation             | EMPLOYEE    |
        | state                         | MT          |
        | phone number                  |             |
        | authorization code expiration | future date |
      Then Click on Let's start button
      And Complete the matching questions with the following options
        | seek help reason                   | I'm feeling anxious or panicky |
        | got it                             |                                |
        | provider gender preference         | Male                           |
        | have you been to a provider before | Yes                            |
        | sleeping habits                    | Excellent                      |
        | physical health                    | Excellent                      |
        | your gender                        | Male                           |
        | state                              | WY                             |
      And Click on secure your match button
      And Click on continue on coverage verification

    Scenario: Direct flows - EAP - Non live state - Live + Messaging - Messaging session modality selected
      And QM - Select MESSAGING as first Live booking modality for B2B_EAP plan
      And QM - Modality preference - Click on messaging information next button
      And QM - Modality preference - Click on messaging information confirm session button
      Then Registration Page - Create your account button is displayed

    Scenario: Direct flows - EAP - Non live state - Live + Messaging - Video session modality selected
      And QM - Select LIVE_CHAT as first Live booking modality for B2B_EAP plan
      Then Registration Page - Create your account button is displayed

  Rule: Direct flows - EAP - Canada - Live + Messaging

    Background:
      Given Navigate to flow78
      When Complete cigna eap validation form for primary user
        | age                           | 18          |
        | authorization code            | MOCK_CIGNA  |
        | session number                | 3           |
        | service type                  | THERAPY     |
        | Email                         | PRIMARY     |
        | employee Relation             | EMPLOYEE    |
        | address                       | CANADA      |
        | phone number                  |             |
        | authorization code expiration | future date |
      Then Click on Let's start button
      And Complete the matching questions with the following options
        | seek help reason                   | I'm feeling anxious or panicky |
        | got it                             |                                |
        | provider gender preference         | Male                           |
        | have you been to a provider before | Yes                            |
        | sleeping habits                    | Excellent                      |
        | physical health                    | Excellent                      |
        | your gender                        | Male                           |
      And Click on the I live outside of the US button
      And QM - Click on continue button
      And Click on secure your match button
      And Click on continue on coverage verification

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2994
    Scenario: Direct flows - EAP - Canada - Live + Messaging - Messaging session modality selected
      And QM - Select MESSAGING as first Live booking modality for B2B_EAP plan
      And QM - Modality preference - Click on messaging information next button
      And QM - Modality preference - Click on messaging information confirm session button
      Then Registration Page - Create your account button is displayed

  Rule: Direct flows - EAP - Messaging only
  this scenario is the happy path where the organization is valid but mapped to messaging only plan and the email is valid

    Background:
      Given Navigate to flow44
      When Complete shared validation form for primary user
        | age               | 18                 |
        | organization      | aetnaMessagingOnly |
        | service type      | THERAPY            |
        | Email             | PRIMARY            |
        | employee Relation | EMPLOYEE           |
        | state             | WY                 |
        | phone number      |                    |
      Then Click on Let's start button
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

    Scenario: Direct flows - EAP - Non live state - Messaging only
      And QM - Modality preference - Click on messaging information next button
      And QM - Modality preference - Click on messaging information confirm session button
      Then Registration Page - Create your account button is displayed

  Rule: Direct flows - EAP - Messaging only + Live state

    Background:
      Given Navigate to flow44
      When Complete shared validation form for primary user
        | age               | 18                 |
        | organization      | aetnaMessagingOnly |
        | service type      | THERAPY            |
        | Email             | PRIMARY            |
        | employee Relation | EMPLOYEE           |
        | state             | MT                 |
        | phone number      |                    |
      Then Click on Let's start button
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

    Scenario: Direct flows - EAP - Live state - Messaging only
    this scenario is the happy path where the organization is valid but mapped to messaging only plan and the email is valid
      Then Registration Page - Create your account button is displayed

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2995
    Rule: Eligibility questions on landing page

    Background:
      Given Navigate to Eligibility questions landing page

    Scenario: Eligibility questions on landing page - BH - Non live state - Live + Messaging - Messaging session modality selected
      And Landing page - Select THERAPY service
      And Landing page - Select WY state
      And Landing page - Select "Premera" insurance provider
      And Landing page - Click getting started button
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | provider gender                                    | Male                           |
        | your gender                                        | Female                         |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | age                                                | 18                             |
      And Click on secure your match button
      And Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_0  |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | WY       |
        | phone number      |          |
      And Click on continue on coverage verification
      And QM - Select MESSAGING as first Live booking modality for B2B_BH plan
      And QM - Modality preference - Click on messaging information next button
      And QM - Modality preference - Click on messaging information confirm session button
      Then Complete purchase is displayed

    Scenario: Eligibility questions on landing page  EAP - Non live state - Live + Messaging - Messaging session modality selected
      And Landing page - Select THERAPY service
      And Landing page - Select WY state
      And Landing page - Select "I have Talkspace through an organization"
      And Landing page - Click getting started button
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | provider gender                                    | Male                           |
        | your gender                                        | Female                         |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | age                                                | 18                             |
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
        | state              | WY       |
        | phone number       |          |
      And Click on continue on coverage verification
      And QM - Select MESSAGING as first Live booking modality for B2B_EAP plan
      And QM - Modality preference - Click on messaging information next button
      And QM - Modality preference - Click on messaging information confirm session button
      And Click on secure your match button
      Then Registration Page - Create your account button is displayed

    Scenario: Eligibility questions on landing page  EAP - Live state - Skip modality preferences
      And Landing page - Select THERAPY service
      And Landing page - Select MT state
      And Landing page - Select "I have Talkspace through an organization"
      And Landing page - Click getting started button
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | provider gender                                    | Male                           |
        | your gender                                        | Female                         |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | age                                                | 18                             |
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
        | state              | MT       |
        | phone number       |          |
      And Click on continue on coverage verification
      And Click on secure your match button
      Then Registration Page - Create your account button is displayed
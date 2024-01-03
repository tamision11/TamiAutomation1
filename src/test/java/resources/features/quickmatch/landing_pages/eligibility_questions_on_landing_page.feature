@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2801
Feature: Landing pages

  Background:
    Given Navigate to Eligibility questions landing page

  Rule: B2C

    Scenario: Eligibility questions on landing page - B2C - Therapy
      And Landing page - Select THERAPY service
      And Landing page - Select MT state
      And Landing page - Select "I’ll pay out of pocket"
      And Landing page - Click getting started button
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | provider gender                                    | Male                           |
        | your gender                                        | Female                         |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | age                                                | 18                             |
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
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Messaging Only Therapy - Monthly |
      And No credits exist in the first room
      And Payment and Plan - Waiting to be matched text is displayed for the first room

    Scenario: Eligibility questions on landing page - B2C - Teen therapy
      And Landing page - Select TEEN_THERAPY service
      And Landing page - Select MT state
      And Landing page - Select "I’ll pay out of pocket"
      And Landing page - Click getting started button
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | I'm feeling anxious or panicky |
        | provider gender                                    | Male                           |
        | your gender                                        | Female                         |
        | sleeping habits                                    | Good                           |
        | physical health                                    | Fair                           |
        | age                                                | 13                             |
        | Parental consent                                   | Yes                            |
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
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Messaging Only Therapy - Monthly |
      And No credits exist in the first room
      And Payment and Plan - Waiting to be matched text is displayed for the first room
      And Client API - The first room status of primary user is WAITING_TO_BE_MATCHED

    Scenario: Eligibility questions on landing page - B2C - Psychiatry
      And Landing page - Select PSYCHIATRY service
      And Landing page - Select NY state
      And Landing page - Select "I’ll pay out of pocket"
      And Landing page - Click getting started button
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider       | Anxiety |
        | prescribed medication to treat a mental health condition | Yes     |
        | your gender                                              | Female  |
        | provider gender                                          | Male    |
        | age                                                      | 18      |
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
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Psychiatry - Initial Evaluation + 1 follow up session |
      And No credits exist in the first room
      And Payment and Plan - Waiting to be matched text is displayed for the first room

    Scenario: Eligibility questions on landing page - B2C - Couples therapy
      And Landing page - Select COUPLES_THERAPY service
      And Landing page - Select MT state
      And Landing page - Select "I’ll pay out of pocket"
      And Landing page - Click getting started button
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
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Couples Therapy with Live Session - Quarterly |
      And No credits exist in the first room
      And Payment and Plan - Waiting to be matched text is displayed for the first room

  Rule: BH

    @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2995
    Scenario: Eligibility questions on landing page - BH - Live state - Live + Messaging - Therapy
    this scenario also verifies no modality preferences screen is shown
      And Landing page - Select THERAPY service
      And Landing page - Select MT state
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
        | state             | MT       |
        | phone number      |          |
      And Click on continue on coverage verification
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
        | checkbox |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Premera BH Unlimited Sessions Messaging or Live Session |
      And Payment and Plan - Waiting to be matched text is displayed for the first room

    Scenario: Eligibility questions on landing page - BH - Psychiatry
      And Landing page - Select PSYCHIATRY service
      And Landing page - Select NY state
      And Landing page - Select "Optum"
      And Landing page - Click getting started button
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider       | Anxiety |
        | prescribed medication to treat a mental health condition | Yes     |
        | your gender                                              | Female  |
        | provider gender                                          | Male    |
        | age                                                      | 18      |
      And Click on secure your match button
      And Complete shared validation form for primary user
        | age               | 18                                  |
        | Member ID         | COPAY_0                             |
        | Email             | PRIMARY                             |
        | employee Relation | ADULT_DEPENDENT_MEMBER_OF_HOUSEHOLD |
        | state             | MT                                  |
        | phone number      |                                     |
      And Click on continue to checkout button
      And Payment - Complete purchase using "visa" card for primary user
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
        | checkbox |        |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name | Optum BH Psychiatry |
      And Payment and Plan - Waiting to be matched text is displayed for the first room

  Rule: EAP

    Scenario: Eligibility questions on landing page - EAP - Therapy
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
        | Email              | PRIMARY  |
        | employee Relation  | EMPLOYEE |
        | state              | WY       |
        | phone number       |          |
      And Click on continue on coverage verification
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                               | KGA EAP 3 Sessions with Live Sessions Voucher |
        | credit description                      | credit amount                                 |
        | 1 x Complimentary live session (10 min) | 1                                             |
        | 3 x Therapy live sessions (45 min)      | 1                                             |
      And Payment and Plan - Waiting to be matched text is displayed for the first room

    @issue=talktala.atlassian.net/browse/PLATFORM-3909
    Scenario: Eligibility questions on landing page - EAP - authorization code with multi-session registration
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
      And Write "test" in organization name
      And Click on next button
      And Enter RANDOM email
      And Click on next button
      And Click on I have a keyword or access code button
      When Enter MOCK_OPTUM authorization code
      When Click on next button
      When Complete optum eap validation form for primary user
        | age                           | 18          |
        | session number                | 12+         |
        | Email                         | PRIMARY     |
        | employee Relation             | EMPLOYEE    |
        | state                         | MT          |
        | phone number                  |             |
        | authorization code expiration | future date |
      And Click on continue on coverage verification
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                           | Optum EAP 16 Sessions With Live Session |
        | credit description                  | credit amount                           |
        | 16 x Therapy live sessions (45 min) | 1                                       |
      And Payment and Plan - Waiting to be matched text is displayed for the first room

  Rule: DTE

    Scenario: Eligibility questions on landing page - DTE - Therapy
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
      When Write "google" in organization name
      When Click on next button
      And Enter RANDOM email
      And Click on next button
      And Complete google validation form for primary user
        | age               | 18       |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | phone number      |          |
      And Click on secure your match button
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                               | Google Unlimited Messaging Only Voucher |
        | credit description                      | credit amount                           |
        | 1 x Complimentary live session (10 min) | 1                                       |
      And Payment and Plan - Waiting to be matched text is displayed for the first room

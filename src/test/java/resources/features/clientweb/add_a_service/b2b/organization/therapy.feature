Feature: Client web - Add a service
  Leads to flow 132

  Background:
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | MT |
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

  @smoke @sanity
  Scenario: Therapy - Eligibility with Organization Code - DTE
    And Write "google" in organization name
    And Click on next button
    And Enter RANDOM email
    And Click on next button
    And Complete google validation form for primary user
      | age               | 18       |
      | employee Relation | EMPLOYEE |
    And Eligibility Widget - Click on start treatment button
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                               | Google Unlimited Messaging Only Voucher |
      | credit description                      | credit amount                           |
      | 1 x Complimentary live session (10 min) | 1                                       |

  Rule: Validation

    @visual
    Scenario: Therapy - Eligibility with Organization Code - Visual regression
      Then Shoot baseline "Client Web - Add a service - Therapy - Eligibility with Organization Code - Enter organization name"
      And Write "test" in organization name
      And Click on next button
      Then Shoot baseline "Client Web - Add a service - Therapy - Eligibility with Organization Code - Enter your email address page"

    @visual
    Scenario: Therapy - Eligibility with Organization Code - Enter your email - invalid email
      And Write "test" in organization name
      And Click on next button
      And Enter INVALID email
      And Click on next button
      Then Shoot baseline "Client Web - Add a service - Therapy - Eligibility with Organization Code - Enter your email address page - Invalid email error" and ignore
        | email input |

    @visual
    Scenario: Therapy - Eligibility with Organization Code - Email with code - invalid code
      And Write "test" in organization name
      And Click on next button
      And Enter PRIMARY email
      And Click on next button
      When Enter invalid verification code
      And Click on next button
      Then Shoot baseline

    @visual
    Scenario: Therapy - Eligibility with Organization Code - Email with code - Already verified email
      And Write "test" in organization name
      And Click on next button
      And Enter EXISTING_CLIENT email
      And Click on next button
      Then Shoot baseline

    @visual
    Scenario: Therapy - Eligibility with Organization Code - Keyword or access code selection page
      And Write "test" in organization name
      And Click on next button
      And Enter RANDOM email
      And Click on next button
      Then Shoot baseline

    @visual
    Scenario: Therapy - Eligibility with Organization Code - Keywords and access code page - invalid access code
      And Write "test" in organization name
      And Click on next button
      And Enter RANDOM email
      And Click on next button
      And Click on I have a keyword or access code button
      When Enter INVALID authorization code
      When Click on next button
      Then Shoot baseline
Feature: QM - Flow 90
  Leads to flow 132

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
      | state                                              | MT                             |
    And Click on secure your match button
    And Email wall - Click on continue after Inserting PRIMARY email

  @smoke @sanity
  Scenario: Therapy - Organization - validation via organization name page - Google
    When Write "google" in organization name
    When Click on next button
    And Enter RANDOM email
    And Click on next button
    And Complete google validation form for primary user
      | age               | 18       |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | phone number      |          |
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

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2837
  Scenario: Therapy - Organization - validation with Keyword via access code page - KGA EAP
    And Write "test" in organization name
    And Click on next button
    And Enter RANDOM email
    And Click on next button
    And Click on I have a keyword or access code button
    And Enter "kga" access code
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

  @smoke @sanity
  Scenario: Therapy - Organization - Whitelisted organization with code registration
  whitelisted organiztion = @talkspace.m8r.co
    And Write "test" in organization name
    And Click on next button
    And Enter PRIMARY email
    And Click on next button
    And Mailinator API - Get verification code from primary user email
    And Enter verification code for primary user
    And Click on next button
    And Create account for primary user with
      | password     | STRONG |
      | nickname     | VALID  |
      | phone number |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                               | Allan Myers 3 Months Messaging Only Voucher |
      | credit description                      | credit amount                               |
      | 1 x Complimentary live session (10 min) | 1                                           |
    And Payment and Plan - Waiting to be matched text is displayed for the first room

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2636
  Scenario: Therapy - Organization - Optum EAP authorization code with multi-session registration
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
      | service type                  | THERAPY     |
      | Email                         | PRIMARY     |
      | employee Relation             | EMPLOYEE    |
      | state                         | MT          |
      | phone number                  |             |
      | authorization code expiration | future date |
    And Click on continue on coverage verification
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

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2636
  Scenario: Therapy - Organization - Cigna EAP authorization code registration
    And Write "test" in organization name
    And Click on next button
    And Enter RANDOM email
    And Click on next button
    And Click on I have a keyword or access code button
    When Enter MOCK_CIGNA authorization code
    When Click on next button
    When Complete cigna eap validation form for primary user
      | age                           | 18                                  |
      | session number                | 3                                   |
      | service type                  | THERAPY                             |
      | Email                         | PRIMARY                             |
      | employee Relation             | ADULT_DEPENDENT_MEMBER_OF_HOUSEHOLD |
      | state                         | MT                                  |
      | phone number                  |                                     |
      | authorization code expiration | future date                         |
    And Click on continue on coverage verification
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name                          | Cigna EAP 3 Sessions Messaging and Live Session Voucher |
      | credit description                 | credit amount                                           |
      | 3 x Therapy live sessions (45 min) | 1                                                       |
    And Payment and Plan - Waiting to be matched text is displayed for the first room

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2837
  Scenario: Therapy - Organization - continue without code
    And Write "test" in organization name
    And Click on next button
    And Enter RANDOM email
    And Click on next button
    And Click on continue without code
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

  @visual
  Scenario: Couples therapy - Organization - Visual regression
    Then Shoot baseline "QM - Couples therapy - Organization - Enter organization name"
    And Write "test" in organization name
    And Click on next button
    Then Shoot baseline "QM - Couples therapy - Organization - Enter your email address page"
    And Enter INVALID email
    And Click on next button
    Then Shoot baseline "QM - Couples therapy - Organization - Enter your email address page - Invalid email error"

  @visual
  Scenario: Therapy - Organization - Email with code - invalid code
    And Write "test" in organization name
    And Click on next button
    And Enter PRIMARY email
    And Click on next button
    When Enter invalid verification code
    And Click on next button
    Then Shoot baseline

  @visual
  Scenario: Therapy - Organization - Keyword or access code selection page
    And Write "test" in organization name
    And Click on next button
    And Enter RANDOM email
    And Click on next button
    Then Shoot baseline

  @visual
  Scenario: Therapy - Organization - Keywords and access code page - invalid access code
    And Write "test" in organization name
    And Click on next button
    And Enter RANDOM email
    And Click on next button
    And Click on I have a keyword or access code button
    When Enter INVALID authorization code
    When Click on next button
    Then Shoot baseline
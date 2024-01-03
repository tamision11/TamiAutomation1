@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2754
Feature: QM - B2C - Assessment flows

  Background:
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
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | age                                                | 18                             |
      | state                                              | MT                             |
    And Click on secure your match button

  @tmsLink=talktala.atlassian.net/browse/CVR-962
  @issue=talktala.atlassian.net/browse/MEMBER-3285
  Scenario: Flow 64
    When Select the second plan
    And Continue with "6 Months" billing period
    And Apply free coupon if running on prod
    Then Payment - Click on continue
    And Payment - Complete purchase using "visa" card for primary user
    Then Options of referral dropdown are
      | Podcast              |
      | Email                |
      | Search Engine        |
      | App Store            |
      | School/university    |
      | Facebook             |
      | Instagram            |
      | Twitter              |
      | Tik Tok              |
      | Online article       |
      | Cable TV             |
      | Digital/Streaming TV |
      | My Insurance         |
      | My Employer/Work     |
      | Radio                |
      | Friend               |
      | Online ad            |
      | Zocdoc               |
      | Other                |
    And Create account for primary user with
      | password     | STRONG |
      | nickname     | VALID  |
      | checkbox     |        |
      | phone number |        |
      | referral     |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Messaging Only Therapy - Biannual |
    And No credits exist in the first room
    And Payment and Plan - Waiting to be matched text is displayed for the first room
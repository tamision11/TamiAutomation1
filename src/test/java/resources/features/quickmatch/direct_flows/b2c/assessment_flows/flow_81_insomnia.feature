@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2754
Feature: QM - B2C - Assessment flows

  Background:
    Given Navigate to flow81
    When Click on continue
    And Click on continue
    And Complete the assessment questions with the following options
      | Please rate the current (i.e., last 2 weeks) SEVERITY of your insomnia problem - difficulty falling asleep                                                                                      | None                   |
      | Please rate the current (i.e., last 2 weeks) SEVERITY of your insomnia problem - difficulty staying asleep                                                                                      | None                   |
      | Please rate the current (i.e., last 2 weeks) SEVERITY of your insomnia problem - problem waking up too early                                                                                    | None                   |
      | How satisfied/dissatisfied are you with your current sleep pattern?                                                                                                                             | Very Satisfied         |
      | To what extent do you consider your sleep problem to INTERFERE with your daily functioning (e.g., daytime fatigue, ability to function at work/daily chores, concentration, memory, mood, etc.) | Not at all Interfering |
      | How NOTICEABLE to others do you think your sleeping problem is in terms of impairing the quality of your life?                                                                                  | Not at all Noticeable  |
      | How WORRIED/distressed are you about your current sleep problem?                                                                                                                                | Not at all             |
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

  Scenario: Flow 81
    When Select the second plan
    And Continue with "6 Months" billing period
    And Apply free coupon if running on prod
    Then Payment - Click on continue
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
      | plan name | Messaging Only Therapy - Biannual |
    And No credits exist in the first room
    And Payment and Plan - Waiting to be matched text is displayed for the first room

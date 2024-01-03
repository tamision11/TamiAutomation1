@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2754
Feature: QM - B2C - Assessment flows

  Background:
    Given Navigate to flow72
    When Click on continue
    And Click on continue
    And Complete the assessment questions with the following options
      | In the past week, I felt happier or more cheerful than usual                                              | Not at all |
      | In the past week, I felt more self-confident than usual                                                   | Not at all |
      | In the past week, I needed less sleep than usual                                                          | Not at all |
      | In the past week, I talked more than usual                                                                | Not at all |
      | In the past week, I have been more active than usual (either socially, sexually, at work, home or school) | Not at all |
    And Click on continue
    And Click on continue
    And Complete the assessment questions with the following options
      | Little interest or pleasure in doing things                                                                                                                              | Not at all |
      | Feeling down, depressed, or hopeless                                                                                                                                     | Not at all |
      | Trouble falling or staying asleep, or sleeping too much                                                                                                                  | Not at all |
      | Feeling tired or having little energy                                                                                                                                    | Not at all |
      | Poor appetite or overeating                                                                                                                                              | Not at all |
      | Feeling bad about yourself - or that you are a failure or have let yourself or your family down                                                                          | Not at all |
      | Trouble concentrating on things, such as reading the newspaper or watching television                                                                                    | Not at all |
      | Moving or speaking so slowly that other people could have noticed. Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual | Not at all |
      | Thoughts that you would be better off dead, or of hurting yourself                                                                                                       | Not at all |
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

  Scenario: Flow 72
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
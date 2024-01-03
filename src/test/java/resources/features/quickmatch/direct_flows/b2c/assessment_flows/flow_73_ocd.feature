@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2754
Feature: QM - B2C - Assessment flows

  Background:
    Given Navigate to flow73
    When Click on continue
    And Click on continue
    And Complete the assessment questions with the following options
      | I have saved up so many things that they get in the way                                               | Not at all |
      | I check things more often than necessary                                                              | Not at all |
      | I get upset if objects are not arranged properly                                                      | Not at all |
      | I feel compelled to count while I am doing things                                                     | Not at all |
      | I find it difficult to touch an object when I know it has been touched by strangers or certain people | Not at all |
      | I find it difficult to control my own thoughts                                                        | Not at all |
      | I collect things I don't need                                                                         | Not at all |
      | I repeatedly check doors, windows, drawers, etc                                                       | Not at all |
      | I get upset if others change the way I have arranged things                                           | Not at all |
      | I feel I have to repeat certain numbers                                                               | Not at all |
      | I sometimes have to wash or clean myself simply because I feel contaminated                           | Not at all |
      | I am upset by unpleasant thoughts that come into my mind against my will                              | Not at all |
      | I avoid throwing things away because I am afraid I might need them later                              | Not at all |
      | I repeatedly check gas and water taps and light switches after turning them off                       | Not at all |
      | I need things to be arranged in a particular way                                                      | Not at all |
      | I feel that there are good and bad numbers                                                            | Not at all |
      | I wash my hands more often and longer than necessary                                                  | Not at all |
      | I frequently get nasty thoughts and have difficulty in getting rid of them                            | Not at all |
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

  Scenario: Flow 73
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

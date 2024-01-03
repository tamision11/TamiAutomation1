@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2754
Feature: QM - B2C - Assessment flows

  Background:
    Given Navigate to flow75
    When Click on continue
    And Click on continue
    And Complete the assessment questions with the following options
      | Felt moments of sudden terror, fear, or fright in social situations                                  | Never |
      | Felt anxious, worried, or nervous about social situations                                            | Never |
      | Had thoughts of being rejected, humiliated, embarrassed, ridiculed, or offending others              | Never |
      | Felt a racing heart, sweaty, trouble breathing, faint, or shaky in social situations                 | Never |
      | Felt tense muscles, felt on edge or restless, or had trouble relaxing in social situations           | Never |
      | Avoided, or did not approach or enter, social situations                                             | Never |
      | Left social situations early or participated only minimally (e.g., said little, avoided eye contact) | Never |
      | Spend a lot of time preparing what to say or how to act in social situations                         | Never |
      | Distracted myself to avoid thinking about social situations                                          | Never |
      | Needed help to cope with social situations (e.g., alcohol or medications, superstitious objects)     | Never |
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

  Scenario: Flow 75
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

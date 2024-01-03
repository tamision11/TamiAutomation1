@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2754
Feature: QM - B2C - Assessment flows

  Background:
    Given Navigate to flow80
    When Click on continue
    And Click on continue
    And Complete the assessment questions with the following options
      | Have any of your closest relationships been troubled by a lot of arguments or repeated breakups?                                                                                                                         | Yes |
      | Have you deliberately hurt yourself physically (e.g., punched yourself, cut yourself, burned yourself)? How about made a suicide attempt?                                                                                | Yes |
      | Have you had at least two other problems with impulsivity (e.g., eating binges and spending sprees, drinking too much and verbal outbursts)?                                                                             | Yes |
      | Have you been extremely moody?                                                                                                                                                                                           | Yes |
      | Have you felt very angry a lot of the time? How about often acted in an angry or sarcastic manner?                                                                                                                       | Yes |
      | Have you often been distrustful of other people?                                                                                                                                                                         | Yes |
      | Have you frequently felt unreal or as if things around you were unreal?                                                                                                                                                  | Yes |
      | Have you chronically felt empty?                                                                                                                                                                                         | Yes |
      | Have you often felt that you had no idea of who you are or that you have no identity?                                                                                                                                    | Yes |
      | Have you made desperate efforts to avoid feeling abandoned or being abandoned (e.g., repeatedly called someone to reassure yourself that he or she still cared, begged them not to leave you, clung to them physically)? | Yes |
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

  Scenario: Flow 80
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
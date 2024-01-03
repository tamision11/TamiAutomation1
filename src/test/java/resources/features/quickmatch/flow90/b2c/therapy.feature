Feature: QM - Flow 90
  Leads to flow 132

  Background:
    Given Navigate to flow90
    When Select THERAPY service
    And Select to pay out of pocket
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | age                                                | 18                             |

  Rule: US customers

    Background:
      And Complete the matching questions with the following options
        | state | MT |
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email

    @tmsLink=talktala.atlassian.net/browse/MEMBER-648
    @smoke @sanity
    Scenario: B2C - Therapy - US
    this scenario also verify that SMS checkbox on registration is not mandatory by not checking it.
      When Select the second plan
      And Continue with "Monthly" billing period
      And Apply free coupon if running on prod
      And Payment - Click on continue
      And B2C Payment - Complete purchase using visa card with stripe link false
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

    @tmslink=talktala.atlassian.net/browse/AUTOMATION-2694
    @ignore
    Scenario: B2C - Therapy - US - Recover session
    ignored until https://talktala.atlassian.net/browse/CVR-755 is fixed
      And Wait 10 seconds
      And Switch to a new window
      And Navigate to recover-session
      And Current url should contain "flow/66/step/24"

  Rule: UK customers

    Scenario: B2C - Therapy - UK
      And Click on the I live outside of the US button
      And Select from list the option "United Kingdom"
      And QM - Click on continue button
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email
      Then Select the first plan
      And Continue with "6 Months" billing period
      And Apply free coupon if running on prod
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
        | plan name | Messaging Therapy Premium - Biannual |
      And No credits exist in the first room
      And Payment and Plan - Waiting to be matched text is displayed for the first room
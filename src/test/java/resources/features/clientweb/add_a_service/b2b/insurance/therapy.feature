@tmsLink=talktala.atlassian.net/browse/AUTOMATION-3076
Feature: Client web - Add a service
  Leads to flow 132

  Background:
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | MT |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Dismiss modal
    When Open account menu
    Then Account Menu - Select add a new service
    And Select THERAPY service
    And Select to pay through insurance provider
    And Continue with "AARP" insurance provider
    And Complete out of network validation form for primary user
      | age       | 18             |
      | state     | MT             |
      | Member ID | OUT_OF_NETWORK |
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |

  Scenario: Therapy - AARP (Out of Network)
    And Click on secure your match button
    Then Select the second plan
    And Apply free coupon if running on prod
    And Payment - Click on continue
    And Payment - Complete purchase using "visa" card for primary user
    And Click on continue to room button
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Messaging Only Therapy - Monthly |
    And No credits exist in the first room
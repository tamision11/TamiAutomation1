Feature: Client web - Add a service
  Leads to flow 97

  @issue=talktala.atlassian.net/browse/MEMBER-3075
  Example: Teen Therapy - B2C
    Given Client API - Create THERAPY room for primary user with therapist3 provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Dismiss modal
    When Open account menu
    Then Account Menu - Select add a new service
    And Select TEEN_THERAPY service
    And Complete the matching questions with the following options
      | does your school or city offer talkspace for free | I’ll use a different form of coverage |
    And Select to pay out of pocket
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | age                                                | 13                             |
      | Parental consent                                   | Yes                            |
      | state                                              | MT                             |
    And Click on secure your match button
    Then Select the second plan
    And Continue with "3 Months" billing period
    And Apply free coupon if running on prod
    When Payment - Click on continue
    And Payment - Complete purchase using "visa" card for primary user
    And Click on continue to room button
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Messaging Only Therapy - Quarterly |
    And No credits exist in the first room
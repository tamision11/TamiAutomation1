Feature: QM - Flow 90
  Leads to flow 132

  Background:
    Given Navigate to flow90
    When Select THERAPY service
    And Select to pay through insurance provider


  Scenario: Therapy - BH - Premera - Teens
    And Continue with "Premera" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 13      |
      | state     | MT      |
      | Member ID | COPAY_0 |
    And Click on continue on coverage verification
    And Complete the matching questions with the following options
      | what do you need support with | Anxiety or worrying           |
      | sleeping habits               | Good                          |
      | physical health               | Fair                          |
      | your gender                   | Female                        |
      | provider gender               | Male                          |
      | state                         | Continue with prefilled state |
    And Click on secure your match button
    And Email wall - Click on continue after Inserting PRIMARY email
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | phone number      |          |
    And Payment - Complete purchase using "visa" card for primary user
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
      | checkbox |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Premera BH Unlimited Sessions Messaging or Live Session |
    And Payment and Plan - Waiting to be matched text is displayed for the first room

  @smoke @sanity
  Scenario: Therapy - BH - Anthem
    And Continue with "Anthem" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18      |
      | state     | MT      |
      | Member ID | COPAY_0 |
    And Click on continue on coverage verification
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Click on secure your match button
    And Email wall - Click on continue after Inserting PRIMARY email
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | phone number      |          |
    And B2B Payment - Complete purchase using visa card with stripe link false
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
      | checkbox |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Anthem BH Unlimited Sessions Messaging or Live Session |
    And Payment and Plan - Waiting to be matched text is displayed for the first room

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2788
  Scenario: Therapy - BH - Gatorcare
  override TriZetto response with copay 0
    And Continue with "Gatorcare" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18        |
      | state     | MT        |
      | Member ID | GATORCARE |
    And Click on continue on coverage verification
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Click on secure your match button
    And Email wall - Click on continue after Inserting PRIMARY email
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | phone number      |          |
    And Payment - Complete purchase using "visa" card for primary user
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
      | checkbox |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | RTE Gatorcare BH Unlimited Sessions Messaging or Live Session v3 |
    And Payment and Plan - Waiting to be matched text is displayed for the first room

  Rule: Out of network

    Background:
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
      And Click on secure your match button
      And Email wall - Click on continue after Inserting PRIMARY email

    @smoke
    Scenario: Therapy - AARP (Out of Network)
      And Select the second plan
      And Apply free coupon if running on prod
      And Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
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
        | plan name | Messaging Only Therapy - Monthly |
      And No credits exist in the first room
      And Payment and Plan - Waiting to be matched text is displayed for the first room

    Scenario: Therapy - AARP (Out of Network) - Exit intent
      And Select the second plan
      And Apply free coupon if running on prod
      And Hover on top of the screen
      And Apply Exit Intent promo code
      And Payment - Click on continue
      And Payment - Complete purchase using "visa" card for primary user
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
        | plan name | Messaging Only Therapy - Monthly |
      And No credits exist in the first room
      And Payment and Plan - Waiting to be matched text is displayed for the first room

    @visual
    Scenario: Therapy - AARP (Out of Network) - Offer page
      Then Shoot baseline

    @visual
    Scenario: Therapy - AARP (Out of Network) - OON coupon applied on payment screen
      And Select the second plan
      And Apply free coupon if running on prod
      Then Shoot baseline

    @visual
    Scenario: Therapy - AARP (Out of Network) - Exit intent coupon applied on payment screen
      And Select the second plan
      And Apply free coupon if running on prod
      And Hover on top of the screen
      And Apply Exit Intent promo code
      Then Shoot baseline


@visual
Feature: Client web - Room status
  added IL as country step in order to always get offer 62 original plans

  Scenario: Active room
    And Therapist API - Login to therapist provider
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    When Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Therapist API - Set primary user Information with therapist provider
      | country | IL |
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    And Navigate to payment and plan URL
    Then Shoot Payment and plan panel element and ignore
      | therapist avatar |
      | therapist name   |

  Scenario: Canceled room
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    When Client API - Cancel Subscription of primary user in the first room
    And Client API - Refund Charge of primary user
    And Navigate to payment and plan URL
    Then Shoot Payment and plan panel element and ignore
      | therapist will be notified text |
      | therapist avatar                |
      | therapist name                  |

  Scenario: B2C psychiatry room
    Given Client API - Create THERAPY room for primary user with psychiatrist
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Dismiss modal
    And Client API - Subscribe to offer 61 of plan 138 with visa card of primary user in the first room
    And Navigate to payment and plan URL
    Then Shoot Payment and plan panel element and ignore
      | therapist avatar |
      | therapist name   |

  Scenario: Expired room
    Given Navigate to client-web
    And Log in with expiredUser user and
      | remember me   | false |
      | 2fa activated | false |
      | skip 2fa      | true  |
    And Navigate to payment and plan URL
    Then Shoot Payment and plan panel element and ignore
      | therapist will be notified text |
      | therapist avatar                |
      | therapist name                  |

  Scenario: Free PT room
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    When Navigate to payment and plan URL
    Then Shoot Payment and plan panel element and ignore
      | therapist will be notified text |
      | therapist avatar                |
      | therapist name                  |

  Scenario: Not renew room
    And Therapist API - Login to therapist provider
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Therapist API - Set primary user Information with therapist provider
      | country | IL |
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    When Client API - Cancel Subscription of primary user in the first room
    And Navigate to payment and plan URL
    Then Shoot Payment and plan panel element and ignore
      | therapist will be notified text |
      | therapist avatar                |
      | therapist name                  |

  Scenario: Out of network therapy room
    Given Client API - Create Out of Network room for primary user with therapist provider with visa card
      | state     | WY             |
      | age       | 18             |
      | Member ID | OUT_OF_NETWORK |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Shoot Payment and plan panel element and ignore
      | therapist avatar |
      | therapist name   |

  Scenario: Past due room
    Given Navigate to client-web
    And Log in with pastDueUser user and
      | remember me   | false |
      | 2fa activated | false |
      | skip 2fa      | true  |
    And Navigate to payment and plan URL
    Then Shoot Payment and plan panel element and ignore
      | therapist will be notified text |
      | therapist avatar                |
      | therapist name                  |

  Scenario: Paused room
    And Therapist API - Login to therapist provider
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Client API - Subscribe to offer 62 of plan 161 with visa card of primary user in the first room
    And Onboarding - Complete treatment intake for primary user
    And Onboarding - Click on close button
    And Therapist API - Set primary user Information with therapist provider
      | country | IL |
    And Onboarding - Click on continue button
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    And Navigate to payment and plan URL
    When Click on pause Therapy
    And Click on pause therapy button modal
    Then Shoot Payment and plan panel element and ignore
      | therapist will be notified text |
      | therapist avatar                |
      | therapist name                  |

  Scenario: BH psychiatry room
    Given Client API - BH - Create manual psychiatry room for primary user with psychiatrist
      | flowId            | 25                            |
      | age               | 18                            |
      | keyword           | premerabhmanualpsychiatrytest |
      | Member ID         | COPAY_0                       |
      | employee Relation | EMPLOYEE                      |
      | state             | WY                            |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Dismiss modal
    When Navigate to payment and plan URL
    Then Shoot Payment and plan panel element and ignore
      | therapist avatar |
      | therapist name   |

  Scenario: Video only room
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Client API - Subscribe to offer 71 of plan 305 with visa card of primary user in the first room
    And Onboarding - Click on meet your provider button
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Shoot Payment and plan panel element and ignore
      | therapist avatar |
      | therapist name   |

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-2754
  Scenario: B2C - Waiting to be matched room
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
      | referral     |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    And Client API - The first room status of primary user is WAITING_TO_BE_MATCHED
    Then Shoot Payment and plan panel element with scenario name as baseline

  Scenario: B2B - Waiting to be matched room
    Given Navigate to flow24

    When Complete shared validation form for primary user
      | age               | 18       |
      | Member ID         | COPAY_0  |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
      | phone number      |          |
    And Click on Let's start button
    And Complete the matching questions with the following options
      | seek help reason                   | I'm feeling anxious or panicky |
      | got it                             |                                |
      | provider gender preference         | I'm not sure yet               |
      | have you been to a provider before | No                             |
      | sleeping habits                    | Good                           |
      | physical health                    | Fair                           |
      | your gender                        | Female                         |
      | state                              | Continue with prefilled state  |
    And Click on secure your match button
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    And Client API - The first room status of primary user is WAITING_TO_BE_MATCHED
    Then Shoot Payment and plan panel element with scenario name as baseline
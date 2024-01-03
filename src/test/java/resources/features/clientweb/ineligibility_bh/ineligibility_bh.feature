@owner=tami_sion
@admin
Feature: Client web - Ineligibility BH

  Background:
    Given LaunchDarkly - MBH_INELIGIBILITY_EXPERIMENT feature flag activation status is true
    Given Therapist API - Login to therapist provider
    And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
      | flowId            | 28        |
      | age               | 18        |
      | Member ID         | COPAY_0   |
      | keyword           | premerabh |
      | employee Relation | EMPLOYEE  |
      | state             | MT        |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Client API - Login to primary user
    And Client API - Switch to therapist provider in the first room for primary user
    And Onboarding - Click on meet your provider button
    And Onboarding - Complete treatment intake for primary user

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-3018
  Scenario: Update coverage in grace period - Keep provider - Session scheduled - Same length
    And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with BH_MESSAGING_AND_LIVE plan and LIVE state
    And Onboarding - Click on close button
    And DB - Set BH primary user to be permanently ineligible in grace period
    And Admin API - Execute RECURRING_ELIGIBILITY cron
    And Refresh the page
    And Update my coverage - Click on continue button
    Then Current url should contain "skipCapacityCheck=true"
    And Client API - There is 1 scheduled booking for primary user in the first room
    And Client API - The first room status of primary user is ACTIVE
    And Update my coverage - Click on continue button
    And Update my coverage - Select to pay through insurance provider
    And Continue with "Aetna" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18      |
      | state     | MT      |
      | Member ID | COPAY_0 |
    And Click on continue on coverage verification
    And Update my coverage - Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
    And Payment - Complete purchase using "visa" card for primary user
    And Ineligibility BH - Click on go to my new room
    And Ineligibility BH - System message appears in new room
    And Ineligibility BH - Click on room closed tag
    And Ineligibility BH - System message room is closed appears in old room
    And Ineligibility BH - System message insurance coverage expired appears in old room
    And Ineligibility BH - Room is closed banner appears in old room
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Aetna BH Unlimited Sessions Messaging or Live Session |
    And Client API - The second room status of primary user is ACTIVE
    And Client API - The first room status of primary user is EXPIRED
    And Client API - There is 0 scheduled booking for primary user in the first room
    And Client API - There is 1 scheduled booking for primary user in the second room
    And therapist is the provider in the second room for primary user
    And Wait 30 seconds
    And DB - Store room id of primary user in the first room in EXPIRED status
    And DB - Change reason for primary user in the first room in EXPIRED status is "due_to_update_coverage"
    And Wait 30 seconds
    And DB - Store room id of primary user in the second room in ACTIVE status
    And DB - Funnel variation for primary user in the second room is "mbh-ineligibility"
    And Sendgrid API - primary user has the following email subjects at his inbox
      | notifyClientInsuranceExpired | 1 |

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-3019
  Scenario: Update coverage in grace period - Keep provider - Session scheduled - Different length
    And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with BH_MESSAGING_AND_LIVE plan and LIVE state
    And Onboarding - Click on close button
    And DB - Set BH primary user to be permanently ineligible in grace period
    And Admin API - Execute RECURRING_ELIGIBILITY cron
    And Refresh the page
    And Update my coverage - Click on continue button
    Then Current url should contain "skipCapacityCheck=true"
    And Client API - There is 1 scheduled booking for primary user in the first room
    And Client API - The first room status of primary user is ACTIVE
    And Update my coverage - Click on continue button
    And Update my coverage - Select to pay through insurance provider
    And Continue with "Gatorcare" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18      |
      | state     | MT      |
      | Member ID | COPAY_0 |
    And Click on continue on coverage verification
    And Update my coverage - Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
    And Payment - Complete purchase using "visa" card for primary user
    And Client API - There is 0 scheduled booking for primary user in the first room
    And Ineligibility BH - Click on book a session
    And in-room scheduler - Book THERAPY live VIDEO session of FORTY_FIVE minutes with BH_MESSAGING_AND_LIVE plan and IGNORE state
    And Ineligibility BH - Click on room closed tag
    And Ineligibility BH - System message room is closed appears in old room
    And Ineligibility BH - System message insurance coverage expired appears in old room
    And Ineligibility BH - Room is closed banner appears in old room
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | RTE Gatorcare BH Unlimited Sessions Messaging or Live Session v3 |
    And Client API - The second room status of primary user is ACTIVE
    And Client API - The first room status of primary user is EXPIRED
    And Client API - There is 1 scheduled booking for primary user in the second room
    And therapist is the provider in the second room for primary user
    And Wait 30 seconds
    And DB - Store room id of primary user in the first room in EXPIRED status
    And DB - Change reason for primary user in the first room in EXPIRED status is "due_to_update_coverage"
    And Wait 30 seconds
    And DB - Store room id of primary user in the second room in ACTIVE status
    And DB - Funnel variation for primary user in the second room is "mbh-ineligibility"
    And Sendgrid API - primary user has the following email subjects at his inbox
      | notifyClientInsuranceExpired | 1 |

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-3031
  Scenario: Update coverage in grace period - Keep provider - Async session in progress
    And in-room scheduler - Skip book first THERAPY live VIDEO session with LIVE state
    And Wait 3 seconds
    And Client API - Start async messaging session for primary user
      | roomIndex  | 0    |
      | isPurchase | true |
    And Refresh the page
    And “Messaging Session in progress“ banner appears
    And DB - Set BH primary user to be permanently ineligible in grace period
    And Admin API - Execute RECURRING_ELIGIBILITY cron
    And Refresh the page
    And Update my coverage - Click on continue button
    Then Current url should contain "skipCapacityCheck=true"
    And Client API - The first room status of primary user is ACTIVE
    And Update my coverage - Click on continue button
    And Update my coverage - Select to pay through insurance provider
    And Continue with "Aetna" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18      |
      | state     | MT      |
      | Member ID | COPAY_0 |
    And Click on continue on coverage verification
    And Update my coverage - Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
    And Payment - Complete purchase using "visa" card for primary user
    And Ineligibility BH - Click on book a session
    And in-room scheduler - Book THERAPY live VIDEO session of FORTY_FIVE minutes with BH_MESSAGING_AND_LIVE plan and IGNORE state
    And Ineligibility BH - System message appears in new room
    And Ineligibility BH - Click on room closed tag
    And Ineligibility BH - System message room is closed appears in old room
    And Ineligibility BH - System message insurance coverage expired appears in old room
    And Ineligibility BH - Room is closed banner appears in old room
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Aetna BH Unlimited Sessions Messaging or Live Session |
    And Client API - The second room status of primary user is ACTIVE
    And Client API - The first room status of primary user is EXPIRED
    And Client API - There is 1 scheduled booking for primary user in the second room
    And therapist is the provider in the second room for primary user
    And Wait 30 seconds
    And DB - Store room id of primary user in the first room in EXPIRED status
    And DB - Change reason for primary user in the first room in EXPIRED status is "due_to_update_coverage"
    And DB - SELECT "end_date" FROM "talkspace_test4.async_sessions" WHERE "room_id='{room_id_1}'" is
      |  |
    And Wait 30 seconds
    And DB - Store room id of primary user in the second room in ACTIVE status
    And DB - Funnel variation for primary user in the second room is "mbh-ineligibility"
    And Sendgrid API - primary user has the following email subjects at his inbox
      | notifyClientInsuranceExpired | 1 |

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-3022
  Scenario: Update coverage in grace period - Keep provider - No session scheduled
    And Onboarding - Click continue on book first session
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    And DB - Set BH primary user to be permanently ineligible in grace period
    And Admin API - Execute RECURRING_ELIGIBILITY cron
    And Refresh the page
    And Update my coverage - Click on continue button
    Then Current url should contain "skipCapacityCheck=true"
    And Client API - The first room status of primary user is ACTIVE
    And Update my coverage - Click on continue button
    And Update my coverage - Select to pay through insurance provider
    And Continue with "Aetna" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18      |
      | state     | MT      |
      | Member ID | COPAY_0 |
    And Click on continue on coverage verification
    And Update my coverage - Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
    And Payment - Complete purchase using "visa" card for primary user
    And Ineligibility BH - Click on book a session
    And in-room scheduler - Book THERAPY live VIDEO session of FORTY_FIVE minutes with BH_MESSAGING_AND_LIVE plan and IGNORE state
    And Ineligibility BH - Click on room closed tag
    And Ineligibility BH - System message room is closed appears in old room
    And Ineligibility BH - System message insurance coverage expired appears in old room
    And Ineligibility BH - Room is closed banner appears in old room
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Aetna BH Unlimited Sessions Messaging or Live Session |
    And Client API - The second room status of primary user is ACTIVE
    And Client API - The first room status of primary user is EXPIRED
    And Client API - There is 1 scheduled booking for primary user in the second room
    And therapist is the provider in the second room for primary user
    And Wait 30 seconds
    And DB - Store room id of primary user in the first room in EXPIRED status
    And DB - Change reason for primary user in the first room in EXPIRED status is "due_to_update_coverage"
    And Wait 30 seconds
    And DB - Store room id of primary user in the second room in ACTIVE status
    And DB - Funnel variation for primary user in the second room is "mbh-ineligibility"
    And Sendgrid API - primary user has the following email subjects at his inbox
      | notifyClientInsuranceExpired | 1 |

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-3029
  Scenario: Update coverage in grace period - New provider - Session scheduled - Same length
    And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with BH_MESSAGING_AND_LIVE plan and LIVE state
    And Onboarding - Click on close button
    And DB - Set BH primary user to be permanently ineligible in grace period
    And Admin API - Execute RECURRING_ELIGIBILITY cron
    And Refresh the page
    And Update my coverage - Click on continue button
    Then Current url should contain "skipCapacityCheck=true"
    And Client API - There is 1 scheduled booking for primary user in the first room
    And Client API - The first room status of primary user is ACTIVE
    And Update my coverage - Click on continue button
    And Update my coverage - Select to pay through insurance provider
    And Continue with "Aetna" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18      |
      | state     | MO      |
      | Member ID | COPAY_0 |
    And Click on continue on coverage verification
    And Update my coverage - Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Click on secure your match button
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
    And QM - Select MESSAGING as first Live booking modality for B2B_BH plan
    And QM - Modality preference - Click on messaging information next button
    And QM - Modality preference - Click on messaging information confirm session button
    And Payment - Complete purchase using "visa" card for primary user
    And Ineligibility BH - Click on go to my new room
    And Ineligibility BH - System message appears in new room
    And Ineligibility BH - Click on room closed tag
    And Ineligibility BH - System message room is closed appears in old room
    And Ineligibility BH - System message insurance coverage expired appears in old room
    And Ineligibility BH - Room is closed banner appears in old room
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Aetna BH Unlimited Sessions Messaging or Live Session |
    And Client API - The second room status of primary user is WAITING_TO_BE_MATCHED_QUEUE
    And Client API - The first room status of primary user is EXPIRED
    And Client API - There is 0 scheduled booking for primary user in the first room
    And Client API - There is 0 scheduled booking for primary user in the second room
    And Wait 30 seconds
    And DB - Store room id of primary user in the first room in EXPIRED status
    And DB - Change reason for primary user in the first room in EXPIRED status is "due_to_update_coverage"
    And Wait 30 seconds
    And DB - Store room id of primary user in the second room in WAITING_TO_BE_MATCHED_QUEUE status
    And DB - Funnel variation for primary user in the second room is "mbh-ineligibility"
    And Sendgrid API - primary user has the following email subjects at his inbox
      | notifyClientInsuranceExpired | 1 |

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-3030
  Scenario: Update coverage in grace period - New provider - No session scheduled
    And Onboarding - Click continue on book first session
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    And DB - Set BH primary user to be permanently ineligible in grace period
    And Admin API - Execute RECURRING_ELIGIBILITY cron
    And Refresh the page
    And Update my coverage - Click on continue button
    Then Current url should contain "skipCapacityCheck=true"
    And Client API - The first room status of primary user is ACTIVE
    And Update my coverage - Click on continue button
    And Update my coverage - Select to pay through insurance provider
    And Continue with "Aetna" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18      |
      | state     | MO      |
      | Member ID | COPAY_0 |
    And Click on continue on coverage verification
    And Update my coverage - Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Click on secure your match button
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
    And QM - Select MESSAGING as first Live booking modality for B2B_BH plan
    And QM - Modality preference - Click on messaging information next button
    And QM - Modality preference - Click on messaging information confirm session button
    And Payment - Complete purchase using "visa" card for primary user
    And Ineligibility BH - Click on go to my new room
    And Ineligibility BH - System message appears in new room
    And Ineligibility BH - Click on room closed tag
    And Ineligibility BH - System message room is closed appears in old room
    And Ineligibility BH - System message insurance coverage expired appears in old room
    And Ineligibility BH - Room is closed banner appears in old room
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Aetna BH Unlimited Sessions Messaging or Live Session |
    And Client API - The second room status of primary user is WAITING_TO_BE_MATCHED_QUEUE
    And Client API - The first room status of primary user is EXPIRED
    And Wait 30 seconds
    And DB - Store room id of primary user in the first room in EXPIRED status
    And DB - Change reason for primary user in the first room in EXPIRED status is "due_to_update_coverage"
    And Wait 30 seconds
    And DB - Store room id of primary user in the second room in WAITING_TO_BE_MATCHED_QUEUE status
    And DB - Funnel variation for primary user in the second room is "mbh-ineligibility"
    And Sendgrid API - primary user has the following email subjects at his inbox
      | notifyClientInsuranceExpired | 1 |

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-3032
  Scenario: Update coverage in grace period extension - Keep provider - Session scheduled - Same length
    And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with BH_MESSAGING_AND_LIVE plan and LIVE state
    And Onboarding - Click on close button
    And DB - Set BH primary user to be permanently ineligible for 240 hours
    And Admin API - Execute RECURRING_ELIGIBILITY cron
    And Refresh the page
    And Update my coverage - Click on continue button
    Then Current url should contain "skipCapacityCheck=true"
    And Client API - There is 0 scheduled booking for primary user in the first room
    And Client API - The first room status of primary user is EXPIRED
    And Update my coverage - Click on continue button
    And Update my coverage - Select to pay through insurance provider
    And Continue with "Aetna" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18      |
      | state     | MT      |
      | Member ID | COPAY_0 |
    And Click on continue on coverage verification
    And Update my coverage - Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
    And Payment - Complete purchase using "visa" card for primary user
    And Ineligibility BH - Click on book a session
    And in-room scheduler - Book THERAPY live VIDEO session of FORTY_FIVE minutes with BH_MESSAGING_AND_LIVE plan and IGNORE state
    And Ineligibility BH - System message appears in new room
    And Ineligibility BH - Click on room closed tag
    And Ineligibility BH - System message room is closed appears in old room
    And Ineligibility BH - System message insurance coverage expired appears in old room
    And Ineligibility BH - Room is closed banner appears in old room
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Aetna BH Unlimited Sessions Messaging or Live Session |
    And Client API - The second room status of primary user is ACTIVE
    And Client API - The first room status of primary user is EXPIRED
    And Client API - There is 1 scheduled booking for primary user in the second room
    And therapist is the provider in the second room for primary user
    And Wait 30 seconds
    And DB - Store room id of primary user in the first room in EXPIRED status
    And DB - Change reason for primary user in the first room that was in ACTIVE status and now is in EXPIRED status is "due_to_ineligibility"
    And Wait 30 seconds
    And DB - Store room id of primary user in the second room in ACTIVE status
    And DB - Funnel variation for primary user in the second room is "mbh-ineligibility"
    And Sendgrid API - primary user has the following email subjects at his inbox
      | notifyclientroomclosedexpiredinsurance | 1 |

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-3035
  Scenario: Update coverage in grace period extension - Keep provider - Async session in progress
    And in-room scheduler - Skip book first THERAPY live VIDEO session with LIVE state
    And Wait 3 seconds
    And Client API - Start async messaging session for primary user
      | roomIndex  | 0    |
      | isPurchase | true |
    And Refresh the page
    And “Messaging Session in progress“ banner appears
    And DB - Set BH primary user to be permanently ineligible for 240 hours
    And Admin API - Execute RECURRING_ELIGIBILITY cron
    And Refresh the page
    And Update my coverage - Click on continue button
    Then Current url should contain "skipCapacityCheck=true"
    And Client API - The first room status of primary user is EXPIRED
    And Update my coverage - Click on continue button
    And Update my coverage - Select to pay through insurance provider
    And Continue with "Aetna" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18      |
      | state     | MT      |
      | Member ID | COPAY_0 |
    And Click on continue on coverage verification
    And Update my coverage - Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
    And Payment - Complete purchase using "visa" card for primary user
    And Ineligibility BH - Click on book a session
    And in-room scheduler - Book THERAPY live VIDEO session of FORTY_FIVE minutes with BH_MESSAGING_AND_LIVE plan and IGNORE state
    And Ineligibility BH - System message appears in new room
    And Ineligibility BH - Click on room closed tag
    And Ineligibility BH - System message room is closed appears in old room
    And Ineligibility BH - System message insurance coverage expired appears in old room
    And Ineligibility BH - Room is closed banner appears in old room
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Aetna BH Unlimited Sessions Messaging or Live Session |
    And Client API - The second room status of primary user is ACTIVE
    And Client API - The first room status of primary user is EXPIRED
    And Client API - There is 1 scheduled booking for primary user in the second room
    And therapist is the provider in the second room for primary user
    And Wait 30 seconds
    And DB - Store room id of primary user in the first room in EXPIRED status
    And DB - Change reason for primary user in the first room that was in ACTIVE status and now is in EXPIRED status is "due_to_ineligibility"
    And DB - Change reason for primary user in the first room that was in EXPIRED status and now is in EXPIRED status is "due_to_update_coverage"
    And DB - SELECT "end_date" FROM "talkspace_test4.async_sessions" WHERE "room_id='{room_id_1}'" is
      |  |
    And Wait 30 seconds
    And DB - Store room id of primary user in the second room in ACTIVE status
    And DB - Funnel variation for primary user in the second room is "mbh-ineligibility"
    And Sendgrid API - primary user has the following email subjects at his inbox
      | notifyclientroomclosedexpiredinsurance | 1 |

  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-3034
  @issue=talktala.atlassian.net/browse/PLATFORM-4680
  Scenario:   Update coverage after grace period extension - Keep provider - Session scheduled - Same length
    And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with BH_MESSAGING_AND_LIVE plan and LIVE state
    And Onboarding - Click on close button
    And DB - Set BH primary user to be permanently ineligible for 600 hours
    And Admin API - Execute RECURRING_ELIGIBILITY cron
    And Refresh the page
    And Update my coverage - Click on continue button
    Then Current url should contain "skipCapacityCheck=false"
    And Client API - There is 0 scheduled booking for primary user in the first room
    And Client API - The first room status of primary user is EXPIRED
    And Update my coverage - Click on continue button
    And Update my coverage - Select to pay through insurance provider
    And Continue with "Aetna" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18      |
      | state     | MT      |
      | Member ID | COPAY_0 |
    And Click on continue on coverage verification
    And Update my coverage - Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
    And Payment - Complete purchase using "visa" card for primary user
    And Ineligibility BH - Click on book a session
    And in-room scheduler - Book THERAPY live VIDEO session of FORTY_FIVE minutes with BH_MESSAGING_AND_LIVE plan and IGNORE state
    And Ineligibility BH - System message appears in new room
    And Ineligibility BH - Click on room closed tag
    And Ineligibility BH - System message room is closed appears in old room
    And Ineligibility BH - System message insurance coverage expired appears in old room
    And Ineligibility BH - Room is closed banner appears in old room
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Aetna BH Unlimited Sessions Messaging or Live Session |
    And Client API - The second room status of primary user is ACTIVE
    And Client API - The first room status of primary user is EXPIRED
    And Client API - There is 1 scheduled booking for primary user in the second room
    And therapist is the provider in the second room for primary user
    And Wait 30 seconds
    And DB - Store room id of primary user in the first room in EXPIRED status
    And DB - Change reason for primary user in the first room that was in ACTIVE status and now is in EXPIRED status is "due_to_ineligibility"
    And DB - Change reason for primary user in the first room that was in EXPIRED status and now is in EXPIRED status is "due_to_update_coverage"
    And Wait 30 seconds
    And DB - Store room id of primary user in the second room in ACTIVE status
    And DB - Funnel variation for primary user in the second room is "mbh-ineligibility"
    And Sendgrid API - primary user has the following email subjects at his inbox
      | notifyclientroomclosedexpiredinsurance | 1 |

  @visual
  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-3040
  Scenario: Update coverage in grace period - Keep provider - Session scheduled - Same length - visual
    And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with BH_MESSAGING_AND_LIVE plan and LIVE state
    And Onboarding - Click on close button
    And DB - Set BH primary user to be permanently ineligible in grace period
    And Admin API - Execute RECURRING_ELIGIBILITY cron
    And Refresh the page
    And Shoot baseline "Update you account screen in grace period"

  @visual
  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-3040
  Scenario: Update coverage in grace period - Keep provider - Session scheduled - Same length - visual
    And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with BH_MESSAGING_AND_LIVE plan and LIVE state
    And Onboarding - Click on close button
    And DB - Set BH primary user to be permanently ineligible in grace period
    And Admin API - Execute RECURRING_ELIGIBILITY cron
    And Refresh the page
    And Shoot baseline "Update you account screen in grace period"
    And Update my coverage - Click on continue button
    And Shoot baseline "Here's what to expect screen"
    And Update my coverage - Click on continue button
    And Update my coverage - Select to pay through insurance provider
    And Continue with "Aetna" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18      |
      | state     | MT      |
      | Member ID | COPAY_0 |
    And Click on continue on coverage verification
    And Update my coverage - Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
    And Payment - Complete purchase using "visa" card for primary user
    And Shoot baseline "Your account is updated! screen - Keep provider - Session scheduled - Same length"
    And Update my coverage - Click on go to my new room
    And Shoot baseline "System message in new room"
    And Ineligibility BH - Click on room closed tag
    And Shoot baseline "System messages room is closed snd insurance coverage expired + banner in old room"

  @visual
  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-3040
  Scenario: Update coverage in grace period - Keep provider - Session scheduled - Different length - visual
    And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with BH_MESSAGING_AND_LIVE plan and LIVE state
    And Onboarding - Click on close button
    And DB - Set BH primary user to be permanently ineligible in grace period
    And Admin API - Execute RECURRING_ELIGIBILITY cron
    And Refresh the page
    And Update my coverage - Click on continue button
    And Update my coverage - Click on continue button
    And Update my coverage - Select to pay through insurance provider
    And Continue with "Gatorcare" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18      |
      | state     | MT      |
      | Member ID | COPAY_0 |
    And Click on continue on coverage verification
    And Update my coverage - Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
    And Payment - Complete purchase using "visa" card for primary user
    And Shoot baseline "Your account is updated! screen - Keep provider - Session scheduled - different length"

  @visual
  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-3040
  Scenario: Update coverage in grace period - Keep provider - No session scheduled - visual
    And Onboarding - Click continue on book first session
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    And DB - Set BH primary user to be permanently ineligible in grace period
    And Admin API - Execute RECURRING_ELIGIBILITY cron
    And Refresh the page
    And Update my coverage - Click on continue button
    And Update my coverage - Click on continue button
    And Update my coverage - Select to pay through insurance provider
    And Continue with "Aetna" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18      |
      | state     | MT      |
      | Member ID | COPAY_0 |
    And Click on continue on coverage verification
    And Update my coverage - Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
    And Payment - Complete purchase using "visa" card for primary user
    And Shoot baseline "Your account is updated! screen - Keep provider - No session scheduled"

  @visual
  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-3040
  Scenario: Update coverage in grace period - New provider - Session scheduled - Same length - visual
    And in-room scheduler - Book THERAPY live VIDEO session of THIRTY minutes with BH_MESSAGING_AND_LIVE plan and LIVE state
    And Onboarding - Click on close button
    And DB - Set BH primary user to be permanently ineligible in grace period
    And Admin API - Execute RECURRING_ELIGIBILITY cron
    And Refresh the page
    And Update my coverage - Click on continue button
    And Update my coverage - Click on continue button
    And Update my coverage - Select to pay through insurance provider
    And Continue with "Aetna" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18      |
      | state     | MT      |
      | Member ID | COPAY_0 |
    And Click on continue on coverage verification
    And Update my coverage - Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Click on secure your match button
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
    And QM - Select MESSAGING as first Live booking modality for B2B_BH plan
    And QM - Modality preference - Click on messaging information next button
    And QM - Modality preference - Click on messaging information confirm session button
    And Payment - Complete purchase using "visa" card for primary user
    And Shoot baseline "Your account is updated! screen - New provider - Session scheduled"

  @visual
  @tmsLink=talktala.atlassian.net/browse/AUTOMATION-3040
  Scenario: Update coverage in grace period - New provider - No session scheduled
    And Onboarding - Click continue on book first session
    And in-room scheduler - Skip book first THERAPY live VIDEO session with IGNORE state
    And DB - Set BH primary user to be permanently ineligible in grace period
    And Admin API - Execute RECURRING_ELIGIBILITY cron
    And Refresh the page
    And Update my coverage - Click on continue button
    And Update my coverage - Click on continue button
    And Update my coverage - Select to pay through insurance provider
    And Continue with "Aetna" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 18      |
      | state     | MT      |
      | Member ID | COPAY_0 |
    And Click on continue on coverage verification
    And Update my coverage - Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | state                                              | Continue with prefilled state  |
    And Click on secure your match button
    And Complete shared after upfront coverage verification validation form for primary user
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
    And QM - Select MESSAGING as first Live booking modality for B2B_BH plan
    And QM - Modality preference - Click on messaging information next button
    And QM - Modality preference - Click on messaging information confirm session button
    And Payment - Complete purchase using "visa" card for primary user
    And Shoot baseline "Your account is updated! screen - New provider - No session scheduled"
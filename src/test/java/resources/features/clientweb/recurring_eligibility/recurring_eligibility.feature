@admin
Feature: Client web - Recurring eligibility

  Background:
    Given Therapist API - Login to therapist provider
    Given Set primary user last name to Automation
    And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
      | flowId            | 28                       |
      | age               | 18                       |
      | Member ID         | MOCK_ELIGIBLE_BH_MEMBERS |
      | keyword           | premerabh                |
      | employee Relation | EMPLOYEE                 |
      | state             | HI                       |
    And DB - Verify primary user email
    And Client API - Login to primary user
    And Client API - Switch to therapist provider in the first room for primary user
    And Client API - Send video-credit-offers request for primary user in the first room

  Scenario: Eligible member with last check > 7 days
    And DB - UPDATE "talkspace_test4.insurance_status" SET "last_eligibility_check_date=(select DATE_SUB(now(), INTERVAL 8 DAY))" WHERE "user_id={user_id} and room_id={room_id_1} and client_insurance_info_timeframe_id is not null limit 1"
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - last_eligibility_check_date of primary user is today
    And DB - SELECT "CONCAT_WS(\", \", is_eligible,source)" FROM "talkspace_test4.insurance_eligibilities" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 1, registration |
      | 1, bookSession  |
      | 1, bookSession  |
    And DB - SELECT "CONCAT_WS(\", \", payer_id,member_id,is_permanent_ineligible,latest_eligibility_status,failed_check_counter)" FROM "talkspace_test4.insurance_status" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 00830, tomcat114888, 0, eligible, 0 |

  Scenario: Eligible member with last check < 7 days
    And DB - UPDATE "talkspace_test4.insurance_status" SET "last_eligibility_check_date=(select DATE_SUB(now(), INTERVAL 2 DAY))" WHERE "user_id={user_id} and room_id={room_id_1} limit 1"
    And Wait 30 seconds
    And DB - Store last eligibility check date for primary user in the first room
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - last_eligibility_check_date of primary user did not change
    And DB - SELECT "CONCAT_WS(\", \", is_eligible,source)" FROM "talkspace_test4.insurance_eligibilities" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 1, registration |
      | 1, bookSession  |
    And DB - SELECT "CONCAT_WS(\", \", payer_id,member_id,is_permanent_ineligible,latest_eligibility_status,failed_check_counter)" FROM "talkspace_test4.insurance_status" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 00830, tomcat114888, 0, eligible, 0 |

  Scenario: Ineligible member with last check > 7 days
    And DB - UPDATE "talkspace_test4.insurance_status" SET "member_id='tomcat143', failed_check_counter=3, latest_eligibility_status='not eligible', last_eligibility_check_date=(select DATE_SUB(now(), INTERVAL 8 DAY))" WHERE "user_id={user_id} and room_id={room_id_1} limit 1"
    And DB - Update insurance eligibilities member id to "tomcat143" for primary user in the first room
    And DB - Update client insurance info member id to "tomcat143" for primary user
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - last_eligibility_check_date of primary user is today
    And DB - SELECT "CONCAT_WS(\", \", is_eligible,source)" FROM "talkspace_test4.insurance_eligibilities" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 1, registration |
      | 1, bookSession  |
      | 0, bookSession  |
    And DB - SELECT "CONCAT_WS(\", \", is_permanent_ineligible,latest_eligibility_status,failed_check_counter)" FROM "talkspace_test4.insurance_status" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 0, not eligible, 4 |

  Scenario: Ineligible member with last check < 7 days
    And DB - UPDATE "talkspace_test4.insurance_status" SET "member_id='tomcat143', failed_check_counter=3, latest_eligibility_status='not eligible', last_eligibility_check_date=(select DATE_SUB(now(), INTERVAL 2 DAY))" WHERE "user_id={user_id} and room_id={room_id_1} limit 1"
    And DB - Update insurance eligibilities member id to "tomcat143" for primary user in the first room
    And DB - Update client insurance info member id to "tomcat143" for primary user
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - last_eligibility_check_date of primary user is today
    And DB - SELECT "CONCAT_WS(\", \", is_eligible,source)" FROM "talkspace_test4.insurance_eligibilities" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 1, registration |
      | 1, bookSession  |
      | 0, bookSession  |
    And DB - SELECT "CONCAT_WS(\", \", is_permanent_ineligible,latest_eligibility_status,failed_check_counter)" FROM "talkspace_test4.insurance_status" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 0, not eligible, 4 |

  Scenario: Ineligible member with multiple booking attempts in one hour
    And DB - UPDATE "talkspace_test4.insurance_status" SET "member_id='tomcat143' , failed_check_counter=3 , latest_eligibility_status = 'not eligible' , last_eligibility_check_date=(select DATE_SUB(now(), INTERVAL 2 DAY))" WHERE "user_id={user_id} and room_id={room_id_1} limit 1"
    And DB - Update insurance eligibilities member id to "tomcat143" for primary user in the first room
    And DB - Update client insurance info member id to "tomcat143" for primary user
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - SELECT "CONCAT_WS(\", \", is_permanent_ineligible,latest_eligibility_status,failed_check_counter)" FROM "talkspace_test4.insurance_status" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 0, not eligible, 4 |
    And DB - UPDATE "talkspace_test4.insurance_status" SET "last_eligibility_check_date=(select DATE_SUB(now(), INTERVAL 40 MINUTE))" WHERE "user_id={user_id} and room_id={room_id_1} limit 1"
    And Wait 30 seconds
    And DB - Store last eligibility check date for primary user in the first room
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - last_eligibility_check_date of primary user did not change
    And DB - SELECT "CONCAT_WS(\", \", is_eligible,source)" FROM "talkspace_test4.insurance_eligibilities" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 1, registration |
      | 1, bookSession  |
      | 0, bookSession  |
      | 0, bookSession  |
    And DB - SELECT "CONCAT_WS(\", \", is_permanent_ineligible,latest_eligibility_status,failed_check_counter)" FROM "talkspace_test4.insurance_status" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 0, not eligible, 4 |
    And Wait 30 seconds
    And DB - Store last eligibility check date for primary user in the first room
    And DB - UPDATE "talkspace_test4.insurance_status" SET "last_eligibility_check_date=(select DATE_SUB(now(), INTERVAL 65 MINUTE))" WHERE "user_id={user_id} and room_id={room_id_1} limit 1"
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - SELECT "CONCAT_WS(\", \", is_eligible,source)" FROM "talkspace_test4.insurance_eligibilities" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 1, registration |
      | 1, bookSession  |
      | 0, bookSession  |
      | 0, bookSession  |
      | 0, bookSession  |
    And DB - SELECT "CONCAT_WS(\", \", is_permanent_ineligible,latest_eligibility_status,failed_check_counter)" FROM "talkspace_test4.insurance_status" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 0, not eligible, 5 |

  Scenario: Permanently ineligibility
    And DB - UPDATE "talkspace_test4.insurance_status" SET "member_id='tomcat143', failed_check_counter=8, latest_eligibility_status='not eligible', last_eligibility_check_date=(select DATE_SUB(now(), INTERVAL 8 DAY))" WHERE "user_id={user_id} and room_id={room_id_1} limit 1"
    And DB - Update insurance eligibilities member id to "tomcat143" for primary user in the first room
    And DB - Update client insurance info member id to "tomcat143" for primary user
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - last_eligibility_check_date of primary user is today
    And DB - SELECT "CONCAT_WS(\", \", is_eligible,source)" FROM "talkspace_test4.insurance_eligibilities" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 1, registration |
      | 1, bookSession  |
      | 0, bookSession  |
    And DB - SELECT "CONCAT_WS(\", \", is_permanent_ineligible,latest_eligibility_status,failed_check_counter)" FROM "talkspace_test4.insurance_status" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 0, not eligible, 9 |
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - last_eligibility_check_date of primary user is today
    And DB - SELECT "CONCAT_WS(\", \", is_eligible,source)" FROM "talkspace_test4.insurance_eligibilities" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 1, registration |
      | 1, bookSession  |
      | 0, bookSession  |
      | 0, bookSession  |
    And DB - UPDATE "talkspace_test4.insurance_status" SET "last_eligibility_check_date=(select DATE_SUB(now(), INTERVAL 2 HOUR))" WHERE "user_id={user_id} and room_id={room_id_1} limit 1"
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - SELECT "CONCAT_WS(\", \", payer_id,member_id,is_permanent_ineligible,latest_eligibility_status,failed_check_counter)" FROM "talkspace_test4.insurance_status" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 00830, tomcat143, 1, not eligible, 10 |
    And DB - UPDATE "talkspace_test4.insurance_status" SET "last_eligibility_check_date=(select DATE_SUB(now(), INTERVAL 8 DAY))" WHERE "user_id={user_id} and room_id={room_id_1} limit 1"
    And Wait 30 seconds
    And DB - Store last eligibility check date for primary user in the first room
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - last_eligibility_check_date of primary user did not change
    And DB - SELECT "CONCAT_WS(\", \", is_eligible,source)" FROM "talkspace_test4.insurance_eligibilities" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 1, registration |
      | 1, bookSession  |
      | 0, bookSession  |
      | 0, bookSession  |
      | 0, bookSession  |
    And DB - SELECT "CONCAT_WS(\", \", payer_id,member_id,is_permanent_ineligible,latest_eligibility_status,failed_check_counter)" FROM "talkspace_test4.insurance_status" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 00830, tomcat143, 1, not eligible, 10 |

  Scenario: Payer timeout with last check > 7 days
    And DB - UPDATE "talkspace_test4.insurance_status" SET "member_id='tomcat122', failed_check_counter=0, latest_eligibility_status = 'eligible', last_eligibility_check_date=(select DATE_SUB(now(), INTERVAL 8 DAY))" WHERE "user_id={user_id} and room_id={room_id_1} limit 1"
    And DB - Update insurance eligibilities member id to "tomcat122" for primary user in the first room
    And DB - Update client insurance info member id to "tomcat122" for primary user
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - last_eligibility_check_date of primary user is today
    And DB - SELECT "CONCAT_WS(\", \", is_eligible,source, trizetto_request_error)" FROM "talkspace_test4.insurance_eligibilities" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 1, registration               |
      | 1, bookSession                |
      | 0, bookSession, payer timeout |
    And DB - SELECT "CONCAT_WS(\", \", is_permanent_ineligible,latest_eligibility_status,failed_check_counter)" FROM "talkspace_test4.insurance_status" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 0, timeout, 0 |
    And DB - UPDATE "talkspace_test4.insurance_status" SET "failed_check_counter=3, latest_eligibility_status='not eligible', last_eligibility_check_date=(select DATE_SUB(now(), INTERVAL 8 DAY))" WHERE "user_id={user_id} and room_id={room_id_1} limit 1"
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - last_eligibility_check_date of primary user is today
    And DB - SELECT "CONCAT_WS(\", \", is_eligible,source, trizetto_request_error)" FROM "talkspace_test4.insurance_eligibilities" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 1, registration               |
      | 1, bookSession                |
      | 0, bookSession, payer timeout |
      | 0, bookSession, payer timeout |
    And DB - SELECT "CONCAT_WS(\", \", is_permanent_ineligible,latest_eligibility_status,failed_check_counter)" FROM "talkspace_test4.insurance_status" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 0, timeout, 3 |

  Scenario: Payer timeout with last check < 7 days
    And DB - UPDATE "talkspace_test4.insurance_status" SET "member_id='tomcat122', failed_check_counter=0, latest_eligibility_status='eligible', last_eligibility_check_date=(select DATE_SUB(now(), INTERVAL 2 DAY))" WHERE "user_id={user_id} and room_id={room_id_1} limit 1"
    And DB - Update insurance eligibilities member id to "tomcat122" for primary user in the first room
    And DB - Update client insurance info member id to "tomcat122" for primary user
    And Wait 30 seconds
    And DB - Store last eligibility check date for primary user in the first room
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - last_eligibility_check_date of primary user did not change
    And DB - SELECT "CONCAT_WS(\", \", is_eligible,source, trizetto_request_error)" FROM "talkspace_test4.insurance_eligibilities" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 1, registration |
      | 1, bookSession  |
    And DB - SELECT "CONCAT_WS(\", \", is_permanent_ineligible,latest_eligibility_status,failed_check_counter)" FROM "talkspace_test4.insurance_status" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 0, eligible, 0 |
    And DB - UPDATE "talkspace_test4.insurance_status" SET "failed_check_counter=3, latest_eligibility_status='not eligible', last_eligibility_check_date=(select DATE_SUB(now(), INTERVAL 2 DAY))" WHERE "user_id={user_id} and room_id={room_id_1} limit 1"
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - last_eligibility_check_date of primary user is today
    And DB - SELECT "CONCAT_WS(\", \", is_eligible,source, trizetto_request_error)" FROM "talkspace_test4.insurance_eligibilities" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 1, registration               |
      | 1, bookSession                |
      | 0, bookSession, payer timeout |
    And DB - SELECT "CONCAT_WS(\", \", is_permanent_ineligible,latest_eligibility_status,failed_check_counter)" FROM "talkspace_test4.insurance_status" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 0, timeout, 3 |

  Scenario: Trizetto timeout with last check > 7 days
    And DB - UPDATE "talkspace_test4.insurance_status" SET "member_id='tomcat121', failed_check_counter=0, latest_eligibility_status = 'eligible', last_eligibility_check_date=(select DATE_SUB(now(), INTERVAL 8 DAY))" WHERE "user_id={user_id} and room_id={room_id_1} limit 1"
    And DB - Update insurance eligibilities member id to "tomcat121" for primary user in the first room
    And DB - Update client insurance info member id to "tomcat121" for primary user
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - last_eligibility_check_date of primary user is today
    And DB - SELECT "CONCAT_WS(\", \", is_eligible,source, trizetto_request_error)" FROM "talkspace_test4.insurance_eligibilities" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 1, registration                  |
      | 1, bookSession                   |
      | 0, bookSession, trizetto timeout |
    And DB - SELECT "CONCAT_WS(\", \", is_permanent_ineligible,latest_eligibility_status,failed_check_counter)" FROM "talkspace_test4.insurance_status" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 0, timeout, 0 |
    And DB - UPDATE "talkspace_test4.insurance_status" SET "failed_check_counter=3, latest_eligibility_status='not eligible', last_eligibility_check_date=(select DATE_SUB(now(), INTERVAL 8 DAY))" WHERE "user_id={user_id} and room_id={room_id_1} limit 1"
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - last_eligibility_check_date of primary user is today
    And DB - SELECT "CONCAT_WS(\", \", is_eligible,source, trizetto_request_error)" FROM "talkspace_test4.insurance_eligibilities" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 1, registration                  |
      | 1, bookSession                   |
      | 0, bookSession, trizetto timeout |
      | 0, bookSession, trizetto timeout |
    And DB - SELECT "CONCAT_WS(\", \", is_permanent_ineligible,latest_eligibility_status,failed_check_counter)" FROM "talkspace_test4.insurance_status" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 0, timeout, 3 |

  Scenario: Trizetto timeout with last check < 7 days
    And DB - UPDATE "talkspace_test4.insurance_status" SET "member_id='tomcat121', failed_check_counter=0, latest_eligibility_status='eligible', last_eligibility_check_date=(select DATE_SUB(now(), INTERVAL 2 DAY))" WHERE "user_id={user_id} and room_id={room_id_1} limit 1"
    And DB - Update insurance eligibilities member id to "tomcat121" for primary user in the first room
    And DB - Update client insurance info member id to "tomcat121" for primary user
    And Wait 30 seconds
    And DB - Store last eligibility check date for primary user in the first room
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - last_eligibility_check_date of primary user did not change
    And DB - SELECT "CONCAT_WS(\", \", is_eligible,source, trizetto_request_error)" FROM "talkspace_test4.insurance_eligibilities" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 1, registration |
      | 1, bookSession  |
    And DB - SELECT "CONCAT_WS(\", \", is_permanent_ineligible,latest_eligibility_status,failed_check_counter)" FROM "talkspace_test4.insurance_status" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 0, eligible, 0 |
    And DB - UPDATE "talkspace_test4.insurance_status" SET "failed_check_counter=3, latest_eligibility_status='not eligible', last_eligibility_check_date=(select DATE_SUB(now(), INTERVAL 2 DAY))" WHERE "user_id={user_id} and room_id={room_id_1} limit 1"
    And Client API - Send video-credit-offers request for primary user in the first room
    And DB - last_eligibility_check_date of primary user is today
    And DB - SELECT "CONCAT_WS(\", \", is_eligible,source, trizetto_request_error)" FROM "talkspace_test4.insurance_eligibilities" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 1, registration                  |
      | 1, bookSession                   |
      | 0, bookSession, trizetto timeout |
    And DB - SELECT "CONCAT_WS(\", \", is_permanent_ineligible,latest_eligibility_status,failed_check_counter)" FROM "talkspace_test4.insurance_status" WHERE "user_id={user_id} and room_id={room_id_1} order by 1 desc" is
      | 0, timeout, 3 |
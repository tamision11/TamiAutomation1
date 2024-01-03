@admin
Feature: Aetna authorization flows

  Scenario: Get response with 10 allowed sessions
    Given Set primary user first name to CLAIM_BALANCE_0
    Given Client API - Create EAP room to primary user with therapist provider
      | flowId            | 44       |
      | age               | 18       |
      | keyword           | icuba    |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
    And DB - Verify primary user email
    And Client API - Login to primary user
    And Client API - Switch to therapist provider in the first room for primary user
    Given Therapist API - Login to therapist provider
    And Client API - Start async messaging session for primary user
      | roomIndex  | 0     |
      | isPurchase | false |
    And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
    And DB - Get past time from database last 10 days back as "service_start_date"
    And DB - Get past time from database last 1 days back as "service_end_date"
    And Therapist API - Send 2 VALID_RANDOM message as therapist provider to primary user in the first room
    And Client API - Send 2 VALID_RANDOM message as primary user in the first room
    And Admin API - Execute AUTOMATIC_SESSION_REPORTS cron
    And DB - Client insurance auth request data is "new" for primary user
    And DB - Store minimum session report id for primary user in the first room
    And DB - Store claim id for primary user
    And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
        "status": "pending_payer_data",
        "statusReason": "Aetna authcode is missing or expired"
    }
    """
    And Admin API - Execute SET_AETNA_REQUEST cron
    And DB - Client insurance auth request data is "sent" for primary user
    And DB - Store next Aetna member id
    And DB - Store primary user birth date
    And DB - Store auth effective date 14 days ago
    And DB - Store auth date
    And S3 - Upload Aetna’s response file with 10 authorized sessions for primary user
    And Admin API - Execute GET_AETNA_RESPONSE cron
    And DB - Number of session reports is 10 for primary in the first room
    And DB - Number of video credits is 10 for primary in the first room
    And DB - Client insurance auth request data is "completed" for primary user
    And DB - Claim has the correct auth code
    And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
        "status": "pending_submit"
    }
    """
    And Mailinator API - primary user has the following email subject at his inbox "Change in allowed number of sessions due to insurance update"
      | We want to inform you that the number of sessions you are eligible for has changed after an Insurance update. The new amount of allowed sessions is 10. |

  Scenario: Get response with 4 allowed sessions
    Given Set primary user first name to CLAIM_BALANCE_0
    Given Client API - Create EAP room to primary user with therapist provider
      | flowId            | 44       |
      | age               | 18       |
      | keyword           | icuba    |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
    And DB - Verify primary user email
    And Client API - Login to primary user
    And Client API - Switch to therapist provider in the first room for primary user
    Given Therapist API - Login to therapist provider
    And Client API - Start async messaging session for primary user
      | roomIndex  | 0     |
      | isPurchase | false |
    And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
    And DB - Get past time from database last 10 days back as "service_start_date"
    And DB - Get past time from database last 1 days back as "service_end_date"
    And Therapist API - Send 2 VALID_RANDOM message as therapist provider to primary user in the first room
    And Client API - Send 2 VALID_RANDOM message as primary user in the first room
    And Admin API - Execute AUTOMATIC_SESSION_REPORTS cron
    And DB - Client insurance auth request data is "new" for primary user
    And DB - Store minimum session report id for primary user in the first room
    And DB - Store claim id for primary user
    And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
        "status": "pending_payer_data",
        "statusReason": "Aetna authcode is missing or expired"
    }
    """
    And Admin API - Execute SET_AETNA_REQUEST cron
    And DB - Client insurance auth request data is "sent" for primary user
    And DB - Store next Aetna member id
    And DB - Store primary user birth date
    And DB - Store auth effective date 14 days ago
    And DB - Store auth date
    And S3 - Upload Aetna’s response file with 2 authorized sessions for primary user
    And Admin API - Execute GET_AETNA_RESPONSE cron
    And DB - Number of session reports is 6 for primary in the first room
    And DB - Number of cancelled session reports is 4 for primary in the first room
    And DB - Number of video credits is 6 for primary in the first room
    And DB - Number of revoked credits is 4 for primary in the first room
    And Mailinator API - primary user has the following email subject at his inbox "Change in allowed number of sessions due to insurance update"
      | We want to inform you that the number of sessions you are eligible for has changed after an Insurance update. The new amount of allowed sessions is 2. |

  Scenario: Session start date is before auth effective date
    Given Set primary user first name to CLAIM_BALANCE_0
    Given Client API - Create EAP room to primary user with therapist provider
      | flowId            | 44       |
      | age               | 18       |
      | keyword           | icuba    |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
    And DB - Verify primary user email
    And Client API - Login to primary user
    And Client API - Switch to therapist provider in the first room for primary user
    Given Therapist API - Login to therapist provider
    And Client API - Start async messaging session for primary user
      | roomIndex  | 0     |
      | isPurchase | false |
    And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
    And DB - Get past time from database last 10 days back as "service_start_date"
    And DB - Get past time from database last 1 days back as "service_end_date"
    And Therapist API - Send 2 VALID_RANDOM message as therapist provider to primary user in the first room
    And Client API - Send 2 VALID_RANDOM message as primary user in the first room
    And Admin API - Execute AUTOMATIC_SESSION_REPORTS cron
    And DB - Client insurance auth request data is "new" for primary user
    And DB - Store minimum session report id for primary user in the first room
    And DB - Store claim id for primary user
    And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
        "status": "pending_payer_data",
        "statusReason": "Aetna authcode is missing or expired"
    }
    """
    And Admin API - Execute SET_AETNA_REQUEST cron
    And DB - Client insurance auth request data is "sent" for primary user
    And DB - Store next Aetna member id
    And DB - Store primary user birth date
    And DB - Store auth effective date 0 days ago
    And DB - Store auth date
    And S3 - Upload Aetna’s response file with 6 authorized sessions for primary user
    And Admin API - Execute GET_AETNA_RESPONSE cron
    And DB - Number of session reports is 6 for primary in the first room
    And DB - Number of video credits is 6 for primary in the first room
    And DB - Client insurance auth request data is "completed" for primary user
    And DB - Claim has the correct auth code
    And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
        "status": "pending_payer_data"
    }
    """

  Scenario: Backfill client_insurance_auth_request_data table
    Given Set primary user first name to CLAIM_BALANCE_0
    Given Client API - Create EAP room to primary user with therapist provider
      | flowId            | 44       |
      | age               | 18       |
      | keyword           | icuba    |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
    And DB - Verify primary user email
    And Client API - Login to primary user
    And Client API - Switch to therapist provider in the first room for primary user
    Given Therapist API - Login to therapist provider
    And Client API - Start async messaging session for primary user
      | roomIndex  | 0     |
      | isPurchase | false |
    And DB - Update date of birth for primary user with "2005-12-26"
    And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
    And DB - Get past time from database last 6 days back as "service_start_date"
    And DB - Get past time from database last 1 days back as "service_end_date"
    And Therapist API - Send 2 VALID_RANDOM message as therapist provider to primary user in the first room
    And Client API - Send 2 VALID_RANDOM message as primary user in the first room
    And Admin API - Execute AUTOMATIC_SESSION_REPORTS cron
    And DB - Client insurance auth request data is "new" for primary user
    And DB - Set null values on client_insurance_auth_request_data table for primary user
    And DB - Store minimum session report id for primary user in the first room
    And DB - Store claim id for primary user
    And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
        "status": "pending_payer_data",
        "statusReason": "Aetna authcode is missing or expired"
    }
    """
    And Admin API - Execute SET_AETNA_REQUEST cron
    And DB - Client insurance auth request data is "sent" for primary user
    And DB - SELECT "CONCAT_WS(\", \", status,is_full_request_data, first_name,date_of_birth,gender,country,city,state,street_address,street_number,address_line_2,zip,phone_number,plan_sponsor_name,is_employee,payer_id,presenting_problem_id,org_id,keyword,business_unit_id,business_unit_name)" FROM "talkspace_test4.client_insurance_auth_request_data" WHERE "user_id={user_id} and last_name is not null" is
      | sent, 1, eap0, 2005-12-26, M, us, cheyenne, mt, 4941 king arthur way, cheyenne, wy 82009, united states, 222, 82009, +12025550126, Independent Colleges and Universities Benefits Association Inc., 1, EAP20, 3, 575772, ICUBA, 45826, Independent Colleges and Universities Benefits |
    And DB - Store next Aetna member id
    And DB - Store primary user birth date
    And DB - Store auth effective date 14 days ago
    And DB - Store auth date
    And S3 - Upload Aetna’s response file with 6 authorized sessions for primary user
    And Admin API - Execute GET_AETNA_RESPONSE cron
    And DB - Number of session reports is 6 for primary in the first room
    And DB - Number of video credits is 6 for primary in the first room
    And DB - Client insurance auth request data is "completed" for primary user
    And DB - Claim has the correct auth code
    And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
        "status": "pending_submit"
    }
    """

  Scenario: Is_full_request_data is false on client_insurance_auth_request_data
    Given Set primary user first name to CLAIM_BALANCE_0
    Given Client API - Create EAP room to primary user with therapist provider
      | flowId            | 44       |
      | age               | 18       |
      | keyword           | icuba    |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
    And DB - Verify primary user email
    And Client API - Login to primary user
    And Client API - Switch to therapist provider in the first room for primary user
    Given Therapist API - Login to therapist provider
    And Client API - Start async messaging session for primary user
      | roomIndex  | 0     |
      | isPurchase | false |
    And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
    And DB - Get past time from database last 6 days back as "service_start_date"
    And DB - Get past time from database last 1 days back as "service_end_date"
    And Therapist API - Send 2 VALID_RANDOM message as therapist provider to primary user in the first room
    And Client API - Send 2 VALID_RANDOM message as primary user in the first room
    And DB - Clear DOB from client insurance info table for primary user
    And Admin API - Execute AUTOMATIC_SESSION_REPORTS cron
    And DB - Client insurance auth request data is "new" for primary user
    And DB - Is_full_request_data on client insurance auth request data table is false for primary user
    And DB - Store minimum session report id for primary user in the first room
    And DB - Store claim id for primary user
    And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
        "status": "unclean",
        "statusReason": "Member birth date is missing"
    }
    """
    And Admin API - Execute SET_AETNA_REQUEST cron
    And DB - Client insurance auth request data is "new" for primary user
    And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
        "status": "unclean",
        "statusReason": "Member birth date is missing"
    }
    """

  Scenario: Match response by name and DOB
    Given Set primary user first name to CLAIM_BALANCE_0
    Given Client API - Create EAP room to primary user with therapist provider
      | flowId            | 44       |
      | age               | 18       |
      | keyword           | icuba    |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
    And DB - Verify primary user email
    And Client API - Login to primary user
    And Client API - Switch to therapist provider in the first room for primary user
    Given Therapist API - Login to therapist provider
    And Client API - Start async messaging session for primary user
      | roomIndex  | 0     |
      | isPurchase | false |
    And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
    And DB - Get past time from database last 10 days back as "service_start_date"
    And DB - Get past time from database last 1 days back as "service_end_date"
    And Therapist API - Send 2 VALID_RANDOM message as therapist provider to primary user in the first room
    And Client API - Send 2 VALID_RANDOM message as primary user in the first room
    And Admin API - Execute AUTOMATIC_SESSION_REPORTS cron
    And DB - Client insurance auth request data is "new" for primary user
    And Admin API - Execute SET_AETNA_REQUEST cron
    And DB - Client insurance auth request data is "sent" for primary user
    And DB - Store next Aetna member id
    And DB - Store primary user birth date
    And DB - Store auth effective date 14 days ago
    And DB - Store auth date
    And S3 - Upload Aetna’s response file with 6 authorized sessions for primary user with blank talkspace user id
    And Admin API - Execute GET_AETNA_RESPONSE cron
    And DB - Number of aetna_auth_responses for primary user is 1
    And DB - Client insurance auth request data is "completed" for primary user
    And DB - Claim has the correct auth code
    And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
        "status": "pending_submit"
    }
    """

  Scenario: Verify request file
    Given Set primary user first name to CLAIM_BALANCE_0
    Given Client API - Create EAP room to primary user with therapist provider
      | flowId            | 44       |
      | age               | 18       |
      | keyword           | icuba    |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
    And DB - Verify primary user email
    And Client API - Login to primary user
    And Client API - Switch to therapist provider in the first room for primary user
    Given Therapist API - Login to therapist provider
    And Client API - Start async messaging session for primary user
      | roomIndex  | 0     |
      | isPurchase | false |
    And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
    And DB - Get past time from database last 10 days back as "service_start_date"
    And DB - Get past time from database last 1 days back as "service_end_date"
    And Therapist API - Send 2 VALID_RANDOM message as therapist provider to primary user in the first room
    And Client API - Send 2 VALID_RANDOM message as primary user in the first room
    And Admin API - Execute AUTOMATIC_SESSION_REPORTS cron
    And DB - Client insurance auth request data is "new" for primary user
    And S3 - Delete athana request files
    And Admin API - Execute SET_AETNA_REQUEST cron
    And DB - Client insurance auth request data is "sent" for primary user
    And DB - Store primary user birth date
    And S3 - Verify athana request file for primary user

  Scenario: Get response when auth code already exists
    Given Set primary user first name to CLAIM_BALANCE_0
    Given Client API - Create EAP room to primary user with therapist provider
      | flowId            | 44       |
      | age               | 18       |
      | keyword           | icuba    |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
    And DB - Verify primary user email
    And Client API - Login to primary user
    And Client API - Switch to therapist provider in the first room for primary user
    Given Therapist API - Login to therapist provider
    And Client API - Start async messaging session for primary user
      | roomIndex  | 0     |
      | isPurchase | false |
    And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
    And DB - Get past time from database last 10 days back as "service_start_date"
    And DB - Get past time from database last 1 days back as "service_end_date"
    And Therapist API - Send 2 VALID_RANDOM message as therapist provider to primary user in the first room
    And Client API - Send 2 VALID_RANDOM message as primary user in the first room
    And DB - Assign auth code to primary user
    And Admin API - Execute AUTOMATIC_SESSION_REPORTS cron
    And DB - Client insurance auth request data is "new" for primary user
    And DB - Store minimum session report id for primary user in the first room
    And DB - Store claim id for primary user
    And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
        "status": "pending_payer_data",
        "statusReason": "Aetna authcode is missing or expired"
    }
    """
    And Admin API - Execute SET_AETNA_REQUEST cron
    And DB - Client insurance auth request data is "sent" for primary user
    And DB - Store next Aetna member id
    And DB - Store primary user birth date
    And DB - Store auth effective date 14 days ago
    And DB - Store auth date
    And S3 - Upload Aetna’s response file with 6 authorized sessions for primary user
    And Admin API - Execute GET_AETNA_RESPONSE cron
    And DB - Client insurance auth request data is "completed" for primary user
    And DB - Store minimum session report id for primary user in the first room
    And DB - Store claim id for primary user
    And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
        "status": "pending_submit"
    }
    """
    And DB - Claim has the correct auth code
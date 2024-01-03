@admin
@tmsLink=talktala.testrail.net/index.php?/runs/overview/43
Feature: Claims

  Rule: EAP

    Background:
      Given Therapist API - Login to therapist provider

    Scenario: EAP - Submit claim
      Given Set primary user first name to CLAIM_BALANCE_GREATER_THEN_0
      Given Client API - Create EAP room to primary user with therapist provider
        | flowId            | 62                      |
        | age               | 18                      |
        | keyword           | optumwellbeingprogram16 |
        | employee Relation | EMPLOYEE                |
        | state             | WY                      |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0     |
        | isPurchase | false |
      And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
      And DB - Get past time from database last 10 days back as "service_start_date"
      And DB - Get past time from database last 1 days back as "service_end_date"
      And Therapist API - Send 2 VALID_RANDOM message as therapist provider to primary user in the first room
      And Client API - Send 2 VALID_RANDOM message as primary user in the first room
      And Admin API - Execute AUTOMATIC_SESSION_REPORTS cron
      And DB - Store minimum session report id for primary user in the first room
      And DB - Store claim id for primary user
      And DB - Store claim status for primary user
      And Admin API - SUBMIT the claim
      And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
    "status": "submitted"
    }
    """

    Scenario: EAP - Verify sendAuthCode and removeRenderingProvider on payer_pa_identity_config admin config
      Given Set primary user first name to CLAIM_BALANCE_0
      Given Client API - Create EAP room to primary user with therapist provider
        | flowId            | 62                      |
        | age               | 18                      |
        | keyword           | optumwellbeingprogram16 |
        | employee Relation | EMPLOYEE                |
        | state             | WY                      |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0     |
        | isPurchase | false |
      And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
      And DB - Get past time from database last 10 days back as "service_start_date"
      And DB - Get past time from database last 1 days back as "service_end_date"
      And Therapist API - Send 2 VALID_RANDOM message as therapist provider to primary user in the first room
      And Client API - Send 2 VALID_RANDOM message as primary user in the first room
      And Admin API - Execute AUTOMATIC_SESSION_REPORTS cron
      And DB - Store minimum session report id for primary user in the first room
      And DB - Store claim id for primary user
      And DB - Store claim status for primary user
      And DB - UPDATE "claims.claims" SET "is_test=1" WHERE "id={claim_id}"
      And Admin API - SUBMIT the claim
      And Admin API - Verify "raw837URL" claim file does not contain
        | 1234567893 |
        | 123456-78  |

    Scenario: EAP - Verify validateAuthCode on payer_pa_identity_config admin config
      Given Set primary user first name to CLAIM_BALANCE_0
      Given Client API - Create EAP room to primary user with therapist provider
        | flowId            | 62                      |
        | age               | 18                      |
        | keyword           | optumwellbeingprogram16 |
        | employee Relation | EMPLOYEE                |
        | state             | WY                      |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0     |
        | isPurchase | false |
      And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
      And DB - Get past time from database last 10 days back as "service_start_date"
      And DB - Get past time from database last 1 days back as "service_end_date"
      And Therapist API - Send 2 VALID_RANDOM message as therapist provider to primary user in the first room
      And Client API - Send 2 VALID_RANDOM message as primary user in the first room
      And Admin API - Execute AUTOMATIC_SESSION_REPORTS cron
      And DB - Store minimum session report id for primary user in the first room
      And DB - Store claim id for primary user
      And DB - Store claim status for primary user
      And DB - UPDATE "claims.claims_data" SET "member_authorization_code=null" WHERE "claim_id={claim_id}"
      And Admin API - RESET the claim
      And Admin API - SUBMIT the claim
      And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
    "status": "submitted"
    }
    """

    Scenario: EAP - Denied claim
      Given Set primary user first name to DENIED
      Given Client API - Create EAP room to primary user with therapist provider
        | flowId            | 62                      |
        | age               | 18                      |
        | keyword           | optumwellbeingprogram16 |
        | employee Relation | EMPLOYEE                |
        | state             | WY                      |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0     |
        | isPurchase | false |
      And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
      And DB - Get past time from database last 10 days back as "service_start_date"
      And DB - Get past time from database last 1 days back as "service_end_date"
      And Therapist API - Send 2 VALID_RANDOM message as therapist provider to primary user in the first room
      And Client API - Send 2 VALID_RANDOM message as primary user in the first room
      And Admin API - Execute AUTOMATIC_SESSION_REPORTS cron
      And DB - Store minimum session report id for primary user in the first room
      And DB - Store claim id for primary user
      And DB - Store claim status for primary user
      And Admin API - SUBMIT the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And Admin API - Verify claim data of primary user and therapist provider
    """json
      {
        "status": "denied",
        "adminEvents": [
          "WRITE_OFF",
          "RESUBMIT",
          "VOID",
          "ESCALATE_TO_MANAGER"
        ]
      }
    """

    Scenario: EAP - Rejected by payer
      Given Set primary user first name to REJECTED_BY_PAYER
      Given Client API - Create EAP room to primary user with therapist provider
        | flowId            | 62                      |
        | age               | 18                      |
        | keyword           | optumwellbeingprogram16 |
        | employee Relation | EMPLOYEE                |
        | state             | WY                      |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0     |
        | isPurchase | false |
      And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
      And DB - Get past time from database last 10 days back as "service_start_date"
      And DB - Get past time from database last 1 days back as "service_end_date"
      And Therapist API - Send 2 VALID_RANDOM message as therapist provider to primary user in the first room
      And Client API - Send 2 VALID_RANDOM message as primary user in the first room
      And Admin API - Execute AUTOMATIC_SESSION_REPORTS cron
      And DB - Store minimum session report id for primary user in the first room
      And DB - Store claim id for primary user
      And DB - Store claim status for primary user
      And Admin API - SUBMIT the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And Admin API - Verify claim data of primary user and therapist provider
    """json
       {
        "status": "rejected",
        "claimSubmitted": {
          "insuranceResolution": "rejected_by_payer",
          "insuranceResolutionReason": "REJECTED_FOR_INVALID_INFO"
        },
        "adminEvents": [
          "WRITE_OFF",
          "RESUBMIT",
          "ESCALATE_TO_MANAGER"
        ]
      }
    """

    Scenario: EAP - Rejected by Trizetto
      Given Set primary user first name to REJECTED_BY_TRIZETTO
      Given Client API - Create EAP room to primary user with therapist provider
        | flowId            | 62                      |
        | age               | 18                      |
        | keyword           | optumwellbeingprogram16 |
        | employee Relation | EMPLOYEE                |
        | state             | WY                      |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0     |
        | isPurchase | false |
      And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
      And DB - Get past time from database last 10 days back as "service_start_date"
      And DB - Get past time from database last 1 days back as "service_end_date"
      And Therapist API - Send 2 VALID_RANDOM message as therapist provider to primary user in the first room
      And Client API - Send 2 VALID_RANDOM message as primary user in the first room
      And Admin API - Execute AUTOMATIC_SESSION_REPORTS cron
      And DB - Store minimum session report id for primary user in the first room
      And DB - Store claim id for primary user
      And DB - Store claim status for primary user
      And Admin API - SUBMIT the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And Admin API - Verify claim data of primary user and therapist provider
    """json
         {
      "status": "rejected",
      "claimSubmitted": {
        "insuranceResolution": "rejected_by_trizetto",
        "insuranceResolutionReason": "One or more segments in error - Segment has data element errors - Mandatory data element missing"
      },
      "adminEvents": [
        "WRITE_OFF",
        "RESUBMIT",
        "ESCALATE_TO_MANAGER"
      ]
    }
    """

    Scenario: EAP - Add claimable credit
      Given Set primary user first name to REJECTED_BY_TRIZETTO
      Given Client API - Create EAP room to primary user with therapist provider
        | flowId            | 62                      |
        | age               | 18                      |
        | keyword           | optumwellbeingprogram16 |
        | employee Relation | EMPLOYEE                |
        | state             | WY                      |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0     |
        | isPurchase | false |
      And DB - Update session report status to "cancelled" for primary user in the first room
      And DB - UPDATE "talkspace_test4.video_credits" SET "revoked_at='2023-10-10 10:10:10'" WHERE "purchased_in_room_id={room_id_1} limit 20"
      And Admin API - Add EAP credit with reason: "health_plan_request" for primary user in the first room
      And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
      And DB - Get past time from database last 10 days back as "service_start_date"
      And DB - Get past time from database last 1 days back as "service_end_date"
      And Therapist API - Send 2 VALID_RANDOM message as therapist provider to primary user in the first room
      And Client API - Send 2 VALID_RANDOM message as primary user in the first room
      And Admin API - Execute AUTOMATIC_SESSION_REPORTS cron
      Then DB - Claim count for primary user in the first room is 1

    Scenario Outline: EAP - Add non claimable credit
      Given Set primary user first name to REJECTED_BY_TRIZETTO
      Given Client API - Create EAP room to primary user with therapist provider
        | flowId            | 62                      |
        | age               | 18                      |
        | keyword           | optumwellbeingprogram16 |
        | employee Relation | EMPLOYEE                |
        | state             | WY                      |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0     |
        | isPurchase | false |
      And DB - Update session report status to "cancelled" for primary user in the first room
      And DB - UPDATE "talkspace_test4.video_credits" SET "revoked_at='2023-10-10 10:10:10'" WHERE "purchased_in_room_id={room_id_1} limit 20"
      And Admin API - Add EAP credit with reason: "<reason>" for primary user in the first room
      And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
      And DB - Get past time from database last 10 days back as "service_start_date"
      And DB - Get past time from database last 1 days back as "service_end_date"
      And Therapist API - Send 2 VALID_RANDOM message as therapist provider to primary user in the first room
      And Client API - Send 2 VALID_RANDOM message as primary user in the first room
      And Admin API - Execute AUTOMATIC_SESSION_REPORTS cron
      Then DB - Claim count for primary user in the first room is 0
      Examples:
        | reason                  |
        | poor_quality            |
        | member_misunderstanding |

    Scenario: Extend EAP auth code by admin
      Given Set primary user first name to REJECTED_BY_TRIZETTO
      Given Client API - Create EAP room to primary user with therapist provider
        | flowId            | 62                      |
        | age               | 18                      |
        | keyword           | optumwellbeingprogram16 |
        | employee Relation | EMPLOYEE                |
        | state             | WY                      |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And DB - UPDATE "talkspace_test4.private_talks" SET "expiration_date=DATE_ADD(CURDATE(), INTERVAL 1 MONTH)" WHERE "id={room_id_1}"
      And DB - UPDATE "talkspace_test4.client_insurance_info_timeframe" SET "ends_at=DATE_ADD(CURDATE(), INTERVAL 1 MONTH)" WHERE "room_id={room_id_1}"
      And Admin API - Extend EAP auth code for primary user in the first room
      And DB - SELECT "CASE WHEN ends_at = CONCAT(DATE_ADD(DATE(NOW()), INTERVAL 1 YEAR), ' 23:59:59') THEN 1 ELSE 0 END AS result" FROM "talkspace_test4.client_insurance_info_timeframe" WHERE "room_id={room_id_1}" is
        | 1 |
      And DB - SELECT "CASE WHEN expiration_date = CONCAT(DATE_ADD(DATE(NOW()), INTERVAL 1 YEAR), ' 00:00:00') THEN 1 ELSE 0 END AS result" FROM "talkspace_test4.private_talks" WHERE "id={room_id_1}" is
        | 1 |

    Scenario: Update EAP member data
      Given Set primary user first name to REJECTED_BY_TRIZETTO
      Given Client API - Create EAP room to primary user with therapist provider
        | flowId            | 62                      |
        | age               | 18                      |
        | keyword           | optumwellbeingprogram16 |
        | employee Relation | EMPLOYEE                |
        | state             | WY                      |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And DB - Store client insurance information id for primary user
      And Admin API - Update member data for primary user
      """json
  {
        "memberID": null,
        "firstName": "eap4",
        "lastName": "matic",
        "dateOfBirth": "2005-12-12",
        "gender": "M",
        "country": "us",
        "city": "HOBOKEN",
        "state": "nj",
        "streetAddress": "2881 12TH ST",
        "streetNumber": "1234",
        "addressLine2": null,
        "zip": "90211",
        "phoneNumber": "+12025550128",
        "groupNumber": null,
        "authorizationCode": "111111-22",
        "planSponsorName": "Optum Wellbeing Program - 16",
        "eligibilityMechanism": null,
        "dataSource": "admin",
        "payerID": "87726"
  }
      """
      And Admin API - Verify member data by client insurance information id for primary user
            """json
  {
        "memberID": null,
        "firstName": "eap4",
        "lastName": "matic",
        "dateOfBirth": "2005-12-12",
        "gender": "M",
        "country": "us",
        "city": "HOBOKEN",
        "state": "nj",
        "streetAddress": "2881 12TH ST",
        "streetNumber": "1234",
        "addressLine2": null,
        "zip": "90211",
        "phoneNumber": "+12025550128",
        "groupNumber": null,
        "authorizationCode": "111111-22",
        "planSponsorName": "Optum Wellbeing Program - 16",
        "eligibilityMechanism": null,
        "dataSource": "admin",
        "payerID": "87726"
    }
      """
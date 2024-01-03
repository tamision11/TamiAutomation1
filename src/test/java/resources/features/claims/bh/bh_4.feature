@admin
@tmsLink=talktala.testrail.net/index.php?/runs/overview/43
Feature: Claims

  Rule: BH

    Background:
      Given Therapist API - Login to therapist provider
      Given Set primary user last name to Automation

    Scenario: BH - Multiple claims on the same ERA AKA aggregated invoices tomcat166
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                 |
        | age               | 18                 |
        | Member ID         | CLAIM_BH_AGGREGATE |
        | keyword           | premerabh          |
        | employee Relation | EMPLOYEE           |
        | state             | HI                 |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0    |
        | isPurchase | true |
      And DB - Update messaging session data - Move dates 30 days back for primary user in the first room
      And Wait 5 seconds
      And DB - Store case id for primary user in the first room
      And DB - Store session report id for primary user in the first room
      And DB - Store customer id for primary user
      And DB - Get past time from database last 30 days back as "service_start_date"
      And DB - Get past time from database last 20 days back as "service_end_date"
      And Therapist API - Submit BH messaging session summary notes
        | cpt code | 5 |
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0    |
        | isPurchase | true |
      And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
      And Wait 5 seconds
      And DB - Store maximum session report id for primary user in the first room
      And DB - Store case id for primary user in the first room
      And DB - Store customer id for primary user
      And DB - Get past time from database last 10 days back as "service_start_date"
      And DB - Get past time from database last 1 days back as "service_end_date"
      And Therapist API - Submit BH messaging session summary notes
        | cpt code | 5 |
      And Wait 5 seconds
      And DB - Store minimum claim id for primary user
      And Admin API - SUBMIT the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And DB - Store maximum claim id for primary user
      And Admin API - SUBMIT the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And DB - Store the following data
        | column                                          | table                  | condition                  | resultName |
        | balance_invoice_id                              | claims.claims_payments | claim_id={claim_id}        | invoice_id |
        | group_concat(id ORDER BY id desc SEPARATOR ',') | claims.claims          | member_room_id={room_id_1} | claims     |
      And Stripe - Invoice metadata is
        | isAggregated | true        |
        | claimID      | {claims}    |
        | copay        | 5000        |
        | chargeType   | postSession |
      And DB - SELECT "count(distinct(era_id))" FROM "claims.claims_payments" WHERE "balance_invoice_id='{invoice_id}'" is
        | 1 |
      And Stripe - Pay unpaid invoices for primary user
      And DB - SELECT "count(*)" FROM "claims.claims" WHERE "member_user_id={user_id}" is
        | 2 |
      And DB - SELECT "count(*)" FROM "claims.claims_history" WHERE "member_user_id={user_id} and reason='Paid by user' " is
        | 2 |
      And DB - SELECT "amount" FROM "claims.claims_transactions" WHERE "claim_id in (select id from claims.claims where member_user_id={user_id}) and invoice_id is not null and charge_id is not null order by claim_id desc" is
        | 5000 |
        | 1000 |
        | 5000 |
        | 1000 |
      And Mailinator API - primary user has the following email subject at his inbox "FYI we charged your card and here's why"
        | We billed you for the *remaining balance of $20.00* |

    Scenario: BH - Getting 277p with rejected after a 277p with accepted
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                                |
        | age               | 18                                |
        | Member ID         | MOCK_277P_REJECTED_AFTER_ACCEPTED |
        | keyword           | premerabh                         |
        | employee Relation | EMPLOYEE                          |
        | state             | HI                                |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0    |
        | isPurchase | true |
      And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
      And Wait 5 seconds
      And DB - Store case id for primary user in the first room
      And DB - Store session report id for primary user in the first room
      And DB - Store customer id for primary user
      And DB - Get past time from database last 10 days back as "service_start_date"
      And DB - Get past time from database last 1 days back as "service_end_date"
      And Therapist API - Submit BH messaging session summary notes
        | cpt code | 5 |
      And Wait 5 seconds
      And DB - Store claim id for primary user
      And Admin API - SUBMIT the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And DB - SELECT "count(*)" FROM "claims.claims_submitted" WHERE "claim_id={claim_id} and raw_277p_storage_key like '%.27P' and raw_277c_storage_key like '%.27C'" is
        | 1 |
      And Admin API - Verify claim data of primary user and therapist provider
        """json
          {
                "status": "rejected",
                "claimSubmitted":
                {
                  "insuranceResolution": "rejected_by_payer"
                },
                "claimHistory": [
                {
                        "reason": "Claim has been marked as clean"
                },
                {
                        "reason": "Admin has submitted the claim"
                },
                {
                        "reason": "The result of pollFunctionalAcks execution"
                },
                {
                        "reason": "The result of pollClearinghouseBusinessRulesAcks execution"
                },
                {
                        "reason": "The result of pollPayerBusinessRulesAcks execution"
                },
                {
                        "reason": "The result of pollPayerBusinessRulesAcks execution"
                }
        ]
      }
        """

    Scenario: BH - Getting 277p with accepted after a 277p with accepted
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                                |
        | age               | 18                                |
        | Member ID         | MOCK_277P_ACCEPTED_AFTER_ACCEPTED |
        | keyword           | premerabh                         |
        | employee Relation | EMPLOYEE                          |
        | state             | HI                                |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0    |
        | isPurchase | true |
      And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
      And Wait 5 seconds
      And DB - Store case id for primary user in the first room
      And DB - Store session report id for primary user in the first room
      And DB - Store customer id for primary user
      And DB - Get past time from database last 10 days back as "service_start_date"
      And DB - Get past time from database last 1 days back as "service_end_date"
      And Therapist API - Submit BH messaging session summary notes
        | cpt code | 5 |
      And Wait 5 seconds
      And DB - Store claim id for primary user
      And Admin API - SUBMIT the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And DB - SELECT "count(*)" FROM "claims.claims_submitted" WHERE "claim_id={claim_id} and raw_277p_storage_key like '%.27P' and raw_277c_storage_key like '%.27C'" is
        | 1 |
      And Admin API - Verify claim data of primary user and therapist provider
        """json
          {
                "status": "accepted_by_payer",
                "claimSubmitted":
                {
                  "insuranceResolutionDetails": " Payer Acknowledged/Accepted the claim"
                },
                "claimHistory": [
                {
                        "reason": "Claim has been marked as clean"
                },
                {
                        "reason": "Admin has submitted the claim"
                },
                {
                        "reason": "The result of pollFunctionalAcks execution"
                },
                {
                        "reason": "The result of pollClearinghouseBusinessRulesAcks execution"
                },
                {
                        "reason": "The result of pollPayerBusinessRulesAcks execution"
                }
        ]
      }
        """

    Scenario: BH - Getting 277p with rejected after a 277p with rejected
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                                |
        | age               | 18                                |
        | Member ID         | MOCK_277P_REJECTED_AFTER_REJECTED |
        | keyword           | premerabh                         |
        | employee Relation | EMPLOYEE                          |
        | state             | HI                                |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0    |
        | isPurchase | true |
      And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
      And Wait 5 seconds
      And DB - Store case id for primary user in the first room
      And DB - Store session report id for primary user in the first room
      And DB - Store customer id for primary user
      And DB - Get past time from database last 10 days back as "service_start_date"
      And DB - Get past time from database last 1 days back as "service_end_date"
      And Therapist API - Submit BH messaging session summary notes
        | cpt code | 5 |
      And Wait 5 seconds
      And DB - Store claim id for primary user
      And Admin API - SUBMIT the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And DB - SELECT "count(*)" FROM "claims.claims_submitted" WHERE "claim_id={claim_id} and raw_277p_storage_key like '%.27P' and raw_277c_storage_key like '%.27C'" is
        | 1 |
      And Admin API - Verify claim data of primary user and therapist provider
        """json
          {
                "status": "rejected",
                "claimSubmitted":
                {
                  "insuranceResolution": "rejected_by_payer"
                },
                "claimHistory": [
                {
                        "reason": "Claim has been marked as clean"
                },
                {
                        "reason": "Admin has submitted the claim"
                },
                {
                        "reason": "The result of pollFunctionalAcks execution"
                },
                {
                        "reason": "The result of pollClearinghouseBusinessRulesAcks execution"
                },
                {
                        "reason": "The result of pollPayerBusinessRulesAcks execution"
                }
        ]
      }
        """

    Scenario: BH - Getting 277p with rejected but not as the last status tomcat179
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                                    |
        | age               | 18                                    |
        | Member ID         | MOCK_277P_REJECTED_NOT_AS_LAST_STATUS |
        | keyword           | premerabh                             |
        | employee Relation | EMPLOYEE                              |
        | state             | HI                                    |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0    |
        | isPurchase | true |
      And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
      And Wait 5 seconds
      And DB - Store case id for primary user in the first room
      And DB - Store session report id for primary user in the first room
      And DB - Store customer id for primary user
      And DB - Get past time from database last 10 days back as "service_start_date"
      And DB - Get past time from database last 1 days back as "service_end_date"
      And Therapist API - Submit BH messaging session summary notes
        | cpt code | 5 |
      And Wait 5 seconds
      And DB - Store claim id for primary user
      And Admin API - SUBMIT the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And DB - SELECT "count(*)" FROM "claims.claims_submitted" WHERE "claim_id={claim_id} and raw_277p_storage_key like '%.27P' and raw_277c_storage_key like '%.27C'" is
        | 1 |
      And Admin API - Verify claim data of primary user and therapist provider
        """json
          {
                "status": "rejected",
                "claimSubmitted":
                {
                  "insuranceResolution": "rejected_by_payer",
                  "insuranceResolutionReason": "REJECTED_FOR_INVALID_INFO",
                  "insuranceResolutionDetails": " Payer Acknowledged/Accepted the claim"
                },
                "claimHistory": [
                {
                        "reason": "Claim has been marked as clean"
                },
                {
                        "reason": "Admin has submitted the claim"
                },
                {
                        "reason": "The result of pollFunctionalAcks execution"
                },
                {
                        "reason": "The result of pollClearinghouseBusinessRulesAcks execution"
                },
                {
                        "reason": "The result of pollPayerBusinessRulesAcks execution"
                }
        ]
      }
        """

    Scenario: BH - Multiple adjustments tomcat180
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                        |
        | age               | 18                        |
        | Member ID         | MOCK_MULTIPLE_ADJUSTMENTS |
        | keyword           | premerabh                 |
        | employee Relation | EMPLOYEE                  |
        | state             | HI                        |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0    |
        | isPurchase | true |
      And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
      And Wait 5 seconds
      And DB - Store case id for primary user in the first room
      And DB - Store session report id for primary user in the first room
      And DB - Store customer id for primary user
      And DB - Get past time from database last 10 days back as "service_start_date"
      And DB - Get past time from database last 1 days back as "service_end_date"
      And Therapist API - Submit BH messaging session summary notes
        | cpt code | 5 |
      And Wait 5 seconds
      And DB - Store claim id for primary user
      And Admin API - SUBMIT the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And DB - SELECT "CONCAT_WS(\", \", group_code, reason_code, reason_description, amount)" FROM "claims.claims_adjustments" WHERE "claim_id={claim_id} order by id desc" is
        | CO, 45, Charge exceeds fee schedule/maximum allowable or contracted/legislated fee arrangement, 5352 |
        | PI, B4, Late filing penalty, 1500                                                                    |
        | PR, 3, Co-payment Amount, 2500                                                                       |
        | PR, 2, Coinsurance Amount, 1178                                                                      |
        | PR, 1, Deductible Amount, 12144                                                                      |
      And Admin API - Verify claim data of primary user and therapist provider
        """json
        {
            "status": "completed",
            "claimPayment":
              {
                "deductibleFinal": 121.44,
                "coinsuranceFinal": 11.78,
                "copayFinal": 25,
                "lateFilingFee": 15,
                "otherAdjustments": 53.52
              }
        }
        """

    Scenario: BH - Cancel claim
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                 |
        | age               | 18                 |
        | Member ID         | CLAIM_BH_BALANCE_0 |
        | keyword           | premerabh          |
        | employee Relation | EMPLOYEE           |
        | state             | HI                 |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0    |
        | isPurchase | true |
      And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
      And Wait 5 seconds
      And DB - Store case id for primary user in the first room
      And DB - Store session report id for primary user in the first room
      And DB - Store customer id for primary user
      And DB - Get past time from database last 10 days back as "service_start_date"
      And DB - Get past time from database last 1 days back as "service_end_date"
      And Therapist API - Submit BH messaging session summary notes
        | cpt code | 5 |
      And Wait 5 seconds
      And DB - Store claim id for primary user
      And Admin API - CANCEL the claim
      And Admin API - Verify claim data of primary user and therapist provider
        """json
          {
                "status": "cancelled",
                "claimHistory": [
                  {
                    "reason": "Claim has been marked as clean"
                  },
                  {
                    "reason": "Admin has closed the claim"
                  }
                  ],
                "adminEvents": [
                  "ESCALATE_TO_MANAGER"
                ]
          }
        """

    Scenario: BH - Claim completed
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                 |
        | age               | 18                 |
        | Member ID         | CLAIM_BH_BALANCE_0 |
        | keyword           | premerabh          |
        | employee Relation | EMPLOYEE           |
        | state             | HI                 |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0    |
        | isPurchase | true |
      And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
      And Wait 5 seconds
      And DB - Store case id for primary user in the first room
      And DB - Store session report id for primary user in the first room
      And DB - Get past time from database last 10 days back as "service_start_date"
      And DB - Get past time from database last 1 days back as "service_end_date"
      And Therapist API - Submit BH messaging session summary notes
        | cpt code | 5 |
      And Wait 5 seconds
      And DB - Store claim id for primary user
      And Admin API - SUBMIT the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
     "status": "completed",
     "adminEvents": [
        "RESUBMIT",
        "VOID",
        "ESCALATE_TO_MANAGER"
      ]
    }
    """

    Scenario: BH - Hold before submit
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                 |
        | age               | 18                 |
        | Member ID         | CLAIM_BH_BALANCE_0 |
        | keyword           | premerabh          |
        | employee Relation | EMPLOYEE           |
        | state             | HI                 |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0    |
        | isPurchase | true |
      And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
      And Wait 5 seconds
      And DB - Store case id for primary user in the first room
      And DB - Store session report id for primary user in the first room
      And DB - Get past time from database last 10 days back as "service_start_date"
      And DB - Get past time from database last 1 days back as "service_end_date"
      And Therapist API - Submit BH messaging session summary notes
        | cpt code | 5 |
      And Wait 5 seconds
      And DB - Store claim id for primary user
      And DB - SELECT "count(*) as verify_configuration" FROM "talkspace_test4.admin_config" WHERE "name='claim_review_period' and json_data like ('%\"00830\":14%')" is 1
      And DB - UPDATE "claims.claims" SET "created_at=(select DATE_SUB(now(), INTERVAL 15 DAY))" WHERE "id={claim_id}"
      And Admin API - HOLD_OFF_SUBMISSION the claim
      And Admin API - Execute SUBMIT_PENDING_CLAIMS cron
      And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
      "status": "on_hold",
          "adminEvents": [
            "CANCEL",
            "SUBMIT",
            "RESET",
            "ESCALATE_TO_MANAGER"
        ]
    }
    """

    @tmsLink=talktala.atlassian.net/browse/PLATFORM-3964
    @ignore
    Scenario: BH - Invalid external id
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                 |
        | age               | 18                 |
        | Member ID         | CLAIM_BH_BALANCE_0 |
        | keyword           | premerabh          |
        | employee Relation | EMPLOYEE           |
        | state             | HI                 |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0    |
        | isPurchase | true |
      And DB - Update messaging session data - Move dates 10 days back for primary user in the first room
      And Wait 5 seconds
      And DB - Store case id for primary user in the first room
      And DB - Store session report id for primary user in the first room
      And DB - Store customer id for primary user
      And DB - Get past time from database last 10 days back as "service_start_date"
      And DB - Get past time from database last 1 days back as "service_end_date"
      And Therapist API - Submit BH messaging session summary notes
        | cpt code | 5 |
      And Wait 5 seconds
      And DB - Store claim id for primary user
      And Admin API - SUBMIT the claim
      And Wait 5 seconds
      And DB - Store external id
      And S3 - Download rmt file from "remits" prefix
      And S3 - Remove first digit from external id
      And S3 - Override existing rmt file
      And Admin API - Execute POLL_EDI_FILES cron
      And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
       "status": "accepted_by_payer"
    }
    """
      And DB - SELECT "count(*)" FROM "claims.claims_processing" WHERE "external_claim_id='{invalid_external_id}' and claim_id=0" is
        | 1 |
      And DB - SELECT "count(*)" FROM "claims.manual_claims" WHERE "external_id='{invalid_external_id}'" is
        | 1 |
@admin
@tmsLink=talktala.testrail.net/index.php?/runs/overview/43
Feature: Claims

  Rule: BH

    Background:
      Given Therapist API - Login to therapist provider
      Given Set primary user last name to Automation

    Scenario: BH - Payer control number on resubmission
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                            |
        | age               | 18                            |
        | Member ID         | CLAIM_BH_REJECTED_BY_TRIZETTO |
        | keyword           | premerabh                     |
        | employee Relation | EMPLOYEE                      |
        | state             | HI                            |
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
      And Admin API - RESUBMIT the claim
      And Wait 15 seconds
      And DB - Update client insurance info member id to "tomcat155" for primary user
      And DB - UPDATE "talkspace_test4.client_insurance_info_timeframe" SET "starts_at=(SELECT DATE_SUB(NOW(), INTERVAL 20 DAY))" WHERE "room_id={room_id_1}"
      And Admin API - RESET the claim
      And Admin API - SUBMIT the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And Admin API - RESUBMIT the claim
      And Admin API - SUBMIT the claim
      And Admin API - Verify "raw837URL" claim file contains
        | ~REF*F8*94151100100~ |
      And DB - Claim submission type are
        | REPLACEMENT |
        | ORIGINAL    |
        | ORIGINAL    |
      And DB - SELECT "payer_control_number" FROM "claims.claims_submitted" WHERE "claim_id={claim_id}" is
        |             |
        | 94151100100 |
        |             |

    Scenario: BH - Claim automatic submission after review period
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                            |
        | age               | 18                            |
        | Member ID         | CLAIM_BH_REJECTED_BY_TRIZETTO |
        | keyword           | premerabh                     |
        | employee Relation | EMPLOYEE                      |
        | state             | HI                            |
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
      And DB - SELECT "count(*) as verify_configuration" FROM "talkspace_test4.admin_config" WHERE "name='claim_review_period' and json_data like ('%\"00830\":14%')" is 1
      And DB - UPDATE "claims.claims" SET "created_at=(select DATE_SUB(now(), INTERVAL 12 DAY))" WHERE "id={claim_id}"
      And Admin API - Execute SUBMIT_PENDING_CLAIMS cron
      And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
      "status": "pending_submit"
    }
      """
      And DB - UPDATE "claims.claims" SET "created_at=(select DATE_SUB(now(), INTERVAL 14 DAY))" WHERE "id={claim_id}"
      And Admin API - Execute SUBMIT_PENDING_CLAIMS cron
      And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
      "status": "submitted"
    }
    """
      And DB - SELECT "count(*)" FROM "claims.claims_history" WHERE "claim_id={claim_id} and reason='Automatic submission'" is 1

    Scenario: BH - Failed claim
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                       |
        | age               | 18                       |
        | Member ID         | UNSUPPORTED_BH_MEMBER_ID |
        | keyword           | premerabh                |
        | employee Relation | EMPLOYEE                 |
        | state             | HI                       |
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
      And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
     "status": "failed",
     "statusReason": "clearinghouseMockComposer: The provided test member ID is not supported",
     "adminEvents": [
        "REVIVE",
        "ESCALATE_TO_MANAGER"
    ]
    }
    """

    Scenario: BH - Revive failed claim
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                       |
        | age               | 18                       |
        | Member ID         | UNSUPPORTED_BH_MEMBER_ID |
        | keyword           | premerabh                |
        | employee Relation | EMPLOYEE                 |
        | state             | HI                       |
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
      And Admin API - REVIVE the claim
      And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
     "status": "pending_submit"
    }
    """
      And DB - SELECT "reason" FROM "claims.claims_history" WHERE "claim_id={claim_id} order by id" is
        | Claim has been marked as clean |
        | An unexpected error occurred   |
        | Admin has revived the claim    |

    Scenario: BH - Original submission type
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
      And DB - Claim submission type are
        | ORIGINAL |
      And Admin API - Verify "raw837URL" claim file contains
        | :B:1*Y |

    Scenario: BH - Corrected submission type
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
      And Admin API - Execute POLL_EDI_FILES cron
      And Admin API - RESUBMIT the claim
      And Admin API - SUBMIT the claim
      And DB - Claim submission type are
        | CORRECTED |
        | ORIGINAL  |
      And Admin API - Verify "raw837URL" claim file contains
        | :B:7*Y |

    Scenario: BH - Replacement submission type
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28              |
        | age               | 18              |
        | Member ID         | CLAIM_BH_DENIED |
        | keyword           | premerabh       |
        | employee Relation | EMPLOYEE        |
        | state             | HI              |
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
      And Admin API - Submit a charge of 5 dollars
      And Admin API - RESUBMIT the claim
      And Admin API - SUBMIT the claim
      And DB - Claim submission type are
        | REPLACEMENT |
        | ORIGINAL    |
      And Admin API - Verify "raw837URL" claim file contains
        | :B:7*Y |

    Scenario: BH - Void submission type
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28              |
        | age               | 18              |
        | Member ID         | CLAIM_BH_DENIED |
        | keyword           | premerabh       |
        | employee Relation | EMPLOYEE        |
        | state             | HI              |
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
      And Admin API - VOID the claim
      And DB - Claim submission type are
        | VOID     |
        | ORIGINAL |
      And Admin API - Verify "raw837URL" claim file contains
        | :B:8*Y |

    Scenario: BH - Void claim
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28              |
        | age               | 18              |
        | Member ID         | CLAIM_BH_CHARGE |
        | keyword           | premerabh       |
        | employee Relation | EMPLOYEE        |
        | state             | HI              |
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
      And Stripe - Pay unpaid invoices for primary user
      And Admin API - VOID the claim
      And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
     "status": "submitted"
    }
    """
      And DB - SELECT "amount" FROM "claims.claims_transactions" WHERE "claim_id={claim_id} order by id desc" is
        | -5000 |
        | -1000 |
        | 1000  |
        | 5000  |
      And DB - Refund amount for primary user in the first room is
        | 50.00 |
        | 10.00 |
      And DB - SELECT "reason_for_refund" FROM "talkspace_test4.payment_transactions_refunds" WHERE "room_id={room_id_1} order by payment_transactions_refunds_id desc" is
        | Voided claim - session |
        | Voided claim - session |
      And DB - SELECT "count(*)" FROM "claims.claims_payments" WHERE "claim_id={claim_id} and prepaid_refund_id is not null and balance_refund_id is not null" is
        | 1 |
      And Admin API - Execute POLL_EDI_FILES cron
      And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
     "status": "cancelled"
    }
    """
      And Mailinator API - primary user has the following email subject at his inbox "Refund applied to your account"
        | a refund in the amount of $50.00 was applied to your payment method on file |
        | and the remaining credit you should receive is $50.00                       |
      And Mailinator API - primary user has the following email subject at his inbox "Refund applied to your account"
        | a refund in the amount of $10.00 was applied to your payment method on file |
        | and the remaining credit you should receive is $10.00                       |

    @ignore
    Scenario: BH - Snooze claim
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28              |
        | age               | 18              |
        | Member ID         | CLAIM_BH_CHARGE |
        | keyword           | premerabh       |
        | employee Relation | EMPLOYEE        |
        | state             | HI              |
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
      And Client API - Create worklist
      And Admin API - Verify worklist has 1 item
      And Wait 30 seconds
      And DB - Store worklist id
      And Admin API - Snooze claim
      And Admin API - Verify worklist has 0 items
      And DB - UPDATE "claims.worklists" SET "fields=REPLACE(fields, (SELECT DATE(DATE_SUB(NOW(), INTERVAL -2 DAY)) AS date_only), (SELECT DATE(DATE_SUB(NOW(), INTERVAL 2 DAY)) AS date_only))" WHERE "id={worklist_id}"
      And Admin API - Verify worklist has 1 item
      And Admin API - Delete worklist
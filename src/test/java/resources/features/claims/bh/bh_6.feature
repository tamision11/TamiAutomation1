@admin
@tmsLink=talktala.testrail.net/index.php?/runs/overview/43
Feature: Claims

  Rule: BH

    Background:
      Given Therapist API - Login to therapist provider
      Given Set primary user last name to Automation

    Scenario: BH - Claim status Pending_member_refund
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28              |
        | age               | 18              |
        | Member ID         | CLAIM_BH_REFUND |
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
      And DB - UPDATE "claims.claims_payments" SET "prepaid_charge_id=concat(prepaid_charge_id,'_corrupted')" WHERE "claim_id={claim_id} limit 1"
      And Admin API - Execute POLL_EDI_FILES cron
      And Admin API - Verify claim data of primary user and therapist provider
      """json
      {
       "status": "pending_member_refund",
       "adminEvents": [
        "VOID",
        "RESUBMIT",
        "ESCALATE_TO_MANAGER"
        ]
       }
      """

    Scenario: BH - Pending_admin_consolidation: refund member
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 86                    |
        | age               | 18                    |
        | Member ID         | CLAIM_BH_REFUND       |
        | keyword           | allegiancebhwithvideo |
        | employee Relation | EMPLOYEE              |
        | state             | HI                    |
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
        | cpt code | 12 |
      And Wait 5 seconds
      And DB - Store claim id for primary user
      And Admin API - SUBMIT the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And Admin API - Verify claim data of primary user and therapist provider
      """json
      {
        "status": "pending_admin_consolidation",
        "adminEvents": [
                "RESUBMIT",
                "WRITE_OFF",
                "REFUND_MEMBER",
                "VOID",
                "ESCALATE_TO_MANAGER"
        ]
      }
      """
      And Admin API - REFUND the claim
      And DB - SELECT "count(*)" FROM "claims.claims_payments" WHERE "claim_id={claim_id} and prepaid_refund_id is not null" is
        | 1 |
      And DB - SELECT "amount" FROM "claims.claims_transactions" WHERE "claim_id={claim_id} and refund_id is not null" is
        | -1000 |
      And DB - Refund amount for primary user in the first room is
        | 10.00 |
      And Mailinator API - primary user has the following email subject at his inbox "Refund applied to your account"
        | a refund in the amount of $10.00 was applied to your payment method on file |
        | and the remaining credit you should receive is $10.00                       |

    Scenario: BH - Pending_admin_consolidation: charge member
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 86                    |
        | age               | 18                    |
        | Member ID         | CLAIM_BH_CHARGE       |
        | keyword           | allegiancebhwithvideo |
        | employee Relation | EMPLOYEE              |
        | state             | HI                    |
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
        | cpt code | 12 |
      And Wait 5 seconds
      And DB - Store claim id for primary user
      And Admin API - SUBMIT the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And Admin API - Verify claim data of primary user and therapist provider
      """json
      {
        "status": "pending_admin_consolidation",
        "adminEvents": [
                "RESUBMIT",
                "WRITE_OFF",
                "CHARGE_MEMBER",
                "VOID",
                "ESCALATE_TO_MANAGER"
        ]
      }
      """
      And Admin API - CHARGE the claim
      And Admin API - Verify claim data of primary user and therapist provider
      """json
      {
        "status": "pending_member_payment"
      }
      """
      And DB - SELECT "count(*)" FROM "claims.claims_payments" WHERE "claim_id={claim_id} and balance_invoice_id is not null and balance_status='draft' and open_member_balance='1000'" is
        | 1 |

    Scenario: BH - Session payment is between 3 and 12 months
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
      And DB - Update messaging session data - Move dates 130 days back for primary user in the first room
      And Wait 5 seconds
      And DB - Store case id for primary user in the first room
      And DB - Store session report id for primary user in the first room
      And DB - Store customer id for primary user
      And DB - Get past time from database last 120 days back as "service_start_date"
      And DB - Get past time from database last 110 days back as "service_end_date"
      And Therapist API - Submit BH messaging session summary notes
        | cpt code | 5 |
      And Wait 5 seconds
      And DB - Store claim id for primary user
      And Admin API - SUBMIT the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And Admin API - Verify claim data of primary user and therapist provider
      """json
      {
        "status": "pending_member_payment"
      }
      """
      And DB - SELECT "concat(balance_status,',',open_member_balance)" FROM "claims.claims_payments" WHERE "claim_id={claim_id} and balance_invoice_id is not null" is
        | open,1000 |
      And Mailinator API - primary user has the following email subject at his inbox "Please pay your outstanding balance"
        | We bill you for the *remaining balance of $10.00*                                                                                                                                                                                                                                                                                                                                                        |
        | If you have questions about your benefits or the amount charged, please contact your insurance company via the information provided on the back of your member ID card. Please note, Talkspace Support does not have access to your individual benefits information and cannot adjust patient responsibility on our end. For answers to these questions, please contact your insurance company directly. |

    Scenario: BH - Session payment was created more than 12 months ago
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
      And DB - Update messaging session data - Move dates 400 days back for primary user in the first room
      And Wait 5 seconds
      And DB - Store case id for primary user in the first room
      And DB - Store session report id for primary user in the first room
      And DB - Store customer id for primary user
      And DB - Get past time from database last 390 days back as "service_start_date"
      And DB - Get past time from database last 380 days back as "service_end_date"
      And Therapist API - Submit BH messaging session summary notes
        | cpt code | 5 |
      And Wait 5 seconds
      And DB - Store claim id for primary user
      And Admin API - SUBMIT the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And Admin API - Verify claim data of primary user and therapist provider
      """json
      {
        "status": "pending_admin_consolidation"
      }
      """

    Scenario: BH - Session payment is between 3 and 12 months, Refund
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28              |
        | age               | 18              |
        | Member ID         | CLAIM_BH_REFUND |
        | keyword           | premerabh       |
        | employee Relation | EMPLOYEE        |
        | state             | HI              |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist provider in the first room for primary user
      And Client API - Start async messaging session for primary user
        | roomIndex  | 0    |
        | isPurchase | true |
      And DB - Update messaging session data - Move dates 130 days back for primary user in the first room
      And Wait 5 seconds
      And DB - Store case id for primary user in the first room
      And DB - Store session report id for primary user in the first room
      And DB - Store customer id for primary user
      And DB - Get past time from database last 120 days back as "service_start_date"
      And DB - Get past time from database last 110 days back as "service_end_date"
      And Therapist API - Submit BH messaging session summary notes
        | cpt code | 5 |
      And Wait 5 seconds
      And DB - Store claim id for primary user
      And Admin API - SUBMIT the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And Admin API - Verify claim data of primary user and therapist provider
      """json
      {
        "status": "completed"
      }
      """
      And DB - SELECT "amount" FROM "claims.claims_transactions" WHERE "claim_id={claim_id} order by id desc" is
        | -1000 |
        | 5000  |
      And DB - SELECT "concat(reason_for_refund,',',refund_amount)" FROM "talkspace_test4.payment_transactions_refunds" WHERE "room_id={room_id_1}" is
        | Negative claim balance consolidation - session,10.00 |
      And DB - SELECT "count(*)" FROM "claims.claims_payments" WHERE "claim_id={claim_id} and prepaid_refund_id is not null and balance_refund_id is null" is
        | 1 |
      And Mailinator API - primary user has the following email subject at his inbox "Refund applied to your account"
        | a refund in the amount of $10.00 was applied to your payment method on file |
        | and the remaining credit you should receive is $10.00                       |

    Scenario: BH - Void claim gets denied
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
      And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
     "status": "denied"
    }
    """
      And Admin API - VOID the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
     "status": "cancelled"
    }
    """

    Scenario: Update BH member data
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
      And DB - Store client insurance information id for primary user
      And Admin API - Update member data for primary user
      """json
 {
        "memberID": "tomcat150",
        "firstName": "auto",
        "lastName": "matic",
        "dateOfBirth": "2005-12-12",
        "gender": "F",
        "country": "US",
        "city": "HOBOKEN",
        "state": "nj",
        "streetAddress": "2881 12TH ST",
        "streetNumber": "11",
        "addressLine2": null,
        "zip": "90211",
        "phoneNumber": "+12025550128",
        "groupNumber": null,
        "authorizationCode": "",
        "planSponsorName": null,
        "eligibilityMechanism": "trizetto",
        "dataSource": "admin",
        "payerID": "47198"
}
      """
      And Admin API - Verify member data by client insurance information id for primary user
            """json
   {
        "memberID": "tomcat150",
        "firstName": "auto",
        "lastName": "matic",
        "dateOfBirth": "2005-12-12",
        "gender": "F",
        "country": "US",
        "city": "HOBOKEN",
        "state": "nj",
        "streetAddress": "2881 12TH ST",
        "streetNumber": "11",
        "addressLine2": null,
        "zip": "90211",
        "phoneNumber": "+12025550128",
        "groupNumber": null,
        "authorizationCode": "",
        "planSponsorName": null,
        "eligibilityMechanism": "trizetto",
        "dataSource": "admin",
        "payerID": "47198"
}
      """

  Rule: BH - Test NPI

    Background:
      Given Therapist API - Login to therapist2 provider

    Scenario: BH - Provider with a test NPI number should not pass clean check
    therapist2 was updated with test NPI number "1111111111" on dev and canary
    update test NPI with the following query: update  therapists set npi_number ='1111111111' where user_id=10801987;
      And Client API - Create THERAPY BH room for primary user with therapist2 provider with visa card
        | flowId            | 28              |
        | age               | 18              |
        | Member ID         | CLAIM_BH_CHARGE |
        | keyword           | premerabh       |
        | employee Relation | EMPLOYEE        |
        | state             | HI              |
      And DB - Verify primary user email
      And Client API - Login to primary user
      And Client API - Switch to therapist2 provider in the first room for primary user
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
        | provider | therapist2 |
        | cpt code | 5          |
      And Wait 5 seconds
      And DB - Store claim id for primary user
      And Admin API - SUBMIT the claim
      And Admin API - Verify claim data of primary user and therapist2 provider
    """json
    {
    "status": "unclean",
    "statusReason": "Provider NPI is missing"
    }
    """
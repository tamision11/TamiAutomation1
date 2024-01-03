@admin
@tmsLink=talktala.testrail.net/index.php?/runs/overview/43
Feature: Claims

  Rule: BH

    Background:
      Given Therapist API - Login to therapist provider
      Given Set primary user last name to Automation

    @tmsLink=talktala.atlassian.net/browse/PLATFORM-3953
    Scenario: BH - Unknown country code
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
      And DB - UPDATE "talkspace_test4.client_insurance_info" SET "country='um'" WHERE "user_id={user_id}"
      And Therapist API - Submit BH messaging session summary notes
        | cpt code | 5 |
      And Wait 5 seconds
      And DB - Store claim id for primary user
      And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
     "status": "pending_submit",
     "statusReason": null
    }
    """

    Scenario: BH - Processed but denied for CO adjustment
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                                |
        | age               | 18                                |
        | Member ID         | CLAIM_BH_DENIED_FOR_CO_ADJUSTMENT |
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
      And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
     "status": "denied",
     "claimSubmitted": {
          "insuranceResolution": "processed"
       },
     "adminEvents": [
        "WRITE_OFF",
        "RESUBMIT",
        "VOID",
        "ESCALATE_TO_MANAGER"
    ]
    }
    """
      And DB - Claim history is
        | created              |
        | pending_submit       |
        | submitted            |
        | received_by_trizetto |
        | accepted_by_trizetto |
        | accepted_by_payer    |

    Scenario: BH - Rejected by Trizetto after accepted by Trizetto
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                                                       |
        | age               | 18                                                       |
        | Member ID         | CLAIM_BH_REJECTED_BY_TRIZETTO_AFTER_ACCEPTED_BY_TRIZETTO |
        | keyword           | premerabh                                                |
        | employee Relation | EMPLOYEE                                                 |
        | state             | HI                                                       |
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
     "status": "rejected",
     "claimSubmitted": {
          "insuranceResolution": "rejected_by_trizetto"
       },
     "adminEvents": [
        "WRITE_OFF",
        "RESUBMIT",
        "ESCALATE_TO_MANAGER"
    ]
    }
    """
      And DB - Claim history is
        | created              |
        | pending_submit       |
        | submitted            |
        | received_by_trizetto |
        | accepted_by_trizetto |

    Scenario: BH - Rejected by payer after accepted by payer
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                                                  |
        | age               | 18                                                  |
        | Member ID         | CLAIM_BH_REJECTED_BY_PAYERS_AFTER_ACCEPTED_BY_PAYER |
        | keyword           | premerabh                                           |
        | employee Relation | EMPLOYEE                                            |
        | state             | HI                                                  |
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
     "status": "rejected",
     "claimSubmitted": {
          "insuranceResolution": "rejected_by_payer"
       },
     "adminEvents": [
        "WRITE_OFF",
        "RESUBMIT",
        "ESCALATE_TO_MANAGER"
    ]
    }
    """
      And DB - Claim history is
        | created              |
        | pending_submit       |
        | submitted            |
        | received_by_trizetto |
        | accepted_by_trizetto |
        | accepted_by_payer    |

    Scenario: BH - Writeoff after denied
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
      And Admin API - WRITE_OFF the claim
      And DB - SELECT "concat(write_off_amount,',',admin_write_off_amount,',', cost_of_service,',',insurance_paid,',',member_prepaid,',',admin_charge_amount,',',allowed_amount)" FROM "claims.claims_payments" WHERE "claim_id={claim_id}" is
        | 1430,8184,13184,0,5000,0,11754 |

    Scenario: BH - Writeoff after refund prepaid invoice by admin
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
      And Wait 5 seconds
      And DB - Store invoice id of 5000 amount
      And Admin API - Refund invoice of primary user in the first room for 50 dollars
      And DB - SELECT "count(*)" FROM "claims.claims_payments" WHERE "claim_id={claim_id} and prepaid_refund_id is not null and balance_refund_id is null and write_off_amount=0 and admin_write_off_amount='5000'" is
        | 1 |
      And DB - SELECT "count(*)" FROM "claims.claims_transactions" WHERE "claim_id={claim_id} and amount='-5000' and status='paid' and charge_id is not null and refund_id is not null" is
        | 1 |
      And DB - SELECT "concat(refund_amount,',',reason_for_refund)" FROM "talkspace_test4.payment_transactions_refunds" WHERE "room_id={room_id_1} and payment_invoice_id is not null and charge_id is not null and payment_transaction_id is not null " is
        | 50.00,Admin charge refund: test reason |
      And Mailinator API - primary user has the following email subject at his inbox "Refund applied to your account"
        | a refund in the amount of $50.00 was applied to your payment method on file. This is a refund related to your copay charge for services received on |
        | and the remaining credit you should receive is $50.00                                                                                               |

    Scenario: BH - Writeoff after refund post session invoice by admin
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
      And Wait 5 seconds
      And DB - Store invoice id of 1000 amount
      And Admin API - Refund invoice of primary user in the first room for 10 dollars
      And DB - SELECT "count(*)" FROM "claims.claims_payments" WHERE "claim_id={claim_id} and balance_charge_id is not null and balance_refund_id is not null and write_off_amount=0 and admin_write_off_amount='1000'" is
        | 1 |
      And DB - SELECT "count(*)" FROM "claims.claims_transactions" WHERE "claim_id={claim_id} and amount='-1000' and status='paid' and charge_id is not null and refund_id is not null" is
        | 1 |
      And DB - SELECT "concat(refund_amount,',',reason_for_refund)" FROM "talkspace_test4.payment_transactions_refunds" WHERE "room_id={room_id_1} and payment_invoice_id is not null and charge_id is not null and payment_transaction_id is not null " is
        | 10.00,Admin charge refund: test reason |
      And Mailinator API - primary user has the following email subject at his inbox "Refund applied to your account"
        | We want to let you know that on                                                                                                                           |
        | a refund in the amount of $10.00 was applied to your payment method on file. This is a refund related to your postSession charge for services received on |
        | and the remaining credit you should receive is $10.00                                                                                                     |

    Scenario: BH - An admin manually charge member for a denied claim
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
      And Admin API - Charge member manually
      And DB - SELECT "concat(balance_status,',',admin_charge_amount)" FROM "claims.claims_payments" WHERE "claim_id={claim_id}" is
        | draft,2499 |
      And Admin API - Verify claim data of primary user and therapist provider
          """json
      {
        "status": "pending_member_payment"
      }
      """
      And Stripe - Pay unpaid invoices for primary user
      And Admin API - Verify claim data of primary user and therapist provider
          """json
      {
        "status": "completed"
      }
      """
      And Mailinator API - primary user has the following email subject at his inbox "FYI we charged your card and here's why"
        | We billed you for the *remaining balance of $24.99* |

    Scenario: BH - Reset claim
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
      And DB - Update client insurance info member id to "tomcat150" for primary user
      And Admin API - RESET the claim
      And Admin API - Verify claim data of primary user and therapist provider
      """json
      {
        "claimData": {
                "memberID": "tomcat150"
        },
        "claimHistory": [
                {
                        "reason": "Claim has been marked as clean"
                },
                {
                        "reason": "Admin has reset the claim"
                },
                {
                        "reason": "Claim has been marked as clean"
                }
        ]
      }
      """

    Scenario: BH - Max member liability
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                            |
        | age               | 18                            |
        | Member ID         | CLAIM_BH_MAX_MEMBER_LIABILITY |
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
      And Admin API - Verify claim data of primary user and therapist provider
      """json
      {
           "status": "failed",
           "statusReason": "Claim member liability amount is too large"
       }
      """
      And DB - SELECT "concat(copay_final,',',customer_balance,',',total_member_liability)" FROM "claims.claims_payments" WHERE "claim_id={claim_id} and balance_charge_id is null and balance_status is null and balance_invoice_id is null" is
        | 50100,45100,50100 |

    Scenario: BH - Void after void
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
      And DB - Store claim id for primary user
      And DB - UPDATE "claims.claims" SET "status='completed'" WHERE "id={claim_id}"
      And Admin API - RESUBMIT the claim
      And Admin API - SUBMIT the claim
      And DB - Claim submission type are
        | VOID     |
        | VOID     |
        | ORIGINAL |
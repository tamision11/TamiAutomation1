@admin
@tmsLink=talktala.testrail.net/index.php?/runs/overview/43
Feature: Claims

  Rule: BH

    Background:
      Given Therapist API - Login to therapist provider
      Given Set primary user last name to Automation

    Scenario: BH - Bad claim in 27c and 27p files
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28           |
        | age               | 18           |
        | Member ID         | BAD_277_FILE |
        | keyword           | premerabh    |
        | employee Relation | EMPLOYEE     |
        | state             | HI           |
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
     "status": "completed"
    }
    """

    Scenario: BH - Invoice payment url
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
      And Stripe - Detach payment method for primary user
      And Admin API - Execute POLL_EDI_FILES cron
      And Stripe - Pay unpaid invoices for primary user
      And Wait 5 seconds
      And DB - Store payment URL
      And Admin API - Verify claim data of primary user and therapist provider
  """json
    {
      "status": "pending_member_payment",
      "claimPayment": {
        "invoicePaymentPageURL": "{payment_url}"
      }
    }
  """
      And Stripe - Open payment link

    Scenario: BH - Refund after resubmit
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
      And Admin API - RESUBMIT the claim
      And Admin API - SUBMIT the claim
      And Admin API - Execute POLL_EDI_FILES cron
      And DB - Claim submission type are
        | CORRECTED |
        | ORIGINAL  |
      And DB - SELECT "amount" FROM "claims.claims_transactions" WHERE "claim_id={claim_id} order by id desc" is
        | -500 |
        | 1000 |
        | 5000 |
      And Admin API - Verify "raw837URL" claim file contains
        | :B:7*Y |
      And Mailinator API - primary user has the following email subject at his inbox "Refund applied to your account"
        | a refund in the amount of $5.00 was applied to your payment method on file |
        | and the remaining credit you should receive is $5.00                       |

    Scenario: BH - Process ERAs for claim that was rejected
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                              |
        | age               | 18                              |
        | Member ID         | MOCK_FOR_PROCESS_AFTER_REJECTED |
        | keyword           | premerabh                       |
        | employee Relation | EMPLOYEE                        |
        | state             | HI                              |
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
     "status": "completed"
    }
    """
      And DB - SELECT "status" FROM "claims.claims_history" WHERE "claim_id={claim_id} order by id asc" is
        | created              |
        | pending_submit       |
        | submitted            |
        | received_by_trizetto |
        | accepted_by_trizetto |
        | rejected             |

    Scenario: BH - Allegiance flow
    sending cigna payer id for allegiance
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 86                    |
        | age               | 18                    |
        | Member ID         | CLAIM_BH_BALANCE_0    |
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
      And Admin API - Verify "raw837URL" claim file contains
        | PI*62308~ |
      And Admin API - Verify claim data of primary user and therapist provider
        """json
            {
              "claimData": {
                "payerID": "81040"
              }
            }
        """

    Scenario: BH - Refund member by ERA re-consolidate
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                               |
        | age               | 18                               |
        | Member ID         | MOCK_MULTI_ERA_SAME_CLAIM_REFUND |
        | keyword           | premerabh                        |
        | employee Relation | EMPLOYEE                         |
        | state             | HI                               |
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
      And DB - Refund amount for primary user in the first room is
        | 10.00 |
      And DB - Claim copay final is
        | 4000 |
        | 6000 |
      And DB - Claim open member balance is
        | 0    |
        | 1000 |
      And DB - Claim balance status is
        |      |
        | void |
      And Admin API - Verify claim data of primary user and therapist provider
    """json
{
        "status": "completed",
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
                        "reason": "The result of pollERAs execution"
                },
                {
                        "reason": "Newer ERA received"
                },
                {
                        "reason": "The result of pollERAs execution"
                }
        ]
}
    """
      And Mailinator API - primary user has the following email subject at his inbox "Refund applied to your account"
        | a refund in the amount of $10.00 was applied to your payment method |
        | and the remaining credit you should receive is $10.00               |

    Scenario: BH - Processing a claim that has been already adjudicated tomcat160
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                               |
        | age               | 18                               |
        | Member ID         | MOCK_MULTI_ERA_SAME_CLAIM_CHARGE |
        | keyword           | premerabh                        |
        | employee Relation | EMPLOYEE                         |
        | state             | HI                               |
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
      And DB - Claim copay final is
        | 8000 |
        | 6000 |
      And DB - Claim open member balance is
        | 3000 |
        | 1000 |
      And DB - Claim balance status is
        | draft |
        | void  |
      And Admin API - Verify claim data of primary user and therapist provider
    """json
{
        "status": "pending_member_payment",
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
                        "reason": "The result of pollERAs execution"
                },
                {
                        "reason": "Newer ERA received"
                },
                {
                        "reason": "The result of pollERAs execution"
                }
        ]
 }
    """
      And Stripe - Pay unpaid invoices for primary user
      And DB - Claim open member balance is
        | 0    |
        | 1000 |
      And DB - Claim balance status is
        | paid |
        | void |
      And DB - SELECT "amount" FROM "claims.claims_transactions" WHERE "claim_id={claim_id} order by id desc" is
        | 3000 |
        | 5000 |
      And Admin API - Verify claim data of primary user and therapist provider
    """json
{
        "status": "completed",
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
                        "reason": "The result of pollERAs execution"
                },
                {
                        "reason": "Newer ERA received"
                },
                {
                        "reason": "The result of pollERAs execution"
                },
                {
                        "reason": "Paid by user"
                }
        ]
}
    """
      And Mailinator API - primary user has the following email subject at his inbox "FYI we charged your card and here's why"
        | We billed you for the *remaining balance of $30.00* |

    Scenario: BH - Processing a claim that has been already adjudicated tomcat161
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                                |
        | age               | 18                                |
        | Member ID         | MOCK_MULTI_ERA_SAME_CLAIM_REFUND2 |
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
      And DB - Refund amount for primary user in the first room is
        | 10.00 |
      And DB - Claim copay final is
        | 4000 |
        | 5000 |
      And DB - Claim open member balance is
        | 0 |
        | 0 |
      And DB - Claim balance status is
        |  |
        |  |
      And DB - SELECT "amount" FROM "claims.claims_transactions" WHERE "claim_id={claim_id} order by id desc" is
        | -1000 |
        | 5000  |
      And Admin API - Verify claim data of primary user and therapist provider
        """json
{
        "status": "completed",
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
                        "reason": "The result of pollERAs execution"
                },
                {
                        "reason": "Newer ERA received"
                },
                {
                        "reason": "The result of pollERAs execution"
                }
        ]
}
    """
      And Mailinator API - primary user has the following email subject at his inbox "Refund applied to your account"
        | a refund in the amount of $10.00 was applied to your payment method on file |
        | and the remaining credit you should receive is $10.00                       |

    Scenario: BH - Processing a claim that has been already adjudicated tomcat162
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                                |
        | age               | 18                                |
        | Member ID         | MOCK_MULTI_ERA_SAME_CLAIM_CHARGE2 |
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
      And DB - Claim copay final is
        | 6000 |
        | 5000 |
      And DB - Claim open member balance is
        | 1000 |
        | 0    |
      And DB - Claim balance status is
        | draft |
        |       |
      And Admin API - Verify claim data of primary user and therapist provider
    """json
{
        "status": "pending_member_payment",
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
                        "reason": "The result of pollERAs execution"
                },
                {
                        "reason": "Newer ERA received"
                },
                {
                        "reason": "The result of pollERAs execution"
                }
        ]
 }
    """
      And Stripe - Pay unpaid invoices for primary user
      And DB - Claim open member balance is
        | 0 |
        | 0 |
      And DB - Claim balance status is
        | paid |
        |      |
      And DB - SELECT "amount" FROM "claims.claims_transactions" WHERE "claim_id={claim_id} order by id desc" is
        | 1000 |
        | 5000 |
      And Admin API - Verify claim data of primary user and therapist provider
    """json
{
        "status": "completed",
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
                        "reason": "The result of pollERAs execution"
                },
                {
                        "reason": "Newer ERA received"
                },
                {
                        "reason": "The result of pollERAs execution"
                },
                {
                        "reason": "Paid by user"
                }
        ]
}
    """
      And Mailinator API - primary user has the following email subject at his inbox "FYI we charged your card and here's why"
        | We billed you for the *remaining balance of $10.00* |

    Scenario: BH - Processing a claim that has been already adjudicated tomcat167
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                               |
        | age               | 18                               |
        | Member ID         | MOCK_MULTI_ERA_SAME_CLAIM_DENIED |
        | keyword           | premerabh                        |
        | employee Relation | EMPLOYEE                         |
        | state             | HI                               |
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
      And DB - SELECT "customer_balance" FROM "claims.claims_payments" WHERE "claim_id={claim_id} order by id desc" is
        | 1000  |
        | -5000 |
        | -5000 |
      And DB - SELECT "total_member_liability" FROM "claims.claims_payments" WHERE "claim_id={claim_id} order by id desc" is
        | 6000 |
        | 0    |
        | 0    |
      And DB - Store the following data
        | column             | table                  | condition                                                                         | resultName |
        | balance_invoice_id | claims.claims_payments | claim_id={claim_id} and balance_invoice_id is not null and balance_status='draft' | invoice_id |
      And Stripe - Invoice status is DRAFT
      And Stripe - Pay unpaid invoices for primary user
      And DB - Claim balance status is
        | paid |
        |      |
        |      |
      And DB - Claim open member balance is
        | 0 |
        | 0 |
        | 0 |
      And DB - SELECT "amount" FROM "claims.claims_transactions" WHERE "claim_id={claim_id} order by id desc" is
        | 1000 |
        | 5000 |
      And Admin API - Verify claim data of primary user and therapist provider
        """json
          {
                "status": "completed",
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
                        "reason": "The result of pollERAs execution"
                },
                {
                        "reason": "Newer ERA received"
                },
                {
                        "reason": "The result of pollERAs execution"
                },
                {
                        "reason": "Newer ERA received"
                },
                {
                        "reason": "The result of pollERAs execution"
                },
                {
                        "reason": "Paid by user"
                }
        ]
}
        """
      And Mailinator API - primary user has the following email subject at his inbox "FYI we charged your card and here's why"
        | We billed you for the *remaining balance of $10.00* |
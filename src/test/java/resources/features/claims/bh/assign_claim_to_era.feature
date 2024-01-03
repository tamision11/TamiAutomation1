@admin
Feature: BH - Assign claim to ERA

  Background:
    Given Therapist API - Login to therapist provider
    Given Set primary user last name to Automation

  Scenario: Denied
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
    And DB - Store era id
    And DB - Store external id
    And Admin API - Assign claim with DENIED adjudication status to ERA
    And DB - SELECT "CONCAT_WS(\", \", allowed_amount, deductible_final, coinsurance_final, copay_final, insurance_paid, total_member_liability)" FROM "claims.claims_payments" WHERE "claim_id={claim_id} order by 1 desc" is
      | 13184, 0, 0, 5000, 8184, 5000            |
      | 12300, 12300, 12300, 12300, 12300, 12300 |

    And Admin API - Verify claim data of primary user and therapist provider
"""json
    {
     "status": "denied",
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
            "reason": "manually created ERA"
        }
      ]
    }
    """

  Scenario: Processed as primary
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
    And DB - Store era id
    And DB - Store external id
    And Admin API - Assign claim with PROCESSED adjudication status to ERA
    And DB - SELECT "CONCAT_WS(\", \", allowed_amount, deductible_final, coinsurance_final, copay_final, insurance_paid, total_member_liability)" FROM "claims.claims_payments" WHERE "claim_id={claim_id} and era_id={era_id} order by 1 desc" is
      | 12300, 12300, 12300, 12300, 12300, 12300 |
      | 11754, 0, 11754, 2500, 0, 0              |
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
            "reason": "manually created ERA"
        }
      ]
    }
    """

  Scenario: Assign manual claim
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
    And DB - Store era id
    And Admin API - Assign manual claim to ERA
    And DB - SELECT "CONCAT_WS(\", \", allowed_amount, deductible, coinsurance, copay, insurance_paid, total_member_liability, date_of_service)" FROM "claims.manual_claims" WHERE "era_id={era_id}" is
      | 12500, 12000, 11000, 5100, 9000, 0, 2023-06-30 00:00:00 |

  Scenario: Reversal failure due to non matching insurance paid and allowed amount
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
    And DB - Store era id
    And DB - Store external id
    And Admin API - Assign claim with REVERSAL adjudication status to ERA
    And DB - SELECT "sum(reversed)" FROM "claims.claims_payments" WHERE "claim_id={claim_id}" is
      | 0 |

  Scenario: Assign claim to ERA
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
    And Wait 5 seconds
    And DB - Store external id
    And Admin API - Assign claim to ERA
    And DB - SELECT "concat (allowed_amount,',',deductible_final,',',coinsurance_final,',',insurance_paid,',',copay_final,',',claim_balance)" FROM "claims.claims_payments" WHERE "claim_id={claim_id} order by 1 desc limit 1" is
      | 20000,19000,15000,11000,9000,-2816 |
    And DB - SELECT "count(*)" FROM "claims.claims_payments" WHERE "claim_id={claim_id}" is
      | 2 |
    And DB - Verify new ERA id on new Payment row
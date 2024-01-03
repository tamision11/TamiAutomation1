@admin
@tmsLink=talktala.testrail.net/index.php?/runs/overview/43
Feature: Claims

  Rule: BH

    Background:
      Given Therapist API - Login to therapist provider
      Given Set primary user last name to Automation

    @tmsLink=talktala.atlassian.net/browse/PLATFORM-3954
    Scenario: BH - Submit claim
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
      And Admin API - Verify claim data of primary user and therapist provider
    """json
      {
         "status": "submitted",
          "statusReason": null,
          "isTest": true,
          "isEscalated": false,
              "claimData": {
              "payerID": "00830",
              "benefitType": "BH",
              "memberID": "tomcat151",
              "memberAuthorizationCode": null,
              "memberFirstName": "test",
              "memberLastName": "Automation",
              "memberGroupNumber": null,
              "memberGender": "Female",
              "memberAddress": "2880 Broadway, New York, NY 10025, US",
              "memberPhoneNumber": "+12025550126",
              "providerNPI": 1234567890,
              "providerFirstName": "Auto",
              "providerLastName": "SwitchPT",
              "serviceCPTCode": "90791",
              "serviceModality": "Text",
              "diagnosisCode": "F0390",
              "diagnosisName": "Unspecified dementia without behavioral disturbance",
              "authCodeEffectiveDate": null,
              "payer": {
                    "id": 2,
                    "gediPayerID": "00830",
                    "payerName": "Blue Cross of Washington/Premera"
                       },
              "payerName": "Blue Cross of Washington/Premera"
              }
      }
      """
      And Admin API - Execute POLL_EDI_FILES cron
      And Stripe - Pay unpaid invoices for primary user
      And Admin API - Verify "raw837URL" claim file contains
        | ISA |
      And Admin API - Verify claim data of primary user and therapist provider
    """json
{
    "status": "completed",
    "statusReason": null,
    "isTest": true,
    "isEscalated": false,
    "claimData": {
        "payerID": "00830",
        "benefitType": "BH",
        "memberID": "tomcat151",
        "memberAuthorizationCode": null,
        "memberFirstName": "test",
        "memberLastName": "Automation",
        "memberGroupNumber": null,
        "memberGender": "Female",
        "memberPhoneNumber": "+12025550126",
        "providerNPI": 1234567890,
        "providerFirstName": "Auto",
        "providerLastName": "SwitchPT",
        "serviceCPTCode": "90791",
        "serviceName": "Premera: First appointment/initial eval",
        "serviceModality": "Text",
        "diagnosisCode": "F0390",
        "diagnosisName": "Unspecified dementia without behavioral disturbance",
        "authCodeEffectiveDate": null,
        "payer": {
            "id": 2,
            "gediPayerID": "00830",
            "payerName": "Blue Cross of Washington/Premera"
        },
        "payerName": "Blue Cross of Washington/Premera"
    },
    "claimPayment": {
        "costOfService": 131.84,
        "currency": "USD",
        "memberPrepaid": 50,
        "prepaidRefundID": null,
        "deductibleEstimated": 30,
        "coinsuranceEstimated": null,
        "copayEstimated": 50,
        "allowedAmount": 131.84,
        "deductibleFinal": 0,
        "coinsuranceFinal": 0,
        "copayFinal": 60,
        "lateFilingFee": 0,
        "otherAdjustments": 0,
        "adjustmentsReason": null,
        "insurancePaid": 71.84,
        "claimBalance": 0,
        "customerBalance": 10,
        "adminChargeAmount": 0,
        "openMemberBalance": 0,
        "writeOffAmount": 0,
        "adminWriteOffAmount": 0,
        "totalMemberLiability": 60,
        "invoicePaymentPageURL": null,
        "balanceStatus": "paid",
        "balanceRefundID": null,
        "cxTicketURL": null,
        "reversed": false,
        "claimAdjustments": [
            {
                "groupCode": "PR",
                "reasonCode": "3",
                "reasonDescription": "Co-payment Amount",
                "amount": 6000
            }
        ],
        "adjustmentSum": 60,
        "adjustments": [
            {
                "description": "PR-3: Co-payment Amount ($60)"
            }
        ]
    },
     "claimSubmitted": {
        "insuranceResolution": "processed",
        "submissionType": "ORIGINAL"
    },
           "adjustments": "PR-3",
     "adminEvents": [
        "RESUBMIT",
        "VOID",
        "ESCALATE_TO_MANAGER"
    ],
    "pastClaimPayments": [],
    "maxChargeAmount": 0
}
      """

    Scenario: BH - Add note to claim
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
      And Admin API - Add note to claim
      And Admin API - Verify note is added to claim

    Scenario: BH - Unclean claim - Member does not have billable diagnosis
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
      And DB - UPDATE "talkspace_test4.customer_information_conditions" SET "condition_id=879" WHERE "user_id={user_id}"
      And DB - UPDATE "talkspace_test4.customer_information_conditions_list" SET "is_billable=0" WHERE "code='F939'"
      And DB - UPDATE "claims.claims_data" SET "diagnosis_code='F939'" WHERE "claim_id={claim_id}"
      And Admin API - RESET the claim
      And Admin API - Verify claim data of primary user and therapist provider
    """json
      {
    "status": "unclean",
    "statusReason": "Member does not have billable diagnosis"
      }
      """
      And DB - UPDATE "talkspace_test4.customer_information_conditions_list" SET "is_billable=1" WHERE "code='F939'"

    Scenario: BH - Assign claim to backoffice admin user
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
      And Admin API - Assign admin to claim
      And Admin API - Verify claim is assigned to backoffice admin user

    Scenario Outline: BH - Adjudication Status codes
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28          |
        | age               | 18          |
        | Member ID         | <Member ID> |
        | keyword           | premerabh   |
        | employee Relation | EMPLOYEE    |
        | state             | HI          |
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
      And Wait 5 seconds
      And DB - Store external id
      And Admin API - Verify ERA file
        | {external_id}*<Code>*131.84* |
      And DB - Insurance resolution is "processed"
      Examples:
        | Member ID               | Code |
        | CLAIM_BH_ADJUDICATION19 | 19   |
        | CLAIM_BH_ADJUDICATION20 | 20   |
        | CLAIM_BH_ADJUDICATION21 | 21   |

    Scenario: BH - 0 balance claim
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
      And Admin API - Verify claim data of primary user and therapist provider
    """json
    {
     "status": "completed"
    }
    """
      And DB - Claim history is
        | created              |
        | pending_submit       |
        | submitted            |
        | received_by_trizetto |
        | accepted_by_trizetto |
        | accepted_by_payer    |

    Scenario: BH - Denied claim
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
     "status": "denied",
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

    Scenario: BH - Claim rejected by Trizetto
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
        | created        |
        | pending_submit |
        | submitted      |

    Scenario: BH - Claim rejected by payer
      And Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28                         |
        | age               | 18                         |
        | Member ID         | CLAIM_BH_REJECTED_BY_PAYER |
        | keyword           | premerabh                  |
        | employee Relation | EMPLOYEE                   |
        | state             | HI                         |
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

    Scenario: BH - Update session info
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
      And Wait 5 seconds
      And Admin API - Update claim session information
      """json
        {
            "propertyName": "serviceStartDate",
            "newValue": "2023-05-20",
            "notes": "update session start date"
        }
      """
      And Admin API - Update claim session information
      """json
        {
            "propertyName": "serviceCPTCode",
            "newValue": "90834",
            "notes": "update CPT"
        }
      """
      And Admin API - Update claim session information
      """json
        {
            "propertyName": "serviceModality",
            "newValue": "Video",
            "notes": "update session modality"
        }
      """
      And Admin API - Update claim session information
      """json
        {
            "propertyName": "payerID",
            "newValue": "25463",
            "notes": "update payer id"
        }
      """
      And Admin API - Verify claim data of primary user and therapist provider
    """json
   {
  "claimDataOverwrites": [
    {
      "propertyName": "serviceStartDate",
      "newValue": "2023-05-20",
      "notes": "update session start date"
    },
    {
      "propertyName": "serviceCPTCode",
      "newValue": "90834",
      "notes": "update CPT"
    },
    {
      "propertyName": "serviceName",
      "newValue": "Premera: Ongoing after first week",
      "notes": "update CPT"
    },
    {
      "propertyName": "serviceModality",
      "oldValue": "Text",
      "newValue": "Video",
      "notes": "update session modality"
    },
    {
      "propertyName": "payerID",
      "newValue": "25463",
      "notes": "update payer id"
    }
  ]
}
    """
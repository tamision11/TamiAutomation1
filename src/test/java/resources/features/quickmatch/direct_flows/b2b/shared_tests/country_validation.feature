@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2980
Feature: QM - B2B - Country validation

  Rule: BH

    Scenario Outline: Automatic BH - Canada
      Given Navigate to <flowId>
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_25 |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | STUDENT  |
        | address           | CANADA   |
        | phone number      |          |
      And Click on next button to approve you are ready to begin
      Examples:
        | flowId  |
        | flow28  |
        | flow32  |
        | flow59  |
        | flow70  |
        | flow84  |
        | flow86  |
        | flow91  |
        | flow92  |
        | flow94  |
        | flow105 |
        | flow110 |
        | flow112 |
        | flow115 |
        | flow117 |
        | flow120 |
        | flow121 |
        | flow124 |
        | flow126 |

    Scenario Outline: Manual BH - Canada
      Given Navigate to <flowId>
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_25 |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | STUDENT  |
        | address           | CANADA   |
        | phone number      |          |
      And Click on Let's start button
      Examples:
        | flowId  |
        | flow24  |
        | flow25  |
        | flow43  |
        | flow60  |
        | flow71  |
        | flow85  |
        | flow93  |
        | flow95  |
        | flow96  |
        | flow104 |
        | flow111 |
        | flow113 |
        | flow116 |
        | flow118 |
        | flow119 |
        | flow122 |
        | flow125 |
        | flow127 |

    @visual
    Scenario: BH - Carelon (flow 113) - Ineligible country
    only Canada and US +territories should pass eligibility for this flow
      Given Navigate to flow113
      When Complete shared validation form for primary user
        | age               | 18             |
        | Member ID         | COPAY_25       |
        | service type      | THERAPY        |
        | Email             | PRIMARY        |
        | employee Relation | STUDENT        |
        | address           | UNITED_KINGDOM |
        | phone number      |                |
      Then Shoot baseline

  Rule: EAP

    Scenario: EAP - Humana (flow 19) - Canada
      Given Navigate to flow19
      When Complete shared validation form for primary user
        | age               | 18                                  |
        | organization      | humana                              |
        | service type      | THERAPY                             |
        | Email             | PRIMARY                             |
        | employee Relation | ADULT_DEPENDENT_MEMBER_OF_HOUSEHOLD |
        | address           | CANADA                              |
        | phone number      |                                     |
      And Click on Let's start button

    Scenario: EAP - Aetna (flow 44) - US territory
      Given Navigate to flow44
      When Complete shared validation form for primary user
        | age               | 18             |
        | organization      | aetna          |
        | service type      | THERAPY        |
        | Email             | PRIMARY        |
        | employee Relation | EMPLOYEE       |
        | address           | AMERICAN_SAMOA |
        | phone number      |                |
      Then Click on Let's start button

    @visual
    Scenario: EAP - Aetna (flow 44) - Ineligible country
    only US +territories should pass eligibility for this flow
      Given Navigate to flow44
      When Complete shared validation form for primary user
        | age               | 18       |
        | organization      | aetna    |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | address           | CANADA   |
        | phone number      |          |
      Then Shoot baseline

    Scenario: EAP - Optum (flow 62) - Canada
      Given Navigate to flow62
      When Complete optum eap validation form for primary user
        | age                           | 18          |
        | authorization code            | MOCK_OPTUM  |
        | session number                | 12+         |
        | service type                  | THERAPY     |
        | Email                         | PRIMARY     |
        | employee Relation             | EMPLOYEE    |
        | address                       | CANADA      |
        | phone number                  |             |
        | authorization code expiration | future date |
      And Click on Let's start button

    Scenario: EAP - Cigna (flow 78) - Canada
      Given Navigate to flow78
      When Complete cigna eap validation form for primary user
        | age                           | 18          |
        | authorization code            | MOCK_CIGNA  |
        | session number                | 3           |
        | service type                  | THERAPY     |
        | Email                         | PRIMARY     |
        | employee Relation             | EMPLOYEE    |
        | address                       | CANADA      |
        | phone number                  |             |
        | authorization code expiration | future date |
      And Click on Let's start button

    Scenario: EAP - KGA (flow 89) - Canada
      Given Navigate to flow89
      When Complete kga eap validation form for primary user
        | authorization code | MOCK_KGA |
        | age                | 18       |
        | organization       | kga      |
        | service type       | THERAPY  |
        | Email              | PRIMARY  |
        | employee Relation  | EMPLOYEE |
        | address            | CANADA   |
        | phone number       |          |
      And Click on Let's start button

    Scenario: EAP - Carelon (flow 98) - Canada
      Given Navigate to flow98
      When Complete carelon eap validation form for primary user
        | age               | 18       |
        | organization      | carelon  |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | address           | CANADA   |
        | phone number      |          |
      And Click on Let's start button

    @visual
    Scenario: EAP - Carelon (flow 98) - Ineligible country
    only Canada and US +territories should pass eligibility for this flow
      Given Navigate to flow98
      When Complete carelon eap validation form for primary user
        | age               | 18             |
        | organization      | carelon        |
        | service type      | THERAPY        |
        | Email             | PRIMARY        |
        | employee Relation | EMPLOYEE       |
        | address           | UNITED_KINGDOM |
        | phone number      |                |
      Then Shoot baseline
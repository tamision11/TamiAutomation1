@tmsLink=talktala.atlassian.net/browse/NYC-7533
Feature: QM - B2B - Age Validation
  flow #44 now allows 13+

  Scenario Outline: Direct flow - Therapy - Under minimum age
    Given Navigate to <flow>
    When Unified eligibility page - Enter age of <age> years old
    And Unified eligibility page - Click on continue button
    Then Unified eligibility page - Error Verification - Check for under <age> error message
    Examples:
      | flow    | age |
      #EAP/DTE flows (support 18+)
      | flow9   | 15  |
      | flow11  | 16  |
      | flow19  | 16  |
      | flow24  | 16  |
      | flow82  | 16  |
      #EAP/DTE flows (support 13+)
      | flow41  | 12  |
      | flow44  | 12  |
      | flow62  | 12  |
      | flow78  | 12  |
      | flow89  | 12  |
      | flow98  | 12  |
      #BH flows (support 13+)
      | flow25  | 12  |
      | flow28  | 12  |
      | flow32  | 12  |
      | flow59  | 12  |
      | flow60  | 12  |
      | flow70  | 12  |
      | flow71  | 12  |
      | flow84  | 12  |
      | flow85  | 12  |
      | flow86  | 12  |
      | flow91  | 12  |
      | flow92  | 12  |
      | flow93  | 12  |
      | flow94  | 12  |
      | flow95  | 12  |
      | flow96  | 12  |
      | flow105 | 12  |
      | flow110 | 12  |
      | flow111 | 12  |
      | flow112 | 12  |
      | flow113 | 12  |
      | flow115 | 12  |
      | flow116 | 12  |
      | flow117 | 12  |
      | flow118 | 12  |
      | flow121 | 12  |
      | flow122 | 12  |
      | flow124 | 12  |
      | flow125 | 12  |
      | flow126 | 12  |
      | flow127 | 12  |
      | flow131 | 12  |
      | flow134 | 12  |
      | flow135 | 12  |
      | flow137 | 12  |

  Scenario Outline: Direct flow - Psychiatry - Under minimum age
    Given Navigate to <flow>
    When Unified eligibility page - Enter age of <age> years old
    And Unified eligibility page - Select PSYCHIATRY service
    And Unified eligibility page - Click on continue button
    Then Unified eligibility page - Psychiatry under age message is displayed
    Examples:
      | flow    | age |
      | flow25  | 17  |
      | flow28  | 17  |
      | flow32  | 17  |
      | flow59  | 17  |
      | flow60  | 17  |
      | flow70  | 17  |
      | flow71  | 17  |
      | flow84  | 17  |
      | flow85  | 17  |
      | flow86  | 17  |
      | flow91  | 17  |
      | flow92  | 17  |
      | flow93  | 17  |
      | flow94  | 17  |
      | flow95  | 17  |
      | flow96  | 17  |
      | flow105 | 17  |
      | flow110 | 17  |
      | flow111 | 17  |
      | flow112 | 17  |
      | flow113 | 17  |
      | flow115 | 17  |
      | flow116 | 17  |
      | flow117 | 17  |
      | flow118 | 17  |
      | flow121 | 17  |
      | flow122 | 17  |
      | flow124 | 17  |
      | flow125 | 17  |
      | flow126 | 17  |
      | flow127 | 17  |
      | flow131 | 17  |
      | flow134 | 17  |
      | flow135 | 17  |
      | flow137 | 17  |

  Scenario: Direct flow - Under minimum age - Help resource redirect
  scenario was written due to linked bug
    Given Navigate to flow11
    When Unified eligibility page - Enter age of 16 years old
    And Unified eligibility page - Click on continue button
    Then Unified eligibility page - Click on the help resource
    And Switch focus to the second tab
    Then Current url should contain "https://helpnow.talkspace.com/under-18"

  @visual
  Scenario Outline: Direct flow - Invalid age
    Given Navigate to <flow>
    When Unified eligibility page - Enter age of <age> years old
    And Unified eligibility page - Click on continue button
    Then Shoot baseline "QM - B2B - Age Restriction - <flow> - invalid age" and ignore
      | date of birth input |
    Examples:
      | flow   | age |
      | flow25 | 200 |
      | flow32 | 600 |
      | flow59 | 150 |
      | flow60 | 150 |
Feature: QM - B2B - Validate Page

  @visual
  Scenario Outline: Validation form - error validation
    Given Navigate to <flow>
    And Unified eligibility page - Click on continue button
    Then Shoot baseline "<baseLineName>"
    Examples:
      | flow    | baseLineName                          |
      | flow19  | QM - B2B - flow11 - error validation  |
      | flow19  | QM - B2B - flow19 - error validation  |
      | flow24  | QM - B2B - flow24 - error validation  |
      | flow25  | QM - B2B - flow25 - error validation  |
      | flow28  | QM - B2B - flow28 - error validation  |
      | flow32  | QM - B2B - flow32 - error validation  |
      | flow43  | QM - B2B - flow43 - error validation  |
      | flow44  | QM - B2B - flow44 - error validation  |
      | flow59  | QM - B2B - flow59 - error validation  |
      | flow60  | QM - B2B - flow60 - error validation  |
      | flow60  | QM - B2B - flow62 - error validation  |
      | flow70  | QM - B2B - flow70 - error validation  |
      | flow71  | QM - B2B - flow71 - error validation  |
      | flow76  | QM - B2B - flow76 - error validation  |
      | flow78  | QM - B2B - flow78 - error validation  |
      | flow82  | QM - B2B - flow82 - error validation  |
      | flow84  | QM - B2B - flow84 - error validation  |
      | flow85  | QM - B2B - flow85 - error validation  |
      | flow86  | QM - B2B - flow86 - error validation  |
      | flow89  | QM - B2B - flow89 - error validation  |
      | flow91  | QM - B2B - flow91 - error validation  |
      | flow92  | QM - B2B - flow92 - error validation  |
      | flow93  | QM - B2B - flow93 - error validation  |
      | flow94  | QM - B2B - flow94 - error validation  |
      | flow95  | QM - B2B - flow95 - error validation  |
      | flow96  | QM - B2B - flow96 - error validation  |
      | flow111 | QM - B2B - flow111 - error validation |
      | flow112 | QM - B2B - flow112 - error validation |
      | flow113 | QM - B2B - flow113 - error validation |
      | flow115 | QM - B2B - flow115 - error validation |
      | flow128 | QM - B2B - flow128 - error validation |

  @tmsLink=talktala.atlassian.net/browse/CVR-248
  Scenario Outline: Skip to flow 90
    Given Navigate to <flow>
    When Click on Continue without insurance button
    Then Current url should contain "flow/90/"
    Examples:
      | flow   |
      | flow19 |
      | flow28 |

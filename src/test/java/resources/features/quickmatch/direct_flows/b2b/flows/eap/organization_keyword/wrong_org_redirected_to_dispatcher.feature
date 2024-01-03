@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2766
Feature: QM - B2B - EAP
  Leads to flow 2

  Background:
    Given Navigate to flow98

    When Complete carelon eap validation form for primary user
      | age               | 18       |
      | organization      | humana   |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | state             | MT       |
      | phone number      |          |

  Scenario: Flow 98 - Carelon - Wrong organization - Flow 90 redirect
    And Unified eligibility page - Click on OK button
    Then Current url should contain "flow/90/step/1"

  @visual
  Scenario: Flow 98 - Carelon - Wrong organization - Visual regression
    Then Shoot dialog element as "QM - B2B - Flow 98 - Carelon - Wrong organization modal" baseline

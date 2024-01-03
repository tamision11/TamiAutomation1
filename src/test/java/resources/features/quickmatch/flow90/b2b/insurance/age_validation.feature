@owner=nir_tal
@tmslink=talktala.atlassian.net/browse/AUTOMATION-3004
Feature: QM - B2B - Age Validation

  Background:
    Given Navigate to flow90
    When Select THERAPY service
    And Select to pay through insurance provider

  Scenario Outline: Therapy - BH - Upfront coverage - Under minimum age validation
    And Continue with "<insurance provider>" insurance provider
    And Complete upfront coverage verification validation form for primary user
      | age       | 12      |
      | state     | MT      |
      | Member ID | COPAY_0 |
    And Upfront coverage - under age message is displayed
    Examples:
      | insurance provider |
      | Premera            |
      | Anthem             |
@tmsLink=talktala.atlassian.net/wiki/spaces/PROD/pages/2495905838/SMB+V1
Feature: SMB

  Background:
    Given Navigate to smb

  @visual
  Scenario: General Visual regression
    Then Shoot baseline "SMB - Get started"
    Given SMB - Partner enter first name
    And SMB - Partner enter last name
    And SMB - Partner enter primary email
    And SMB - Partner enter 80 people on organization
    And SMB - Partner clicks on view plans button
    Then Shoot baseline "SMB - Plan selection page"
    And SMB - Partner open plans dropdown
    Then Shoot baseline "SMB - Plan selection page - Open dropdown"

  @visual
  Scenario: View pricing details popup
    Given SMB - Partner enter first name
    And SMB - Partner enter last name
    And SMB - Partner enter primary email
    And SMB - Partner enter 80 people on organization
    And SMB - Partner clicks on view plans button
    And SMB - Partner clicks on View pricing details button
    Then Shoot baseline

  @visual
  Scenario: General Visual regression
    Given SMB - Partner enter first name
    And SMB - Partner enter last name
    And SMB - Partner enter primary email
    And SMB - Partner enter 80 people on organization
    And SMB - Partner clicks on view plans button
    And SMB - Partner clicks on select plan button
    Then Shoot baseline "SMB - Organization details"
    And SMB - Partner enter organization name
    And SMB - Partner confirm 80 people in the organization
    And SMB - Partner select "Employee Health & Wellness" from Roles dropdown
    And SMB - Partner select "Business services" from Industry dropdown
    And SMB - Partner checks the confirmation checkbox
    And SMB - Partner clicks on Continue button
    Then Shoot baseline "SMB - Review details"
    And SMB - Partner clicks on Continue to checkout button
    And SMB - Insert visa card
    Then Shoot baseline "SMB - Checkout page"
    And SMB - Partner clicks on complete purchase button
    Then Shoot baseline "SMB - Confirmation page"

  @visual
  Scenario Outline: PEPM calculation
    Given SMB - Partner enter first name
    And SMB - Partner enter last name
    And SMB - Partner enter primary email
    And SMB - Partner enter <organization size> people on organization
    And SMB - Partner clicks on view plans button
    And SMB - Select from list the option "<plan>"
    Then Shoot baseline "SMB - Select organization size: <organization size> and plan name: <plan>"
    Examples:
      | organization size | plan                              |
      | 30                | 2 monthly Live Sessions (30min)   |
      | 30                | 1 monthly Live Session (30min)    |
      | 30                | Messaging only (no Live Sessions) |
      | 80                | 2 monthly Live Sessions (30min)   |
      | 80                | 1 monthly Live Session (30min)    |
      | 80                | Messaging only (no Live Sessions) |

  Rule: Error handling

    @visual
    Scenario: Error handling
      Given SMB - Partner clicks on view plans button
      Then Shoot baseline "SMB - Get started error messages"
      Given SMB - Partner enter first name
      And SMB - Partner enter last name
      And SMB - Partner enter primary email
      And SMB - Partner enter 75 people on organization
      And SMB - Partner clicks on view plans button
      And SMB - Partner clicks on select plan button
      And SMB - Partner clear number of people on organization
      And SMB - Partner clicks on Continue button
      Then Shoot baseline "SMB - Organization details errors"

  Rule: Organization with more then 50 people below 100

    @smoke
    Scenario: 75 people organization registration with user redemption
    registering organization and user fill details on smb landing page (redemption)
      Given SMB - Partner enter first name
      And SMB - Partner enter last name
      And SMB - Partner enter primary email
      And SMB - Partner enter 75 people on organization
      And SMB - Partner clicks on view plans button
      And SMB - Partner clicks on View pricing details button
      And SMB - Partner close pricing details popup
      And SMB - Select from list the option "Messaging only (no Live Sessions)"
      And SMB - Partner clicks on select plan button
      And SMB - Partner enter organization name
      And SMB - Partner confirm 75 people in the organization
      And SMB - Partner select "Employee Health & Wellness" from Roles dropdown
      And SMB - Partner select "Business services" from Industry dropdown
      And SMB - Partner checks the confirmation checkbox
      And SMB - Partner clicks on Continue button
      And SMB - Partner clicks on Continue to checkout button
      And SMB - Insert visa card
      And SMB - Partner clicks on complete purchase button
      And SMB - Partner clicks on copy Keyword button
      And SMB - Partner clicks on this page button
      Then Switch focus to the second tab
      And SMB - User landing page - enter primary email
      And SMB - User landing page - enter keyword
      And SMB - User landing page - clicks on get started button
      And Current url should contain "flow/138/"

  Rule: Organization with less than 25 people

    Scenario: Homepage redirect - Organization with less than 25 people
      Given SMB - Partner enter first name
      And SMB - Partner enter last name
      And SMB - Partner enter primary email
      And SMB - Partner enter 24 people on organization
      And SMB - Partner clicks on view plans button
      And SMB - Partner clicks on visit our homepage button
      Then Switch focus to the second tab
      And Current url should match home page without ld parameters url

    @visual
    Scenario: Homepage redirect - Organization with 24 people
      Given SMB - Partner enter first name
      And SMB - Partner enter last name
      And SMB - Partner enter primary email
      And SMB - Partner enter 24 people on organization
      And SMB - Partner clicks on view plans button
      Then Shoot baseline

    @visual
    Scenario: Organization details - Minimum 25 people error
      Given SMB - Partner enter first name
      And SMB - Partner enter last name
      And SMB - Partner enter primary email
      And SMB - Partner enter 100 people on organization
      And SMB - Partner clicks on view plans button
      And SMB - Partner clicks on select plan button
      And SMB - Partner enter organization name
      And SMB - Partner clear number of people on organization
      And SMB - Partner confirm 24 people in the organization
      And SMB - Partner checks the confirmation checkbox
      And SMB - Partner clicks on Continue button
      Then Shoot baseline

  Rule: Organization with more than 100 people

    Scenario: Demo page redirect - Organization with more than 101 people
      Given SMB - Partner enter first name
      And SMB - Partner enter last name
      And SMB - Partner enter primary email
      And SMB - Partner enter 101 people on organization
      And SMB - Partner clicks on view plans button
      And SMB - Partner clicks on request demo
      Then Switch focus to the second tab
      And Current url should match demo page url

    @visual
    Scenario: Demo page redirect - Organization with 101 people
      Given SMB - Partner enter first name
      And SMB - Partner enter last name
      And SMB - Partner enter primary email
      And SMB - Partner enter 101 people on organization
      And SMB - Partner clicks on view plans button
      Then Shoot baseline

    @visual
    Scenario: Organization details - Maximum 100 people error
      Given SMB - Partner enter first name
      And SMB - Partner enter last name
      And SMB - Partner enter primary email
      And SMB - Partner enter 100 people on organization
      And SMB - Partner clicks on view plans button
      And SMB - Partner clicks on select plan button
      And SMB - Partner enter organization name
      And SMB - Partner clear number of people on organization
      And SMB - Partner confirm 101 people in the organization
      And SMB - Partner checks the confirmation checkbox
      And SMB - Partner clicks on Continue button
      Then Shoot baseline
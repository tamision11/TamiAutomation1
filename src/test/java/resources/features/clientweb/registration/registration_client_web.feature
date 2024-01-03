@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2660
Feature: Client web - Registration

  @smoke @sanity
  Scenario Outline: Registration from client-web - Entrypoint exists end returns 200 status code
    Given Navigate to <url>
    And Wait 10 seconds
    And Client Web - Entrypoint response is 200
    Examples:
      | url                |
      | client-web         |
      | client-web sign up |
      | therapist slug     |
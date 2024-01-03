@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2866
Feature: Client web - Chat

  Background:
    And Therapist API - Login to therapist provider
    Given Navigate to client-web
    And Log in with inPlatformMatching user and
      | remember me   | false |
      | 2fa activated | false |
      | skip 2fa      | true  |

  Scenario: New message notification
    And Client API - Get rooms info of inPlatformMatching user
    And Wait 15 seconds
    And Scroll to the top of the chat
    And Therapist API - Send 1 VALID_RANDOM message as therapist provider to inPlatformMatching user in the first room
    And Click on new message button
    Then Message is available in the chat
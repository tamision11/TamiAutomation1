Feature: Client web - Chat

  Background:
    Given Navigate to client-web
    And Log in with starring user and
      | remember me   | false |
      | 2fa activated | true  |
    Then Room is available

  @visual
  Scenario: Chat - Empty Starred messages page
    Given Client API - Unstar all user messages of starring user
    And Wait until a message is available
    When Open account menu
    And Account Menu - Select starred messages
    Then Shoot Starred messages panel element as "Client Web - Chat - Empty Starred messages page" baseline

  Scenario: Star all messages in chat
  First time to verify all messages are starred on the front-end once the stars are clicked.
  The second time, after reloading the page, is to verify the server response also shows the messages as starred
    Given Client API - Unstar all user messages of starring user
    And Refresh the page
    And Wait until a message is available
    When Star all messages
    Then All messages are starred
    When Refresh the page
    And Wait until a message is available
    Then All messages are starred

  Scenario: Unstar all messages in chat
  First time to verify all messages are unstarred on the front-end once the stars are clicked.
  The second time, after reloading the page, is to verify the server response also shows the messages as unstarred
    Given Client API - Star all room messages of starring user in the first room
    And Wait 10 seconds
    And Refresh the page
    And Wait 10 seconds
    When Unstar all messages
    Then All messages are unstarred
    When Refresh the page
    And Wait until a message is available
    Then All messages are unstarred

  @visual
  Scenario: Chat - Starred messages - Visual regression
    Given Client API - Star all room messages of starring user in the first room
    And Wait until a message is available
    When Open account menu
    And Account Menu - Select starred messages
    Then Shoot baseline "Client Web - Chat - Starred messages appear on Starred messages page"
    When Starred Messages - Click on the edit button
    Then All messages are starred
    When Unstar all messages
    Then All messages are unstarred
    When Starred Messages - Click on the done button
    Then Shoot baseline "Client Web - Chat - Unstar all messages on Starred messages page"
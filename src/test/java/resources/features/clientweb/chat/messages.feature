Feature: Client web - Chat

  Background:
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Dismiss modal

  Rule: Member sends messages

    Scenario: Member sends text message - Message too long error
      And Send the following message
        | TOO_LONG |
      Then Message too long error is available

    Scenario: Message in chat
      And Send the following messages and verify they are present in chat
        | MAXIMUM             |
        | LINE_BREAK          |
        | COPY_PASTED_MESSAGE |
        | SPECIAL_CHARACTER   |

    @smoke @sanity
    Scenario: Member sends text message - Edit text before sending
      And Insert VALID_RANDOM text message
      And Clear message box
      And Insert VALID_RANDOM text message
      And Click on send
      Then Message is available in the chat

    @visual
    Scenario: Chat - Member sends text message - Simple message
      And Insert SPECIAL_CHARACTER text message
      And Click on send
      And Wait 5 seconds
      And Message is available in the chat
      Then Shoot baseline

    Scenario: Member sends text message - URL
    returning to the first tab to get the access token
      And Send the following messages and verify they are present in chat
        | URL |
      And Access url in last message
      And Switch focus to the second tab
      And Verify the accessed URL

    Scenario: Member sends PDF file
      And Upload PDF
      And Click on send
      Then PDF message is in the chat

    @issue=talktala.atlassian.net/browse/MEMBER-2947
    Scenario: Member sends text message - Sending a message using CTRL+ENTER
      And Insert VALID_RANDOM text message
      And Press keys
        | CTRL  |
        | ENTER |
      Then Message is available in the chat

  Rule: Customer sends audio messages

    Background:
      When Start audio record

    Scenario: Member sends audio message
      And Wait 10 seconds
      When Stop audio record after 10 seconds
      And Wait 4 seconds
      And Click on send
      And Wait 10 seconds
      And Recorded message is available in input

    @visual
    Scenario: Chat - Member sends audio Message - Audio message in chat
      When Stop audio record after 10 seconds
      And Wait 4 seconds
      And Click on send
      And Wait 10 seconds
      And Recorded message is available in input
      Then Shoot baseline

    Scenario: Member sends audio Message - Delete unsent message
      When Stop audio record after 10 seconds
      And Wait 4 seconds
      And Delete recorded message
      Then Send button should not be available

    Scenario: Member sends audio Message - Verify unsent message component
      When Stop audio record after 3 seconds
      And Wait 10 seconds
      When Play recorded message
      And Wait 1 seconds
      When Pause recorded message
      Then Play button for recorded message is available

    @smoke @sanity
    Scenario: Member sends audio Message - Sent message components
      When Stop audio record after 7 seconds
      When Click on send
      Then Audio message is in the chat
      When Play the audio message from chat
      And Wait 2 seconds
      When Pause the audio message from chat
      Then Play button is available for audio message from chat

  Rule: Provider sends messages

    Background:
      And Therapist API - Login to therapist provider

    @smoke @sanity
    Scenario: Message From provider - Message in chat
      And Send the following messages as therapist provider to primary user in the first room and verify they are present in chat
        | VALID_RANDOM      |
        | SPECIAL_CHARACTER |

    Scenario: Message From provider - URL
    returning to the first tab to get the access token
      And Therapist API - Send 1 URL message as therapist provider to primary user in the first room
      Then Message is available in the chat
      When Access url in last message
      And Switch focus to the second tab
      Then Verify the accessed URL
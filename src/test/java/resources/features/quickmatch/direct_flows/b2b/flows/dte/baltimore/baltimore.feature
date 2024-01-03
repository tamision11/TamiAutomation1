@owner=tami_sion
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-3096
Feature: QM - B2B - DTE

  Rule: Start from TSG branching screen

    Background:
      Given Navigate to talkspace go
      And Talkslace Go - Click on Learn the fundamentals first

    Scenario: Talkspace Go - Baltimore - Not eligible for voucher
      And Talkslace Go - Complete validation form for primary user
        | age     | 18  |
        | address | NYC |
      And Talkslace Go - Click on I was given a keyword
      And Talkslace Go - Enter "test" as keyword
      And Talkslace Go - Click on Continue
      And Talkslace Go - Invalid keyword message is displayed


    @issue=talktala.atlassian.net/browse/MEMBER-3075
    @issue=talktala.atlassian.net/browse/TSG-349
    @sanity
    Scenario: Talkspace Go - Baltimore - Eligible for voucher
      And Talkslace Go - Complete validation form for primary user
        | age     | 18  |
        | address | NYC |
      And Talkslace Go - Click on I was given a keyword
      And Talkslace Go - Enter "bcps" as keyword
      And Talkslace Go - Click on Continue
      And Talkslace Go - Click on Continue
      And Talkslace Go - Create account
        | password | STRONG  |
        | Email    | PRIMARY |
      And Talkslace Go - Click on Continue
      And Talkslace Go - Complete the matching questions
      And Current url should contain "talkspace.com/quiz/results"


  Rule: Start from Baltimore landing page

    Background:
      Given Navigate to Baltimore landing page

    @issue=talktala.atlassian.net/browse/TSG-349
    @sanity
    Scenario: Baltimore landing page - Eligible for voucher
      And Landing page Baltimore - Click getting started after entering primary user email and keyword bcps
      And Talkslace Go - Click on Continue
      And Talkslace Go - Create account
        | password | STRONG  |
        | Email    | PRIMARY |
      And Talkslace Go - Click on Continue
      And Talkslace Go - Enter "teen" date of birth
      And Talkslace Go - Click on Continue
      And Talkslace Go - Complete the matching questions
      And Current url should contain "talkspace.com/quiz/results"
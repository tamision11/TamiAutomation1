Feature: QM - Flow 90

  Background:
    Given Navigate to flow90

  @tmsLink=talktala.atlassian.net/browse/CVR-539
  @tmsLink=talktala.atlassian.net/browse/CVR-714
  @tmsLink=talktala.atlassian.net/browse/HPE-1918
  @tmslink=https://pinetools.com/add-text-each-line
  @tmslink=https://alphabetizer.flap.tv/
  Scenario: Insurance payers verification
    Then Client API - Verify insurance payers for primary user has over 1000 payers
    Then Revoke access token for primary user

  Rule: Starting pages

    @visual
    Scenario: Flow90 - Visual regression
      Then Shoot baseline "QM - Flow90 - Service type selection page"

  Rule: Online Therapy - flow 66

    Background:
      And Select THERAPY service

    @visual
    Scenario: Therapy - How would you like to pay page - flow 66
      Then Shoot baseline

  Rule: Couples therapy - Flow 67

    Background:
      And Select COUPLES_THERAPY service
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider - multi select | Decide whether we should separate |
        | looking for a provider that will                                  | Teach new skills                  |
        | have you been to a provider before                                | Yes                               |
        | live with your partner                                            | Yes                               |
        | type of relationship                                              | Straight                          |
        | domestic violence                                                 | No                                |
        | ready                                                             | We're ready now                   |
        | your gender                                                       | Female                            |
        | provider gender                                                   | Male                              |
        | age                                                               | 18                                |
        | state                                                             | MT                                |

    @visual
    Scenario: Couples therapy - How would you like to pay page - flow 67
      Then Shoot baseline

  Rule: Psychiatry - flow 68

    Background:
      And Select PSYCHIATRY service
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider       | Anxiety |
        | prescribed medication to treat a mental health condition | Yes     |
        | your gender                                              | Female  |
        | provider gender                                          | Male    |
        | age                                                      | 18      |
        | state                                                    | NY      |

    @visual
    Scenario: Psychiatry - How would you like to pay page - flow 68
      Then Shoot baseline
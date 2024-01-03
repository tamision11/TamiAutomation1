@visual
Feature: QM - B2C - Shared - Age Restriction

  Scenario Outline: Shared - Age Restriction - under 13
    Given Navigate to <flow>
    When Click on continue
    And Click on continue
    And Complete the assessment questions with the following options
      | Little interest or pleasure in doing things                                                                                                                              | Not at all |
      | Feeling down, depressed, or hopeless                                                                                                                                     | Not at all |
      | Trouble falling or staying asleep, or sleeping too much                                                                                                                  | Not at all |
      | Feeling tired or having little energy                                                                                                                                    | Not at all |
      | Poor appetite or overeating                                                                                                                                              | Not at all |
      | Feeling bad about yourself - or that you are a failure or have let yourself or your family down                                                                          | Not at all |
      | Trouble concentrating on things, such as reading the newspaper or watching television                                                                                    | Not at all |
      | Moving or speaking so slowly that other people could have noticed. Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual | Not at all |
      | Thoughts that you would be better off dead, or of hurting yourself                                                                                                       | Not at all |
    And Click on Submit assessment
    When Click on show results after Inserting PRIMARY email
    And Click on Get matched with a provider
    When Select THERAPY service
    And Select to pay out of pocket
    And Complete the matching questions with the following options
      | why you thought about getting help from a provider | I'm feeling anxious or panicky |
      | sleeping habits                                    | Good                           |
      | physical health                                    | Fair                           |
      | your gender                                        | Female                         |
      | provider gender                                    | Male                           |
      | age                                                | <age>                          |
    Then Shoot baseline "QM - B2C - Shared - Age Restriction - Under 13 - <flow>" and ignore
      | date of birth input |
    Examples:
      | flow   | age |
      | flow65 | 12  |

@visual
Feature: QM - B2B: Flow 7 - Payment Validation

  Background:
    Given Navigate to flow28

  Rule: Copay page validation

    Scenario: B2B - Flow 7 - No copay Psychiatry payment page
      When Complete shared validation form for primary user
        | age               | 18         |
        | Member ID         | COPAY_0    |
        | service type      | PSYCHIATRY |
        | Email             | PRIMARY    |
        | employee Relation | EMPLOYEE   |
        | state             | MT         |
        | phone number      |            |
      And Click on next button to approve you are ready to begin
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | Anxiety |
        | state                                              | MT      |
      And Click on secure your match button
      Then Shoot baseline

    Scenario: B2B - Flow 7 - $25 copay Psychiatry payment page
      When Complete shared validation form for primary user
        | age               | 18         |
        | Member ID         | COPAY_25   |
        | service type      | PSYCHIATRY |
        | Email             | PRIMARY    |
        | employee Relation | EMPLOYEE   |
        | state             | MT         |
        | phone number      |            |
      And Click on next button to approve you are ready to begin
      And Complete the matching questions with the following options
        | why you thought about getting help from a provider | Anxiety |
        | state                                              | MT      |
      And Click on secure your match button
      Then Shoot baseline

    Scenario: B2B - Flow 7 - No copay therapy payment page
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_0  |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
        | phone number      |          |
      And Click on next button to approve you are ready to begin
      And Complete the matching questions with the following options
        | seek help reason                   | I'm feeling anxious or panicky |
        | got it                             |                                |
        | provider gender preference         | Male                           |
        | have you been to a provider before | Yes                            |
        | sleeping habits                    | Excellent                      |
        | physical health                    | Excellent                      |
        | your gender                        | Male                           |
        | state                              | Continue with prefilled state  |
      And Click on secure your match button
      And Click on continue on coverage verification
      Then Shoot baseline

    Scenario: B2B - Flow 7 - $25 copay therapy payment page
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_25 |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | STUDENT  |
        | state             | MT       |
        | phone number      |          |
      And Click on next button to approve you are ready to begin
      And Complete the matching questions with the following options
        | seek help reason                   | I'm feeling anxious or panicky |
        | got it                             |                                |
        | provider gender preference         | Male                           |
        | have you been to a provider before | Yes                            |
        | sleeping habits                    | Excellent                      |
        | physical health                    | Excellent                      |
        | your gender                        | Male                           |
        | state                              | Continue with prefilled state  |
      And Click on secure your match button
      And Click on continue on coverage verification
      Then Shoot baseline

    Scenario: B2B - Flow 7 - No copay Couples therapy payment page
      When Complete shared validation form for primary user
        | age               | 18              |
        | Member ID         | COPAY_0         |
        | service type      | COUPLES_THERAPY |
        | Email             | PRIMARY         |
        | employee Relation | EMPLOYEE        |
        | state             | MT              |
        | phone number      |                 |
      And Click on next button to approve you are ready to begin
      And Complete the matching questions with the following options
        | seek help reason                   | I'm feeling anxious or panicky |
        | got it                             |                                |
        | provider gender preference         | Male                           |
        | have you been to a provider before | Yes                            |
        | sleeping habits                    | Excellent                      |
        | physical health                    | Excellent                      |
        | your gender                        | Male                           |
        | state                              | Continue with prefilled state  |
      And Click on secure your match button
      And Click on continue on coverage verification
      Then Shoot baseline

    Scenario: B2B - Flow 7 - $25 copay Couples therapy payment page
      When Complete shared validation form for primary user
        | age               | 18              |
        | Member ID         | COPAY_25        |
        | service type      | COUPLES_THERAPY |
        | Email             | PRIMARY         |
        | employee Relation | EMPLOYEE        |
        | state             | MT              |
        | phone number      |                 |
      And Click on next button to approve you are ready to begin
      And Complete the matching questions with the following options
        | seek help reason                   | I'm feeling anxious or panicky |
        | got it                             |                                |
        | provider gender preference         | Male                           |
        | have you been to a provider before | Yes                            |
        | sleeping habits                    | Excellent                      |
        | physical health                    | Excellent                      |
        | your gender                        | Male                           |
        | state                              | Continue with prefilled state  |
      And Click on secure your match button
      And Click on continue on coverage verification
      Then Shoot baseline

  Rule: Error validation

    Background:
      When Complete shared validation form for primary user
        | age               | 18       |
        | Member ID         | COPAY_0  |
        | service type      | THERAPY  |
        | Email             | PRIMARY  |
        | employee Relation | EMPLOYEE |
        | state             | MT       |
        | phone number      |          |
      And Click on next button to approve you are ready to begin
      And Complete the matching questions with the following options
        | seek help reason                   | I'm feeling anxious or panicky |
        | got it                             |                                |
        | provider gender preference         | Male                           |
        | have you been to a provider before | Yes                            |
        | sleeping habits                    | Excellent                      |
        | physical health                    | Excellent                      |
        | your gender                        | Male                           |
        | state                              | Continue with prefilled state  |
      And Click on secure your match button
      And Click on continue on coverage verification

    Scenario: B2B - Flow 7 - Invalid credit card - insufficient funds with stripe link on
      And B2B Payment - Complete purchase using insufficientFunds card with stripe link true
      Then Shoot baseline

    Scenario: B2B - Flow 7 - Missing credit card
      And Payment - Enter cardholder name of visa card
      And B2B - Click on complete purchase
      Then Shoot baseline
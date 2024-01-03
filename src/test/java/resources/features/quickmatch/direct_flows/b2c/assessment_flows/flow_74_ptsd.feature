@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2754
Feature: QM - B2C - Assessment flows

  Background:
    Given Navigate to flow74
    When Click on continue
    And Click on continue
    And Complete the assessment questions with the following options
      | Repeated, disturbing, and unwanted memories of the stressful experience?                                                                                                                                                          | Not at all |
      | Repeated, disturbing dreams of the stressful experience?                                                                                                                                                                          | Not at all |
      | Suddenly feeling or acting as if the stressful experience were actually happening again (as if you were actually back there reliving it)?                                                                                         | Not at all |
      | Feeling very upset when something reminded you of the stressful experience?                                                                                                                                                       | Not at all |
      | Having strong physical reactions when something reminded you of the stressful experience (for example, heart pounding, trouble breathing, sweating)?                                                                              | Not at all |
      | Avoiding memories, thoughts, or feelings related to the stressful experience?                                                                                                                                                     | Not at all |
      | Avoiding external reminders of the stressful experience (for example, people, places, conversations, activities, objects, or situations)?                                                                                         | Not at all |
      | Trouble remembering important parts of the stressful experience?                                                                                                                                                                  | Not at all |
      | Having strong negative beliefs about yourself, other people, or the world (for example, having thoughts such as: I am bad, there is something seriously wrong with me, no one can be trusted, the world is completely dangerous)? | Not at all |
      | Blaming yourself or someone else for the stressful experience or what happened after it?                                                                                                                                          | Not at all |
      | Having strong negative feelings such as fear, horror, anger, guilt, or shame?                                                                                                                                                     | Not at all |
      | Loss of interest in activities that you used to enjoy?                                                                                                                                                                            | Not at all |
      | Feeling distant or cut off from other people?                                                                                                                                                                                     | Not at all |
      | Trouble experiencing positive feelings (for example, being unable to feel happiness or have loving feelings for people close to you)?                                                                                             | Not at all |
      | Irritable behavior, angry outbursts, or acting aggressively?                                                                                                                                                                      | Not at all |
      | Taking too many risks or doing things that could cause you harm?                                                                                                                                                                  | Not at all |
      | Being "superalert" or watchful or on guard?                                                                                                                                                                                       | Not at all |
      | Feeling jumpy or easily startled?                                                                                                                                                                                                 | Not at all |
      | Having difficulty concentrating?                                                                                                                                                                                                  | Not at all |
      | Trouble falling or staying asleep?                                                                                                                                                                                                | Not at all |
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
      | age                                                | 18                             |
      | state                                              | MT                             |
    And Click on secure your match button

  Scenario: Flow 74
    When Select the second plan
    And Continue with "6 Months" billing period
    And Apply free coupon if running on prod
    Then Payment - Click on continue
    And Payment - Complete purchase using "visa" card for primary user
    And Create account for primary user with
      | password     | STRONG |
      | nickname     | VALID  |
      | checkbox     |        |
      | phone number |        |
    And Browse to the email verification link for primary user and
      | phone number | false |
    And Onboarding - Dismiss modal
    And Navigate to payment and plan URL
    Then Plan details for the first room are
      | plan name | Messaging Only Therapy - Biannual |
    And No credits exist in the first room
    And Payment and Plan - Waiting to be matched text is displayed for the first room
Feature: QM - B2B - EAP
  Leads to flow 2

  Background:
    Given Navigate to flow62

  @tmsLink=talktala.atlassian.net/browse/CVR-96
  Scenario: "How Did You Hear About Us?" EAP dropdown options
    Then Options of referral dropdown are
      | Podcast              |
      | Email                |
      | Search Engine        |
      | App Store            |
      | School/university    |
      | Facebook             |
      | Instagram            |
      | Twitter              |
      | Tik Tok              |
      | Online article       |
      | Cable TV             |
      | Digital/Streaming TV |
      | My Insurance         |
      | My Employer/Work     |
      | Radio                |
      | Friend               |
      | Online ad            |
      | Zocdoc               |
      | Other                |

  Rule: With video

    Background:
      Then Options of the second dropdown are
        | Employee                            |
        | Spouse/partner                      |
        | Adult dependent/Member of household |
        | Student                             |
      When Complete optum eap validation form for primary user
        | age                           | 18          |
        | authorization code            | MOCK_OPTUM  |
        | session number                | 12+         |
        | service type                  | THERAPY     |
        | Email                         | PRIMARY     |
        | employee Relation             | EMPLOYEE    |
        | state                         | MT          |
        | phone number                  |             |
        | authorization code expiration | future date |
      And Click on Let's start button
      And Complete the matching questions with the following options
        | seek help reason                   | I'm feeling anxious or panicky |
        | got it                             |                                |
        | provider gender preference         | Male                           |
        | have you been to a provider before | Yes                            |
        | sleeping habits                    | Excellent                      |
        | physical health                    | Excellent                      |
        | your gender                        | Male                           |
        | state                              | Continue with prefilled state  |

    @smoke @sanity
    Scenario: Flow 62 - Optum - Therapy - with video
      And Click on secure your match button
      And Click on continue on coverage verification
      And Create account for primary user with
        | password | STRONG |
        | nickname | VALID  |
      And Browse to the email verification link for primary user and
        | phone number | false |
      And Onboarding - Dismiss modal
      And Navigate to payment and plan URL
      Then Plan details for the first room are
        | plan name                           | Optum EAP 16 Sessions With Live Session |
        | credit description                  | credit amount                           |
        | 16 x Therapy live sessions (45 min) | 1                                       |
      And Payment and Plan - Waiting to be matched text is displayed for the first room
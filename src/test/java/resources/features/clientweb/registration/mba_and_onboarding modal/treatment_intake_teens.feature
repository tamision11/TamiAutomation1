@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-3037
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-3038
@issue=talktala.atlassian.net/browse/MEMBER-2895
Feature: Client web - Registration - MBA and Onboarding

  Background:
    Given LaunchDarkly - LANGUAGE_MATCHING_TEEN_FLOW_128 feature flag activation status is true
    Given Create "parent" user
    Given Therapist API - Login to therapist provider
    Given Navigate to flow128
    And Complete broadway validation form for primary user
      | age     | 13      |
      | Email   | PRIMARY |
      | address | NYC     |
    And Teens NYC - Click on continue button
    And Teens NYC - Click on continue button
    And Complete the matching questions with the following options
      | how often do you feel stressed | Very often                                 |
      | what do you need support with  | Anxiety or worrying, Sadness or depression |
    And Teens NYC - Click on continue button
    And Complete the matching questions with the following options
      | have you talked to your parent or guardian about doing therapy | Yes |
    And Teens NYC - Click on continue button
    And Complete the matching questions with the following options
      | how do you feel about doing therapy | Nervous |
      | your gender                         | Male    |
      | provider gender preference          | Male    |
    And Select non-english as preferred language
    And Select non-english as soft filter
    And Teens NYC - Click on continue button
    And Create account for primary user with
      | password | STRONG |
      | nickname | VALID  |
    And Browse to the email verification link for primary user and
      | phone number | true |

  @visual
  Scenario: Registration - Onboarding - Treatment Intake - Teens - Visual regression
    Then Onboarding - Click on start onboarding button
                        ### Parental consent ###
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - Parental consent options"
    And Treatment Intake - Parental consent - Select parent option
    And Treatment Intake - Parental consent - Enter parent first name
    And Treatment Intake - Parental consent - Enter parent last name
    And Treatment Intake - Parental consent - Enter parent email
    And Treatment Intake - Parental consent - Click on submit consent button
                        ### Teens emergency contact ###
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - Who would you like to designate as your emergency contact"
    And Treatment Intake - Teens intake - Click on continue for Who would you like to designate as your emergency contact?
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - What is their relationship to you?"
    And Treatment Intake - Select from list the option "Friend"
    And Treatment Intake - Teens intake - Click on continue for What is their relationship to you?
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - What is your emergency contact’s phone number"
    And Treatment Intake - Emergency contact - Enter emergency contact phone number of primary user
    And Treatment Intake - Teens intake - Click on continue for What is your emergency contact’s phone number?
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - What is your full name"
    And Treatment Intake - Emergency contact - Enter primary user first name
    And Treatment Intake - Emergency contact - Enter primary user middle name
    And Treatment Intake - Emergency contact - Enter primary user last name
    And Treatment Intake - Teens intake - Click on continue for What is your full name?
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - Which race or ethnicity do you identify with"
    And Treatment Intake - Select from list the option "Black or African American"
    And Treatment Intake - Teens intake - Click on continue for Which race or ethnicity do you identify with?
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - What is your address"
    And Treatment Intake - Teens intake - Click on continue for What is your address?
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - What is your phone number"
    And Treatment Intake - Teens intake - Click on continue for What is your phone number?
    And Onboarding - Click on continue button
                        ### Teens mental health ###
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - Have you ever been hospitalized for psychiatric care"
    And Treatment Intake - Select from list the option "Yes, in the last 3 years"
    And Treatment Intake - Teens intake - Click on continue for Have you ever been hospitalized for psychiatric care?
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - Which of the following mental health conditions have you been diagnosed with"
    And Treatment Intake - Select from list the option "Panic attacks"
    And Treatment Intake - Teens intake - Click on continue for Which of the following mental health conditions have you been diagnosed with?
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - Have you ever had specific thoughts of killing yourself? question"
    And Treatment Intake - Select from list the option "Yes, in the past 30 days"
    And Treatment Intake - Teens intake - Click on next for Have you ever had specific thoughts of killing yourself? question
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - Have you ever thought about how you might do this? suicide question"
    And Treatment Intake - Select from list the option "Yes, in the past 30 days"
    And Treatment Intake - Teens intake - Click on continue for Have you ever thought about how you might do this? suicide question
    And Treatment Intake - Click on next button
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - Have you ever had thoughts about harming or killing others? question"
    And Treatment Intake - Select from list the option "Yes, in the past 30 days"
    And Treatment Intake - Teens intake - Click on next for Have you ever had thoughts about harming or killing others? question
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - Have you ever thought about how you might do this? homicide question"
    And Treatment Intake - Select from list the option "Yes, in the past 30 days"
    And Treatment Intake - Teens intake - Click on continue for Have you ever thought about how you might do this? homicide question
    And Treatment Intake - Select from list the option "Yes"
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens -Do you have excessive anger behaviors? question"
    And Treatment Intake - Teens intake - Click on next for Do you have excessive anger behaviors? question
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - Have you experienced an especially frightening, horrible, or traumatic event? question"
    And Treatment Intake - Select from list the option "Yes"
    And Treatment Intake - Teens intake - Click on next for Have you experienced an especially frightening, horrible, or traumatic event? question
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - have you struggled with thoughts or dreams of the event? question"
    And Treatment Intake - Select from list the option "Yes"
    And Treatment Intake - Teens intake - Click on next for In the past 30 days, have you struggled with thoughts or dreams of the event? question
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - In the past 30 days, have you felt guilty or blamed yourself for what happened? question"
    And Treatment Intake - Select from list the option "Yes"
    And Treatment Intake - Teens intake - Click on next for In the past 30 days, have you felt guilty or blamed yourself for what happened? question
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - In the past 30 days, have you felt distant from others or stopped enjoying your usual activities? question"
    And Treatment Intake - Select from list the option "Yes"
    And Treatment Intake - Teens intake - Click on next for In the past 30 days, have you felt distant from others or stopped enjoying your usual activities? question
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - Do you currently use or have you used any of the following substances? question"
    And Treatment Intake - Select from list the option "Cocaine"
    And Treatment Intake - Teens intake - Click on next for Do you currently use or have you used any of the following substances? question
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - How would you describe your sleep quality? question"
    And Treatment Intake - Select from list the option "Poor"
    And Treatment Intake - Teens intake - Click on next for How would you describe your sleep quality? question
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - Which of the following are you experiencing at school or in your community? question"
    And Treatment Intake - Select from list the option "Bullying"
    And Treatment Intake - Teens intake - Click on continue on Which of the following are you experiencing at school or in your community? question
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - Which of the following have you experienced through social media? question"
    And Treatment Intake - Select from list the option "Cyberbullying"
    And Treatment Intake - Teens intake - Click on continue Which of the following have you experienced through social media? question
    And Onboarding - Click on continue button
    And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
    And Onboarding - Click on meet your provider button
    Then Shoot baseline "Registration - Onboarding - Treatment Intake - Teens - Onboarding finished"

  Scenario: Registration - Onboarding - Treatment Intake - Teens
    Then Onboarding - Click on start onboarding button
                        ### Parental consent ###
    And Treatment Intake - Parental consent - Select parent option
    And Treatment Intake - Parental consent - Enter parent first name
    And Treatment Intake - Parental consent - Enter parent last name
    And Treatment Intake - Parental consent - Enter parent email
    And Treatment Intake - Parental consent - Click on submit consent button
                        ### Teens emergency contact ###
    And Treatment Intake - Teens intake - Click on continue for Who would you like to designate as your emergency contact?
    And Treatment Intake - Select from list the option "Friend"
    And Treatment Intake - Teens intake - Click on continue for What is their relationship to you?
    And Treatment Intake - Emergency contact - Enter emergency contact phone number of primary user
    And Treatment Intake - Teens intake - Click on continue for What is your emergency contact’s phone number?
    And Treatment Intake - Emergency contact - Enter primary user middle name
    And Treatment Intake - Emergency contact - Enter primary user last name
    And Treatment Intake - Teens intake - Click on continue for What is your full name?
    And Treatment Intake - Select from list the option "Black or African American"
    And Treatment Intake - Teens intake - Click on continue for Which race or ethnicity do you identify with?
    And Treatment Intake - Teens intake - Click on continue for What is your address?
    And Treatment Intake - Teens intake - Click on continue for What is your phone number?
    And Onboarding - Click on continue button
                        ### Teens mental health ###
    And Treatment Intake - Select from list the option "Yes, in the last 3 years"
    And Treatment Intake - Teens intake - Click on continue for Have you ever been hospitalized for psychiatric care?
    And Treatment Intake - Select from list the option "Panic attacks"
    And Treatment Intake - Teens intake - Click on continue for Which of the following mental health conditions have you been diagnosed with?
    And Treatment Intake - Select from list the option "Yes, in the past 30 days"
    And Treatment Intake - Teens intake - Click on next for Have you ever had specific thoughts of killing yourself? question
    And Treatment Intake - Select from list the option "Yes, in the past 30 days"
    And Treatment Intake - Teens intake - Click on continue for Have you ever thought about how you might do this? suicide question
    And Treatment Intake - Click on next button
    And Treatment Intake - Select from list the option "Yes, in the past 30 days"
    And Treatment Intake - Teens intake - Click on next for Have you ever had thoughts about harming or killing others? question
    And Treatment Intake - Select from list the option "Yes, in the past 30 days"
    And Treatment Intake - Teens intake - Click on continue for Have you ever thought about how you might do this? homicide question
    And Treatment Intake - Select from list the option "Yes"
    And Treatment Intake - Teens intake - Click on next for Do you have excessive anger behaviors? question
    And Treatment Intake - Select from list the option "Yes"
    And Treatment Intake - Teens intake - Click on next for Have you experienced an especially frightening, horrible, or traumatic event? question
    And Treatment Intake - Select from list the option "Yes"
    And Treatment Intake - Teens intake - Click on next for In the past 30 days, have you struggled with thoughts or dreams of the event? question
    And Treatment Intake - Select from list the option "Yes"
    And Treatment Intake - Teens intake - Click on next for In the past 30 days, have you felt guilty or blamed yourself for what happened? question
    And Treatment Intake - Select from list the option "Yes"
    And Treatment Intake - Teens intake - Click on next for In the past 30 days, have you felt distant from others or stopped enjoying your usual activities? question
    And Treatment Intake - Select from list the option "Cocaine"
    And Treatment Intake - Teens intake - Click on next for Do you currently use or have you used any of the following substances? question
    And Treatment Intake - Select from list the option "Poor"
    And Treatment Intake - Teens intake - Click on next for How would you describe your sleep quality? question
    And Treatment Intake - Select from list the option "Bullying"
    And Treatment Intake - Teens intake - Click on continue on Which of the following are you experiencing at school or in your community? question
    And Treatment Intake - Select from list the option "Cyberbullying"
    And Treatment Intake - Teens intake - Click on continue Which of the following have you experienced through social media? question
    And Onboarding - Click on continue button
    And MBA - Book first THERAPY live VIDEO session with NO_LIVE_PREFERENCE selection
    And Onboarding - Click on meet your provider button
    And Onboarding - Click on close button
    And Client API - Switch to therapist provider in the first room for primary user
    And Therapist API - primary user of therapist provider emergency contact details are
     """json
      {
        "firstName": "test",
        "middleName": "Auto",
        "lastName": "Automation",
        "address": "4941 King Arthur Way, Cheyenne, WY 82009, United States",
        "address2": "123 Main St",
        "city": "New York",
        "state": "NY",
        "zipcode": "10019",
        "phone": "+12025550126",
        "contactName": "TestParent AutomationParent",
        "relationship": "friend",
        "contactPhone": "+12025550126"
    }
      """
    And Therapist API - primary user clinical information for therapist provider is
      """json
    {
        "previousMentalHealthIssues": [
            5
        ],
        "previousRelativesMentalHealthIssues": [],
        "acuity": null,
        "stageOfChange": null,
        "sleepQuality": "poor",
        "sleepAidUse": null,
        "socialSupportSystem": null,
        "experiencingSchoolCommunity": [
            2
        ],
        "experiencingSocialMedia": [
            2
        ],
        "previousMentalHealthTreatment": null,
        "hospitalizationHistory": "yes_in_the_last_3_years",
        "traumaticExperience": true,
        "traumaticFlashbacks": true,
        "guilt": true,
        "isolation": true,
        "suicideIdeation": "yes_in_the_past_30_days",
        "suicidePlanning": "yes_in_the_past_30_days",
        "homicidalIdeation": "yes_in_the_past_30_days",
        "homicidalPlanning": "yes_in_the_past_30_days",
        "angerAggression": 1
    }
    """
    And Therapist API - primary user parental consent for therapist provider is
     """json
     {
        "consenterFirstName": "TestParent",
        "consenterLastName": "AutomationParent",
        "consenterRelationship": "parent",
        "consentGrantedAt": null,
        "providerApprovedManualConsentAt": null,
        "providerApprovedExemptionAt": null,
        "consentStatus": "emailSent"
    }
      """

  Scenario:  Registration - Onboarding - Treatment Intake - Emergency Resources redirect - Teens
  this scenario checks the emergency resources redirect
    Then Onboarding - Click on start onboarding button
                        ### Parental consent ###
    And Treatment Intake - Parental consent - Select parent option
    And Treatment Intake - Parental consent - Enter parent first name
    And Treatment Intake - Parental consent - Enter parent last name
    And Treatment Intake - Parental consent - Enter parent email
    And Treatment Intake - Parental consent - Click on submit consent button
                        ### Teens emergency contact ###
    And Treatment Intake - Teens intake - Click on continue for Who would you like to designate as your emergency contact?
    And Treatment Intake - Select from list the option "Friend"
    And Treatment Intake - Teens intake - Click on continue for What is their relationship to you?
    And Treatment Intake - Emergency contact - Enter emergency contact phone number of primary user
    And Treatment Intake - Teens intake - Click on continue for What is your emergency contact’s phone number?
    And Treatment Intake - Emergency contact - Enter primary user first name
    And Treatment Intake - Emergency contact - Enter primary user middle name
    And Treatment Intake - Emergency contact - Enter primary user last name
    And Treatment Intake - Teens intake - Click on continue for What is your full name?
    And Treatment Intake - Select from list the option "Black or African American"
    And Treatment Intake - Teens intake - Click on continue for Which race or ethnicity do you identify with?
    And Treatment Intake - Teens intake - Click on continue for What is your address?
    And Treatment Intake - Teens intake - Click on continue for What is your phone number?
    And Onboarding - Click on continue button
                        ### Teens mental health ###
    And Treatment Intake - Select from list the option "Yes, in the last 3 years"
    And Treatment Intake - Teens intake - Click on continue for Have you ever been hospitalized for psychiatric care?
    And Treatment Intake - Select from list the option "Panic attacks"
    And Treatment Intake - Teens intake - Click on continue for Which of the following mental health conditions have you been diagnosed with?
    And Treatment Intake - Select from list the option "Yes, in the past 30 days"
    And Treatment Intake - Teens intake - Click on next for Have you ever had specific thoughts of killing yourself? question
    And Treatment Intake - Select from list the option "Yes, in the past 30 days"
    And Treatment Intake - Teens intake - Click on continue for Have you ever thought about how you might do this? suicide question
    Then Click on emergency resource link
    And Switch focus to the second tab
    Then Current url should match "https://helpnow.talkspace.com/"

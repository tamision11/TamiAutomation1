@tmsLink=talktala.testrail.net/index.php?/cases/view/11941
Feature: Client web - Treatment Intake

  Background:
    Given Therapist API - Login to therapist provider
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |
    And Onboarding - Click on meet your provider button
    And Onboarding - Dismiss modal
    Given Therapist API - Send treatment intake to primary user from therapist provider in the first room

  Scenario: Treatment Intake - Female
  In the Medical History flow, if the client responded that they were female or transgender male, then it will ask them an additional question to see if they are currently Pregnant.
    And Therapist API - Set primary user Information with therapist provider
      | gender | female |
    When Open treatment intake
    And Click on continue
    Then Click on begin button
      ### Emergency contact section ###
    And Treatment Intake - Emergency contact - Enter primary user first name
    And Treatment Intake - Emergency contact - Enter primary user last name
    And Click on next button
    And Treatment Intake - Emergency contact - Enter home address of primary user
    And Click on next button
    And Treatment Intake - Emergency contact - Enter phone number of primary user
    And Click on next button
    And Treatment Intake - Emergency contact - Enter emergency contact full name
    And Click on next button
    And Treatment Intake - Select from list the option "Parent"
    And Click on next button
    And Treatment Intake - Emergency contact - Enter emergency contact phone number of primary user
    And Click on next button
    And Click on begin button
      ### Clinical Information ###
    And Treatment Intake - Select from list the option "Good"
    And Click on next button
    And Treatment Intake - Select from list the option "No"
    And Click on next button
    And Treatment Intake - Select from list the option "Good"
    And Click on next button
    And Treatment Intake - Select from list the option "No"
    And Click on next button
    And Select multiple focus
      | Anxiety |
    And Click on next button
    And Treatment Intake - Select from list the option "No"
    And Click on next button
    And Treatment Intake - Select from list the option "Never"
    And Click on next button
    And Treatment Intake - Select from list the option "Never"
    And Click on next button
    And Treatment Intake - Select from list the option "No"
    And Click on next button
      ### Medical Information ###
    Then Click on begin button
    And Select multiple focus
      | Asthma |
    And Click on next button
    And Treatment Intake - Select from list the option "No"
    And Click on next button
    #Pregnant question
    And Treatment Intake - Select from list the option "No"
    And Click on next button
    And Select multiple focus
      | Methadone |
    And Click on next button
    And Treatment Intake - Medical History - enter over the counter medications
    And Click on next button
    And Treatment Intake - Medical history - Enter pharmacy address of primary user
    And Click on next button
    And Treatment Intake - Medical History - enter drug allergies
    And Click on next button
    And Select multiple focus
      | Alcohol |
    And Treatment Intake - Click on submit button
    And Therapist API - primary user of therapist provider emergency contact details are
     """json
      {
   "firstName": "test",
   "middleName": null,
   "lastName": "Automation",
   "address": "4941 King Arthur Way",
   "address2": "",
   "city":"Cheyenne",
   "state": "WY",
   "zipcode": "82009",
   "phone": "+12025550126",
   "contactName": "Automation Emergency Contact",
   "relationship": "parent",
   "contactPhone": "+12025550126"
       }
      """
    And Therapist API - primary user clinical information for therapist provider is
      """json
{
   "acuity": null,
   "guilt": null,
   "hospitalizationHistory": null,
   "isolation": null,
   "previousMentalHealthIssues": [],
   "previousMentalHealthTreatment": "no",
   "previousRelativesMentalHealthIssues" :[
      2
   ],
   "sleepAidUse": "no",
   "sleepQuality": "good",
   "socialSupportSystem": "good",
   "stageOfChange": null,
   "suicideIdeation": "never",
   "suicidePlanning": null,
   "traumaticExperience": false,
   "traumaticFlashbacks": false,
   "homicidalIdeation": "never",
   "homicidalPlanning": null,
   "angerAggression": 0
}
      """
    And Therapist API - primary user medical information for therapist provider is
      """json
{
   "isPregnant": false,
   "hasChronicPain": false,
   "pharmacyAddress": "4941 King Arthur Way, Cheyenne, WY 82009, USA",
   "medicalIssues":[
      1
   ],
   "medications":[
      28
   ],
   "medicationsCustom":[],
   "controlledSubstances":[
      1
   ],
   "drugAllergies": "None",
   "otcMedications": "None",
   "otherCurrentPrescriptionMedications": null
}
              """

  Scenario: Treatment Intake - Male
  Pregnant question is hidden - only validating this.
    And Therapist API - Set primary user Information with therapist provider
      | gender | male |
    When Open treatment intake
    And Click on continue
    Then Click on begin button
      ### Emergency contact section ###
    And Treatment Intake - Emergency contact - Enter primary user first name
    And Treatment Intake - Emergency contact - Enter primary user last name
    And Click on next button
    And Treatment Intake - Emergency contact - Enter home address of primary user
    And Click on next button
    And Treatment Intake - Emergency contact - Enter phone number of primary user
    And Click on next button
    And Treatment Intake - Emergency contact - Enter emergency contact full name
    And Click on next button
    And Treatment Intake - Select from list the option "Parent"
    And Click on next button
    And Treatment Intake - Emergency contact - Enter emergency contact phone number of primary user
    And Click on next button
    Then Click on begin button
      ### Clinical Information ###
    And Treatment Intake - Select from list the option "Good"
    And Click on next button
    And Treatment Intake - Select from list the option "No"
    And Click on next button
    And Treatment Intake - Select from list the option "Good"
    And Click on next button
    And Treatment Intake - Select from list the option "No"
    And Click on next button
    And Select multiple focus
      | Anxiety |
    And Click on next button
    And Treatment Intake - Select from list the option "No"
    And Click on next button
    And Treatment Intake - Select from list the option "Never"
    And Click on next button
    And Treatment Intake - Select from list the option "Never"
    And Click on next button
    And Treatment Intake - Select from list the option "No"
    And Click on next button
      ### Medical Information ###
    Then Click on begin button
    And Select multiple focus
      | Asthma |
    And Click on next button
    And Treatment Intake - Select from list the option "No"
    And Click on next button
    And Select multiple focus
      | Methadone |
    And Click on next button
    And Treatment Intake - Medical History - enter over the counter medications
    And Click on next button
    And Treatment Intake - Medical history - Enter pharmacy address of primary user
    And Click on next button
    And Treatment Intake - Medical History - enter drug allergies
    And Click on next button
    And Select multiple focus
      | Alcohol |
    And Treatment Intake - Click on submit button
    And Therapist API - primary user medical information for therapist provider is
      """json
{
   "isPregnant":null
}
              """

  @visual
  Scenario: Treatment Intake - Visual regression
    When Open treatment intake
    And Click on continue
    Then Click on begin button
      ### Emergency contact section ###
    And Treatment Intake - Emergency contact - Enter primary user first name
    And Treatment Intake - Emergency contact - Enter primary user last name
    And Click on next button
    And Treatment Intake - Emergency contact - Enter home address of primary user
    And Click on next button
    And Treatment Intake - Emergency contact - Enter phone number of primary user
    And Click on next button
    And Treatment Intake - Emergency contact - Enter emergency contact full name
    And Click on next button
    And Treatment Intake - Select from list the option "Parent"
    And Click on next button
    And Treatment Intake - Emergency contact - Enter emergency contact phone number of primary user
    And Click on next button
    Then Click on begin button
      ### Clinical Information ###
    And Treatment Intake - Select from list the option "Good"
    And Click on next button
    And Treatment Intake - Select from list the option "No"
    And Click on next button
    And Treatment Intake - Select from list the option "Good"
    And Click on next button
    And Treatment Intake - Select from list the option "No"
    And Click on next button
    And Select multiple focus
      | Anxiety |
    And Click on next button
    And Treatment Intake - Select from list the option "No"
    And Click on next button
    And Treatment Intake - Select from list the option "Never"
    And Click on next button
    And Treatment Intake - Select from list the option "Never"
    And Click on next button
    And Treatment Intake - Select from list the option "No"
    And Click on next button
      ### Medical Information ###
    Then Shoot treatment intake modal element as "Client Web - Treatment Intake - Select section page - Medical history" baseline
    Then Click on begin button
    Then Shoot baseline "Client Web - Treatment Intake - Medical history - Are you currently being treated or have you ever been treated for any of the following medical issues question"
    And Select multiple focus
      | Asthma |
    And Click on next button
    Then Shoot baseline "Client Web - Treatment Intake - Medical history - Are you experiencing chronic pain question"
    And Treatment Intake - Select from list the option "No"
    And Click on next button
    Then Shoot baseline "Client Web - Treatment Intake - Medical history - Are you currently taking any of the following psychiatric medications question"
    And Select multiple focus
      | Methadone |
    And Click on next button
    Then Shoot baseline "Client Web - Treatment Intake - Medical history - List any over-the-counter medications, supplements, vitamins, or herbs you're currently taking question"
    And Treatment Intake - Medical History - enter over the counter medications
    And Click on next button
    Then Shoot baseline "Client Web - Treatment Intake - Medical history - Please provide your preferred pharmacy address question"
    And Treatment Intake - Medical history - Enter pharmacy address of primary user
    And Click on next button
    Then Shoot baseline "Client Web - Treatment Intake - Medical history - drug allergies question"
    And Treatment Intake - Medical History - enter drug allergies
    And Click on next button
    Then Shoot baseline "Client Web - Treatment Intake - Medical history - Do you currently use or have you previously used any of the following controlled substances question"
    And Select multiple focus
      | Alcohol |
    And Treatment Intake - Click on submit button
    Then Shoot treatment intake modal element as "Client Web - Treatment Intake - You're all done!" baseline

  Rule: Mental health section

    @visual
    Scenario: Treatment Intake - Visual regression
      Then Shoot treatment intake chat message element as "Client Web - Treatment Intake - message in chat" baseline
      When Open treatment intake
      Then Shoot treatment intake modal element as "Client Web - Treatment Intake - starting page" baseline
      When Click on continue
            ### Emergency contact section ###
      Then Shoot treatment intake modal element as "Client Web - Treatment Intake - Select section page - Emergency contact" baseline
      When Click on begin button
      Then Shoot baseline "Client Web - Treatment Intake - Emergency contact - What is your name question"
      And Treatment Intake - Emergency contact - Enter primary user first name
      And Treatment Intake - Emergency contact - Enter primary user last name
      And Click on next button
      Then Shoot baseline "Client Web - Treatment Intake - Emergency contact - What is your home address question"
      And Treatment Intake - Emergency contact - Enter home address of primary user
      And Click on next button
      Then Shoot baseline "Client Web - Treatment Intake - Emergency contact - What is your phone number question"
      And Treatment Intake - Emergency contact - Enter phone number of primary user
      And Click on next button
      Then Shoot baseline "Client Web - Treatment Intake - Emergency contact - Designate emergency contact question"
      And Treatment Intake - Emergency contact - Enter emergency contact full name
      And Click on next button
      Then Shoot baseline "Client Web - Treatment Intake - Emergency contact - What is their relationship to you question"
      And Select from list the option "Parent"
      And Click on next button
      Then Shoot baseline "Client Web - Treatment Intake - Emergency contact - How can we reach your contact question"
      And Treatment Intake - Emergency contact - Enter emergency contact phone number of primary user
      And Click on next button
                  ### Clinical Information ###
      Then Shoot treatment intake modal element as "Client Web - Treatment Intake - Select section page - Mental health" baseline
      When Click on begin button
      And Treatment Intake - Select from list the option "Good"
      And Click on next button
      Then Shoot baseline "Client Web - Treatment Intake - Mental health - sleep aids question"
      And Treatment Intake - Select from list the option "No"
      And Click on next button
      Then Shoot baseline "Client Web - Treatment Intake - Mental health - social support question"
      And Treatment Intake - Select from list the option "Good"
      And Click on next button
      Then Shoot baseline "Client Web - Treatment Intake - Mental health - have you previously seen a mental health professional question"
      And Treatment Intake - Select from list the option "No"
      And Click on next button
      Then Shoot baseline "Client Web - Treatment Intake - Mental health - relatives been diagnosed with or treated for any of the following mental health conditions question"
      And Select multiple focus
        | Anxiety |
      And Click on next button
      Then Shoot baseline "Client Web - Treatment Intake - Mental health - Have you ever experienced an especially frightening, horrible, or traumatic event question"
      And Treatment Intake - Select from list the option "No"
      And Click on next button
      Then Shoot baseline "Client Web - Treatment Intake - Mental health - Have you ever had specific thoughts of killing yourself question"
      And Treatment Intake - Select from list the option "Yes, in the past 30 days"
      And Click on next button
      Then Shoot baseline "Client Web - Treatment Intake - Mental health - Have you ever thought about how you might do this question"
      And Treatment Intake - Select from list the option "Yes, in the past 30 days"
      Then Shoot baseline "Client Web - Treatment Intake - Mental health - Emergency Resources"
      And Click on next button
      Then Shoot baseline "Client Web - Treatment Intake - Mental health - Have you ever had thoughts about harming or killing others question"
      And Treatment Intake - Select from list the option "Yes, in the past 30 days"
      Then Shoot baseline "Client Web - Treatment Intake - Mental health - Have you ever thought about how you might do this question"
      And Treatment Intake - Select from list the option "Yes, in the past 30 days"
      And Click on next button
      Then Shoot baseline "Client Web - Treatment Intake - Mental health - Do you have excessive anger, aggression, and/or violent behaviors question"

    Scenario: Treatment Intake - Mental health - Emergency Resources redirect
      When Open treatment intake
      And Click on continue
      Then Click on begin button
      ### Emergency contact section ###
      And Treatment Intake - Emergency contact - Enter primary user first name
      And Treatment Intake - Emergency contact - Enter primary user last name
      And Click on next button
      And Treatment Intake - Emergency contact - Enter home address of primary user
      And Click on next button
      And Treatment Intake - Emergency contact - Enter phone number of primary user
      And Click on next button
      And Treatment Intake - Emergency contact - Enter emergency contact full name
      And Click on next button
      Then Options of the first dropdown are
        | Parent      |
        | Guardian    |
        | Friend      |
        | Co-worker   |
        | Partner     |
        | Relative    |
        | Sibling     |
        | Adult child |
        | Other       |
      And Treatment Intake - Select from list the option "Parent"
      And Click on next button
      And Treatment Intake - Emergency contact - Enter emergency contact phone number of primary user
      And Click on next button
      Then Click on begin button
      ### Clinical Information ###
      And Treatment Intake - Select from list the option "Good"
      And Click on next button
      And Treatment Intake - Select from list the option "No"
      And Click on next button
      And Treatment Intake - Select from list the option "Good"
      And Click on next button
      And Treatment Intake - Select from list the option "No"
      And Click on next button
      And Select multiple focus
        | Anxiety |
      And Click on next button
      And Treatment Intake - Select from list the option "No"
      And Click on next button
      And Treatment Intake - Select from list the option "Yes, in the past 30 days"
      And Click on next button
      And Treatment Intake - Select from list the option "Yes, in the past 30 days"
      And Click on next button
      Then Click on emergency resource link
      And Switch focus to the second tab
      And Wait 5 seconds
      Then Current url should match "https://helpnow.talkspace.com/"

  Rule: Medical history section

    @visual
    Scenario: Treatment Intake - Medical history - Are you pregnant question
    In the Medical History flow, if the client responded that they were female or transgender male, then it will ask them an additional question to see if they are currently Pregnant.
      And Therapist API - Set primary user Information with therapist provider
        | gender | female |
      When Open treatment intake
      And Click on continue
      Then Click on begin button
      ### Emergency contact section ###
      And Treatment Intake - Emergency contact - Enter primary user first name
      And Treatment Intake - Emergency contact - Enter primary user last name
      And Click on next button
      And Treatment Intake - Emergency contact - Enter home address of primary user
      And Click on next button
      And Treatment Intake - Emergency contact - Enter phone number of primary user
      And Click on next button
      And Treatment Intake - Emergency contact - Enter emergency contact full name
      And Click on next button
      And Treatment Intake - Select from list the option "Parent"
      And Click on next button
      And Treatment Intake - Emergency contact - Enter emergency contact phone number of primary user
      And Click on next button
      Then Click on begin button
      ### Clinical Information ###
      And Treatment Intake - Select from list the option "Good"
      And Click on next button
      And Treatment Intake - Select from list the option "No"
      And Click on next button
      And Treatment Intake - Select from list the option "Good"
      And Click on next button
      And Treatment Intake - Select from list the option "No"
      And Click on next button
      And Select multiple focus
        | Anxiety |
      And Click on next button
      And Treatment Intake - Select from list the option "No"
      And Click on next button
      And Treatment Intake - Select from list the option "Never"
      And Click on next button
      And Treatment Intake - Select from list the option "Never"
      And Click on next button
      And Treatment Intake - Select from list the option "No"
      And Click on next button
      Then Click on begin button
      ### Medical Information ###
      And Select multiple focus
        | Asthma |
      And Click on next button
      And Treatment Intake - Select from list the option "No"
      And Click on next button
      Then Shoot baseline
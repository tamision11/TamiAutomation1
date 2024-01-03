@tmsLink=talktala.testrail.net/index.php?/cases/view/11941
Feature: Client web - Registration - MBA and Onboarding

  Background:
    Given Therapist API - Login to therapist provider
    Given Client API - Create THERAPY room for primary user with therapist provider
      | state | WY |
    And Browse to the email verification link for primary user and
      | phone number | true |


  Scenario: Registration - Onboarding - Treatment Intake - Female
  In the Medical History flow, if the client responded that they were female or transgender male, then it will ask them an additional question to see if they are currently Pregnant.
    And Therapist API - Set primary user Information with therapist provider
      | gender | female |
    And Onboarding - Click on meet your provider button
    Then Onboarding - Click on start onboarding button
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
     ### Emergency contact section ###
    Then Onboarding - Click on continue button
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
     ### Treatment intake finished ###
    Then Onboarding - Click on close button
    Then Room is available
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

  Scenario: Registration - Onboarding - Treatment Intake - Male
  Pregnant question is hidden - only validating this.
    And Onboarding - Click on meet your provider button
    Then Onboarding - Click on start onboarding button
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
     ### Emergency contact section ###
    Then Onboarding - Click on continue button
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
     ### Treatment intake finished ###
    Then Onboarding - Click on close button
    Then Room is available
    And Therapist API - primary user medical information for therapist provider is
      """json
{
   "isPregnant":null
}
              """

  Scenario: Registration - Onboarding - Treatment Intake - Emergency Resources redirect
  this scenario check the emergency resources redirect and also the ability to continue to medical Information after
  answering having suicidal thoughts
    And Onboarding - Click on meet your provider button
    Then Onboarding - Click on start onboarding button
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
    Then Current url should match "https://helpnow.talkspace.com/"
    And Switch focus to the first tab
    And Treatment Intake - Click on next button
    And Treatment Intake - Select from list the option "Yes, in the past 30 days"
    And Click on next button
    And Treatment Intake - Select from list the option "Yes, in the past 30 days"
    And Click on next button
    And Treatment Intake - Select from list the option "Yes"
    And Click on next button
  ### Medical Information ###
    And Wait 5 seconds
    And Select multiple focus
      | Asthma |
    And Click on next button
    And Wait 5 seconds
    And Treatment Intake - Select from list the option "No"
    And Click on next button
    And Wait 5 seconds
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
     ### Emergency contact section ###
    Then Onboarding - Click on continue button
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
     ### Treatment intake finished ###
    Then Onboarding - Click on close button
    Then Room is available
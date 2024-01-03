@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-3038
Feature: Client web - Registration - MBA and Onboarding

  Background:
    Given Create "parent" user
    Given Create "guardian" user

  Rule: NY Teens

    Background:
      Given Therapist API - Login to therapist provider
      Given Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28        |
        | age               | 13        |
        | Member ID         | COPAY_25  |
        | keyword           | premerabh |
        | employee Relation | EMPLOYEE  |
        | state             | NY        |
      And Browse to the email verification link for primary user and
        | phone number | true |
      Then Onboarding - Click on start onboarding button

    @issue=talktala.atlassian.net/browse/PLATFORM-4252
    Scenario: Registration - Onboarding - Treatment Intake - NY Teens - See consent exceptions
    waiting for redirect URL to be fixed
      And Teens NYC - Click on See consent exceptions
      And Switch focus to the second tab
      Then Current url should match "https://help.talkspace.com/hc/en-us/articles/18167691776027"

    @visual
    Scenario: Registration - Onboarding - Treatment Intake - NY Teens - Parent email can’t be the same as the user’s
      And Treatment Intake - Parental consent - Select parent option
      And Treatment Intake - Parental consent - Enter parent first name
      And Treatment Intake - Parental consent - Enter parent last name
      And Treatment Intake - Parental consent - Enter primary user email
      And Treatment Intake - Parental consent - Click on submit consent button
      Then Shoot baseline and ignore
        | email input |

    @visual
    Scenario: Registration - Onboarding - Treatment Intake - NY Teens - Guardian email can’t be the same as the user’s
      And Treatment Intake - Parental consent - Select guardian option
      And Treatment Intake - Parental consent - Enter guardian first name
      And Treatment Intake - Parental consent - Enter guardian last name
      And Treatment Intake - Parental consent - Enter primary user email
      And Treatment Intake - Parental consent - Click on submit consent button
      Then Shoot baseline and ignore
        | guardian email input |

    Scenario: Registration - Onboarding - Treatment Intake - NY Teens - I'm exempt from consent
      And Treatment Intake - Parental consent - Select I'm exempt from consent
      And Treatment Intake - Parental consent - Click on continue button
                         ### Teens emergency contact ###
      And Treatment Intake - Emergency contact - Enter primary user full name
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
      And Treatment Intake - Emergency contact - Enter home address of primary user
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
      And Client API - Switch to therapist provider in the first room for primary user
      And Onboarding - Click on meet your provider button
      And Onboarding - Dismiss modal
      Then Room is available

    @visual
    Scenario: Registration - Onboarding - Treatment Intake - NY Teens - Parental consent form Visual regression
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
      And Treatment Intake - Emergency contact - Enter home address of primary user
      And Treatment Intake - Teens intake - Click on continue for What is your address?
      And Treatment Intake - Teens intake - Click on continue for What is your phone number?
      And Onboarding - Click on continue button
      And Switch to a new tab
      And Mailinator API - Go to link on parent user email
        | subject          | Your teen requests consent |
        | surrounding text | Review consent form        |
      Then Shoot baseline "Registration - Onboarding - Treatment Intake - NY Teens - Parental consent form"
      Then Treatment Intake - Parental consent - Clear parent first name
      Then Treatment Intake - Parental consent - Clear parent last name
      And Treatment Intake - Parental consent - Click on accept terms checkbox
      Then Treatment Intake - Parental consent - Click on submit consent button
      Then Shoot baseline "Registration - Onboarding - Treatment Intake - NY Teens - Parental consent form validations"

    Scenario: Registration - Onboarding - Treatment Intake - NY Teens - Parental consent as parent
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
      And Treatment Intake - Emergency contact - Enter home address of primary user
      And Treatment Intake - Teens intake - Click on continue for What is your address?
      And Treatment Intake - Teens intake - Click on continue for What is your phone number?
      And Onboarding - Click on continue button
      And Switch to a new tab
      And Mailinator API - Go to link on parent user email
        | subject          | Your teen requests consent |
        | surrounding text | Review consent form        |
      Then Treatment Intake - Parental consent - Submit form
      Then Treatment Intake - Parental consent - Form has been received

    @visual
    Scenario: Registration - Onboarding - Treatment Intake - NY Teens - remove my parent is also my emergency contact checkbox - Visual regression
                      ### Parental consent ###
      And Treatment Intake - Parental consent - Select parent option
      And Treatment Intake - Parental consent - Enter parent first name
      And Treatment Intake - Parental consent - Enter parent last name
      And Treatment Intake - Parental consent - Enter parent email
      And Treatment Intake - Parental consent - check consent also emergency contact checkbox false
      And Treatment Intake - Parental consent - Click on submit consent button
      Then Shoot baseline "Registration - Onboarding - Treatment Intake - NY Teens - Who would you like to designate as your emergency contact not prefilled"
      And Treatment Intake - Emergency contact - Enter primary user full name
      And Treatment Intake - Teens intake - Click on continue for Who would you like to designate as your emergency contact?
      And Treatment Intake - Select from list the option "Friend"
      And Treatment Intake - Teens intake - Click on continue for What is their relationship to you?
      Then Shoot baseline "Registration - Onboarding - Treatment Intake - NY Teens - What is your emergency contact’s phone number not prefilled"

    Scenario: Registration - Onboarding - Treatment Intake - NY Teens - Parental consent as guardian
                      ### Parental consent ###
      And Treatment Intake - Parental consent - Select guardian option
      And Treatment Intake - Parental consent - Enter guardian first name
      And Treatment Intake - Parental consent - Enter guardian last name
      And Treatment Intake - Parental consent - Enter guardian email
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
      And Treatment Intake - Emergency contact - Enter home address of primary user
      And Treatment Intake - Teens intake - Click on continue for What is your address?
      And Treatment Intake - Teens intake - Click on continue for What is your phone number?
      And Onboarding - Click on continue button
      And Switch to a new tab
      And Mailinator API - Go to link on guardian user email
        | subject          | Your teen requests consent |
        | surrounding text | Review consent form        |
      Then Treatment Intake - Parental consent - Submit form
      Then Treatment Intake - Parental consent - Form has been received

    Scenario: Registration - Onboarding - Treatment Intake - NY Teens - Parental consent cant be signed twice
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
      And Treatment Intake - Emergency contact - Enter home address of primary user
      And Treatment Intake - Teens intake - Click on continue for What is your address?
      And Treatment Intake - Teens intake - Click on continue for What is your phone number?
      And Onboarding - Click on continue button
      And Switch to a new tab
      And Mailinator API - Go to link on parent user email
        | subject          | Your teen requests consent |
        | surrounding text | Review consent form        |
      And Treatment Intake - Parental consent - Submit form
      And Switch to a new tab
      And Mailinator API - Go to link on parent user email
        | subject          | Your teen requests consent |
        | surrounding text | Review consent form        |
      Then Treatment Intake - Parental consent - Form has already been signed

  Rule: Non NY Teens

    Background:
      Given Therapist API - Login to therapist provider
      Given Client API - Create THERAPY BH room for primary user with therapist provider with visa card
        | flowId            | 28        |
        | age               | 13        |
        | Member ID         | COPAY_25  |
        | keyword           | premerabh |
        | employee Relation | EMPLOYEE  |
        | state             | MT        |
      And Browse to the email verification link for primary user and
        | phone number | true |
      Then Onboarding - Click on start onboarding button

    @visual
    Scenario: Registration - Onboarding - Treatment Intake - Non NY teens - Visual regression
      And Shoot baseline "Registration - Onboarding - Treatment Intake - Non NY teens - No consent exceptions option"
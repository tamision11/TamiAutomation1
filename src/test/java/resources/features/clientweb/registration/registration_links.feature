@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2752
Feature: Client web - Registration

  Background:
    Given Navigate to therapist slug

  Rule: Informed consent

    Scenario: Informed consent redirect
      And Click on informed consent link
      And Switch focus to the second tab
      And Current url should match "https://www.talkspace.com/public/telemedicine"

    @visual
    Scenario: Informed consent - Visual regression
      And Click on informed consent link
      And Switch focus to the second tab
      And Shoot baseline

  Rule: Terms of use

    Scenario: Terms of use redirect
      And Click on terms of use link
      And Switch focus to the second tab
      And Current url should match "https://www.talkspace.com/public/terms"

  Rule: Privacy policy

    Scenario: Privacy policy redirect
      And Click on privacy policy link
      And Switch focus to the second tab
      And Current url should match "https://www.talkspace.com/public/privacy-policy"

    @visual
    Scenario: Privacy policy - Visual regression
      And Click on privacy policy link
      And Switch focus to the second tab
      And Shoot baseline
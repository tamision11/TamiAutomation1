@owner=nir_tal
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2831
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2832
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2833
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2834
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2835
@tmsLink=talktala.atlassian.net/browse/AUTOMATION-2836
Feature: Landing pages

  @issue=talktala.atlassian.net/browse/CVR-1863
  Scenario Outline: Redirect to flow 90
    Given Navigate to "<url>" landing page
    Given Landing page - Click on "<cta>" CTA
    Then Current url should contain "flow/90/step/1"
    Examples:
      | url                                            | cta           |
      | talkspace.com/psychiatry                       | navCTA        |
      | talkspace.com/psychiatry                       | heroCTA       |
      | talkspace.com/psychiatry                       | howItWorksCTA |
      | talkspace.com/psychiatry                       | benefitsCTA   |
      | talkspace.com/psychiatry                       | connectCTA    |
      | talkspace.com                                  | howItWorksCTA |
      | talkspace.com                                  | conditionsCTA |
      | talkspace.com/research/stress-in-the-workplace | navCTA        |
      | talkspace.com/research                         | navCTA        |
      | talkspace.com/research                         | heroCTA       |
      | talkspace.com/press                            | navCTA        |
      | talkspace.com/online-therapy/veterans          | navCTA        |
      | talkspace.com/online-therapy/veterans          | heroCTA       |
      | talkspace.com/online-therapy/veterans          | howItWorksCTA |
      | talkspace.com/online-therapy/lgbtqia           | navCTA        |
      | talkspace.com/online-therapy/lgbtqia           | heroCTA       |
      | talkspace.com/online-therapy/lgbtqia           | howItWorksCTA |
      | talkspace.com/online-therapy/couples-therapy   | navCTA        |
      | talkspace.com/online-therapy/couples-therapy   | heroCTA       |
      | talkspace.com/online-therapy/couples-therapy   | howItWorksCTA |
      | talkspace.com/online-therapy/couples-therapy   | whatYouGetCTA |
      | talkspace.com/online-therapy/couples-therapy   | benefitsCTA   |
      | talkspace.com/michael                          | navCTA        |
      | talkspace.com/michael                          | readyCTA      |
      | talkspace.com/michael                          | readyCTA      |
      | talkspace.com/assessments                      | navCTA        |

  Scenario Outline: Try Talksapce - Redirect to flow 90
    Given Navigate to try Talkspace "<url>" landing page
    Given Landing page - Click on "<cta>" CTA
    Then Current url should contain "flow/90/step/1"
    Examples:
      | url                                 | cta                 |
      | talkspace.com/therapy               | heroCTA             |
      | talkspace.com/therapy               | personalizedCareCTA |
      | talkspace.com/therapy               | howItWorksCTA       |
      | talkspace.com/therapy               | efficacyCTA         |
      | talkspace.com/therapy               | assessmentCTA       |
      | talkspace.com/therapists-overview   | heroCTA             |
      | talkspace.com/therapists-overview   | howItWorksCTA       |
      | talkspace.com/therapists-overview   | assessmentCTA       |
      | talkspace.com/talkspace-for-teens   | heroCTA             |
      | talkspace.com/talkspace-for-teens   | benefitsCTA         |
      | talkspace.com/talkspace-for-teens   | howItWorksCTA       |
      | talkspace.com/studentplan           | heroParentCTA       |
      | talkspace.com/studentplan           | heroStudentCTA      |
      | talkspace.com/studentplan           | howItWorksCTA       |
      | talkspace.com/studentplan           | benefitsCTA         |
      | talkspace.com/studentplan           | benefitsCTA         |
      | talkspace.com/studentplan           | faqParentCTA        |
      | talkspace.com/studentplan           | faqStudentCTA       |
      | talkspace.com/smb                   | heroCTA             |
      | talkspace.com/smb                   | howItWorksCTA       |
      | talkspace.com/smb                   | assessmentCTA       |
      | talkspace.com/skimm                 | heroCTA             |
      | talkspace.com/skimm                 | howItWorksCTA       |
      | talkspace.com/skimm                 | assessmentCTA       |
      | talkspace.com/michael               | heroCTA             |
      | talkspace.com/michael               | howItWorksCTA       |
      | talkspace.com/michael               | readyCTA            |
      | talkspace.com/online-therapy/1      | howItWorksCTA       |
      | talkspace.com/online-therapy/1      | benefitsCTA         |
      | talkspace.com/online-therapy/1      | inTheNewsCTA        |
      | talkspace.com/online-therapy        | heroCTA             |
      | talkspace.com/online-therapy        | personalizedCareCTA |
      | talkspace.com/online-therapy        | howItWorksCTA       |
      | talkspace.com/online-therapy        | resultsCTA          |
      | talkspace.com/online-counseling     | heroCTA             |
      | talkspace.com/online-counseling     | howItWorksCTA       |
      | talkspace.com/online-counseling     | assessmentCTA       |
      | talkspace.com/michael               | howItWorksCTA       |
      | talkspace.com/michael               | readyCTA            |
      | talkspace.com/mental-health-toolkit | heroCTA             |
      | talkspace.com/mental-health-toolkit | toolkitCTA          |
      | talkspace.com/mental-health-toolkit | howItWorksCTA       |
      | talkspace.com/mental-health-toolkit | assessmentCTA       |
      | talkspace.com/couples               | assessmentCTA       |
      | talkspace.com/couples               | heroCTA             |
      | talkspace.com/couples               | howItWorksCTA       |
      | talkspace.com/couples               | couplesTherapyCTA   |
      | talkspace.com/affiliate/verywell/1  | heroCTA             |
      | talkspace.com/affiliate/verywell/1  | howItWorksCTA       |
      | talkspace.com/affiliate/verywell/1  | assessmentCTA       |
      | talkspace.com/                      | heroCTA             |
      | talkspace.com/                      | personalizedCareCTA |
      | talkspace.com/                      | howItWorksCTA       |
      | talkspace.com/                      | resultsCTA          |
      | talkspace.com/affiliate             | heroCTA             |
      | talkspace.com/affiliate             | howItWorksCTA       |
      | talkspace.com/affiliate             | assessmentCTA       |

  Scenario Outline: Assessments - Redirect to assessment landing page
    Given Navigate to "<url>" landing page
    Given Landing page - Click on "<cta>" CTA
    Then Current url should contain "<redirectUrl>"
    Examples:
      | url                       | cta                                  | redirectUrl                                      |
      | talkspace.com/assessments | anxietyTestCTA                       | assessments/anxiety-test                         |
      | talkspace.com/assessments | depressionTestCTA                    | assessments/depression-test                      |
      | talkspace.com/assessments | bipolarTestCTA                       | assessments/bipolar-disorder-test                |
      | talkspace.com/assessments | ocdTestCTA                           | assessments/obsessive-compulsive-disorder-test   |
      | talkspace.com/assessments | ptsdTestCTA                          | assessments/ptsd-test                            |
      | talkspace.com/assessments | socialAnxietyTestCTA                 | assessments/social-anxiety-test                  |
      | talkspace.com/assessments | panicDisorderTestCTA                 | assessments/panic-disorder-test                  |
      | talkspace.com/assessments | borderlinePersonalityDisorderTestCTA | assessments/borderline-personality-disorder-test |
      | talkspace.com/assessments | insomniaTestCTA                      | assessments/insomnia-test                        |
      | talkspace.com/assessments | postpartumDepressionTestCTA          | assessments/postpartum-depression-test           |

  Scenario Outline: Redirect to flow assessment flows
    Given Navigate to "<url>" landing page
    Given Landing page - Click on "<cta>" CTA
    And Switch focus to the second tab
    Then Current url should contain "<redirectUrl>"
    Examples:
      | url                                                            | cta             | redirectUrl    |
      | talkspace.com/assessments/anxiety-test                         | navCTA          | flow/64/step/1 |
      | talkspace.com/assessments/anxiety-test                         | heroCTA         | flow/64/step/1 |
      | talkspace.com/assessments/anxiety-test                         | tryTalkspaceCTA | flow/64/step/1 |
      | talkspace.com/assessments/anxiety-test                         | beginTestCTA    | flow/64/step/1 |
      | talkspace.com/assessments/postpartum-depression-test           | navCTA          | flow/65/step/1 |
      | talkspace.com/assessments/postpartum-depression-test           | heroCTA         | flow/65/step/1 |
      | talkspace.com/assessments/postpartum-depression-test           | tryTalkspaceCTA | flow/65/step/1 |
      | talkspace.com/assessments/postpartum-depression-test           | beginTestCTA    | flow/65/step/1 |
      | talkspace.com/assessments/bipolar-disorder-test                | navCTA          | flow/72/step/1 |
      | talkspace.com/assessments/bipolar-disorder-test                | heroCTA         | flow/72/step/1 |
      | talkspace.com/assessments/bipolar-disorder-test                | tryTalkspaceCTA | flow/72/step/1 |
      | talkspace.com/assessments/bipolar-disorder-test                | beginTestCTA    | flow/72/step/1 |
      | talkspace.com/assessments/obsessive-compulsive-disorder-test   | navCTA          | flow/73/step/1 |
      | talkspace.com/assessments/obsessive-compulsive-disorder-test   | heroCTA         | flow/73/step/1 |
      | talkspace.com/assessments/obsessive-compulsive-disorder-test   | tryTalkspaceCTA | flow/73/step/1 |
      | talkspace.com/assessments/obsessive-compulsive-disorder-test   | beginTestCTA    | flow/73/step/1 |
      | talkspace.com/assessments/ptsd-test                            | heroCTA         | flow/74/step/1 |
      | talkspace.com/assessments/ptsd-test                            | navCTA          | flow/74/step/1 |
      | talkspace.com/assessments/ptsd-test                            | tryTalkspaceCTA | flow/74/step/1 |
      | talkspace.com/assessments/ptsd-test                            | beginTestCTA    | flow/74/step/1 |
      | talkspace.com/assessments/social-anxiety-test                  | navCTA          | flow/75/step/1 |
      | talkspace.com/assessments/social-anxiety-test                  | heroCTA         | flow/75/step/1 |
      | talkspace.com/assessments/social-anxiety-test                  | tryTalkspaceCTA | flow/75/step/1 |
      | talkspace.com/assessments/social-anxiety-test                  | beginTestCTA    | flow/75/step/1 |
      | talkspace.com/assessments/panic-disorder-test                  | navCTA          | flow/79/step/1 |
      | talkspace.com/assessments/panic-disorder-test                  | heroCTA         | flow/79/step/1 |
      | talkspace.com/assessments/panic-disorder-test                  | tryTalkspaceCTA | flow/79/step/1 |
      | talkspace.com/assessments/panic-disorder-test                  | beginTestCTA    | flow/79/step/1 |
      | talkspace.com/assessments/borderline-personality-disorder-test | navCTA          | flow/80/step/1 |
      | talkspace.com/assessments/borderline-personality-disorder-test | heroCTA         | flow/80/step/1 |
      | talkspace.com/assessments/borderline-personality-disorder-test | tryTalkspaceCTA | flow/80/step/1 |
      | talkspace.com/assessments/borderline-personality-disorder-test | beginTestCTA    | flow/80/step/1 |
      | talkspace.com/assessments/insomnia-test                        | navCTA          | flow/81/step/1 |
      | talkspace.com/assessments/insomnia-test                        | heroCTA         | flow/81/step/1 |
      | talkspace.com/assessments/insomnia-test                        | tryTalkspaceCTA | flow/81/step/1 |
      | talkspace.com/assessments/insomnia-test                        | beginTestCTA    | flow/81/step/1 |

  @visual
  Scenario Outline: Try Talkspace - Visual regression
    Given Navigate to try Talkspace "<url>" landing page
    Then Shoot baseline "<baseLineName>"
    Examples:
      | url                                     | baseLineName                                           |
      | talkspace.com/                          | Try talkspace  landing page                            |
      | talkspace.com/therapy                   | Try talkspace - Therapy landing page                   |
      | talkspace.com/therapists-overview       | Try talkspace - Therapists overview landing page       |
      | talkspace.com/talkspace-for-teens       | Try talkspace - Talkspace for teens landing page       |
      | talkspace.com/studentplan               | Try talkspace - Student plan landing page              |
      | talkspace.com/smb                       | Try talkspace - SMB landing page                       |
      | talkspace.com/skimm                     | Try talkspace - Skimm landing page                     |
      | talkspace.com/online-therapy/1          | Try talkspace - Eligibility questions landing page     |
      | talkspace.com/online-therapy            | Try talkspace - Online therapy landing page            |
      | talkspace.com/online-counseling         | Try talkspace - Online counseling landing page         |
      | talkspace.com/michael                   | Try talkspace - Michael landing page                   |
      | talkspace.com/mental-health-toolkit     | Try talkspace - Mental health toolkit landing page     |
      | talkspace.com/affiliate/verywell/1      | Try talkspace - affiliate/verywell/1 landing page      |
      | talkspace.com/affiliate/perkspot        | Try talkspace - affiliate/perkspot landing page        |
      | talkspace.com/affiliate/healthtap       | Try talkspace - affiliate/healthtap landing page       |
      | talkspace.com/affiliate/forbes          | Try talkspace - affiliate/forbes landing page          |
      | talkspace.com/affiliate/everyday-health | Try talkspace - affiliate/everyday-health landing page |
      | talkspace.com/affiliate/                | Try talkspace - affiliate landing page                 |

  @visual
  Scenario Outline: Visual regression
    Given Navigate to "<url>" landing page
    Then Shoot baseline "<baseLineName>" Without ignoring elements
    Examples:
      | url                                                            | baseLineName                                                    |
      | talkspace.com/assessments                                      | Assessments landing page                                        |
      | talkspace.com/assessments/anxiety-test                         | Assessments - anxiety-test landing page                         |
      | talkspace.com/assessments/social-anxiety-test                  | Assessments - social-anxiety-test landing page                  |
      | talkspace.com/assessments/postpartum-depression-test           | Assessments - postpartum-depression-test landing page           |
      | talkspace.com/assessments/bipolar-disorder-test                | Assessments - bipolar-disorder-test                             |
      | talkspace.com/assessments/obsessive-compulsive-disorder-test   | Assessments - obsessive-compulsive-disorder-test landing page   |
      | talkspace.com/assessments/ptsd-test                            | Assessments - ptsd-test landing page                            |
      | talkspace.com/assessments/panic-disorder-test                  | Assessments - panic-disorder-test landing page                  |
      | talkspace.com/assessments/borderline-personality-disorder-test | Assessments - borderline-personality-disorder-test landing page |
      | talkspace.com/assessments/insomnia-test                        | Assessments - insomnia-test landing page                        |
      | talkspace.com/psychiatry                                       | Psychiatry landing page                                         |
      | talkspace.com                                                  | Home page                                                       |
      | talkspace.com/self-guided-therapy                              | Self guided therapy landing page                                |
      | talkspace.com/research/stress-in-the-workplace                 | Stress in the workplace landing page                            |
      | talkspace.com/research                                         | Research landing page                                           |
      | talkspace.com/press                                            | press landing page                                              |
      | talkspace.com/online-therapy/veterans                          | Veterans landing page                                           |
      | talkspace.com/online-therapy/lgbtqia                           | Lgbtqia landing page                                            |
      | talkspace.com/online-therapy/couples-therapy                   | Couples therapy landing page                                    |
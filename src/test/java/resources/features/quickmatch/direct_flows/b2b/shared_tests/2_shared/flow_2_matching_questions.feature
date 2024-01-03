Feature: QM - B2B - Flow 2 - Matching Questions

  Background:
    Given Navigate to flow11
    When Complete google validation form for primary user
      | age               | 18       |
      | service type      | THERAPY  |
      | Email             | PRIMARY  |
      | employee Relation | EMPLOYEE |
      | phone number      |          |

  @visual
  Scenario: B2B - Flow 2 - Visual regression
    Then Shoot baseline "QM - B2B - Flow 2 - Let's Start Page"
    When Click on Let's start button
    Then Shoot baseline "QM - B2B - Flow 2 - Presenting Problems question"
    And Click on "I'm feeling anxious or panicky" button
    Then Shoot baseline "QM - B2B - Flow 2 - Things to know page"
    And Click on GOT IT!
    Then Shoot baseline "QM - B2B - Flow 2 - Provider gender question"
    When Select the option "Male"
    Then Shoot baseline "QM - B2B - Flow 2 - Have you been to a provider before question"
    And Select the option "Yes"
    Then Shoot baseline "QM - B2B - Flow 2 - Sleeping habits question"
    And Select the option "Excellent"
    Then Shoot baseline "QM - B2B - Flow 2 - Physical health question"
    And Select the option "Excellent"
    Then Shoot baseline "QM - B2B - Flow 2 - user gender question"
    When Select the option "Male"
    Then Shoot baseline "QM - B2B - Flow 2 - Residence question - US states"
    And Click on the I live outside of the US button
    Then Shoot baseline "QM - B2B - Flow 2 - Residence question - countries"

  Scenario: Flow 2 - Residence question - US states list
  skipping validating existence of countries outside the US because they come from third party
    When Click on Let's start button
    And Complete the matching questions with the following options
      | seek help reason                   | I'm feeling anxious or panicky |
      | got it                             |                                |
      | provider gender preference         | Male                           |
      | have you been to a provider before | Yes                            |
      | sleeping habits                    | Excellent                      |
      | physical health                    | Excellent                      |
      | your gender                        | Male                           |
    Then Options of the first dropdown are
      | Alaska               |
      | Alabama              |
      | Arkansas             |
      | Arizona              |
      | California           |
      | Colorado             |
      | Connecticut          |
      | District of Columbia |
      | Delaware             |
      | Florida              |
      | Georgia              |
      | Hawaii               |
      | Iowa                 |
      | Idaho                |
      | Illinois             |
      | Indiana              |
      | Kansas               |
      | Kentucky             |
      | Louisiana            |
      | Massachusetts        |
      | Maryland             |
      | Maine                |
      | Michigan             |
      | Minnesota            |
      | Missouri             |
      | Mississippi          |
      | Montana              |
      | North Carolina       |
      | North Dakota         |
      | Nebraska             |
      | New Hampshire        |
      | New Jersey           |
      | New Mexico           |
      | Nevada               |
      | New York             |
      | Ohio                 |
      | Oklahoma             |
      | Oregon               |
      | Pennsylvania         |
      | Rhode Island         |
      | South Carolina       |
      | South Dakota         |
      | Tennessee            |
      | Texas                |
      | Utah                 |
      | Virginia             |
      | Vermont              |
      | Washington           |
      | Wisconsin            |
      | West Virginia        |
      | Wyoming              |
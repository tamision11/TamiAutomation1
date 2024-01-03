@admin
Feature: Client web - Live eligibility check

  Scenario: Ineligible member
    And Admin API - Run live eligibility check
    """json
    {
        "memberID": "mem555",
        "firstName": "test",
        "lastName": "auto",
        "gediPayerID": "00830",
        "dateOfBirth": "2000-11-11",
        "state": "HI",
        "overwriteDBValues": false,
        "isOON": false
        }
    """
    And Admin API - Verify live eligibility check response
    """json
    {
    "data": {
        "copayCents": null,
        "isEligible": false,
        "coinsurancePercent": null,
        "deductible": null,
        "planSponsorName": null
      }
    }
    """
    And Admin API - Verify ineligible member in check response
    """json
    {
    "userID": null,
    "roomID": null,
    "firstName": "TEST",
    "lastName": "AUTO",
    "memberID": "mem555",
    "gediPayerID": "00830",
    "gender": null,
    "dateOfBirth": "2000-11-11",
    "city": null,
    "state": null,
    "streetAddress": null,
    "zip": null,
    "copayCents": null,
    "coinsurancePercent": null,
    "deductible": null,
    "isEligible": false,
    "source": "backoffice",
    "actualCopay": null,
    "outOfPocketRemaining": null,
    "planSponsorName": null,
    "planCoverageDescription": null,
    "groupPolicyNumber": null,
    "isOON": false,
    "trizettoRequestSucceeded": true,
    "trizettoRequestError": null
    }
    """

  Scenario: Eligible member
    And Admin API - Run live eligibility check
    """json
    {
        "memberID": "tomcat110953",
        "firstName": "ani",
        "lastName": "keghart",
        "gediPayerID": "00830",
        "dateOfBirth": "1999-04-11",
        "state": "NY",
        "overwriteDBValues": false,
        "isOON": false
    }
    """
    And DB - Store the following data
      | column  | table                                   | condition                                                                | resultName               |
      | id      | talkspace_test4.insurance_eligibilities | member_id='tomcat110953' and last_name='keghart' order by 1 desc limit 1 | insurance_eligibility_id |
      | user_id | talkspace_test4.insurance_eligibilities | member_id='tomcat110953' and last_name='keghart' order by 1 desc limit 1 | user_id                  |
      | room_id | talkspace_test4.insurance_eligibilities | member_id='tomcat110953' and last_name='keghart' order by 1 desc limit 1 | room_id                  |
    And Admin API - Verify eligible member in check response
    """json
    {
            "actualCopay": 953,
            "city": "New York",
            "coinsurancePercent": null,
            "copayCents": 953,
            "dateOfBirth": "1999-04-11",
            "deductible": null,
            "firstName": "ani",
            "gediPayerID": "00830",
            "gender": "F",
            "groupPolicyNumber": null,
            "isEligible": true,
            "isOON": false,
            "lastName": "keghart",
            "memberID": "tomcat110953",
            "outOfPocketRemaining": null,
            "planCoverageDescription": null,
            "planSponsorName": null,
            "source": "backoffice",
            "state": "NY",
            "streetAddress": "2880 Broadway",
            "trizettoRequest": {
                    "xmlOut": "<TestCredentialsUsed />"
            },
            "trizettoRequestError": null,
            "trizettoRequestSucceeded": true,
            "uuid": null,
            "zip": "10025"
    }
    """

  Scenario: User’s details do not match
    And Admin API - Run live eligibility check
    """json
    {
        "memberID": "tomcat115000",
        "firstName": "test",
        "lastName": "auto",
        "gediPayerID": "00830",
        "dateOfBirth": "2000-11-11",
        "state": "HI",
        "overwriteDBValues": false,
        "isOON": false
        }
    """
    And Admin API - Verify live eligibility check response
    """json
    {
                "errorMessage": "user details dont match former data",
                "mismatchKey": "firstName"
    }
    """


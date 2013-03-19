@javascript
Feature: Create session
  Background:
    Given I am signed in as "admin"
    And I click on "More"
    And I click on "Sessions"
    And I click on "New"
  
  Scenario: First session
    When I fill in "Start at" with "2013-01-01"
    And I fill in "End at" with "2013-02-13"
    And I click on "Create"
    Then I should see "Session is successfully created"
  
  Scenario: Session in crossed period
    Given I have a session from "2013-01-01" till "2013-01-10"
    When I fill in "Start at" with "2013-01-01"
    And I fill in "End at" with "2013-02-13"
    And I click on "Create"
    Then I should see "Impossible to create a session"

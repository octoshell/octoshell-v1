@javascript
Feature: See project prefixes
  
  Scenario: Listing non empty project prefixes list
    Given there is a Project Prefix "edu-"
    And I am signed in as "admin"
    When I click on "More"
    And I click on "Project Prefixes"
    Then I should see "edu-" Project Prefix

  Scenario: Listing empty project prefixes list
    Given I am signed in as "admin"
    When I click on "More"
    And I click on "Project Prefixes"
    Then I should see "There are no Project Prefixes"
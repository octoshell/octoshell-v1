@javascript
Feature: Add project prefix
  
  Scenario: Successful creating new Project Prefix
    Given I am signed in as "admin"
    When I click on "More"
    And I click on "Project Prefixes"
    And I click on "New Project Prefix"
    And I fill in "Name" with "edu-"
    And I click on "Create"
    Then project prefix with name "edu-" should be exists

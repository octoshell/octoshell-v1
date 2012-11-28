@javascript
Feature: Update project prefix
  
  Scenario: Success
    Given I am signed in as "admin"
    And there is a Project Prefix "edu-"
    When I click on "More"
    And I click on "Project Prefixes"
    And I click on "Edit"
    And I fill in "Name" with "emu-"
    And I click on "Update"
    Then project prefix with name "emu-" should be exists

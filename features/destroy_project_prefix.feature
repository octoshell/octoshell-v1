@javascript
Feature: Destroy project prefix
  
  Scenario: Success
    Given I am signed in as "admin"
    And there is a Project Prefix "edu-"
    When I click on "More"
    And I click on "Project Prefixes"
    And I click on "Destroy"
    And I confirm dialog
    Then project prefix with name "emu-" should not be exists

@javascript
Feature: Update abilities to group
  
  Scenario: Succesful adding abilities
    Given I am signed in as "admin"
    And there is an Ability "show" "users"
    And there is a Group "All"
    And I click on "More"
    And I click on "Groups"
    When I check ability for "show" "users"
    And I click on "Update"
    Then Group "All" should have abilities to "show" "users"

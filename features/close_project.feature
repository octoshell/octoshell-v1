Feature: Close Project
  
  Background:
    Given I am signed in as "sured"
    And I have a project named "Rocks"
    And I navigated to the project
    And I click on "Close"
  
  Scenario: Confirmation of destroying with valid confirmation code
    When I fill in "Confirmation code" with "Rocks"
    And I click on "Close"
    Then I should see "Project successfully closed"
    
  Scenario: Confirmation of destroying with invalid confirmation code
    When I fill in "Confirmation code" with "Candies"
    And I click on "Close"
    Then I should see "Wrong confirmation code"
    
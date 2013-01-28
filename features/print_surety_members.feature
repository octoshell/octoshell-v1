@javascript
Feature: Print surety members
  
  Background:
    Given I am signed in as "sured"
    And I have a project with 2 surety members

  Scenario:
    When I navigated to the surety
    And I click on "Members list"
    Then I should see members list

@javascript
Feature: Print surety members
  
  Background:
    Given I am signed in as "sured"
    And I have a project with 2 surety members
    And I navigated to the surety

  Scenario: Print Button
    Then the page should have link to "Print Members List"
  
  Scenario: Member List
    Then the page should have a table of the Members List

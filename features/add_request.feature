@javascript
Feature: Add request
  Background:
    Given I am signed in as "sured"
    And I have a project
    And I followed to new request page for the project

  Scenario: Successfully creation
    When I fill in the request form
    And I click on "Create"
    Then I should see "Request successfuly created"

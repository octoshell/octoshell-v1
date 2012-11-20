@javascript
Feature: Add membership
  
  Background:
    Given I am signed in as user
    And There is an organization Org
    And I navigated to Membership

  Scenario: Successfully creation
    When I fill in Organization with Org
    And I click on Create
    Then membership for organization Org should be created

@javascript
Feature: Add membership
  
  Background:
    Given I am signed in as user
    And There is an organization Org
    And I click Profile
    And I click New Membership

  Scenario: Successfully creation
    When I fill in Organization with Org
    And I click Create
    Then membership for organization Org should be created

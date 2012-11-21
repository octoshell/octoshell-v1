@javascript
Feature: Add membership
  
  Background:
    Given I am signed in as user
    And There is an organization OctoCorp
    And I navigated to Membership

  Scenario: Successfully creation
    When I filled in Membership form right
    And I click on Create
    Then membership for organization OctoCorp should be created

@javascript
Feature: Add membership
  
  Background:
    Given I am signed in as "user"
    And There is an organization "OctoCorp"
    And I navigated to New Membership

  Scenario: Successfully creation
    When I select "OctoCorp" from "Organization"
    And I click on "Create"
    Then membership for organization "OctoCorp" should be created

@javascript
Feature: Join Project
  In order get access to Project
  As a inviter
  I want to use secret code

  Background:
    Given I am signed in as "user"
    And There is an organization "OctoCorp"
    And There is a direction of science "OctoRobots"
    And There is a critical technology "OctoMath"
    And There is a membership for "OctoCorp" for current user
    And debug
    And I havigated to new project
    When I select "OctoCorp" from "Main Organization"
    And I fill in "Name" with "OctoProj"
    And I fill in "Description" with "8 palpus"
    And I select "OctoRobots" from "Direction of sciences"
    And I select "OctoMath" from "Critical technologies"
    And I fill in "Boss full name" with "OctoBoss"
    And I fill in "Boss position" with "OctoCEO"
    And I click on "Add Member"
    And I fill in input with class "email" with "user@octoshell.com" in last membership form
    And I fill in input with class "full-name" with "Mr. Shell" in last membership form
    And I click on "Create"
    And I signed out
    And I register as "user@octoshell.com"
    And I click on "Projects"
    And I click on "Use Code"

  Scenario: Using valid code
    When I fill in Code with right secret code
    And I click on "Use"
    Then I should get access to project "OctoProj"

  Scenario: Using invalid code
    When I fill in "Code" with "WRONG CODE"
    And I click on "Use"
    Then I should see "Code not found"

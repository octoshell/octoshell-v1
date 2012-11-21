@javascript
Feature: Add project
  Background:
    Given I am signed in as user
    And There is an organization OctoCorp
    And There is a membership for OctoCorp for current user
    And There is a direction of science OctoRobots
    And There is a critical technology OctoMath

  Scenario: Creating project by unsured user
    Given I havigated to new project
    When I select OctoCorp from Main Organization
    And I fill in Name with OctoTask
    And I fill in Description with 8 palpus
    And I select OctoRobots from Direction of sciences
    And I select OctoMath from Critical technologies
    And I fill in Boss full name with OctoBoss
    And I fill in Boss position with OctoCEO
    And I click on Create

  Scenario: Creating project by sured user


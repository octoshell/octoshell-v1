@javascript
Feature: Invite to Project
  Background:
    Given I am signed in as "sured"
    And I have a project
    And I navigated to Invite to the Project
  
  Scenario: Invite user with surety
    Given There is a sured user "Bruce Wayne"
    When I choose "Bruce Wayne" in select2 box
    And I click on "Invite"
    Then I should see "Bruce Wayne invited to the project"
  
  Scenario: Invite user without surety


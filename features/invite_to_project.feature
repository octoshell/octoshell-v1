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
    When I fill in "Boss full name" with "Bruce Wayne"
    And I fill in "Boss position" with "Batman"
    And I fill in "Email" with "robin@acme.com" in "1" member
    And I fill in "Full name" with "Tim Drake" in "1" member
    And I click on "Add"
    And I fill in "Email" with "batgirl@acme.com" in "2" member
    And I fill in "Full name" with "Barbara Gordon" in "2" member
    And debug
    And I click on "Create"
    Then I should see "Surety has been created"

@javascript
Feature: History
  In order to store user history
  As system
  I want to save key points

  Background:
    Given I am signed in as user

  Scenario: Creation Credential
    Given I have created Public Key
    Then the History Item create_credential should be created

  Scenario: Creation Membership
    Given I have created Membership
    Then the History Item create_membership should be created
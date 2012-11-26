@javascript
Feature: History
  In order to store user history
  As system
  I want to save key points

  Background:
    Given I am signed in as "user"
    And There is an organization "OctoCorp"

  Scenario: Creation Credential
    Given I have created Public Key
    Then History Item "create_credential" should be created

  Scenario: Creation Membership
    Given I have created Membership
    Then History Item "create_membership" should be created
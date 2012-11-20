@javascript
Feature: Tracking
  In order to store user history
  As system
  I want to save key points

  Background:
    Given I am signed in as user

  Scenario: Successfully creation
    Given I have created Public Key MyKey
    Then the History Item create_credential should be created

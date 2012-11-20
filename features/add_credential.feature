@javascript
Feature: Add credential
  
  Background:
    Given I am signed in as user
    And I have navigated to New Public Key

  Scenario: Successfully creation
    When I filled in Public key form
    And I click Create
    Then the public key MyKey should be created

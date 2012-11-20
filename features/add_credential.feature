@javascript
Feature: Add credential
  
  Background:
    Given I am signed in as user
    And I have navigated to New Public Key

  Scenario: Successfully creation
    When I filled in Public key form right
    And I click on Create
    Then the public key MyKey should be created

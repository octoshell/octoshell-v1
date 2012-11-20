@javascript
Feature: Add credential
  
  Background:
    Given I am signed in as user
    And I click Profile
    And I click New Public Key

  Scenario: Successfully creation
    When I fill in Name with MyKey
    And I fill in Public key with AAAAA====
    And I click Create
    Then the public key MyKey should be created

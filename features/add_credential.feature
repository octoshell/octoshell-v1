@javascript
Feature: Add credential
  
  Background:
    Given I am signed in as "user"
    And I click on "Profile"
    And I click on "New Public Key"
    And I fill in "Name" with "MyKey"
    And I fill in ".js-credential-public-key" with "====="

  Scenario: Successfully creation
    When I click on "Create"
    Then public key "MyKey" should be created

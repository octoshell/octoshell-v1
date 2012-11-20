@javascript
Feature: Tracking
  In order to store user history
  As system
  I want to save key points

  Scenario: Successfully creation
    Given I create a Public Key MyKey
    Then the History Item of Publick Key MyKey should be created

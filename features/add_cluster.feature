@javascript
Feature: Add cluster
  
  Background:
    Given I am signed in as "admin"
    And I click on "Clusters"
    And I click on "New Cluster"

  Scenario: Successfully creating new cluster
    When I fill in "Name" with "Home"
    And I fill in "Host" with "0.0.0.0"
    And I click on "Create"
    Then cluster "Home" should be created

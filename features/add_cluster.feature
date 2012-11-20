@javascript
Feature: Add cluster
  
  Background:
    Given I am signed in as admin
    And I click Clusters
    And I click New Cluster

  Scenario: Successfully creating new cluster
    When I fill in Name with Home
    And I fill in Host with 0.0.0.0
    And I click Create
    Then the cluster Home should be created

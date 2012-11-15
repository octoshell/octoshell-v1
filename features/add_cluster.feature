@javascript
Feature: Add cluster
  
  Background:
    Given I am signed in as admin
    And I click Clusters
    And I click New Cluster

  Scenario: Successfully creating new cluster
    When I fill new_cluster form with the following:
      | name | host    |
      | Home | 0.0.0.0 |
    And I click Create
    Then the cluster should be created



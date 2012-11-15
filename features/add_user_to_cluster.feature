Feature: Add user to cluster
  
  Background:
    Given I have an active cluster project

  Scenario: Successfully adding
    When I activate the cluster user
    Then I create an add_user task
  
  
Feature: Add credential to cluster
  
  Background:
    Given I have an active cluster user

  Scenario: Successfully adding
    When I activate the access
    Then I create an add_openkey task
  
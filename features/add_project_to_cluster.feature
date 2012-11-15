Feature: Add project to cluster
  
  Background:
    Given I have a closed cluster project

  Scenario: Successfully adding
    When I activate the cluster project
    Then I create an add_project task
  
  
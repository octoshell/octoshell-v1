@javascript
Feature: Approving request
  
  Scenario: Success
    Given I am signed in as "admin"
    And there is a project "OctoProj"
    And there is a cluster "OctoMach"
    And there is a pending request for project "OctoProj" on "OctoMach"
    When I click on "Requests"
    And I click on "Open" the "request"
    And I click on "activate"
    Then the request should be "active"

Feature: Approve Surety
  Background:
    Given I am signed in as "admin"
    And There is a pending surety
    And I navigated to the surety

  Scenario: Successfuly approving
    When I click on "activate"
    Then I should see "Surety successfully activated"

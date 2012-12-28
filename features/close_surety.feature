@javascript
Feature: Close Surety
  Scenario: Successfuly closing by admin
    Given I am signed in as "admin"
    And There is a pending surety
    And I navigated to the admin surety
    When I click on "close"
    And I confirm dialog
    Then I should see "Surety successfully closed"

  Scenario: Successfuly closing by user
    Given I am signed in as "sured"
    And I have a pending surety
    And I navigated to the surety
    When I click on "close"
    And I confirm dialog
    Then I should see "Surety successfully closed"

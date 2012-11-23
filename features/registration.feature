@javascript
Feature: Registration
  
  Scenario: Successfully registration
    When I register as "user@octoshell.com"
    Then user "user@octoshell.com" should be exists

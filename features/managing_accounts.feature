Feature: Managing accounts
  In order to manage an user access to project
  I want to manage their account
  
  Scenario: Activation an account for sured user for a project
    Given a sured user
    When I activate an account for the user
    Then the user receive a notification 
  
  Scenario: Activation an account for sured user for a project with an active request
    Given a sured user
    When I create an account for the user
    Then the related cluster user becomes activating
  
  
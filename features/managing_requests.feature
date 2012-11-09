Feature: Managing requests
  In order to approve resources request
  As an admin
  I want to activate a request

  Scenario: Activation a request
    Given a pending request
    When an admin activate the request
    Then the request becomes active
    And cluster project becomes activing
  
  Scenario: Activation a second request for a same cluster
    Given a pending request
    When an admin activate the request
    Then the admin got an error
    And the request stays pending
  
  Scenario: Notification about closed request
    Given a pending request
    When an admin close the request
    Then the project's owner received a notification about it
    And the project becomes closed
  
  Scenario: Closing an active request
    Given an active request
    When an admin close the request
    Then the project's cluster project becomes pausing
  
  
  
  
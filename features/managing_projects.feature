Feature: Managing projects
  In order to manage projects
  As an admin
  I want be able to close it
  
  Scenario: Closure a project
    Given an active project
    When I close the project
    Then the project becomes closed
    And related sureties becomes closed
    And related requests becomes closed
    And related accounts becomes closed
    And related cluster project becomes closed
  
  
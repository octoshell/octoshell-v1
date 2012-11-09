Feature: Managing sureties
  In order to give to a user permissions to access clusters
  As an admin
  I want to activate his surety
  
  Scenario: Creating a surety
    Given a project
    When project owner create a surety with an active member
    Then the member has a surety
  
  Scenario Outline: Changing surety state
    Given I have a <init state> surety
    When I <event> the surety
    Then the surety becomes <result state>
  
    Examples:
      | init state | event    | result state |
      | pending    | activate | active       |
      | pending    | decline  | declined     |
      | pending    | close    | closed       |
      | active     | activate | active       |
      | active     | decline  | active       |
      | active     | close    | closed       |
      | declined   | activate | declined     |
      | declined   | decline  | declined     |
      | declined   | close    | closed       |
      | closed     | active   | closed       |
      | closed     | decline  | closed       |
      | closed     | close    | close        |
  
  Scenario: Activation a surety
    Given a pending surety with member
    When an admin activate the surety
    Then surety members becomes sured
  
  Scenario: Closure a surety
    Given an active surety
    When an admin close the surety
    Then surety members becomes active

  
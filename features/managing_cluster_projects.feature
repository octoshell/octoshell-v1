Feature: Managing Cluster Project
  In order to managing project on cluster
  As an admin
  I want to change cluster project state and create a task for completing event
  
  Scenario Outline: Changing cluster project state
    Given I have a <init state> cluster project
    When I <event> the cluster project
    Then the cluster project becomes <result state>
    And if the state have changed a task <task> should be created
    
    Examples:
      | init state | event    | result state | task          |
      | closed     | activate | activing     | add_project   |
      | closed     | pause    | closed       |               |
      | closed     | close    | close        |               |
      | paused     | activate | activing     | add_project   |
      | paused     | pause    | pause        |               |
      | paused     | close    | closing      | del_project   |
      | active     | activate | active       |               |
      | active     | pause    | pausing      | block_project |
      | active     | close    | closing      | del_project   |
  
  Scenario: Closure cluster project
    Given I have an active cluster project
    When I close the cluster project
    Then related cluster users becomes closing
  
  Scenario: Activation cluster project
    Given I have a closed cluster project
    When I activate cluster project
    Then related cluster users becomes activing
  
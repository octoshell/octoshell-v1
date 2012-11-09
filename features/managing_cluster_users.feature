Feature: Managing cluster users
  In order to manage cluster user on cluster
  As an admin
  I want to be able to change cluster user state and create a task for completing event
  
  Scenario Outline: Changing cluster user state
    Given a <init state> cluster user
    When I <event> the cluster user
    Then the cluster user becomes <result state>
    And if the state have changed a task <task> should be created
    
    Examples:
      | init state | event    | result state | task       |
      | closed     | activate | activing     | add_user   |
      | closed     | pause    | closed       |            |
      | closed     | close    | close        |            |
      | active     | activate | active       |            |
      | active     | pause    | pausing      | block_user |
      | active     | close    | closing      | del_user   |

  Scenario: Complete activation of cluster user
    Given a closed cluster user
    When I complete activate cluster user
    Then related to the cluster user accesses becomes activing
    And cluster user becomes active
  
  Scenario: Complete closure of cluster user
    Given an active cluster user
    When I close the cluster user
    Then related to the cluster user accesses becomes closing
    And cluster user becomes closed
  
  
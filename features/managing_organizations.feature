Feature: Managing organizations
  In order to organize people by their organization
  As an admin
  I want to managing organization members by groups
  
  Scenario: Notification about organization creation
    When organization is created
    Then admins receive a notification
  
  Scenario: Closing an organization
    Given an active organization
    When admin close organization
    Then related memberships becomes closed
    And related projects becomes closed
  
  Scenario: Merging an organization
    Given an organization
    And an another organization
    When admin merge organization with another organization
    Then another organization becomes deleted
    And related memberships becomes related to the organization
    And related projects becomes related to the organization

  
  
  
  
  
  

  

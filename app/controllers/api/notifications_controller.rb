class Api::NotificationsController < Api::ApplicationController
  put    "/notifications/:id/deliver"                             => "notifications#deliver"
  delete "/notifications/:id/recipients"                          => "notifications#destroy_recipients"
  put    "/notifications/:id/add_all_users"                       => "notifications#add_all_users"
  put    "/notifications/:id/add_from_cluster"                    => "notifications#add_from_cluster"
  put    "/notifications/:id/add_from_organization_kind"          => "notifications#add_from_organization_kind"
  put    "/notifications/:id/add_from_organization"               => "notifications#add_from_organization"
  put    "/notifications/:id/add_from_project"                    => "notifications#add_from_project"
  put    "/notifications/:id/add_with_projects"                   => "notifications#add_with_projects"
  put    "/notifications/:id/add_with_accounts"                   => "notifications#add_with_accounts"
  put    "/notifications/:id/add_with_refused_accounts"           => "notifications#add_with_refused_accounts"
  put    "/notifications/:id/add_from_session"                    => "notifications#add_from_session"
  put    "/notifications/:id/add_unsuccessful_of_current_session" => "notifications#add_unsuccessful_of_current_session"
  put    "/notifications/:id/add_user"                            => "notifications#add_user"
  
  def create
    @notification = Notification.new(params[:notification], as: :admin)
  end
  
  def deliver
    
  end
  
  def add_all_users
    
  end
  
  def add_from_cluster
    
  end
  
  def add_from_organization_kind
    
  end
  
  def add_from_organization
    
  end
  
  def add_from_project
    
  end
  
  def add_with_projects
    
  end
  
  def add_with_accounts
    
  end
  
  def add_with_refused_accounts
    
  end
  
  def add_from_session
    
  end
  
  def add_unsuccessful_of_current_session
    
  end
  
  def add_user
    
  end
end

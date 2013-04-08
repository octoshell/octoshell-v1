class ProjectInviter
  def initialize(project, members)
    @project = project
    @members = members
  end
  
  def invite
    ActiveRecord::Base.transaction do
      create_new_surety! if need_new_surety?
      provide_access_for_sured!
      send_welcome_emails!
    end
    true
  rescue
    false
  end
  
private
  
  def need_new_surety?
    members_for_new_surety.any?
  end
  
  def members_for_new_surety
    @users_for_new_surety ||= begin
      @members.find_all do |_, member|
        member[:user_id].blank? || !User.find(member[:user_id]).sured?
      end.map { |k, v| v }
    end
  end
  
  def create_new_surety!
    @project.sureties.create! do |surety|
      members_for_new_surety.each do |member|
        surety.surety_members.build do |sm|
          sm.last_name = member[:last_name]
          sm.first_name = member[:first_name]
          sm.middle_name = member[:middle_name]
          sm.email = member[:email]
          sm.user = User.find(member[:user_id]) if member[:user_id]
        end
      end
    end
    true
  end
  
  def provide_access_for_sured!
    true
  end
  
  def send_welcome_emails!
    true
  end
end

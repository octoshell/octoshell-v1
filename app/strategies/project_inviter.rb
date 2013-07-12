require "csv"

# Приглашатель пользователей в проект
class ProjectInviter
  def initialize(project, members)
    @project = project
    @members = members
  end
  
  def self.csv(project, members)
    members = Hash[CSV.parse(members).map do |member|
      h = HashWithIndifferentAccess.new
      h[:email] = member[0].to_s.downcase.strip
      h[:user_id] = User.find_by_email(h[:email]).try(:id)
      h[:last_name] = member[1]
      h[:first_name] = member[2]
      h[:middle_name] = member[3]
      h
    end.each_with_index.to_a.map(&:reverse)]
    new project, members
  end
  
  def invite
    ActiveRecord::Base.transaction do
      create_new_surety! if need_new_surety?
      provide_access_for_sured!
      send_welcome_emails!
    end
    true
  rescue => e
    raise [e.to_s, e.backtrace.join("\n")].join
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
    surety = @project.sureties.with_state(:filling).first || begin
      @project.sureties.create! do |surety|
        surety.organization = @project.organization
        if s = @project.sureties.last
          surety.boss_full_name = s.boss_full_name
          surety.boss_position  = s.boss_position
        end
      end
    end
    members_for_new_surety.each do |member|
      surety.surety_members.create! do |sm|
        sm.last_name   = member[:last_name]
        sm.first_name  = member[:first_name]
        sm.middle_name = member[:middle_name]
        sm.email       = member[:email]
        sm.user = User.find(member[:user_id]) if member[:user_id].present?
      end
    end
    true
  end
  
  def sured_users
    @sured_users ||= begin
      @members.values.map do |user|
        User.find(user[:user_id]) if user[:user_id].present?
      end.compact
    end
  end
  
  def provide_access_for_sured!
    sured_users.each do |user|
      account = @project.accounts.where(user_id: user.id).first_or_create!
      account.allowed? || account.allow!
    end
    true
  end
  
  def send_welcome_emails!
    true
  end
end

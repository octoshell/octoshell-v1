class ProjectMover
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_reader :error
  
  def initialize(project, user = nil)
    @project = project
    @user = user
  end
  
  def user_id
    @user.try(:id)
  end
  
  def move
    return false unless @user
    ActiveRecord::Base.transaction do
      @project.requests.update_all user_id: @user.id
      if old = @project.accounts.where(user_id: @project.user_id).first
        old.active? && old.cancel!
      end
      if new = @project.accounts.where(user_id: @user.id).first_or_create!
        new.active? || new.activate!
      end
      @project.user = @user
      @project.save!
    end
  rescue => e
    @error = e.to_s
    false
  end
  
  def persisted?
    false
  end
end

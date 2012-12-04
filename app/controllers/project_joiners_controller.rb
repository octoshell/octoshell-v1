class ProjectJoinersController < ApplicationController
  def new
    @project_joiner = ProjectJoiner.new(code: params[:code])
    @project_joiner.user_id = current_user.id
  end

  def create
    @project_joiner = ProjectJoiner.new(params[:project_joiner])
    @project_joiner.user_id = current_user.id
    if @project_joiner.join
      redirect_to projects_path, notice: t('.code_activated')
    else
      flash.now[:alert] = @project_joiner.errors.to_sentence
      render :new
    end
  end

private
  
  def namespace
    :dashboard
  end
end

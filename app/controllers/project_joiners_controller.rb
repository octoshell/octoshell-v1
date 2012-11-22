# coding: utf-8
class ProjectJoinersController < ApplicationController
  def new
    @project_joiner = ProjectJoiner.new(code: params[:code])
    @project_joiner.user_id = current_user.id
  end

  def create
    @project_joiner = ProjectJoiner.new(current_user, params[:code])
    @project_joiner.user_id = current_user.id
    if @project_joiner.join
      redirect_to projects_path, notice: 'Вы активировали код'
    else
      flash.now[:alert] = @project_joiner.errors
      render :new
    end
  end

private
  
  def namespace
    :dashboard
  end
end

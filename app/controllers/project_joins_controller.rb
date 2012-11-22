# coding: utf-8
class ProjectJoinsController < ApplicationController
  def new
    @project_joiner = ProjectJoiner.new(current_user, params[:code])
  end

  def create
    @project_joiner = ProjectJoiner.new(current_user, params[:code])
    if @project_joiner.join
      redirect_to projects_path, notice: 'Вы активировали код'
    else
      flash.now[:alert] = @project_joiner.errors
      render :new
    end
  end
end

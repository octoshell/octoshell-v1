class ProjectPrefixesController < ApplicationController
  def index
    @project_prefixes = ProjectPrefix.all
  end

  def new
    @project_prefix = ProjectPrefix.new
  end

  def edit
    @project_prefix = ProjectPrefix.find(params[:id])
  end

  def create
    @project_prefix = ProjectPrefix.new(params[:project_prefix], as_role)
    if @project_prefix.save
      redirect_to project_prefixes_path
    else
      render :new
    end
  end

  def update
    @project_prefix = ProjectPrefix.find(params[:id])
    if @project_prefix.update_attributes(params[:project_prefix], as_role)
      redirect_to project_prefixes_path
    else
      render :new
    end
  end

  def destroy
    @project_prefix = ProjectPrefix.find(params[:id])
    @project_prefix.destroy
    redirect_to project_prefixes_path
  end

private
  
  def namespace
    :admin
  end
end

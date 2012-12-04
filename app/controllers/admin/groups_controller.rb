class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    @group.update_attributes(params[:group])
    redirect_to groups_path
  end

private
  
  def namespace
    :admin
  end
end

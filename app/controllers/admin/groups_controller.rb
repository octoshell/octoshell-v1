class Admin::GroupsController < Admin::ApplicationController
  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(params[:group], as: :admin)
    if @group.save
      redirect_to [:edit, :admin, @group]
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    @group.update_attributes(params[:group], as: :admin)
    redirect_to admin_groups_path
  end
end

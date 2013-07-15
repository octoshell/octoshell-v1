class Admin::SettingsController < Admin::ApplicationController
  def show
    @settings = Settings.new
    render :edit
  end
  
  def update
    Settings.update(params[:settings])
    redirect_to admin_settings_path
  end
  
  def default_breadcrumb
    false
  end
end

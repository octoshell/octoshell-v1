class Admin::SettingsController < Admin::ApplicationController
  def edit
    @settings = Settings.new
  end
  
  def update
    Settings.update(params[:settings])
    redirect_to edit_settings_path
  end
end

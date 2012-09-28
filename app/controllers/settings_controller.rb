class SettingsController < ApplicationController
  def edit
    @settings = Settings.new
  end
  
  def update
    Settings.update(params[:settings])
    redirect_to edit_settings_path
  end
  
private
  
  def namespace
    :admin
  end
end

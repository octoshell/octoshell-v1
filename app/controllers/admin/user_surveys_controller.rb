class Admin::UserSurveysController < Admin::ApplicationController
  def show
    authorize! :access, :user_surveys
    @us = UserSurvey.find(params[:id])
    add_breadcrumb "Пользователь", [:admin, @us.user]
    add_breadcrumb @us.human_name
  end
  
  private
  def default_breadcrumb
    false
  end
end

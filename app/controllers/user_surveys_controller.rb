class UserSurveysController < ApplicationController
  def accept
    us = get_survey(params[:user_survey_id])
    if us.accept
      redirect_to us
    else
      redirect_to root_path, alert: us.errors.full_messages.to_sentence
    end
  end
  
  def show
    @survey = get_survey(params[:id])
  end
  
  def update
    @survey = get_survey(params[:id])
    if @survey.fill_values(params[:fields])
      redirect_to @survey
    else
      # flash.now[:alert] = @survey.errors_sentence
      render :show
    end
  end
  
  def submit
    @survey = get_survey(params[:user_survey_id])
    if @survey.fill_values_and_submit(params[:fields])
      redirect_to @survey
    else
      flash.now[:alert] = @survey.errors_sentence
      render :show
    end
  end
  
private
  
  def get_survey(id)
    current_user.user_surveys.find(id)
  end
end

class Admin::SurveyFieldsController < Admin::ApplicationController
  def new
    @survey = Survey.find(params[:survey_id])
    @survey_field = @survey.fields.build
  end
  
  def create
    @survey = Survey.find(params[:survey_id])
    @survey_field = @survey.fields.build(params[:survey_field], as: :admin)
    if @survey_field.save
      redirect_to [:admin, @survey]
    else
      render :new
    end
  end
  
  def edit
    @survey = Survey.find(params[:survey_id])
    @survey_field = @survey.fields.find(params[:id])
  end
  
  def update
    @survey = Survey.find(params[:survey_id])
    @survey_field = @survey.fields.find(params[:id])
    if @survey_field.update_attributes(params[:survey_field], as: :admin)
      redirect_to [:admin, @survey]
    else
      render :edit
    end
  end
end

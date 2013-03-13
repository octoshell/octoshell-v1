class Admin::SurveysController < Admin::ApplicationController
  def show
    @survey = Survey.find(params[:id])
  end
end

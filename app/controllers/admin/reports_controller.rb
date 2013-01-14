class Admin::ReportsController < Admin::ApplicationController
  def index
    @reports = Report.not_selected
  end

  def all
    @reports = Report.all
    render :index
  end

  def self_selected
    @reports = Report.rated
    render :index
  end

  def rated
    @reports = Report.rated
    render :index
  end
end
# coding: utf-8
class Admin::ApplicationController < ApplicationController
  before_filter :require_login
  before_filter :authorize_admins!

  before_filter do
    add_breadcrumb "Список", url_for(action: :index) rescue nil
  end

  before_filter only: :show do
    add_breadcrumb "Детальная информация"
  end

  before_filter only: [:new, :create] do
    add_breadcrumb "Новая запись"
  end

  before_filter only: [:edit, :update] do
    add_breadcrumb "Обновление записи"
  end

  before_filter only: [:destroy] do
    add_breadcrumb "Удаление записи"
  end

private

  def namespace
    :admin
  end

  def authorize_admins!
    authorize! :access, :admin
  end
  
  def get_report(id)
    report = Report.find(id)
    if !(report.expert == current_user || report.assessing? || report.assessed?)
      raise MayMay::Unauthorized
    end
    report
  end
end

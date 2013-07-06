class Admin::CohortesController < Admin::ApplicationController
  
  def index
  end
  
  def calc
    Delayed::Job.enqueue CohortUpdater.new
    redirect_to admin_cohortes_path, notice: "Пересчет поставлен в очередь и данные скоро появятся. Обновите страницу через пару минут."
  end
  
  private
  def default_breadcrumb
    false
  end
end

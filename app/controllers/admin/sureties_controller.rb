# coding: utf-8
class Admin::SuretiesController < Admin::ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = Surety.search(params[:q]).result(distinct: true)
    @sureties = show_all? ? @search : @search.page(params[:page])
  end
  
  def show
    @surety = find_surety(params[:id])
    add_breadcrumb "Список", admin_sureties_path
    add_breadcrumb "Поручительство ##{@surety.id}"
    respond_to do |format|
      format.html
      format.rtf do
        send_data @surety.to_rtf
      end
    end
  end
  
  def find
    @surety = find_surety(params[:id])
    redirect_to @surety
  rescue ActiveRecord::RecordNotFound
    redirect_to sureties_path, alert: t('flash.alerts.surety_not_found')
  end
  
  def activate
    @surety = find_surety(params[:surety_id])
    if @surety.activate
      @surety.user.track! :activate_surety, @surety, current_user
      redirect_to_surety(@surety, notice: t('.surety_activated', default: 'Surety successfully activated'))
    else
      redirect_to_surety_with_alert(@surety)
    end
  end
  
  def decline
    @surety = find_surety(params[:surety_id])
    if @surety.decline
      @surety.user.track! :decline_surety, @surety, current_user
      redirect_to_surety(@surety)
    else
      redirect_to_surety_with_alert(@surety)
    end
  end
  
  def close
    @surety = find_surety(params[:surety_id])
    if @surety.close
      @surety.user.track! :close_surety, @surety, current_user
      redirect_to_surety(@surety, notice: t('.surety_closed', default: 'Surety successfully closed'))
    else
      redirect_to_surety_with_alert(@surety)
    end
  end
  
  def confirm
    @surety = find_surety(params[:surety_id])
    if @surety.confirm
      @surety.user.track! :confirm_surety, @surety, current_user
      redirect_to_surety(@surety)
    else
      redirect_to_surety_with_alert(@surety)
    end
  end
  
  def unconfirm
    @surety = find_surety(params[:surety_id])
    if @surety.unconfirm
      @surety.user.track! :unconfirm_surety, @surety, current_user
      redirect_to_surety(@surety)
    else
      redirect_to_surety_with_alert(@surety)
    end
  end

  def edit_template
    @html = File.read("#{Rails.root}/config/surety.liquid")
    @rtf = File.read("#{Rails.root}/config/surety.rtf")
  end
  
  def update_template
    File.open("#{Rails.root}/config/surety.liquid", 'w+') do |f|
      f.write params[:template]
    end
    redirect_to template_admin_sureties_path, notice: 'Шаблон сохранен'
  end
  
  def default_template
    File.open("#{Rails.root}/config/surety.liquid", 'w+') do |f|
      f.write File.read("#{Rails.root}/config/surety.liquid.default")
    end
    redirect_to template_admin_sureties_path, notice: 'Шаблон сохранен'
  end
  
  def rtf_template
    File.open("#{Rails.root}/config/surety.rtf", 'w+') do |f|
      f.write params[:template]
    end
    redirect_to template_admin_sureties_path, notice: 'Шаблон загружен'
  end
  
  def default_rtf
    File.open("#{Rails.root}/config/surety.rtf", 'w+') do |f|
      f.write File.read("#{Rails.root}/config/surety.rtf.default")
    end
    redirect_to template_admin_sureties_path, notice: 'Шаблон восстановлен'
  end
  
  def download_rtf_template
    send_data File.read("#{Rails.root}/config/surety.rtf"), type: "application/msword"
  end
  
  def load_scan
    @surety = Surety.find(params[:surety_id])
    if @surety.load_scan(params[:file])
      @surety.user.track! :create_scan, @surety, current_user
      redirect_to [:admin, @surety], notice: "Файл загружен"
    else
      redirect_to [:admin, @surety, :scan], alert: @surety.errors.full_messages.join(', ')
    end
  end
  
  def new_scan
    @surety = Surety.find(params[:surety_id])
  end
  
private
  
  def find_surety(id)
    Surety.find(id)
  end
  
  def redirect_to_surety_with_alert(surety)
    redirect_to [:admin, surety], alert: surety.errors.full_messages.join(', ')
  end
  
  def redirect_to_surety(surety, options = {})
    redirect_to [:admin, surety], options
  end
  
  def default_breadcrumb
    false
  end
  
  def setup_default_filter
    params[:q] ||= { state_in: ['generated'] }
  end
end

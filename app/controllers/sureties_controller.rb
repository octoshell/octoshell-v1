# coding: utf-8
class SuretiesController < ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  
  def index
    if admin?
      @search = Surety.search(params[:search])
      @sureties = @search.page(params[:page])
    else
      @search = current_user.sureties.search(params[:search])
      @sureties = @search.page(params[:page])
    end
  end
  
  def new
    @surety = Surety.new
  end
  
  def create
    @surety = Surety.new(params[:surety], as_role)
    @surety.user = current_user unless admin?
    if @surety.save
      redirect_to @surety
    else
      render :new
    end
  end
  
  def show
    @surety = find_surety(params[:id])
    @template = File.read("#{Rails.root}/config/surety.liquid")
    authorize! :show, @surety
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
      redirect_to_surety(@surety)
    else
      redirect_to_surety_with_alert(@surety)
    end
  end
  
  def decline
    @surety = find_surety(params[:surety_id])
    if @surety.decline
      redirect_to_surety(@surety)
    else
      redirect_to_surety_with_alert(@surety)
    end
  end
  
  def close
    @surety = find_surety(params[:surety_id])
    if @surety.close
      redirect_to_surety(@surety)
    else
      redirect_to_surety_with_alert(@surety)
    end
  end
  
  def confirm
    @surety = find_surety(params[:surety_id])
    if @surety.confirm
      redirect_to_surety(@surety)
    else
      redirect_to_surety_with_alert(@surety)
    end
  end
  
  def unconfirm
    @surety = find_surety(params[:surety_id])
    if @surety.unconfirm
      redirect_to_surety(@surety)
    else
      redirect_to_surety_with_alert(@surety)
    end
  end

  def edit_template
    @template = File.read("#{Rails.root}/config/surety.liquid")
  end
  
  def update_template
    File.open("#{Rails.root}/config/surety.liquid", 'w+') do |f|
      f.write params[:template]
    end
    redirect_to template_sureties_path, notice: 'Шаблон сохранен'
  end
  
  def default_template
    File.open("#{Rails.root}/config/surety.liquid", 'w+') do |f|
      f.write File.read("#{Rails.root}/config/surety.liquid.default")
    end
    redirect_to template_sureties_path, notice: 'Шаблон сохранен'
  end
  
private
  
  def find_surety(id)
    Surety.find(id)
  end
  
  def redirect_to_surety_with_alert(surety)
    redirect_to surety, alert: surety.errors.full_messages.join(', ')
  end
  
  def redirect_to_surety(surety)
    redirect_to surety
  end
  
  def namespace
    admin? ? :admin : :profile
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['pending'] }
  end
end

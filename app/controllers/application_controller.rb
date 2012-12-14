# coding: utf-8
class ApplicationController < ActionController::Base
  attr_accessor :skip_authentication_by_token
  prepend_before_filter :authenticate_by_token, unless: :skip_authentication_by_token
  
  before_filter :block_closed_users
  before_filter :get_extends, :get_wikis
  
  protect_from_forgery
  
  # rescue_from CanCan::Unauthorized, with: :not_authorized
  # rescue_from ActiveRecord::RecordInProcess, with: :record_in_process
  
  def dashboard
    if admin?
      redirect_to admin_users_path
    elsif logged_in?
      redirect_to projects_path
    else
      redirect_to new_session_path
    end
  end

  def ability
    @ability ||= begin
      mm = MayMay::Ability.new(current_user)
      (logged_in? ? current_user.abilities : Ability.default).each do |ability|
        method = ability.available ? :may : :maynot
        Rails.logger.info [method, ability.action_name, ability.subject_name].inspect
        mm.send method, ability.action_name, ability.subject_name
      end
      mm
    end
  end
  
private
  
  def not_authenticated
    redirect_to new_session_path
  end
  
  def not_authorized
    redirect_to root_path, alert: "У вас недостаточно прав для доступа в #{"http://#{request.host}#{request.fullpath}"}"
  end
  
  def after_login_path
    dashboard_path
  end
  
  def skip_action?
    false
  end
  
  def as_role
    admin? ? { as: :admin } : {}
  end
  
  def block_closed_users
    if logged_in? && current_user.closed?
      logout
      raise CanCan::Unauthorized
    end
  end
  
  def authenticate_by_token
    if token = params[:token]
      user = User.find_by_token!(token)
      if user.activation_active? && !user.admin?
        auto_login user
        redirect_to uri_without_token
      end
    end
  end
  
  def uri_without_token
    uri = URI request.url
    params = Rack::Utils.parse_query uri.query
    params.delete('token')
    uri.query = params.to_param
    uri.to_s
  end
  
  def record_in_process
    redirect_to :back, alert: 'Не возможно изменить пока связанные записи выполняются на кластере или выполнены с ошибками.'
  end
  
  def get_extends
    @page_extends = Extend.order('weight desc').find_all do |extend|
      request.path =~ %r{#{extend.url}}
    end
  end
  
  def get_wikis
    @wikis = Page.all.find_all do |page|
      request.path =~ %r{#{page.locator}} if page.locator? && (page.publicized or may?(:show_all, :pages))
    end
  end
  
  def show_all?
    params[:show_all] == '1' && admin?
  end

  def authorize_access_to_controller
    authorize! :full_access, params[:controller].to_sym
  end

  def namespace
    :dashboard
  end
  helper_method :namespace
end

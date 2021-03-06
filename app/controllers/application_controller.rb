# coding: utf-8
class ApplicationController < ActionController::Base
  before_filter :block_closed_users
  before_filter :get_notice, if: :logged_in?
  before_filter :get_extends, :get_wikis

  protect_from_forgery

  rescue_from ActiveRecord::RecordInProcess, with: :record_in_process
  rescue_from MayMay::Unauthorized, with: :not_authorized
  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError do |exception|
    admin_path = "/admin" + request.fullpath
    recognized_path = Rails.application.routes.recognize_path(admin_path) rescue nil
    if may?(:access, :admin) && recognized_path.present?
      redirect_to admin_path
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def dashboard
    if may? :access, :admin
      redirect_to admin_start_path
    elsif logged_in?
      redirect_to projects_path
    else
      redirect_to new_session_path
    end
  end

  def ability
    @ability ||= begin
      current_user and current_user.extend(UserAbilities)
      logged_in? ? current_user.ability : (begin
        mm = MayMay::Ability.new(current_user)
        Ability.default.each do |ability|
          method = ability.available ? :may : :maynot
          mm.send method, ability.action_name, ability.subject_name
        end
        mm
      end)
    end
  end

private

  def not_authenticated
    redirect_to new_session_path
  end

  def not_authorized
    if may?(:access, :admin)
      redirect_to admin_start_path, alert: "У вас недостаточно прав для доступа в #{"http://#{request.host}#{request.fullpath}"}"
    elsif logged_in?
      chopped_path = request.fullpath.gsub!("/admin", "")
      recognized_path = Rails.application.routes.recognize_path(chopped_path) rescue nil
      if recognized_path.present?
        redirect_to chopped_path
      else
        redirect_to projects_path, alert: "У вас недостаточно прав для доступа в #{"http://#{request.host}#{request.fullpath}"}"
      end
    else
      redirect_to root_path, alert: "У вас недостаточно прав для доступа в #{"http://#{request.host}#{request.fullpath}"}"
    end
  end

  def after_login_path
    projects_path
  end

  def skip_action?
    false
  end

  def block_closed_users
    if logged_in? && current_user.closed?
      logout
      not_authorized
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
      request.path =~ (%r{#{extend.url}} rescue /1/)
    end
  end

  def get_wikis
    @wikis = Page.all.find_all do |page|
      request.path =~ %r{#{page.locator}} if page.locator? && (page.publicized or may?(:show_all, :pages))
    end
  end

  def show_all?
    params[:show_all] == '1' && may?(:access, :admin)
  end

  helper_method :show_all?

  def authorize_access_to_controller
    authorize! :full_access, params[:controller].to_sym
  end

  def namespace
    :dashboard
  end
  helper_method :namespace

  def subnamespace
    @subnamespace
  end
  helper_method :subnamespace

  def admin_start_path
    page = %w(users reports sureties requests projects tickets clusters tasks
        organizations organization_kinds critical_technologies
        direction_of_sciences position_names
        extends images project_prefixes groups pages).find do |i|
      may? :manage, i.to_sym
    end
    send("admin_#{page}_path")
  end
  helper_method :admin_start_path

  def user_agent
    @user_agent = UserAgent.parse(request.env["HTTP_USER_AGENT"])
  end
  helper_method :user_agent

  def get_notice
    @user_notice = current_user.new_notice(request.path)
  end
end

class Admin::SessionsController < Admin::ApplicationController
  def index
    @sessions = Session.all
  end
  
  def new
    @session = Session.new
  end
  
  def create
    @session = Session.new(params[:session], as: :admin)
    if @session.save
      redirect_to admin_sessions_path, notice: t('.session_is_successfully_created', default: 'Session is successfully created')
    else
      flash.now[:alert] = @session.errors.full_messages.to_sentence
      render :new
    end
  end
  
  def show
    @session = get_session(params[:id])
  end
  
  def start
    @session = get_session(params[:session_id])
    if @session.start
      redirect_to [:admin, @session]
    else
      redirect_to [:admin, @session], alert: @session.errors.full_messages.to_sentence
    end
  end
  
  def stop
    @session = get_session(params[:session_id])
    if @session.stop
      redirect_to [:admin, @session]
    else
      redirect_to [:admin, @session], alert: @session.errors.full_messages.to_sentence
    end
  end
  
  def download
    @session = get_session(params[:session_id])
    Delayed::Job.enqueue SessionDataSender.new(@session.id, current_user.email)
    redirect_to [:admin, @session], notice: "Дождитесь письма со ссылкой на загрузку"
  end
  
private
  
  def get_session(id)
    Session.find(id)
  end
  
end

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
    @session = Session.find(params[:id])
  end
end

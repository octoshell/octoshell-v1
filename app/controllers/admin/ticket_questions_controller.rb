class Admin::TicketQuestionsController < Admin::ApplicationController
  before_filter :setup_default_filter, only: :index
  before_filter do
    params[:controller] = :'admin/tickets'
  end
  
  def index
    @search = TicketQuestion.search(params[:q])
    search_result = @search.result(distinct: true)
    @ticket_questions = show_all? ? search_result : search_result.page(params[:page])
  end
  
  def show
    @ticket_question = find_ticket_question(params[:id])
  end
  
  def new
    @ticket_question = TicketQuestion.new(params[:ticket_question], as: :admin)
  end
  
  def create
    @ticket_question = TicketQuestion.new(params[:ticket_question], as: :admin)
    if @ticket_question.save
      redirect_to [:admin, @ticket_question]
    else
      render :new
    end
  end
  
  def edit
    @ticket_question = find_ticket_question(params[:id])
  end
  
  def update
    @ticket_question = find_ticket_question(params[:id])
    if @ticket_question.update_attributes(params[:ticket_question], as: :admin)
      redirect_to [:admin, @ticket_question]
    else
      render :edit
    end
  end
  
  def close
    @ticket_question = find_ticket_question(params[:ticket_question_id])
    if @ticket_question.close
      redirect_to [:admin, @ticket_question]
    else
      render :show
    end
  end
  
private
  
  def find_ticket_question(id)
    TicketQuestion.find(id)
  end
  
  def redirect_to_index
    redirect_to admin_ticket_questions_path
  end
  
  def setup_default_filter
    params[:q] ||= { state_in: ['active'] }
  end

  def subnamespace
    :ticket_questions
  end
end

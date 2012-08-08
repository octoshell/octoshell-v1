class TicketQuestionsController < ApplicationController
  def index
    @ticket_questions = TicketQuestion.scoped
  end
  
  def show
    @ticket_question = find_ticket_question(params[:id])
  end
  
  def new
    @ticket_question = TicketQuestion.new
  end
  
  def create
    @ticket_question = TicketQuestion.new(params[:ticket_question], as_role)
    if @ticket_question.save
      redirect_to @ticket_question
    else
      render :new
    end
  end
  
  def edit
    @ticket_question = find_ticket_question(params[:id])
  end
  
  def update
    @ticket_question = find_ticket_question(params[:id])
    if @ticket_question.update_attributes(params[:ticket_question], as_role)
      redirect_to @ticket_question
    else
      render :new
    end
  end
  
  def close
    @ticket_question = find_ticket_question(params[:ticket_id])
    if @ticket_question.close
      redirect_to @ticket_question
    else
      render :show
    end
  end
  
private
  
  def find_ticket_question(id)
    TicketQuestion.find(id)
  end
  
  def redirect_to_index
    redirect_to ticket_questions_path
  end
  
  def namespace
    :support
    
  end
end

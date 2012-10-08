class TicketTemplatesController < ApplicationController
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = TicketTemplate.search(params[:search])
    @ticket_templates = show_all? ? @search.all : @search.page(params[:page])
  end
  
  def show
    @ticket_template = find_ticket_template(params[:id])
  end
  
  def new
    @ticket_template = TicketTemplate.new(params[:ticket_template], as_role)
  end
  
  def create
    @ticket_template = TicketTemplate.new(params[:ticket_template], as_role)
    if @ticket_template.save
      redirect_to @ticket_template
    else
      render :new
    end
  end
  
  def edit
    @ticket_template = find_ticket_template(params[:id])
  end
  
  def update
    @ticket_template = find_ticket_template(params[:id])
    if @ticket_template.update_attributes(params[:ticket_template], as_role)
      redirect_to @ticket_template
    else
      render :new
    end
  end
  
  def close
    @ticket_template = find_ticket_template(params[:ticket_template_id])
    @ticket_template.close
    redirect_to @ticket_template
  end
  
private
  
  def find_ticket_template(id)
    TicketTemplate.find(id)
  end
  
  def namespace
    :support
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
  end
end

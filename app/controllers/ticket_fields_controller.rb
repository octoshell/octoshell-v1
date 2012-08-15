class TicketFieldsController < ApplicationController
  def index
    @ticket_fields = TicketField.scoped
  end
  
  def show
    @ticket_field = find_ticket_field(params[:id])
  end
  
  def new
    @ticket_field = TicketField.new
  end
  
  def create
    @ticket_field = TicketField.new(params[:ticket_field], as_role)
    if @ticket_field.save
      redirect_to @ticket_field
    else
      render :new
    end
  end
  
  def edit
    @ticket_field = find_ticket_field(params[:id])
  end
  
  def update
    @ticket_field = find_ticket_field(params[:id])
    if @ticket_field.update_attributes(params[:ticket_field], as_role)
      redirect_to @ticket_field
    else
      render :edit
    end
  end
  
  def close
    @ticket_field = find_ticket_field(params[:ticket_field_id])
    @ticket_field.close
    redirect_to @ticket_field
  end
  
private
  
  def find_ticket_field(id)
    TicketField.find(id)
  end
  
  def namespace
    :support
  end
  
  def redirect_to_index
    redirect_to ticket_fields_path
  end
end
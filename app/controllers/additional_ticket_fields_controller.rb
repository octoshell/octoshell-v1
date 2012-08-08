class AdditionalTicketFieldsController < ApplicationController
  def index
    @additional_ticket_fields = AdditionalTicketField.scoped
  end
  
  def show
    @additional_ticket_field = find_additional_ticket_field(params[:id])
  end
  
  def new
    @additional_ticket_field = AdditionalTicketField.new
  end
  
  def create
    @additional_ticket_field = AdditionalTicketField.new(params[:additional_ticket_field], as_role)
    if @additional_ticket_field.save
      redirect_to_index
    else
      render :new
    end
  end
  
  def edit
    @additional_ticket_field = find_additional_ticket_field(params[:id])
  end
  
  def update
    @additional_ticket_field = find_additional_ticket_field(params[:id])
    if @additional_ticket_field.update_attributes(params[:additional_ticket_field], as_role)
      redirect_to_index
    else
      render :edit
    end
  end
  
  def close
    @additional_ticket_field = find_additional_ticket_field(params[:additional_ticket_field_id], as_role)
    @additional_ticket_field.close
    redirect_to_index
  end
  
private
  
  def find_additional_ticket_field(id)
    AdditionalTicketField.find(id)
  end
  
  def namespace
    :support
  end
  
  def redirect_to_index
    redirect_to additional_ticket_fields_path
  end
end

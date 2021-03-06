class Admin::TicketFieldsController < Admin::ApplicationController
  before_filter :setup_default_filter, only: :index
  before_filter do
    params[:controller] = :'admin/tickets'
  end

  def index
    @search = TicketField.search(params[:q])
    search_result = @search.result(distinct: true)
    @ticket_fields = show_all? ? search_result : search_result.page(params[:page])
  end

  def show
    @ticket_field = find_ticket_field(params[:id])
  end

  def new
    @ticket_field = TicketField.new
  end

  def create
    @ticket_field = TicketField.new(params[:ticket_field], as: :admin)
    if @ticket_field.save
      redirect_to [:admin, @ticket_field]
    else
      render :new
    end
  end

  def edit
    @ticket_field = find_ticket_field(params[:id])
  end

  def update
    @ticket_field = find_ticket_field(params[:id])
    if @ticket_field.update_attributes(params[:ticket_field], as: :admin)
      redirect_to [:admin, @ticket_field]
    else
      render :edit
    end
  end

  def close
    @ticket_field = find_ticket_field(params[:ticket_field_id])
    @ticket_field.close
    redirect_to [:admin, @ticket_field]
  end

private

  def find_ticket_field(id)
    TicketField.find(id)
  end

  def redirect_to_index
    redirect_to ticket_fields_path
  end

  def setup_default_filter
    params[:q] ||= { state_in: ['active'] }
  end

  def subnamespace
    :ticket_fields
  end
end

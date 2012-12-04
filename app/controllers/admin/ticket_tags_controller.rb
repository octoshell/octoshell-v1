class TicketTagsController < ApplicationController
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = TicketTag.search(params[:search])
    @ticket_tags = show_all? ? @search.all : @search.page(params[:page])
  end
  
  def show
    @ticket_tag = find_ticket_tag(params[:id])
  end
  
  def new
    @ticket_tag = TicketTag.new
  end
  
  def create
    @ticket_tag = TicketTag.new(params[:ticket_tag], as_role)
    if @ticket_tag.save
      redirect_to @ticket_tag
    else
      render :new
    end
  end
  
  def edit
    @ticket_tag = find_ticket_tag(params[:id])
  end
  
  def update
    @ticket_tag = find_ticket_tag(params[:id])
    if @ticket_tag.update_attributes(params[:ticket_tag], as_role)
      redirect_to @ticket_tag
    else
      render :edit
    end
  end
  
  def close
    @ticket_tag = find_ticket_tag(params[:ticket_tag_id])
    @ticket_tag.close
    redirect_to @ticket_tag
  end
  
  def merge
    @ticket_tag = find_ticket_tag(params[:ticket_tag_id])
    @duplication = find_ticket_tag(params[:ticket_tag].delete(:merge_id))
    if @ticket_tag.merge(@duplication)
      redirect_to @ticket_tag
    else
      render :show
    end
  end
  
private
  
  def find_ticket_tag(id)
    TicketTag.find(id)
  end
  
  def namespace
    :support
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
  end
end

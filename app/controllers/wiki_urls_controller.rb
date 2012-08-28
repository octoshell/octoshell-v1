class WikiUrlsController < ApplicationController
  def create
    @wiki_url = WikiUrl.new(params[:wiki_url], as_role)
    @wiki_url.save
    redirect_to_edit_page @wiki_url
  end
  
  def update
    @wiki_url = WikiUrl.find(params[:id])
    @wiki_url.update_attributes params[:wiki_url], as_role
    redirect_to_edit_page @wiki_url
  end
  
  def destroy
    @wiki_url = WikiUrl.find(params[:id])
    @wiki_url.destroy
    redirect_to_edit_page @wiki_url
  end

private
  
  def redirect_to_edit_page(wiki_url)
    if wiki_url.errors.any?
      redirect_to [:edit, wiki_url.page], alert: wiki_url.errors.full_messages.join(', ')
    else
      redirect_to [:edit, wiki_url.page]
    end
  end
end

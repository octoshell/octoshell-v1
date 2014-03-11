# Служебный контроллер для предпросмотра md-текстов.
class MarkdownController < ApplicationController
  def create
    render text: Redcarpet.new(params[:raw], :smart, :tables, :filter_html, :hard_wrap).to_html.html_safe
  end
end

module ApplicationHelper
  def title title
    content_for :title, title
  end
  
  def render_git_version
    "<!-- version: #{MSU::VERSION} -->".html_safe
  end
end

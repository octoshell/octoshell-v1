class BootstrapBreadcrumbs < BreadcrumbsOnRails::Breadcrumbs::Builder
  def render
    return "" if @elements.empty?
   
    menu = %{<ul class="breadcrumb">}
    menu << @elements.map { |e| render_element(e) }.join(" / ")
    menu << %{</ul>}
    menu.html_safe
  end

private
  
  def render_element(element)
    if element.path == nil
      content = compute_name(element)
    else
      content = @context.link_to_unless @context.request.fullpath == compute_path(element), compute_name(element), compute_path(element), element.options
    end
    if content =~ /<a/
      "<li>#{content}</li>"
    else
      %{<li class="active">#{content}</li>}
    end
  end
end

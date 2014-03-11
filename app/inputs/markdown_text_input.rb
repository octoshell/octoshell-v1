class MarkdownTextInput < SimpleForm::Inputs::TextInput
  def input
    input_html_options[:class] << "raw"
    template.content_tag(:div, "input-group") do
      template.concat @builder.text_area(attribute_name, input_html_options)
      template.concat preview_area
      template.concat helpers_area
    end
  end

  def preview_area
    template.content_tag(:div, class: "preview-area") do
    end
  end

  def helpers_area
    template.content_tag(:div, class: "helpers-area") do
      template.concat preview_link
      template.concat edit_link
      template.concat syntax_help
    end
  end

  def preview_link
    template.content_tag(:a, class: "preview") do
      template.concat I18n.translate("markdown_helpers.preview")
    end
  end

  def edit_link
    template.content_tag(:a, class: "edit") do
      template.concat I18n.translate("markdown_helpers.edit")
    end
  end

  def syntax_help
    template.content_tag(:p) do
      template.concat I18n.translate("markdown_helpers.syntax").html_safe
    end
  end
end

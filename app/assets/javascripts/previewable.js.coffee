class Previewable
  constructor: (attributes) ->
    @field = attributes.field
    @raw = @field.find "textarea.raw"
    @preview_area = @field.find "div.preview-area"
    @preview_area.hide()

    @previewButton = @field.find "a.preview"
    @previewButton.on 'click', @preview

    @editButton = @field.find "a.edit"
    @editButton.on 'click', @edit
    @editButton.hide()

  preview: =>
    $.ajax(
      type: "POST"
      url:  "/markdown"
      data: { raw: @raw.val() }
    ).done (data) =>
      @raw.hide()
      @preview_area.show()
      @preview_area.html(data)
      @previewButton.hide()
      @editButton.show()

  edit: =>
    @preview_area.hide()
    @raw.show()
    @editButton.hide()
    @previewButton.show()

$(document).ready ->
  $(".markdown_text").each (i, field) ->
    new Previewable field: $(field)

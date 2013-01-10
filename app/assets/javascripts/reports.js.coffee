$ ->
  $('@project-name-autocompleter').on 'blur', ->
    input = $(@)
    title = input.parents('.row:first').prev().find('h2 span:first')
    title.html input.val()
  
  $('form.report-form').on 'click @report-button]', (e) ->
    link = $(e.target)
    if link.is('@report-button')
      $('input[name="_method"]', @).val link.data('method')
      if link.hasClass('remove-project')
        link.parents('project:first').remove()
      @.action = link.attr('href')
      @.submit()
      false
  
  $('div[data-max-values]').on 'change :checkbox', ->
    condition = $(':checked', @).length >= Number($(@).data('max-values'))
    $(':not(:checked)', @).prop 'disabled', condition
  $('div[data-max-values]').each (i, e) ->
    $(':checkbox:first', e).trigger('change')
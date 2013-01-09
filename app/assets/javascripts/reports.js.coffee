$ ->
  $('@project-name-autocompleter').on 'blur', ->
    input = $(@)
    title = input.parents('.row:first').prev().find('h2 span:first')
    title.html input.val()
  
  $('@remove-project').on 'click', (e) ->
    form = $(@).parents('form:first')[0]
    form.action = $(@).attr('href')
    $('input[name="_method"]', form).val('delete')
    $(@).parents('project:first').remove()
    form.submit()
    false

  $('@add-project').on 'click', (e) ->
    form = $(@).parents('form:first')[0]
    form.action = $(@).attr('href')
    $('input[name="_method"]', form).val('post')
    form.submit()
    false
  
  $('div[data-max-values]').on 'change :checkbox', ->
    condition = $(':checked', @).length >= Number($(@).data('max-values'))
    $(':not(:checked)', @).prop 'disabled', condition
  
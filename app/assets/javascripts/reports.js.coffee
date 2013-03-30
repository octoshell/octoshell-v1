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
    max = Number($(@).data('max-values'))
    return if max <= 0
    condition = $(':checked', @).length >= max
    $(':not(:checked)', @).prop 'disabled', condition
  $('div[data-max-values]').each (i, e) ->
    $(':checkbox:first', e).trigger('change')

  $('table.summable').each (i, table) ->
    table = $(table)
    row = $('tr:last', table).clone()
    row.find('th').html('Всего')

    table.recalc = ->
      row.find('td').each (j, td) ->
        td = $(td)
        val = 0
        $('tr', table).each (k, tr) ->
          v = Number $('td:eq(' + j + ')', $(tr)).find('input').val()
          val += v unless _(v).isNaN()
        td.html(val)

    table.on 'blur input', =>
      table.recalc()

    table.recalc()
    table.append(row)
  
  $('a@report-allower').on 'click', ->
    $('input@allow-event').val $(@).data('event')
    $('form@allow').submit()
    return false

  
  
  window.cache ||= {}
  $('.typeahead').each (i, html) ->
    $input = $(html)
    $controlGroup = $input.parents('div.control-group:first')
    url = $input.data('entity-source')
    window.cache[url] = {}
    if $input.val().length > 0
      window.cache[url][$input.val()] = true
    $input.typeahead
      minLength: 1,
      source: (query, process) ->
        $.getJSON url, { q: query }, (data) ->
          process(
            data.records.map (r) ->
              window.cache[url][r.text] = true
              r.text
          )
    if $input.data('strict-collection')
      $input.on 'blur', ->
        if window.cache[url][$input.val()]
          $controlGroup.removeClass('error').addClass('success')
        else
          $controlGroup.removeClass('success').addClass('error')
      $input.on 'focus', ->
        $controlGroup.removeClass('error').removeClass('success')
  
  $('.submit-survey').on 'click', ->
    $button = $(@)
    $form = $button.parents('form:first')
    $form.prop 'action', $button.data('action')
    true
  
  $('#membership_organization_id').on 'change', ->
    return if $(@).val().length == 0
    $.getJSON '/organizations/' + $(@).val() + '/subdivisions', (data) ->
      $('#membership_subdivision_name').data 'source', data
  $('#membership_organization_id').change()
  
  $('code.public-key').on 'click', ->
    if (document.selection)
      range = document.body.createTextRange()
      range.moveToElementText(@)
    else if window.getSelection
      range = document.createRange()
      range.selectNode(@);
      window.getSelection().addRange(range)
    $(document).click()
    $(@).tooltip('show')
    $(document).one 'click', =>
      $(@).tooltip('hide')
    false
  
  $('.well-collapseble').on 'click .well-close', ->
    klass = 'well-collapsed'
    cookie = 'hide_session'
    $well = $(@)
    if $well.hasClass(klass)
      $.removeCookie(cookie)
      $well.removeClass klass
    else
      $.cookie cookie, '1', { expires: 7, path: '/' }
      $well.addClass klass
  
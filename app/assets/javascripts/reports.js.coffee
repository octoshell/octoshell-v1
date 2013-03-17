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
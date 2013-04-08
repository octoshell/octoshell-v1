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
  
  $('.well-collapseble').on 'click .well-close', (e) ->
    return if !$(e.target).hasClass('well-close')
    
    klass = 'well-collapsed'
    cookie = 'hide_session'
    $well = $(@)
    if $well.hasClass(klass)
      $.removeCookie(cookie)
      $well.removeClass klass
    else
      $.cookie cookie, '1', { expires: 7, path: '/' }
      $well.addClass klass
  
  $('@popoverable').each (i, link) ->
    $(link).popover(
      content: ( ->
        $($(@).data('content')).html()
      ),
      html: true
    )
  
  
  $('@add-member-to-project').on 'click', ->
    $('@add-project-members').removeClass('hidden')
    $(@).addClass('hidden')
    false
  
  $('@project-members-collapse').on 'click', ->
    $('@add-project-members').addClass('hidden')
    $('@add-member-to-project').removeClass('hidden')
    false
  
  $('@project-members-controller').each (i, html) ->
    $input = $(html)
    url = $input.data('entity-source')
    
    db = {}
    n = 0
    
    $template = _.template('
      <tr>
        <td>
          <% if (state == "sured") { %>
            <abbr title="Есть поручительство" class="text-success">✓</abbr>
          <% } else { %>
            <abbr title="Нет поручительства">_</abbr>
          <% } %>
          </td>
        <td>
          <input name="members[<%= n %>][user_id]" type="hidden" value="<%= id %>">
          <% if (id) { %>
            <span class="input-block-level uneditable-input"><%= last_name %></span>
          <% } else { %>
            <input name="members[<%= n %>][last_name]" class="input-block-level" type="text" value="<%= last_name %>">
          <% } %>
        </td>
        <td>
          <% if (id) { %>
            <span class="input-block-level uneditable-input"><%= first_name %></span>
          <% } else { %>
            <input name="members[<%= n %>][first_name]" class="input-block-level" type="text" value="" autofocus="true">
          <% } %>
        </td>
        <td>
          <% if (id) { %>
            <span class="input-block-level uneditable-input"><%= middle_name %></span>
          <% } else { %>
            <input name="members[<%= n %>][middle_name]" class="input-block-level" type="text" value="">
          <% } %>
        </td>
        <td>
          <% if (id) { %>
            <span class="input-block-level uneditable-input"><%= email %></span>
          <% } else { %>
            <input name="members[<%= n %>][email]" class="input-block-level" type="text" value="">
          <% } %>
        </td>
        <td><big><a style="vertical-align: middle; font-weight: bold;" class="danger" role="remove-member" href="#">&times;</a></big></td>
      </tr>')
    $members = $('@project-members')
    
    $members.on 'click @remove-member', (e) ->
      $link = $(e.target)
      if $link.is('@remove-member')
        table = $link.parents('table:first')
        $link.parents('tr:first').remove()
        if $('td', table).length == 0
          table.addClass('hidden')
        false
    
    $input.typeahead
      minLength: 1,
      source: (query, process) ->
        $.getJSON url, { q: query }, (data) ->
          process(
            data.records.map (r) ->
              db[r.text] = r
              r.text
          )
    
    $input.on 'change', (e) ->
      last_name = @.value
      id = ''
      if record = db[last_name]
        last_name = record.last_name
        id = record.id
      else
        record =  {}
      $members.removeClass('hidden')
      $members.append $template(
        id: id
        last_name: last_name
        first_name: record.first_name
        middle_name: record.middle_name
        email: record.email
        state: record.state
        n: n
      )
      n = n + 1
      
      $input.val('')
      
  
$ ->
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
      minLength: 1
      source: (query, process) ->
        $.getJSON url, { q: query }, (data) ->
          process(
            data.records.map (r) ->
              db[r.text] = r
              r.text
          )
      highlighter: (item) ->
        item = item.replace(/@(.*)/, "@...")
        query = this.query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&')
        item.replace(new RegExp('(' + query + ')', 'ig'), ($1, match) ->
          '<strong>' + match + '</strong>'
        )
    
    $input.on 'change', (e) ->
      last_name = @.value
      id = ''
      email = ''
      if record = db[last_name]
        last_name = record.last_name
        email = record.email.replace(/@(.*)/, "@...")
        id = record.id
      else
        record =  {}
      $members.removeClass('hidden')
      $members.append $template(
        id: id
        last_name: last_name
        first_name: record.first_name
        middle_name: record.middle_name
        email: email
        state: record.state
        n: n
      )
      n = n + 1
      
      $input.val('')
  
  $('@project-invite-code-viewer').each (i, html) ->
    $link = $(html)
    $link.popover(
      html: true
    )
    $link.on 'click', (e) ->
      false
  
  $('@instant-finder').each (i, html) ->
    db = {}
    $finder = $(html)
    $finder.typeahead
      source: (query, process) ->
        $.getJSON $finder.data('source-url'), { q: query }, (data) ->
          process(
            data.records.map (r) ->
              db[r.text] = r.id
              r.text
          )
      updater: (item) ->
        id = db[item]
        if id
          document.location = $finder.data('redirect-to').replace('%s', id)
        item
  
  $("@instant-submit").each (i, html) ->
    db = {}
    $finder = $(html)
    $finder.typeahead
      source: (query, process) ->
        $.getJSON $finder.data('source-url'), { q: query }, (data) ->
          process(
            data.records.map (r) ->
              db[r.text] = r.id
              r.text
          )
      updater: (item) ->
        id = db[item]
        $finder.val(id)
        $finder.parents("form:first").submit()
        id
  
  google.setOnLoadCallback ->
    width = 720
    height = 300
    titleTextStyle =
      fontSize: 18
    
    $('.graph-pie').each (i, html) ->
      $graph = $(html)
      
      source = $graph.data('source')
      data = new google.visualization.DataTable();
      data.addColumn 'string', 'Name'
      data.addColumn 'number', 'Count'
      data.addRows(source)
    
      options =
        title: ""
        titleTextStyle: titleTextStyle
        width: width
        height: height
    
      chart = new google.visualization.PieChart($graph[0])
      chart.draw data, options
    
    $('.graph-bar').each (i, html) ->
      $graph = $(html)
      
      table = []
      
      source = $graph.data('source')
      
      data = new google.visualization.DataTable();
      data.addColumn 'string', 'Название'
      data.addColumn 'number', 'Количество'
      data.addRows($graph.data('source'))

      options =
        title: ""
        titleTextStyle: titleTextStyle
        width: width
        height: height
        hAxis:
          slantedText: true
          textStyle:
            fontSize: 12

      chart = new google.visualization.ColumnChart($graph[0])
      chart.draw data, options
    
    $('.cohort').each (i, html) ->
      setTimeout(->
        $graph = $(html)
        data = google.visualization.arrayToDataTable($graph.data("chart"))
        chart = new google.visualization.ColumnChart($graph[0])
        width = (data.getNumberOfRows() * data.getNumberOfColumns() * 12)
        unless width > 940
          width = 940
        options = 
          height: height
          width: width
          chartArea: { width: width - 100, height: '61%' }
          hAxis:
            textStyle:
              fontSize: 14
          vAxis:
            textStyle:
              fontSize: 14
          tooltip:
            textStyle:
              fontSize: 14
          legend:
            textStyle:
              fontSize: 14
            position: 'top'
        chart.draw(data, options)
      , 500 * i)
  
  $("@btn-urled").on "click", ->
    $button = $(@)
    $form = $button.parents("form:first")
    $form.prop("action", $button.data("url"))
    $form.submit()
    false
  
  $("@show-disabled-projects").on "click", ->
    $link = $(@)
    $link.parents("table:first").find("tr.hidden").removeClass("hidden")
    $link.parents("tr:first").remove()
    false
  
  $("@queue-shower").on "click", ->
    $link = $(@)
    $ul = $link.parents("ul:first")
    $container = $link.parents("div.thumbnail:first")
    $ul.find("@queue-active").removeClass("hidden")
    $ul.find("@queue-inactive").addClass("hidden")
    $ul.find("@log-active").addClass("hidden")
    $ul.find("@log-inactive").removeClass("hidden")
    $container.find("pre.log").hide()
    $container.find("pre.queue").show()
    false
  
  $("@log-shower").on "click", ->
    $link = $(@)
    $ul = $link.parents("ul:first")
    $container = $link.parents("div.thumbnail:first")
    $ul.find("@log-active").removeClass("hidden")
    $ul.find("@log-inactive").addClass("hidden")
    $ul.find("@queue-active").addClass("hidden")
    $ul.find("@queue-inactive").removeClass("hidden")
    $container.find("pre.queue").hide()
    $container.find("pre.log").show()
    false

  $(".reply-show-raw a").on "click", (e) ->
    $shower = $(@).parents(".reply-show-raw")
    $shower.prev().show()
    $shower.remove()
    false
  
  $("@block-account-form-opener").on "click", ->
    $link = $(@)
    $link.parents("td:first").find(".block-account-form").show()
    $link.remove()
    false
  
  $("@notice-shower").on "click", ->
    $notice = $("@notice-body[data-id='" + $(@).data("id") + "']")
    $notice.toggleClass("hidden")
    false

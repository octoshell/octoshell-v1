$ ->
  country_id = $("#organization_country_id").val()
  if country_id
    url = "/countries/#{country_id}/cities.json"
    $("#organization_city_title").data('source-url', url)
    $("#organization_city_title").typeahead
      source: (query, process) ->
        $.getJSON $("#organization_city_title").data('source-url'), { q: query }, (data) ->
          process(
            data.records.map (r) ->
              r.text
          )

  $("#organization_country_id").change ->
    country_id = $(this).val()
    $("#organization_city_title").val('').focus()
    url = "/countries/#{country_id}/cities.json"
    $("#organization_city_title").data('source-url', url)

    $("#organization_city_title").typeahead
      source: (query, process) ->
        $.getJSON $("#organization_city_title").data('source-url'), { q: query }, (data) ->
          process(
            data.records.map (r) ->
              r.text
          )
  $('#q_country_id_eq').change ->
    country_id = $(this).val()
    url = "/countries/#{country_id}/cities"
    select = $("#q_city_id_eq")
    select.data('source', url)
    reinit_select2(select)

  reinit_select2 = (el) ->
    select = $(el)
    options = select.find("option")
    $(options[0]).select()  if options.size() is 1
    options =
      placeholder: select2_localization[window.locale]
      allowClear: $(this).hasClass("clearable")

    options.ajax =
      url: select.data("source")
      dataType: "json"
      quietMillis: 100
      data: (term, page) ->
        q: $.trim(term)
        page: page
        per: 10

      results: (data, page) ->
        more = undefined
        more = (page * 10) < data.total
        results: data.records
        more: more

    options.dropdownCssClass = "bigdrop"
    options.initSelection = (element, callback) ->
      if element.val().length > 0
        $.getJSON select.data("source") + "/" + element.val(), {}, (data) ->
          callback
            id: data.id
            text: data.text


    select.select2 options

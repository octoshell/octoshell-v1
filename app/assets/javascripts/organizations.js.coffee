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
              r.title_ru
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
              r.title_ru
          )

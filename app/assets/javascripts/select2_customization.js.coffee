$ ->
  $('@instance-search').on 'change', ->
    input = $(@)
    document.location = input.data('url').replace('%s', input.val())
    
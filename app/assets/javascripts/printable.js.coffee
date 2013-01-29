$ ->
  $("a.printable").on 'click', ->
    $('#print-me').html $($(@).data('print')).clone()
    window.print()

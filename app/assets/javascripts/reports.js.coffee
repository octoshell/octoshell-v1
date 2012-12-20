# $ ->
#   $.fn.disable = ->
#     @[0].disabled = true
#   $.fn.undisable = ->
#     @[0].disabled = false
#   form = $('form.report-form')
#   $('input.input-shower', form).each (i, input) ->
#     rel = $($(input).data('rel'))
#     rel.disable() unless input.checked
#     $(input).on 'change', ->
#       if input.checked
#         rel.undisable()
#       else
#         rel.disable()

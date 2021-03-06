// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require role
//= require cookie
//= require underscore
//= require bootstrap
//= require raphael
//= require morris
//= require select2
//= require tablesorter
//= require datepicker
//= require jquery.expander.js
//= require_tree .

$(document).ready(function(){
  
  select2_localization = {
    ru: "Выберите значение",
    en: "Choose"
  }

  $('input.chosen, select.chosen').each(function(i, e){
    var select = $(e)
    var options = select.find('option')
    if (options.size() == 1) {
      $(options[0]).select()
    }
    options = {
      placeholder: select2_localization[window.locale],
      allowClear: $(this).hasClass('clearable')
    }
    
    if (select.hasClass('ajax')) {
      options.ajax = {
        url: select.data('source'),
        dataType: 'json',
        quietMillis: 100,
        data: function(term, page) {
          return {
            q: $.trim(term),
            page: page,
            per: 10
          }
        },
        results: function(data, page) {
          var more = (page * 10) < data.total
          return { results: data.records, more: more }
        }
      }
      options.dropdownCssClass = "bigdrop"
      options.initSelection = function (element, callback) {
        if (element.val().length > 0) {
          $.getJSON(select.data('source') + '/' + element.val(), {}, function(data) {
            callback({ id: data.id, text: data.text })
          })
        }
      }
    }
    select.select2(options)
  })
  
  $("select[multiple]=multiple").each(function(i, e){
    if (!$(e).hasClass('chosen')) {
      var select_all = $("<a href='#' class='select-all'>Выделить все</a>")
      $(e).before(select_all)
      select_all.click(function(){
        $(e).find("option").each(function(i, e){ e.selected = true })
        $(e).trigger('change')
        return false
      })
    }
  })
  
	$('#ticket_template').on('change', function(){
		var reply_message = $('#reply_message')
		if (_(reply_message.val()).isEmpty()) {
			reply_message.val($(this).val())
		} else {
			reply_message.val(reply_message.val() + '\n' + $(this).val())
		}
	});
	
	$(document).on('reload_form form', function(e){
	  var form = $(e.target)
	  $.get(form.data('reload-url'), function(data){
	    form.replaceWith(data)
	  })
	});
	
	$(document)
	  .on('ajax:success #new_ticket_tag', function(e, data, xhr){
  	  $('#tag_relations').trigger('reload_form')
  	})
  	.on('ajax:beforeSend #new_ticket_tag', function(e){
  	  $(e.target).find(':input').each(function(i, e){
  	    e.disabled = true
  	  })
  	})
  	.on('ajax:complete #new_ticket_tag', function(e){
  	  $(e.target).find(':input').each(function(i, e){
  	    if (e.type != 'submit') {
  	      e.value = ""
  	    }
  	    e.disabled = false
  	  })
  	})
  
  $('div.toggle-box').on('click > div.toggle', function(e){
    var box = $(e.target).parents('div.toggle-box:first')
    box.find('> div.object').toggle()
  })
  
  $('#ticket-template-maker').on('click', function(e){
    var data = $('#reply_message').val()
    var url = e.target.href + '?' + 'ticket_template[message]=' + data
    window.open(url, '_blank')
    return false
  })
  
  $('a.disabled').on('click', function(){ return false })
  
  var import_item_form = $('form.edit_import_item')
  if (import_item_form.length > 0) {
    $("a.user-choser", import_item_form).click(function(){
      var record = $(this).data('record')
      var default_email = $('#import_item_email').data('default-email')
      $('#import_item_email').val(record.email)
      $('#import_item_additional_email').val(default_email)
      return false
    })

    $("a.user-clear", import_item_form).click(function(){
      var record = $(this).data('record')
      _(record).each(function(value, key){
        if (value != "-") {
          $('#import_item_' + key).val(value)
        }
      })
      $('#import_item_additional_email').val("")
      return false
    })

    $("a.choser", import_item_form).click(function(){
      var record = $(this).data('record')
      _(record).each(function(value, key){
        if (value != "-") {
          $('#import_item_' + key).val(value)
        }
      })
      return false
    })
  }

  $('.datepicker').datepicker({ format: 'yyyy-mm-dd' })

  var menu = $('ul#top-menu')
  var drop = $('ul.dropdown-menu', menu)
  var prev = null
  var dropped = false
  
  $('li[class!="dropdown"]', menu).each(function(i, e){
    var li = $(e)
    if (!dropped && prev && (prev.position().left > li.position().left)) {
      dropped = true
      $('li.dropdown', menu).show()
      prev.appendTo(drop)
    } 
    if (dropped) {
      li.appendTo(drop)
    }
    prev = li
  })
});

(function($){
  $.fn.datepicker.dates['ru'] = {
    days: ["Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"],
    daysShort: ["Вск", "Пнд", "Втр", "Срд", "Чтв", "Птн", "Суб", "Вск"],
    daysMin: ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"],
    months: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"],
    monthsShort: ["Янв", "Фев", "Мар", "Апр", "Май", "Июн", "Июл", "Авг", "Сен", "Окт", "Ноя", "Дек"],
    today: "Сегодня"
  };
}(jQuery));

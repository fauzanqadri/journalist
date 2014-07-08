$(document).delegate "#journal-modal, #journal-account-modal, #user-modal", 'hidden.bs.modal', (e) ->
  $(e.target).remove()

$(document).ready ->
  $("#flash .alert").each (i, e) ->
    $(this).delay(i*1000).fadeIn('slow')
$(document).delegate "#flash .alert button.close", "click", (e) ->
  parent = $(e.target).parent(".alert")
  parent.fadeOut 'slow', () ->
    $(this).remove()

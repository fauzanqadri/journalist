# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("#journal-account-tables").dataTable
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#journal-account-tables').data('url')
    sPaginationType: "bootstrap"
    aoColumnDefs: [
      bSortable: false,
      aTargets: [3, 4]
    ]

// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$( document ).on('turbolinks:load', function() {
  if(!$('[id$="wrapper"]').length) {
    $('#events_teams_table').DataTable({
      stateSave: true
    });
  }
});

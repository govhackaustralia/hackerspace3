// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$( document ).on('ready turbolinks:load', function() {

  var windowObjectReference;
  var strWindowFeatures = "menubar=no,location=no,resizable=yes,scrollbars=yes,status=no,width=700,height=800";

  function openRequestedPopup(team_scorecards_path) {
    windowObjectReference = window.open(team_scorecards_path, 'Team Scorecards', strWindowFeatures);
  }

  function refreshParent() {
    window.opener.location.reload();
  }

  $('.open-team-scorecards').click(function (event) {
    event.preventDefault();
    var scorecard_id = $(this).data("id");
    openRequestedPopup(_admin_teams_path + '/' + scorecard_id + '/scorecards?popup=true');
  });

  $('#close-team-scorecards').click(function (event) {
    event.preventDefault();
    window.close();
  });

});

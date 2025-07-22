// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$( document ).on('ready turbolinks:load', function() {

  const strWindowFeatures = "menubar=no,location=no,resizable=yes,scrollbars=yes,status=no,width=700,height=800";

  const openRequestedPopup = (team_scorecards_path) => windowObjectReference = window.open(team_scorecards_path, 'Team Scorecards', strWindowFeatures);


  const refreshParent = () =>  window.opener.location.reload();
  

  $('.open-team-scorecards').click(function (event) {
    event.preventDefault();
    const team_id = $(this).data("id");
    const include_judges =$(this).data("include-judges");
    openRequestedPopup(_admin_teams_path + '/' + team_id + '/scorecards?include_judges='+ include_judges +'&popup=true');
  });

  $('#close-team-scorecards').click(function (event) {
    event.preventDefault();
    window.close();
  });

});

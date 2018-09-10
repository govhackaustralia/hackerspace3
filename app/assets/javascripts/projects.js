// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var windowObjectReference;
var strWindowFeatures = "menubar=yes,location=yes,resizable=yes,scrollbars=yes,status=yes";

function openRequestedPopup() {
  windowObjectReference = window.open(_scorecard_path, _scorecard_title, strWindowFeatures);
}

$('#open-scorecard').click(function (event) {
  openRequestedPopup();
  event.preventDefault();
});

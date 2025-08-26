// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require cable
//= require datatable
//= require datatable_responsive
//= require_tree .


$(document).ready(function() {
	$("p.alert, p.notice").click(function(event) {
		$(this).hide();
	});
});

$( document ).on('turbolinks:load', function() {
	// Initilize the table and save any state changes.
	const table = $('[id$="table"]').DataTable({
		stateSave: true,
		responsive: true
	});

	// To avoid duplicate table initializations, make sure turbolinks only caches
	// the orginial un-enhanced table.
	$( document ).on('turbolinks:before-cache', function() {
		table.destroy();
	});

	// Check if filter needs to be applied
	if ((window._search !== undefined) && (window._search.length > 0 )) {
		// Apply the filter param to the filter box.
		table.search(window._search);
		table.draw();

		// Clear the filter in the URL when the search param is updated.
		table.on( 'search.dt', function () {
			if ((table.search() !== window._search) && (window._search.length > 0 )) {
				const url = window.location.href;
				const tail = url.substring(url.lastIndexOf('/') + 1);
				
				// Remove any query parameters from the segment
				const clean_tail = tail.substring(0, tail.lastIndexOf('?'));

				// Clean up the document title by removing text after '#' symbol and whitespace
				const clean_title = document.title.replace(/#(.*?)\s/, '');

				history.replaceState({}, clean_title, clean_tail);
				document.title = clean_title;
				$('span.search').remove();
			}
		});
	}
});

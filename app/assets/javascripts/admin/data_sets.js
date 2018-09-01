// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$( document ).on('ready turbolinks:load', function() {
	$("#data_set_url").blur(function() {
		var url = $("#data_set_url").val();
		var separated = url.split("/dataset/");
		
		var data = {
			id: separated[1]
		}
		console.log("get");
		$.ajax({
			type: "GET",
			data: data,
			url: separated[0] + "/api/3/action/package_show",
			success: function (data) {
				$("#data_set_name").val(data.result.title);
				$("#data_set_description").val(data.result.notes);
			},
			dataType: "jsonp"
		})
	});
});
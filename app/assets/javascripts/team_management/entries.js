// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$( document ).on('ready turbolinks:load', function() {
	$("#team_data_set_url").blur(function() {
		const teamUrlData = $("#team_data_set_url").val().split("/dataset/");
		
		var data = {
			id: teamUrlData[1]
		}
		$.ajax({
			type: "GET",
			data: data,
			url: teamUrlData[0] + "/api/3/action/package_show",
			success: function (data) {
				$("#team_data_set_name").val(data.result.title);
				$("#team_data_set_description").val(data.result.notes);
				$("#hiddendescription").width($("#data_set_description").width());

				const content = data.result.notes.replace(/\n/g, "<br>");

				$("#hiddendescription").html(content);
				$("#team_data_set_description").css("height", $("#hiddendescription").outerHeight());
			},
			dataType: "jsonp"
		})
	});
	try {
	$("#hiddendescription").width($("#data_set_description").width());

	const content = $("#team_data_set_description").val().replace(/\n/g, "<br>");

	$("#hiddendescription").html(content);
	$("#team_data_set_description").css("height", $("#hiddendescription").outerHeight());
	} catch (e) {
		console.error('An error occured.', e)
	}
});
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
	$("#team_data_set_url").blur(function() {
		const url = $("#team_data_set_url").val();
		const separated = url.split("/dataset/");
		
		var data = {
			id: separated[1]
		}
		$.ajax({
			type: "GET",
			data: data,
			url: separated[0] + "/api/3/action/package_show",
			success: function (data) {
				$("#team_data_set_name").val(data.result.title);
				$("#team_data_set_description").val(data.result.notes);
				
				$("#hiddendescription").width($("#team_data_set_description").width());

				const content = data.result.notes.replace(/\n/g, "<br>");

				$("#hiddendescription").html(content);
				$("#team_data_set_description").css("height", $("#hiddendescription").outerHeight());
			},
			dataType: "jsonp"
		})
	});
	
	try {

	$("#hiddendescription").width($("#team_data_set_description").width());

	const content = $("#team_data_set_description").val().replace(/\n/g, "<br>");

	$("#hiddendescription").html(content);
	$("#team_data_set_description").css("height", $("#hiddendescription").outerHeight());

	} catch (e) {

		console.error("An error occurred:", e);

	}
});
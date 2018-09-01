// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$( document ).on('ready turbolinks:load', function() {
	$("#data_set_url").blur(function() {
		var url = $("#data_set_url").val();
		var separated = url.split("/dataset/");
		
		var data = {
			id: separated[1]
		}
		$.ajax({
			type: "GET",
			data: data,
			url: separated[0] + "/api/3/action/package_show",
			success: function (data) {
				$("#data_set_name").val(data.result.title);
				$("#data_set_description").val(data.result.notes);
				
				$("#hiddendescription").width($("#data_set_description").width());
				var content = data.result.notes.replace(/\n/g, "<br>");
				$("#hiddendescription").html(content);
				$("#data_set_description").css("height", $("#hiddendescription").outerHeight());
			},
			dataType: "jsonp"
		})
	});
});

$(".journal-post aside.comments form textarea").keyup(function(event) {
		
		$(".hiddencomment").width($(this).width());
		
		var content = $(this).val();
		
		content = content.replace(/\n/g, "<br>");
		$(".hiddencomment").html(content);
		$(this).css("height", $(".hiddencomment").outerHeight());
		$(this).parent().parent().removeClass("error");
		
	});
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$('#button1').click ->
		$('#step2').toggle('slow')
	$('#button2').click ->
		$('#step3').toggle('slow')
	$('#button3').click ->
		$('#step4').toggle('slow')
	$(".pathdiv").click ->
		beingedit = $(this).HTML
		alert(beingedit)
	$("#create_users_form")
		.bind("ajax:beforeSend", (evt, xhr, settings) ->
			$submitButton = $(this).find("submitbtn")
			$submitButton.data "origText", $(this).text()
			$submitButton.text "Submitting..."

		.bind("ajax:success", (evt, data, status, xhr) ->
			$form = $(this)
			$form.find("div.validation-error").empty()
			$("#confirm").append xhr.responseText
			$('#confirm').toggle('slow')

		.bind("ajax:complete", (evt, xhr, status) ->
			$submitButton = $(this).find("submitbtn")
			$submitButton.text $(this).data("origText")

		.bind "ajax:error", (evt, xhr, status, error) ->
			$form = $(this)
			errors = undefined
			errorText = undefined

			try
				errors = $.parseJSON(xhr.responseText)
			catch err
				errors = message: "Please reload the page and try again"

			errorText = "There were errors with the submission: \n<ul>"

			for error of errors
				errorText += "<li>" + error + ": " + errors[error] + "</li> "
				errorText += "</ul>"
				$form.find("div.validation-error").html errorText




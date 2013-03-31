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
	$(".pathdiv").blur ->
		current = oFormObject.elements["pathfield"].value
		newpath = $(this).innerHTML
		current.replace(beingedit,newpath)
		oFormObject.elements["pathfield"].value = newpath




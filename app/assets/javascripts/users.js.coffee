$ ->

	$('#button1').click ->
		$('#step2').fadeIn()
		$('#button1').hide()

	$('#button2').click ->
		$('#step3').fadeIn()
		$('#button2').hide()

	$('#button3').click ->
		$('#sched').fadeIn()
		$('#button3').hide()

	$('#button4no').click ->
		$('#sens').fadeIn()
		$('#sched_checkbox').prop "checked", false
		status("#sched_checkbox","#button4yes","#button4no")

	$('#button4yes').click ->
		$('#sched_act').fadeIn()
		$('#sens').fadeIn()
		$('#sched_checkbox').prop "checked", true
		status("#sched_checkbox","#button4yes","#button4no")

	$('#button5no').click ->
		$('#end').fadeIn()
		$('#sens_checkbox').prop "checked", false
		status("#sens_checkbox","#button5yes","#button5no")

	$('#button5yes').click ->
		$('#end').fadeIn()
		$('#sens_checkbox').prop "checked", true
		status("#sens_checkbox","#button5yes","#button5no")

	$('#new_link').click ->
		$('#street_text_fields').append "<div class='each_street'> <input class='streetfield' type='text'/> <a class='kill_link'> X </a> </div>"
		redoSreets()

	$('#send').click ->
		redoSreets()

	$("#street_text_fields").focusout ->
	    redoSreets()

$('#street_text_fields').on 'click','.kill_link', ->
	$(this).parent().remove()
	redoSreets()

 $ ->
	redoSreets()

redoSreets = ->
	tmp = ""
	$(".streetfield").each ->
  		tmp += $(this).val().replace(/[^a-z0-9],./gi, "") + ","
  	tmp = tmp.slice(0,-1)

  	$('#pathfield').val(tmp)

status = (element,oui,non) ->
	isChecked = (if $(element).prop("checked") then true else false)
	if isChecked == true
		$(non).addClass('inactive')
		$(non).removeClass('button')
		$(oui).addClass('button')
		$(oui).addClass('yes')
		$(oui).removeClass('inactive')
	else if isChecked == false
		$(oui).removeClass('button')
		$(oui).removeClass('yes')
		$(oui).addClass('inactive')
		$(non).removeClass('inactive')
		$(non).addClass('button')
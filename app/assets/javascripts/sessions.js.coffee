$ ->
	status("#sched_checkbox","#sched-u-yes","#button4no")
	status("#sens_checkbox","#sens-u-yes","#sens-u-no")

	$("#street_text_fields").focusout ->
		redoSreets()
	$('#button1').click ->
		$('#step2').fadeIn()
		$('#button1').hide()

	$('#button2').click ->
		$('#step3').fadeIn()
		$('#button2').hide()

	$('#button3').click ->
		$('#sched').fadeIn()
		$('#button3').hide()

	$('#sched-u-no').click ->
		$('#sched_checkbox').prop "checked", false
		$('#sched_act').fadeOut()
		status("#sched_checkbox","#sched-u-yes","#sched-u-no")

	$('#sched-u-yes').click ->
		$('#sched_act').fadeIn()
		$('#sched_checkbox').prop "checked", true
		status("#sched_checkbox","#sched-u-yes","#sched-u-no")

	$('#sens-u-no').click ->
		$('#sens_checkbox').prop "checked", false
		status("#sens_checkbox","#sens-u-yes","#sens-u-no")

	$('#sens-u-yes').click ->
		$('#sens_checkbox').prop "checked", true
		status("#sens_checkbox","#sens-u-yes","#sens-u-no")

	$('#street_text_fields').on 'click','.kill_link', ->
		$(this).parent().remove()
		redoSreets()

$('#new_link').click ->
		$('#street_text_fields').append "<div class='each_street'> <input class='streetfield' type='text'/> <a class='kill_link'> X </a> </div>"
		redoSreets()

redoSreets = ->
	tmp = ""
	$(".streetfield").each ->
  		tmp += $(this).val().replace(/[^a-z0-9],./, "") + ","
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


	
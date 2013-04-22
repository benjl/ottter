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
		$('#button4yes').removeClass('yes')
		$('#button4yes').removeClass('button')
		$('#button4yes').addClass('inactive')

	$('#button4yes').click ->
		$('#sched_act').fadeIn()
		$('#sched_checkbox').prop "checked", true
		$('#button4no').removeClass('button')
		$('#button4no').addClass('inactive')

	$('#done_sched').click ->
		$('#sens').fadeIn()

	$('#button5no').click ->
		$('#end').fadeIn()
		$('#sens_checkbox').prop "checked", false
		$('#button5yes').removeClass('yes')
		$('#button5yes').removeClass('button')
		$('#button5yes').addClass('inactive')

	$('#button5yes').click ->
		$('#end').fadeIn()
		$('#sens_checkbox').prop "checked", true
		$('#button5no').removeClass('button')
		$('#button5no').addClass('inactive')

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
  		if $(this).val() == "ON-417" 
		    tmp += 'Queensway,Hwy 417,'
  	tmp = tmp.slice(0,-1)

  	$('#pathfield').val(tmp)



	
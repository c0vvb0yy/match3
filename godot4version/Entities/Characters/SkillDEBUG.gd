extends Button


#TODO: buggy when you match_all_pieces of color with more than 1 color consequtively
#error occurs at combo counter, it steps up with however many colors are getting cleare

func _on_pressed():
	take_damage()

func take_damage():
	PartyManager.take_damage(3)

func do_skill():
	if GameManager.grid_state != GameManager.GRID_STATES.ready:
		return
	GameManager.grid_state = GameManager.GRID_STATES.wait
	var cost = 0
	var cost_color = Util.COLOR.Flesh
	if GameManager.current_pieces[cost_color] >= cost:
		GameManager.emit_signal("collect_pieces", cost_color, -cost)
		#Skills.collect_all_pieces_of_color(Util.COLOR.Void)
		Skills.turn_pieces_into_color(Util.COLOR.Void, Util.COLOR.Flesh)
		#Skills.match_all_pieces_of_color(Util.COLOR.Life)
		#Skills.match_all_pieces_of_color(Util.COLOR.Void)
		#Skills.match_all_pieces_of_color(Util.COLOR.Flesh)
	GameManager.grid_state = GameManager.GRID_STATES.move

#Character and skill ideas
	#'Enty -> turn all Life into Void
	#Ian -> turn all Void into Divine
		#Ian Oracle of Strife -> match all Void and Life
		
#enemy skills:
	#disable random color character(s) for x turns
	#"Change the past" - scramble players inventory 

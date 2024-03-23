extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	if GameManager.grid_state != GameManager.GRID_STATES.ready:
		return
	GameManager.grid_state = GameManager.GRID_STATES.wait
	var cost = 0
	var cost_color = Util.COLOR.Flesh
	if GameManager.current_pieces[cost_color] >= cost:
		GameManager.emit_signal("collect_pieces", cost_color, -cost)
		#Skills.collect_all_pieces_of_color(Util.COLOR.Void)
		#Skills.turn_pieces_into_color(Util.COLOR.Divine, Util.COLOR.Flesh)
		Skills.match_all_pieces_of_color(Util.COLOR.Life)
		Skills.match_all_pieces_of_color(Util.COLOR.Void)
	pass # Replace with function body.


#Character and skill ideas
	#'Enty -> turn all Life into Void
	#Ian -> turn all Void into Divine
		#Ian Oracle of Strife -> match all Void and Life
		
#enemy skills:
	#disable random color character for x turns

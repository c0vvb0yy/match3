extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	var cost = 10
	var cost_color = Util.COLOR.Flesh
	if GameManager.current_pieces[cost_color] >= cost:
		GameManager.emit_signal("collect_pieces", cost_color, -cost)
		Skills.turn_pieces_into_color(Util.COLOR.Divine, Util.COLOR.Flesh)
	pass # Replace with function body.

extends Control


func _ready():
	GameManager.state = GameManager.STATES.menu
	pass # Replace with function body.


func _process(delta):
	pass


func _on_button_pressed():
	GameManager.start_game()

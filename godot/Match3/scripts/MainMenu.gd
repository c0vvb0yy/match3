extends Node2D


func _ready():
	pass


func _on_PlayButton_pressed():
	if GameManager.heroes.size() < 1:
		get_tree().change_scene("res://scenes/ChooseStartingHero.tscn")
	else:
		get_tree().change_scene("res://scences/Overworld.tscn")
	pass 

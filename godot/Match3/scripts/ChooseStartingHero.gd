extends Control

var possible_heroes = [
	preload("res://scenes/Anthrazit.tscn"),
	preload("res://scenes/Zaavan.tscn")
];

func _on_AnthraButton_pressed():
	GameManager.heroes.append(possible_heroes[0])
	get_tree().change_scene("res://scences/Overworld.tscn")
	pass # Replace with function body.


func _on_ZaavButton_pressed():
	GameManager.heroes.append(possible_heroes[1])
	get_tree().change_scene("res://scences/Overworld.tscn")
	pass # Replace with function body.


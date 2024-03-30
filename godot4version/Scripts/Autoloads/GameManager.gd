extends Node

enum STATES{
	menu,
	fight,
}

var state

var match_3_scene = preload("res://Entities/Game.tscn")
#use this for like
#round?
#which enemies to load
#giving out exp

func _ready():
	for node in $"/root".get_children():
		if node.name == "Game":
			EnemyManager.spawn_enemy()

func start_game():
	GameManager.state = GameManager.STATES.fight
	get_tree().change_scene_to_packed(match_3_scene)
	await get_tree().create_timer(0.1).timeout
	EnemyManager.spawn_enemy()

extends Node

signal gain_exp

enum STATES{
	menu,
	fight,
	level_up
}

var state

var match_3_scene = preload("res://GameScenes/Game.tscn")
var level_up_scene = preload("res://GameScenes/level_up.tscn")
#use this for like
#round?
#which enemies to load
#giving out exp

func _ready():
	for node in $"/root".get_children():
		if node.name == "Game":
			EnemyManager.spawn_enemy()

func save_party():
	for char in PartyManager.party:
		char.reparent(PartyManager)

func start_game():
	save_party()
	state = STATES.fight
	get_tree().change_scene_to_packed(match_3_scene)
	await get_tree().create_timer(0.1).timeout
	PartyManager.init_party()
	EnemyManager.spawn_enemy()

func init_level_up():
	save_party()
	state = STATES.level_up
	get_tree().change_scene_to_packed(level_up_scene)
	await get_tree().create_timer(0.1).timeout
	gain_exp.emit(EnemyManager.gathered_exp)

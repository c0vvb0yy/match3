extends Node

signal register_match
signal apply_combo
signal hp_change
var party_hp : int
var current_hp : int

func take_damage(amount:int):
	if current_hp == 0:
		current_hp = party_hp
	current_hp -= amount
	hp_change.emit(current_hp)
	if current_hp <= 0:
		game_over()

func game_over():
	print("rip")


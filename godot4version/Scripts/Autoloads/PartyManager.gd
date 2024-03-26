extends Node

signal register_match
signal apply_combo
signal hp_change
signal attack_over
var party_hp : int
var current_hp : int
var party_size = 2
var finished_party_member_count : int
func take_damage(amount:int):
	if current_hp == 0:
		current_hp = party_hp
	current_hp -= amount
	hp_change.emit(current_hp)
	if current_hp <= 0:
		game_over()

func game_over():
	print("rip")

func register_attack():
	finished_party_member_count += 1
	if finished_party_member_count == party_size:
		attack_over.emit()
		finished_party_member_count = 0

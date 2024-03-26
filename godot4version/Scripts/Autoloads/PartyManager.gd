extends Node

signal register_match
signal apply_combo
signal hp_change
signal attack_over
var party_hp : int
var current_hp : int
var party_size = 2
var finished_party_member_count : int

var damage := []

func take_damage(amount:int):
	if current_hp == 0:
		current_hp = party_hp
	current_hp -= amount
	hp_change.emit(current_hp)
	if current_hp <= 0:
		game_over()

func game_over():
	print("rip")

func register_attack(damage, main_color, sec_color):
	#damage.append([damage, main_color])
	EnemyManager.register_damage(damage, main_color)
	if sec_color != main_color:
		EnemyManager.register_damage(damage, sec_color)
	finished_party_member_count += 1
	if finished_party_member_count == party_size:
		attack_over.emit()
		finished_party_member_count = 0

func heal(amount:int):
	current_hp += amount
	if current_hp > party_hp:
		current_hp = party_hp
	hp_change.emit(current_hp)

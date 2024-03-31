extends Node

signal party_ready
signal register_match
signal apply_combo
signal hp_change
signal attack_over
var party_hp : int
var current_hp : int
var finished_party_member_count : int
var damages := []

var party_scenes := [
	preload("res://Entities/Characters/Heroes/Zaavan.tscn"),
	preload("res://Entities/Characters/Heroes/character_DEBUG.tscn"),
]
var party := ['zaav', 'ian']

func init_party():
	if party.size() == 0:
		for hero in party_scenes:
			var chara = hero.instantiate()
			add_child(chara)
			party.append(chara)
	party_hp = 0
	for hero in party:
		party_hp += Characters.try_get_value(hero, Characters.data.HP)
	party_ready.emit()

#TODO: /consider, have type advantages also apply to party from enemy attacks
func take_damage(amount:int):
	if current_hp == 0:
		current_hp = party_hp
	current_hp -= amount
	if current_hp <= 0:
		current_hp = 0
		game_over()
	hp_change.emit(current_hp)

func game_over():
	GridManager.disable_grid(true)

func register_attack(damage, main_color, sec_color):
	if damage != 0:
		damages.append([damage, main_color])
		#EnemyManager.register_damage(damage, main_color)
		if sec_color != main_color:
			damages.append([damage, sec_color])
	finished_party_member_count += 1
	if finished_party_member_count == party.size():
		if damages.size() == 0:
			attack_over.emit()
			return
		attack()#attack_over.emit()
		finished_party_member_count = 0

func attack():
	for att in damages:
		EnemyManager.register_damage(att[0], att[1])
	await get_tree().create_timer(0.5).timeout
	damages.clear()

func heal(amount:int):
	current_hp += amount
	if current_hp > party_hp:
		current_hp = party_hp
	hp_change.emit(current_hp)

func spawn_party(parent:Node):
	for chara in party:
		var hero = Characters.char_scenes[chara].instantiate()
		parent.add_child(hero)

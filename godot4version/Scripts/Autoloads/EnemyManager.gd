extends Node

signal take_damage
signal damage_finished

var hp
var color : Util.COLOR

var recieved_attacks := 0
var finished_attacks := 0

var enemys = [
	preload("res://Entities/Enemy/enemy.tscn"),
	preload("res://Entities/Enemy/enemy_flesh.tscn"),
	preload("res://Entities/Enemy/enemy_machine.tscn"),
	preload("res://Entities/Enemy/enemy_void.tscn"),
	preload("res://Entities/Enemy/enemy_life.tscn"),
	
]

const effective := 1.5
const not_effective := 0.5
const neutral := 1.0
const very_effective := 2.0

static var flesh_dict = {
	Util.COLOR.Flesh: neutral,
	Util.COLOR.Machine: not_effective,
	Util.COLOR.Divine: effective,
	Util.COLOR.Void: neutral,
	Util.COLOR.Life: neutral
}
static var machine_dict = {
	Util.COLOR.Flesh: effective,
	Util.COLOR.Machine: neutral,
	Util.COLOR.Divine: not_effective,
	Util.COLOR.Void: neutral,
	Util.COLOR.Life: neutral,
}
static var divine_dict = {
	Util.COLOR.Flesh: not_effective,
	Util.COLOR.Machine: effective,
	Util.COLOR.Divine: neutral,
	Util.COLOR.Void: neutral,
	Util.COLOR.Life: neutral,
}
static var void_dict = {
	Util.COLOR.Flesh: neutral,
	Util.COLOR.Machine: neutral,
	Util.COLOR.Divine: neutral,
	Util.COLOR.Void: neutral,
	Util.COLOR.Life: very_effective,
}
static var life_dict = {
	Util.COLOR.Flesh: neutral,
	Util.COLOR.Machine: neutral,
	Util.COLOR.Divine: neutral,
	Util.COLOR.Void: very_effective,
	Util.COLOR.Life: neutral,
}

func _ready():
	spawn_enemy()
	pass

func register_damage(amount, attack_color):
	#print("Initial damage: ",amount, "of: ", attack_color)
	var type_dict = get_effectiveness(attack_color)
	var multiplier = type_dict[color]
	var final_amount = amount * multiplier
	#print("type damage: ",amount, "of: ", attack_color)
	recieved_attacks += 1
	take_damage.emit(amount, final_amount, attack_color)


func get_effectiveness(attack_color):
	match attack_color:
		Util.COLOR.Flesh:
			return flesh_dict
		Util.COLOR.Machine:
			return machine_dict
		Util.COLOR.Divine:
			return divine_dict
		Util.COLOR.Void:
			return void_dict
		Util.COLOR.Life:
			return life_dict

func spawn_enemy():
	var parent = $"/root/Game/EnemyPlacement"
	var index = randi_range(0, enemys.size()-1)
	var enemy = enemys[index].instantiate()
	parent.add_child(enemy)

func register_finished_attack():
	finished_attacks += 1
	if finished_attacks == recieved_attacks:
		finished_attacks = 0
		recieved_attacks = 0
		damage_finished.emit()

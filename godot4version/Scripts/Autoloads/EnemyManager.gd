extends Node

signal take_damage

var hp
var color : Util.COLOR

var enemy

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
func register_damage(amount, attack_color):
	#print("Initial damage: ",amount, "of: ", attack_color)
	var type_dict = get_effectiveness(attack_color)
	var multiplier = type_dict[color]
	amount *= multiplier
	#print("type damage: ",amount, "of: ", attack_color)
	take_damage.emit(amount)

static func get_effectiveness(attack_color):
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

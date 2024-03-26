extends Node

signal take_damage

var hp
var color : Util.COLOR

var enemy

const effective := 1.5
const not_effective := 0.5
const neutral := 1.0
const very_effective := 2.0

var flesh_dict = {
	Util.COLOR.Flesh: neutral,
	Util.COLOR.Machine: not_effective,
	Util.COLOR.Divine: effective,
	Util.COLOR.Void: neutral,
	Util.COLOR.Life: neutral
}
var machine_dict = {
	Util.COLOR.Flesh: effective,
	Util.COLOR.Machine: neutral,
	Util.COLOR.Divine: not_effective,
	Util.COLOR.Void: neutral,
	Util.COLOR.Life: neutral,
}
var divine_dict = {
	Util.COLOR.Flesh: not_effective,
	Util.COLOR.Machine: effective,
	Util.COLOR.Divine: neutral,
	Util.COLOR.Void: neutral,
	Util.COLOR.Life: neutral,
}
var void_dict = {
	Util.COLOR.Flesh: neutral,
	Util.COLOR.Machine: neutral,
	Util.COLOR.Divine: neutral,
	Util.COLOR.Void: neutral,
	Util.COLOR.Life: very_effective,
}
var life_dict = {
	Util.COLOR.Flesh: neutral,
	Util.COLOR.Machine: neutral,
	Util.COLOR.Divine: neutral,
	Util.COLOR.Void: very_effective,
	Util.COLOR.Life: neutral,
}

func register_damage(amount, color):
	take_damage.emit(amount)
	pass

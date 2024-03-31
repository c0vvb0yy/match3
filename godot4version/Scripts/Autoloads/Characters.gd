extends Node

enum data{
	MAINCOLOR,
	SECCOLOR,
	BASE_HP,
	HP,
	BASE_ATK,
	ATK,
	LEVEL,
	HP_MULT,
	ATK_MULT,
	SKILL_COLOR,
	SKILL_COST,
	SKILL_NAME,
	SKILL_DESC,
	CURRENT_EXP,
	EXP_TO_NEXT_LEVEL
}

signal get_exp
signal level
signal exp_finished
var char_scenes ={
	'default' : load("res://Entities/Characters/Heroes/character_DEBUG.tscn"),
	'zaav' : load("res://Entities/Characters/Heroes/Zaavan.tscn"),
	'ian' : load("res://Entities/Characters/Heroes/Ian.tscn")
}

var default = {
	data.MAINCOLOR : Util.COLOR.Flesh,
	data.SECCOLOR : Util.COLOR.Flesh,
	data.BASE_HP : 10,
	data.HP : 10,
	data.BASE_ATK : 5,
	data.ATK : 5,
	data.LEVEL: 1,
	data.HP_MULT: 1.5,
	data.ATK_MULT: 1.1,
	data.SKILL_COLOR: Util.COLOR.Flesh,
	data.SKILL_COST: 1,
	data.SKILL_NAME: "Skill",
	data.SKILL_DESC: "Skill Description",
	data.CURRENT_EXP: 0,
	data.EXP_TO_NEXT_LEVEL: 7
}

var zaav = {
	data.MAINCOLOR : Util.COLOR.Divine,
	data.SECCOLOR : Util.COLOR.Void,
	data.BASE_HP : 7,
	data.HP : 7,
	data.BASE_ATK: 10,
	data.SKILL_COLOR : Util.COLOR.Divine,
	data.SKILL_COST : 10,
}

var ian = {
	data.MAINCOLOR : Util.COLOR.Life,
	data.SECCOLOR : Util.COLOR.Life,
}

##Will look if the character dictionary holds a value for a specified stat, 
##if it doesn't, the value from the default dictionary will get retrieved and add it to the character dictionary
func try_get_value(character, stat:data) -> Variant:
	var chara = get(character)
	if !chara.has(stat):
		chara[stat] = default[stat]
	return chara.get(stat)

func calc_next_level_exp(level) -> int:
	var next_level_exp = level * 3 * log(level*3)+5.5
	var prev_level_exp = (level-1) * 3 * log((level-1)*3)+5.5
	var diff = next_level_exp - prev_level_exp
	return diff

func update_combat_stats_of(character):
	var dict = get(character)
	var level = try_get_value(character, data.LEVEL)
	var base_hp = try_get_value(character, data.BASE_HP)
	var hp_multiplier = try_get_value(character, data.HP_MULT)
	dict[data.HP] = base_hp * (hp_multiplier * level)
	var base_atk = try_get_value(character, data.BASE_ATK)
	var atk_multiplier = try_get_value(character, data.ATK_MULT)
	dict[data.ATK] = base_atk * (atk_multiplier * level)

@warning_ignore("shadowed_global_identifier")
func receive_exp(character, exp:int, starting_level):
	print("receiving exp: ", exp)
	if exp == 0:
		return
	get_exp.emit(character, exp)
	var dict = get(character)
	#var current_exp = try_get_value(character, data.CURRENT_EXP)
	var needed_exp = try_get_value(character, data.EXP_TO_NEXT_LEVEL)
	print("needed: ", needed_exp)
	if exp > needed_exp:
		level_up(character)
		receive_exp(character, exp-needed_exp, starting_level)
	else: 
		try_get_value(character, data.CURRENT_EXP) 
		dict[data.CURRENT_EXP] += needed_exp - exp 
		var new_level = try_get_value(character, data.LEVEL)
		var level_diff = new_level - starting_level
		exp_finished.emit(character, level_diff)

func level_up(chara):
	var character = get(chara)
	try_get_value(chara, data.LEVEL)
	character[data.LEVEL] += 1
	character[data.EXP_TO_NEXT_LEVEL] = calc_next_level_exp(character[data.LEVEL])
	character[data.CURRENT_EXP] = 0
	update_combat_stats_of(chara)
	#print(character[data.LEVEL], "exp needed for next level: ", character[data.EXP_TO_NEXT_LEVEL])
	#level.emit(chara)


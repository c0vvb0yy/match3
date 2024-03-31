extends Node

var char_scenes ={
	'default' : load("res://Entities/Characters/Heroes/character_DEBUG.tscn"),
	'zaav' : load("res://Entities/Characters/Heroes/Zaavan.tscn"),
	'ian' : load("res://Entities/Characters/Heroes/Ian.tscn")
}

var default = {
	"main_color" : Util.COLOR.Flesh,
	"sec_color" : Util.COLOR.Flesh,
	"base_hp" : 10,
	"hp" : 10,
	"base_atk" : 5,
	"atk" : 5,
	"level": 1,
	"hp_multiplier": 1.5,
	"atk_multiplier": 1.1,
	"skill_color": Util.COLOR.Flesh,
	"skill_cost": 1,
	"skill_name": "Skill",
	"skill_desc": "Skill Description",
	"current_exp": 0,
	"exp_to_next_level": 7
}

var zaav = {
	"main_color" : Util.COLOR.Divine,
	"sec_color" : Util.COLOR.Void,
	"base_hp" : 7,
	"hp" : 7,
	"base_atk": 10,
	"skill_color" : Util.COLOR.Divine,
	"skill_cost" : 10,
}

var ian = {
	"main_color" : Util.COLOR.Life,
	"sec_color" : Util.COLOR.Life,
}

##Will look if the character dictionary holds a value for a specified stat, 
##if it doesn't, the value from the default dictionary will get retrieved and add it to the character dictionary
func try_get_value(character, stat:String) -> Variant:
	var chara = get(character)
	if !chara.has(stat):
		chara[stat] = default[stat]
	return chara.get(stat)

func calc_next_level_exp(level) -> int:
	return level * 3 * log(level*3)+5.5

func update_combat_stats_of(character):
	var level = try_get_value(character, "level")
	var base_hp = try_get_value(character, "base_hp")
	var hp_multiplier = try_get_value(character, "hp_multiplier")
	character["hp"] = base_hp * (hp_multiplier * level)
	var base_atk = try_get_value(character, "base_atk")
	var atk_multiplier = try_get_value(character, "atk_multiplier")
	character["atk"] = base_atk * (atk_multiplier * level)

@warning_ignore("shadowed_global_identifier")
func receive_exp(character, exp:int):
	#var current_exp = try_get_value(character, "experience")
	var needed_exp = try_get_value(character, "exp_to_next_level")
	if exp > needed_exp:
		level_up(character)
		receive_exp(character, exp-needed_exp)
	else: 
		character["experience"] += exp

func level_up(character):
	try_get_value(character, "level")
	character["level"] += 1
	character["exp_to_next_level"] = calc_next_level_exp(character["level"])


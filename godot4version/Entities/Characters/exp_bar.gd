extends TextureProgressBar

var character
var exp
var starting_hp
var starting_atk
var new_hp
var new_atk
var level_diff
var stats
@onready
var stats_label = $StatDifferences

func _ready():
	Characters.get_exp.connect(register_exp)
	Characters.exp_finished.connect(get_exp)

func init(chara):
	character = chara
	max_value = Characters.try_get_value(character, Characters.data.EXP_TO_NEXT_LEVEL)
	value = Characters.try_get_value(character, Characters.data.CURRENT_EXP)
	

func get_exp(chara, level_difference, start_hp, start_atk):
	if chara != character:
		return
	level_diff = level_difference
	starting_atk = start_atk
	starting_hp = start_hp
	set_up_stats(chara)
	display_stats(0)
	for i in range(level_difference, -1, -1):
		if i == 0:
			await fill_bar(Characters.try_get_value(character, Characters.data.CURRENT_EXP))
		else:
			await fill_bar(Characters.try_get_value(character, Characters.data.EXP_TO_NEXT_LEVEL))
		if value == max_value:
			Characters.level.emit(character)


func fill_bar(fill_value):
	max_value = Characters.try_get_value(character, Characters.data.EXP_TO_NEXT_LEVEL)
	value = 0
	var tween = create_tween()
	tween.tween_property(self, "value", fill_value, .2)
	await tween.finished

func register_exp(chara, exp_received):
	if chara == character:
		exp = exp_received

func set_up_stats(character):
	new_atk = Characters.try_get_value(character, Characters.data.ATK)
	new_hp = Characters.try_get_value(character, Characters.data.HP)
	var atk_diff = new_atk - starting_atk
	var hp_diff = new_hp - starting_hp
	stats = [level_diff, atk_diff, hp_diff]

func display_stats(index):
	if level_diff == 0:
		stats_label.text = ""
		return
	var stat_string = str("[center]+",stats[index])
	match index:
		0:
			stat_string += str(" Levels!")
		1:
			stat_string += str(" ATK!")
		2:
			stat_string += str(" HP!")
	stats_label.text = stat_string
	var up_tween = create_tween()
	up_tween.tween_property(stats_label, "position:y", -150, .6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await up_tween.finished
	var down_tween = create_tween()
	down_tween.tween_property(stats_label, "position:y", -80, .6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await down_tween.finished
	var next_index = index + 1
	if next_index == stats.size():
		next_index = 0
	display_stats(next_index)

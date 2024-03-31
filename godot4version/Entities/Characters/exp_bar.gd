extends TextureProgressBar

var character
var exp

func _ready():
	Characters.get_exp.connect(register_exp)
	Characters.exp_finished.connect(get_exp)

func init(chara):
	character = chara
	max_value = Characters.try_get_value(character, Characters.data.EXP_TO_NEXT_LEVEL)
	value = Characters.try_get_value(character, Characters.data.CURRENT_EXP)
	

func get_exp(chara, level_difference):
	if chara != character:
		return
	print(character, ": ", exp)
	for i in range(level_difference, -1, -1):
		if i == 0:
			await fill_bar(Characters.try_get_value(character, Characters.data.CURRENT_EXP))
		else:
			await fill_bar(Characters.try_get_value(character, Characters.data.EXP_TO_NEXT_LEVEL))
		if value == max_value:
			Characters.level.emit(character)
	#for exp_received in exp:
		

func fill_bar(fill_value):
	max_value = Characters.try_get_value(character, Characters.data.EXP_TO_NEXT_LEVEL)
	value = 0
	#print(character, " has: ", curr_exp)
	#print(character, " gotten: ", exp_received)
	#print("expected value: ", curr_exp+exp_received)
	#print(character, "needs: ", max_value)
	#print("---------------------------------------------")
	var tween = create_tween()
	tween.tween_property(self, "value", fill_value, .2)
	await tween.finished

func register_exp(chara, exp_received):
	if chara == character:
		exp = exp_received

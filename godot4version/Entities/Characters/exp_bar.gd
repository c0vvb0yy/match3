extends TextureProgressBar

var character
var exp_received

func set_up(hero):
	character = hero
	max_value = character.experience_needed
	value = character.experience
	exp_received = EnemyManager.gathered_exp
	var tween = create_tween()
	tween.tween_property(self, "value", value+exp_received, 1.0)
	await tween.finished

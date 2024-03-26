extends Control

@onready
var label = $Label
var initial_damage
var final_damage
var is_finished := false
var is_final_greater := false
#func _process(delta):
	#if is_finished:
		#await get_tree().create_timer(1.3).timeout
		#queue_free()
	#if initial_damage != final_damage:
		##initial_damage = lerp(float(initial_damage), float(final_damage), delta * 10)
		#
		##if final_damage > initial_damage:
			##scale = lerp(scale, Vector2(2,2), delta * 5) 
			##tween.tween_method(resize_text, Vector2(1,1), Vector2(2,2), 0.5)
			##tween.tween_property(self, "position", Vector2(50, 0), .2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		##if final_damage < initial_damage:
			##scale = lerp(scale, Vector2(0.75,0.75), delta * 5) 
			##tween.tween_method(resize_text, Vector2(1,1), Vector2(0.75,0.75), 0.5)
			##tween.tween_property(self, "position", Vector2(-50, 0), .2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		#if initial_damage >= final_damage-10:
			#initial_damage = final_damage
			#is_finished = true
		#label.text = str(round(initial_damage))

func set_damage(init, final, dmg_color):
	initial_damage = init
	final_damage = final
	is_final_greater = final_damage > initial_damage
	label.text = str(round(initial_damage))
	self.modulate = Util.color_modulates[dmg_color]
	var tween = create_tween()
	if is_final_greater:
		tween.tween_method(lerper, initial_damage, final_damage, .8).set_ease(Tween.EASE_IN).set_delay(.5).set_trans(Tween.TRANS_SINE)
	else:
		tween.tween_method(lerper, final_damage, initial_damage, .8).set_ease(Tween.EASE_IN).set_delay(.5).set_trans(Tween.TRANS_SINE)
	await tween.finished

func resize_text(new_scale):
	scale = Vector2(new_scale)

func lerper(value):
	initial_damage = value
	label.text = str(round(initial_damage))
	if is_final_greater:
		if initial_damage >= final_damage-5:
			initial_damage = final_damage
			label.text = str(round(initial_damage))
			await get_tree().create_timer(1.3).timeout
			queue_free()
	else:
		if initial_damage >= final_damage + 5:
			initial_damage = final_damage
			label.text = str(round(initial_damage))
			await get_tree().create_timer(1.3).timeout
			queue_free()
	if initial_damage == final_damage:
		await get_tree().create_timer(1.3).timeout
		queue_free()
#func show_damage(initial_damage, final_damage):
	
	#if target == 0:
		#text = ""
	#if current != target:
		#current = lerp(int(current), int(target), delta * 10)
		#scale = lerp(scale, Vector2(2,2), delta * 5) 
		#text = str(prefix,round(current))
		#if(current >= target-5):
			#current = target
			#text = str(prefix,round(current))
			#await get_tree().create_timer(0.1).timeout
			#var tween = create_tween()
			#tween.tween_property(self, "scale", Vector2(1,1), .4)
			#scale = lerp(scale, Vector2(1,1), delta * 5)

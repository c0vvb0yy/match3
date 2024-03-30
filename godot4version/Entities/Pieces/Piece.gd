extends Node2D


@export
var color : Util.COLOR

var matched := false
var selected := false
@onready
var sprite = $TextureRect
var original_scale
func _ready():
	original_scale = sprite.scale
	sprite.texture = Util.piece_textures[color]

func move(target_cell:Vector2):
	var tween = create_tween()
	tween.tween_property(self, "position", target_cell, .3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	await tween.finished

func dim(alpha:= 0.5, duration := 0.1): #shows pieces being matched 
	var tween = create_tween()
	var color = modulate
	color.a = alpha
	tween.tween_property(self, "modulate", color, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	#sprite.modulate = Color(1,1,1, alpha);

func fall(target_cell:Vector2):
	var tween = create_tween()
	tween.tween_property(self, "position", target_cell, .3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	await tween.finished

func clear():
	#await dim(0)
	var tween = create_tween()
	tween.parallel().tween_property(sprite, "scale", Vector2.ZERO, .1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	#await tween.finished
	queue_free()

func transform(new_color):
	sprite.texture = Util.piece_textures[new_color]
	self.color = new_color

func multiply_scale(multiplier := 1.0):
	var tween = create_tween()
	var new_scale = original_scale * multiplier
	tween.tween_property(sprite, "scale", new_scale, .1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func set_disabled(grey_value : float):
	var tween = create_tween()
	var alpha = 1.0
	if matched:
		alpha = 0.5
	tween.tween_property(self, "modulate", Color(grey_value, grey_value, grey_value, alpha), .3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)

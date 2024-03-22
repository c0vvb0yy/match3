extends Node2D


@export
var color : Util.COLOR
@export
var sprites : Array

var matched = false

@onready
var sprite = $TextureRect

func move(target_cell:Vector2):
	var tween = create_tween()
	tween.tween_property(self, "position", target_cell, .3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	await tween.finished

func dim(alpha:= 0.5, duration := 0.1): #shows pieces being matched 
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1, alpha), duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
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

func transform(color):
	sprite.texture = sprites[color]
	self.color = color

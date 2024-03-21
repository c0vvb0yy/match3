extends Node2D

#enum COLOR {Flesh, Machine, Divine, Void, Life}

@export
var color : Util.COLOR
var matched = false

@onready
var sprite = $Sprite2D

func move(target_cell:Vector2):
	var tween = create_tween()
	tween.tween_property(self, "position", target_cell, .3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func dim(alpha:= 0.5): #shows pieces being matched 
	sprite.modulate = Color(1,1,1, alpha);

func fall(target_cell:Vector2):
	var tween = create_tween()
	tween.tween_property(self, "position", target_cell, .3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

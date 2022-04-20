extends Node2D

export (String) var color
var move_tween;
var matched = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	move_tween = get_node("MoveTween");
	pass # Replace with function body.

func move(target):
	move_tween.interpolate_property(self, "position", position, target,
	 .3, Tween.TRANS_CUBIC, Tween.EASE_OUT); 
	move_tween.start();
	pass;

func dim():
	var sprite = get_node("Sprite");
	sprite.modulate = Color(1, 1, 1, 0.5);
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

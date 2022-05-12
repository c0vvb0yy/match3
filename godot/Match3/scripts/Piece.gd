extends Node2D

enum COLOR {sun = 0, moon = 1, star = 2, order = 3, chaos = 4}

export (COLOR) var color;
export (Array) var sprites;
var move_tween;
var matched = false;

onready var sprite = get_node("Sprite");

# Called when the node enters the scene tree for the first time.
func _ready():
	move_tween = get_node("MoveTween");
	pass # Replace with function body.

func move(target): #Movement for player-based swapping of pieces
	move_tween.interpolate_property(self, "position", position, target,
	 .3, Tween.TRANS_CUBIC, Tween.EASE_OUT); 
	move_tween.start();
	pass;

func fall(target): # Movement for pieces falling inbetween turns
	move_tween.interpolate_property(self, "position", position, target,
	 .3, Tween.TRANS_BOUNCE, Tween.EASE_OUT); 
	move_tween.start();
	pass;

func dim(alpha : float):
	sprite.modulate = Color(1, 1, 1, alpha);
	pass;

func transform(wanted_color):
	sprite.texture = sprites[wanted_color];
	color = wanted_color;
	pass;

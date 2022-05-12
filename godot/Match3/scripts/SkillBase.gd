extends Node2D

enum COLOR {sun = 0, moon = 1, star = 2, order = 3, chaos = 4}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) onready var grid = get_node(grid);

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


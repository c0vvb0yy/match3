extends HBoxContainer

@onready
var grid = $".."
@onready
var bg = $Background
@onready
var bar = $TextureProgressBar

func _ready():
	size = Vector2(bg.texture.get_size().x * grid.dimension.x+bar.get_size().x, bg.texture.get_size().y * grid.dimension.y)
	print(bar.get_size())

#@onready 
#var grid = $"../.."
#
#func _ready():
	#size = Vector2(texture.get_size().x * grid.dimension.x, texture.get_size().y * grid.dimension.y)
	#pass # Replace with function body.

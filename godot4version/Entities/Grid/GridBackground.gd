extends BoxContainer

@onready
var grid = $"../"
@onready
var bg = $"Background"
@onready
var bar = $"TextureProgressBar"

func _ready():
	#var x = bg.texture.get_size().x * grid.dimension.x + bar.get_size().x
	#var y = bg.texture.get_size().y * grid.dimension.y #+inventory_slot.get_size().y + spacer.get_size().y
	var x = 128 * grid.dimension.x + bar.get_size().x
	var y = 128 * grid.dimension.y #+inventory_slot.get_size().y + spacer.get_size().y
	
	size = Vector2(x, y)

#@onready 
#var grid = $"../.."
#
#func _ready():
	#size = Vector2(texture.get_size().x * grid.dimension.x, texture.get_size().y * grid.dimension.y)
	#pass # Replace with function body.

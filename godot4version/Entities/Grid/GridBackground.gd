extends BoxContainer

@onready
var grid = $"../"
@onready
var bg = $"Background"
@onready
var bar = $"TextureProgressBar"

func _ready():
	var x = bg.texture.get_size().x * grid.dimension.x + bar.get_size().x
	var y = bg.texture.get_size().y * grid.dimension.y #+inventory_slot.get_size().y + spacer.get_size().y
	size = Vector2(x, y)
	#inventory.calc_separation()
	print(bar.get_size())

#@onready 
#var grid = $"../.."
#
#func _ready():
	#size = Vector2(texture.get_size().x * grid.dimension.x, texture.get_size().y * grid.dimension.y)
	#pass # Replace with function body.

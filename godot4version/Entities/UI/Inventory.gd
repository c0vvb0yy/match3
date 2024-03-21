extends HBoxContainer

@onready
var container = $".."
@onready
var slot = $Flesh

func calc_separation():
	var max_width = container.bg.get_size().x
	var unit_width = slot.get_size().x * 5
	var separation = (max_width-unit_width)/4
	print(separation)
	add_theme_constant_override("separation", abs(separation))

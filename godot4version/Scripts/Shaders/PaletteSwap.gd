extends TextureRect

@export
var gradient : Array[Color]

var framerate = .1
var counter = .1

@onready
var mat = self.material
func _ready():
	mat.set_shader_parameter("numberOfColors", gradient.size()-1)
	#apply_grey_scale()
	#var half = floor(gradient.size()/2) 
	#for i in range(half):
		#gradient[i] = gradient_blue_black(i)
	#for i in range(half):
		#gradient[i+half] = gradient_light_blue_black(i)

func gradient_pink_black(i):
	var r = float(156 - i * 22)  / 255
	var g = float(2 / 255)
	var b = float(212 - i * 27) / 255
	return Color(r,g,b,1.0)

func gradient_blue_black(i):
	var r = float(27 - i * 4) / 255
	var g = float(5 - i * 7) / 255
	var b = float(208 - i * 32) / 255
	return Color(r,g,b,1.0)

func gradient_light_blue_black(i):
	var r = float(71 - i * 9) / 255
	var g = float(164 - i * 20) / 255
	var b = float(218 - i * 30) / 255
	return Color(r,g,b,1.0)

func apply_grey_scale():
	for i in gradient.size():
		var value = abs(sin(float(i)/gradient.size()*PI))
		gradient[i] = Color(value,value,value,1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#counter -= delta
	if counter <= 0:
		counter = framerate
		set_shader_parameters()
		cycle_gradient()
	pass

func set_shader_parameters():
	for i in gradient.size():
		var parameter_name = str("C",i)
		mat.set_shader_parameter(parameter_name, gradient[i])

func cycle_gradient():
	var arr_size = gradient.size()
	for i in range(arr_size):
		var holder = gradient[i]
		if i == arr_size-1:
			gradient[i] = gradient[0]
		else:
			gradient[i] = gradient[i+1]
		gradient[i-1] = holder

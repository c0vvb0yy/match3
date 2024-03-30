extends TextureRect

@export
var gradient : Array[Color]

var framerate = .1
var counter = .1

func _ready():
	for i in gradient.size():
		var value = abs(sin(float(i)/gradient.size()*PI))
		print(value)
		#var value = float(i)/gradient.size()
		gradient[i] = Color(value,value,value,1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	counter -= delta
	if counter <= 0:
		counter = framerate
		set_shader_parameters()
		cycle_gradient()
	pass

func set_shader_parameters():
	for i in gradient.size():
		var parameter_name = str("C",i)
		var mat = self.material
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

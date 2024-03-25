extends TextureProgressBar

@onready
var timer = $"../../RoundTimer"

var round_time

# Called when the node enters the scene tree for the first time.
func _ready():
	round_time = timer.wait_time
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.value = timer.get_time_left() * (self.max_value / round_time);
	self.set_tint_progress(lerp(Color(0.7, 0, 0), Color(0, 0.7,0), self.value/90))
	pass

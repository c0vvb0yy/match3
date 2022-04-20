extends TextureProgress

var turn_timer;

# Called when the node enters the scene tree for the first time.
func _ready():
	turn_timer = get_parent().get_node("TurnTimer");
	pass; # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#self.value = lerp(50,turn_timer.get_time_left(), _delta);
	self.value = turn_timer.get_time_left() * 10;
	self.set_tint_progress(lerp(Color(0.7, 0, 0), Color(0, 0.7, 0), self.value/50));
	pass;

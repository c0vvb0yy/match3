extends Label

onready var move_tween = $Tween;

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "";
	pass # Replace with function body.

func display_combo(amount: float, duration: float):
	self.modulate.a = 1;
	var text = String(amount);
	self.text = text;
	self.text += " Combo!";
	move_tween.interpolate_property(self, "rect_position", self.rect_position, Vector2(self.rect_position.x, self.rect_position.y - 2500), 
	duration, Tween.TRANS_LINEAR, Tween.EASE_OUT);

func _process(_delta):
	var value = lerp(self.modulate.a, 0, _delta*0.7);
	self.modulate = Color(0.9, 0.2, 0.2, value);

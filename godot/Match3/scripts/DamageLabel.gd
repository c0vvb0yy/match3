extends Label

enum COLOR {sun = 0, moon = 1, star = 2, order = 3, chaos = 4}

var target_amount : int;
var display_amount : int;

var target_size : int;
var display_size : int

var tween;
var font;
var timer;

var origin;
func _ready():
	tween = get_node("Tween");
	font = self.get_font("font");
	timer = get_node("Timer");
	display_size = font.size;
	target_size = font.size;
	origin = rect_position;
	reset();

func reset():
	rect_position = origin;
	display_amount = 0;

func init(target_pos : Vector2, base_damage : int, damage : int, alignment, size : float):
	tween = get_node("Tween");
	display_amount = base_damage;
	target_amount = damage;
	self.text = String(display_amount);
	self.modulate = select_color(alignment);
	if(size > 1):
		target_size = display_size + 25;
	else:
		target_size = display_size - 25;
	var start_pos = self.rect_position;
	tween.interpolate_property(self, "rect_position", start_pos, target_pos, 1.2, 
	Tween.TRANS_LINEAR, Tween.EASE_OUT);
#	tween.start();
	tween.interpolate_property(font, "size", display_size, target_size, 1.22, 
	Tween.TRANS_LINEAR, Tween.EASE_OUT);
	tween.start();
	#timer.start(2);
	pass # Replace with function body.

func _tween_rect_position(pos):
	self.rect_position = pos;

func select_color(alignment):
	match alignment:
		COLOR.sun:
			return Color(0.88, 0.35, 0.09, 1);
		COLOR.moon:
			return Color(0.92, 1, 1, 1);
		COLOR.star:
			return Color(0.55, 0.85, 0.96, 1);
		COLOR.order:
			return Color(0.98, 0.95, 0.57, 1);
		COLOR.sun:
			return Color(0.55, 0.41, 1, 1);

func _process(delta):
	self.text = set_content();
	#font.size = set_font_size();
	#self.add_font_override("font", font) ;
	pass;

func set_content():
	if(display_amount == 0):
		return ""
	if(display_amount < target_amount):
		display_amount += 1;
	elif(display_amount > target_amount):
		display_amount -= 1;
	return String(display_amount);

func set_font_size():
	if(display_size == target_size):
		return display_size;
	if(display_size < target_size):
		display_size += 1;
	elif(display_size > target_size):
		display_size -= 1;
	return display_size;

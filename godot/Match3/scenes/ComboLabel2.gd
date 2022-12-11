extends Label

onready var tween = $ComboTween
onready var vis_effect = get_parent().get_node("VisEffectCombo");

onready var grid = get_parent().get_node("Grid");

var origin;
var target;

var time_left = 0;

signal apply_combo;
signal damage_enemy;

func _ready():
	origin = self.rect_position;
	target = origin;
	target.x = 180;
	vis_effect.modulate.a = 0;

func even_more_score():
	print("more score")
	emit_signal("apply_combo");

func damage_enemy():
	print("damaging enemy");
	emit_signal("damage_enemy");

func _on_Grid_damage_enemy():
	vis_effect.modulate.a = 1;
	var string = "Combo %s x !!!";
	var content = string % String(grid.get_combo());
	self.text = content;
	tween.interpolate_property(self, "rect_position", origin, target, 0.5, 
	Tween.TRANS_BACK, Tween.EASE_OUT);
	tween.interpolate_callback(self, 0.3, "even_more_score");
	tween.interpolate_callback(self, 1.5, "damage_enemy");
	tween.start();
	pass # Replace with function body.
	


func _on_Grid_new_turn():
	self.rect_position = origin;
	
	vis_effect.modulate.a = 0;
	pass # Replace with function body.

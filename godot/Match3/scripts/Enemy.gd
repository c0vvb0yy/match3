extends Control

export (int) var health;
export (int) var attack;
export (int) var cool_down; #rounds until attack

export(Array, NodePath) onready var heroes;

var current_health :int;

onready var health_bar = $TextureProgress;
onready var damage_label = $DamageLabel;
onready var sprite = $TextureRect;

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = health;
	health_bar.max_value = health;
	health_bar.value = health;
	
	pass # Replace with function body.

func take_damage(damage : int):
	current_health = current_health - damage;
	health_bar.value = current_health;
	health_bar.set_tint_progress(lerp(Color(0, 0.7, 0), Color(0.7, 0, 0), current_health/health));
	damage_label.text = String(damage);
	if(current_health <= 0):
		sprite.flip_v = true;
		print("Enemy killed");


func _on_Grid_damage_enemy():
	var damage = 0;
	for hero in heroes:
		var attacker = get_node(hero);
		damage += attacker.get_score();
	take_damage(damage);
	pass # Replace with function body.


func _on_Grid_new_turn():
	damage_label.text = "";
	pass # Replace with function body.

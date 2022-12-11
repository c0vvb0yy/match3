extends Control

export (TypeInfo.COLOR) var alignment;

export (int) var health;
export (int) var attack;
export (int) var rounds_to_attack; #rounds until attack
var offset = 50; #for damage label tween
var cool_down;

export(Array, NodePath) onready var heroes;
export(Array, NodePath) onready var damage_labels;

var current_health :int;
var is_alive = true

onready var health_bar = $TextureProgress;
onready var sprite = $TextureRect;
onready var health_label = $HealthLabel;

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = health;
	health_bar.max_value = health;
	health_bar.value = health;
	health_bar.set_tint_progress(TypeInfo.colors[alignment])
	health_label.text = String(current_health)+"/"+String(health);
	cool_down = rounds_to_attack;
	pass # Replace with function body.

func update_health(damage : int):
	current_health = current_health - damage;
	health_bar.value = current_health;
	#health_bar.set_tint_progress(lerp(Color(0, 0.7, 0), Color(0.7, 0, 0), current_health/health));
	health_label.text = String(current_health)+"/"+String(health);
	if(current_health <= 0):
		sprite.flip_v = true;
		is_alive = false
		print("Enemy killed");


func calculate_new_pos(pos, offset):
	var new_x = pos.x + offset;
	#var new_y = pos.y - abs(offset);
	return Vector2(new_x, pos.y);

func get_alignment_effectiveness(alignemnt_of_attacker):
	#get the dictionary that lists the effectivenesses
	var dict = TypeInfo.dictionaries[alignment];
	#get the entry in the dictionary to find how effective the attack is
	var mult = dict[alignemnt_of_attacker];
	return mult;

func _on_Grid_new_turn():
	for label in damage_labels:
		get_node(label).reset();
	
	pass 


func take_damage():
	var damage = 0;
	var alignment_attack = null;
	var at_least_one_attacker = false;
	for i in heroes.size():
		var attacker = get_node(heroes[i]);
		damage = attacker.get_score();
		alignment_attack = attacker.get_alignment();
		#if(damage <= 0):
		#	continue;
		at_least_one_attacker = true;
		#update enemy stats
		var mult = get_alignment_effectiveness(alignment_attack);
		var type_damage = damage * mult;
		update_health(type_damage);
		#visual feedback on how the damage got done
		var label = get_node(damage_labels[i]);
		var target_pos = label.get_position();
		if(type_damage > damage):
			target_pos = calculate_new_pos(target_pos, offset);
		elif(type_damage < damage):
			target_pos = calculate_new_pos(target_pos, -offset);
		label.init(target_pos, damage, type_damage, alignment_attack, mult);
	cool_down -= 1;
	if(cool_down == 0 && is_alive):
		attack();
	pass # Replace with function body.

func attack():
	print("ATTACK")
	var target_found = false
	while !target_found:
		var index = floor(rand_range(0, heroes.size()));
		var target = get_node(heroes[index]);
		if target.current_health > 0:
			target.take_damage(attack);
			target_found = true
	cool_down = rounds_to_attack;

func _on_ComboLabel2_damage_enemy():
	take_damage();
	pass # Replace with function body.

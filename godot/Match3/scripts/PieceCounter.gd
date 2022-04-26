extends HBoxContainer

onready var labels = [
	$bottom_slot_sun/TextureRect/amount,
	$bottom_slot_moon/TextureRect/amount,
	$bottom_slot_star/TextureRect/amount,
	$bottom_slot_order/TextureRect/amount,
	$bottom_slot_chaos/TextureRect/amount
	]


enum COLOR {sun = 0, moon = 1, star = 2, order = 3, chaos = 4}

var current_amounts = [0, 0, 0, 0, 0,];
var target_amounts = [0, 0, 0, 0, 0,];
var has_score_updated = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		for i in target_amounts.size():
			if(current_amounts[i] < target_amounts[i]):
				current_amounts[i] = lerp(current_amounts[i], target_amounts[i], delta * 5);
				labels[i].text = String(round(current_amounts[i]));
#		for i in target_amounts.size():
#			while (current_amounts[i] != target_amounts[i]):
#				current_amounts[i] += 1;
#				labels[i].text = String(current_amounts[i]);
#			if(i == target_amounts.size()-1):
#				has_score_updated = false;


func _on_Grid_update_piece_count(received_amount, received_color):
	var index;
	for i in COLOR.size():
		index = i;
		if (i == received_color):
			target_amounts[i] += received_amount;
			has_score_updated = true;
			break;
	pass;

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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Grid_update_piece_count(received_amount, received_color):
	for i in COLOR.size():
		if (i == received_color):
			current_amounts[i] += received_amount;
			labels[i].text = String(current_amounts[i]);
			break;
	pass;

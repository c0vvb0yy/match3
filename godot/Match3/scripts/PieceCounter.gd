extends HBoxContainer

onready var labels = [
	$bottom_slot_sun/amount,
	$bottom_slot_moon/amount,
	$bottom_slot_star/amount,
	$bottom_slot_order/amount,
	$bottom_slot_chaos/amount
	]
var colors = ["sun", "moon", "star", "order", "chaos"];
export (String) var color;
var current_amounts = [0, 0, 0, 0, 0,];

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Grid_update_piece_count(received_amount, received_color):
	var counter = 0;
	for i in colors:
		if (i == received_color):
			current_amounts[counter] += received_amount;
			labels[counter].text = String(current_amounts[counter]);
		counter += 1;
	pass;

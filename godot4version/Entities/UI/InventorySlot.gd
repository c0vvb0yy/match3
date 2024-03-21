extends Control

var current_amount = 0
var target_amount = 0

@export
var own_color : Util.COLOR

@onready
var label = $Counter/Label
@onready
var heal_button = $Heal
func _ready():
	GameManager.collect_pieces.connect(set_piece_amount)

func _process(delta):
	if current_amount != target_amount:
		current_amount = lerp(float(current_amount), float(target_amount), delta * 5)
		label.text = str(round(current_amount))
	if current_amount > 9:
		heal_button.disabled = false
	else:
		heal_button.disabled = true

func get_piece_amount(color):
	if color == own_color:
		return target_amount

func set_piece_amount(color):
	if color == own_color:
		target_amount += 1

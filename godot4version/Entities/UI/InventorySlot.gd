extends Control

var current_amount = 0
var target_amount = 0

var max_amount = 40

@export
var own_color : Util.COLOR

@onready
var label = $Counter/Label
@onready
var heal_button = $Heal
@onready
var progress = $Counter/Amount

func _ready():
	GridManager.collect_pieces.connect(update_piece_count)
	progress.max_value = max_amount

func _process(delta):
	if current_amount != target_amount:
		current_amount = lerp(float(current_amount), float(target_amount), delta * 5)
		progress.value = current_amount
		label.text = str(round(current_amount))
	if current_amount > 9:
		heal_button.disabled = false
	else:
		heal_button.disabled = true

func get_piece_amount(color):
	if color == own_color:
		return target_amount

func update_piece_count(color, amount):
	if color == own_color:
		target_amount += amount
		if target_amount > max_amount:
			target_amount = max_amount
		GridManager.update_current_pieces(color, target_amount)

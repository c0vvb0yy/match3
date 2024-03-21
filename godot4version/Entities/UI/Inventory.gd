extends BoxContainer

@onready
var labels = [
	$Flesh/Counter/Label,
	$Machine/Counter/Label,
	$Divine/Counter/Label,
	$Void/Counter/Label,
	$Life/Counter/Label
]

var current_amounts = [0,0,0,0,0]
var target_amounts = [0,0,0,0,0]

func _ready():
	GameManager.collect_pieces.connect(set_piece_amount)

func _process(delta):
	for i in range(target_amounts.size()):
		if current_amounts[i] == target_amounts[i]:
			continue
		current_amounts[i] = lerp(float(current_amounts[i]), float(target_amounts[i]), delta * 5);
		labels[i].text = str(round(current_amounts[i]));

func get_piece_amount(color):
	return target_amounts[color]

func set_piece_amount(color, amount):
	target_amounts[color] += amount

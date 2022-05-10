extends Control

enum COLOR {sun = 0, moon = 1, star = 2, order = 3, chaos = 4}

export (COLOR) var allignment;
export (int) var health_points;
export (int) var skill_cost;

export(NodePath) onready var piece_counter = get_node(piece_counter);

onready var skill = $Skill;
onready var score_display = $ScoreDisplay/Text

var target_score : int
var displayed_score : int
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(displayed_score < target_score):
		displayed_score = lerp(displayed_score, target_score, delta * 5);
		score_display.text = String(round(displayed_score));
	pass

func get_score():
	return displayed_score;

func _on_Button_pressed():
	#check if we have enough materials for skill activation
	var current_amount = ceil(piece_counter.get_piece_amount(allignment));
	if(current_amount == skill_cost || current_amount > skill_cost):
		print("collected enough!");
		skill.skill();
	else:
		print("not enough pieces");
	pass # Replace with function body.

func _on_Grid_score(received_amount, received_color):
	if(received_color == allignment):
		print(received_amount, "for", received_color);
		target_score = received_amount;
	pass # Replace with function body.

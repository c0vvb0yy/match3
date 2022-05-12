extends Control

enum COLOR {sun = 0, moon = 1, star = 2, order = 3, chaos = 4}

export (COLOR) var allignment;
export (int) var health_points;
export (int) var skill_cost;

export(NodePath) onready var grid = get_node(grid);
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
	if(displayed_score >= target_score - 15):
		displayed_score = target_score;
	if(displayed_score < target_score):
		displayed_score = lerp(displayed_score, target_score, delta * 9);
	score_display.text = String(displayed_score);
	pass

func get_all_pieces_of_color(color):
	var wanted_pieces = [];
	for i in grid.width:
		for j in grid.height:
			if(grid.is_piece_existing(grid.all_pieces, i,j)):
				var current_piece = grid.all_pieces[i][j];
				if(int(current_piece.color) == color):
					wanted_pieces.append(grid.all_pieces[i][j]);
	return wanted_pieces;

func turn_pieces_into_color(initial_color, wanted_color):
	var wanted_pieces = get_all_pieces_of_color(initial_color);
	for piece in wanted_pieces:
		piece.transform(wanted_color);
	pass;

func set_pieces_of_color_matched(color):
	grid.state = grid.game_states.wait;
	for i in grid.width:
		for j in grid.height:
			if(grid.is_piece_existing(grid.all_pieces, i,j)):
				var current_piece = grid.all_pieces[i][j];
				if(int(current_piece.color) == color):
					grid.cool_matches.append([i, j, 1, 0, color]);
					grid.match_and_dim([current_piece]);
					grid.add_to_array([Vector2(i,j)], grid.current_matches)
	grid.score_timer.start(0.5);

func get_score():
	return target_score;

func _on_Button_pressed():
	#check if we have enough materials for skill activation
	var current_amount = ceil(piece_counter.get_piece_amount(allignment));
	if(current_amount == skill_cost || current_amount > skill_cost):
		print("collected enough!");
		piece_counter.set_piece_amount(allignment, current_amount - skill_cost);
		skill.skill();
	else:
		print("not enough pieces");
	pass # Replace with function body.

func _on_Grid_score(received_amount, received_color):
	if(received_color == allignment):
		print(received_amount, "for", received_color);
		target_score = received_amount;
	pass # Replace with function body.


func _on_Grid_new_turn():
	target_score = 0;
	displayed_score = 0;
	score_display.text = "0";
	pass # Replace with function body.

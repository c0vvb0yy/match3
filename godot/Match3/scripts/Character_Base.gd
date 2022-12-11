extends Control

export (TypeInfo.COLOR) var allignment;
export (int) var max_health;
export (int) var skill_cost;

export(NodePath) onready var grid = get_node(grid);
export(NodePath) onready var piece_counter = get_node(piece_counter);


onready var skill = $Skill;
onready var score_display = $ScoreDisplay/Text
onready var hero_sprite = $PortraitBorder/Character;
onready var health_bar = $HPDisplay

var current_health;

var target_score : int
var displayed_score : int
var original_text_size;
var font;
# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health;
	health_bar.max_value = max_health;
	health_bar.value = current_health;
	#health_bar.set_tint_progress(TypeInfo.colors[allignment])
	font = score_display.get_font("font");
	original_text_size = font.size;
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(displayed_score < target_score):
		update_score();
	else: 
		if(font.size > original_text_size):
			font.size -= 2;
	pass

func update_score():
	displayed_score += 1;
	if(font.size < 100):
		font.size += 1;
	score_display.text = String(displayed_score)

func take_damage(damage : int):
	current_health -= damage;
	health_bar.value = current_health;
	if(current_health <= 0):
		hero_sprite.flip_v = true;
		hero_sprite.modulate = Color(0.5,0.5,0.5,0.5);

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
					grid.combo = 0
	grid.score_timer.start(0.5);

func heal_self(amount : int):
	current_health += amount;
	clamp_health();

func heal_self_percentage(amount : int):
	current_health += (amount * max_health) / 100;
	clamp_health();

func clamp_health():
	if current_health > max_health:
		current_health = max_health;
	health_bar.value = current_health;

func get_score():
	return target_score;
func get_alignment():
	return allignment;

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
	if current_health > 0:
		if(received_color == allignment):
			print(received_amount, "for", received_color);
			target_score = received_amount;
	pass # Replace with function body.


func _on_Grid_new_turn():
	target_score = 0;
	displayed_score = 0;
	score_display.text = "0";
	pass # Replace with function body.

func _on_ComboLabel2_apply_combo():
	target_score += (float(displayed_score)/4) * grid.get_combo();
	
	pass # Replace with function body.

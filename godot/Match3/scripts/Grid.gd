extends "res://scripts/Util.gd"

#State Machine
enum{
	wait,
	move
}
var state;

enum{
	horizontal,
	vertical
}

enum colors{
	sun,
	moon,
	star,
	order,
	chaos
}

#Grid Variables
export (int) var width;
export (int) var height;
export (Vector2) var start;
export (int) var offset;
export (int) var piece_y_offset; #from how many grid sapces upwards a new piece will fall into play

var pressed_grid_position;
var released_grid_position;

#Obstacles
export (PoolVector2Array) var empty_spaces;

#piece variables
var all_pieces = []; #current pieces in the scene
var possible_pieces = [
	preload("res://scenes/ChaosPiece.tscn"),
	preload("res://scenes/MoonPiece.tscn"),
	preload("res://scenes/StarPiece.tscn"),
	preload("res://scenes/SunPiece.tscn"),
	preload("res://scenes/OrderPiece.tscn")
];
var current_matches = [];
var cool_matches = [];


#input variables
var start_touch = Vector2(0, 0);
var end_touch = Vector2(0, 0);
var is_controlling_piece = false;

#Timer
onready var turn_timer = get_parent().get_node("TurnTimer");
onready var fall_timer = get_parent().get_node("FallTimer");
onready var fill_timer = get_parent().get_node("FillTimer");
onready var destroy_timer = get_parent().get_node("DestroyTimer");
onready var score_timer = get_parent().get_node("ScoreTimer");

#scoring variables / stats
signal update_piece_count;
signal damage_enemy;
signal update_combo;
signal score;
export (int) var piece_value;
var combo = 1;
var turns = 0;

onready var combo_label = get_parent().get_node("ComboLabel");
onready var combo_counter = get_parent().get_node("MiddleUI/ComboCounter/Text");
onready var turn_counter = get_parent().get_node("MiddleUI/TurnCounter/Text");

# Called when the node enters the scene tree for the first time.
func _ready():
	state = move;
	
	randomize();
	all_pieces = make_2d_array(width, height);
	fill_grid();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(state == move):
		touch_input();
		if(Input.is_action_just_pressed("ui_accept")):
			on_space();
	pass;

func fill_grid(): #top to bottom then left to right
	for i in width:
		for j in height:
			if(!is_restricted_in_placement(Vector2(i, j), empty_spaces)):
				#choose a random number and store it
				var rand = floor(rand_range(0, possible_pieces.size()));
				#instance piece from array
				var piece = possible_pieces[rand].instance();
				var loops = 0;
				while(is_match_at_short(all_pieces, i, j, piece) && loops < 100):
					rand = floor(rand_range(0, possible_pieces.size()));
					piece = possible_pieces[rand].instance();
					loops +=1;
				#add piece to scene
				add_child(piece);
				piece.position = grid_to_pixel(start, offset, i, j);
				all_pieces[i][j] = piece;

func find_matches():
	find_long_matches();
	for tile in current_matches:
		match_and_dim([all_pieces[tile.x][tile.y]]);
	return current_matches.size() > 0;

func find_long_matches():
	var last_color = null;
	var matched = 1;
	cool_matches.clear();
	for i in width:
		for j in height:
			var current_color;
			if(is_piece_existing(all_pieces, i, j)):
				current_color = int(all_pieces[i][j].color);
			if(current_color == last_color && current_color != null):
				matched += 1;
			else:
				store_match(i, j - 1, matched, vertical, last_color);
				matched = 1;
			last_color = current_color;
		store_match(i, height - 1, matched, vertical, last_color);
		matched = 1;
		last_color = null;
	for y in height:
		for x in width:
			var current_color;
			if(is_piece_existing(all_pieces, x, y)):
				current_color = int(all_pieces[x][y].color);
			if(current_color == last_color && current_color != null):
				matched += 1;
			else:
				store_match(x - 1, y, matched, horizontal, last_color);
				matched = 1;
			last_color = current_color;
		store_match(width- 1, y, matched, horizontal, last_color);
		matched = 1;
		last_color = null;
	if(cool_matches.size() > 0):
		print(cool_matches);

func break_matches():
	for i in width:
		for j in height:
			if(is_piece_existing(all_pieces, i, j)):
				if(all_pieces[i][j].matched && !is_match_at(width, height, all_pieces, i, j)):
					unmatch([all_pieces[i][j]]);
					current_matches.erase(Vector2(i, j));

func score_match():
	for i in cool_matches.size():
		if(cool_matches[i] != null):
			var cool_match = cool_matches[i];
			var amount = cool_match[2];
			var score_amount = amount * 11;
			score_amount += (score_amount/4) * combo;
			if(cool_match[3] == vertical):
				var y_grid = cool_match[1];
				combo_label.set_position(grid_to_pixel(start, offset, cool_match[0], y_grid-2));
				for j in range(cool_match[1]-amount, cool_match[1]):
					all_pieces[cool_match[0]][j+1].dim(0);
			else:
				var x_grid = cool_match[0];
				combo_label.set_position(grid_to_pixel(start, offset, x_grid-2, cool_match[1]));
				for j in range(cool_match[0]-amount, cool_match[0]):
					all_pieces[j+1][cool_match[1]].dim(0);
			combo_label.display_combo(combo, 0.5);
			combo_counter.text = String(combo);
			emit_signal("score", score_amount, cool_match[4]); #cool_match[4] == color
			combo += 1;
			cool_matches[i] = null;
			score_timer.start(0.5);
			return;
	
	pass;

func destroy_matched():
#	for cool_match in cool_matches:
#		var current_piece;
#		if(cool_match[3] == vertical):
#			for i in range(cool_match[1]-cool_match[2], cool_match[1]):
#				if(is_piece_existing(all_pieces, cool_match[0], i + 1)):
#					current_piece = all_pieces[cool_match[0]][i+1];
#					current_piece.queue_free();
#					all_pieces[cool_match[0]][i+1] = null;
#		else:
#			for i in range(cool_match[0]-cool_match[2], cool_match[0]):
#				if(is_piece_existing(all_pieces, i + 1, cool_match[1])):
#					current_piece = all_pieces[i + 1][cool_match[1]];
#					current_piece.queue_free();
#					all_pieces[cool_match[i+1]][cool_match[1]] = null;
#
	for tile in current_matches:
			var current_piece = all_pieces[tile.x][tile.y]
			if(current_piece != null):
				current_piece.queue_free();
				all_pieces[tile.x][tile.y] = null;
				#NOW POINTS ARE GIVEN OUT
	update_stats();
	print(current_matches);
	current_matches.clear();

func store_match(x, y, amount : int, direction : int, color):
	if (amount < 3 ):
		return;
	cool_matches.append([x, y, amount, direction, color]);
	if(direction == vertical):
		for i in range(y-amount, y):
			 add_to_array([Vector2(x, i + 1)], current_matches);
	else:
		for i in range(x-amount, x):
			add_to_array([Vector2(i + 1, y)], current_matches);
	pass;

func update_stats():
	for cool_match in cool_matches:
		#update individual piece count
		var amount = cool_match[2];
		var color = cool_match[4];
		emit_signal("update_piece_count", amount, color);


func make_current_pieces_fall():
	for i in width:
		for j in height:
			if(all_pieces[i][j] == null && !is_restricted_in_placement(Vector2(i, j), empty_spaces)):
				for k in range(j - 1, -1, -1):
					if(all_pieces[i][k] != null):
						all_pieces[i][k].fall(grid_to_pixel(start, offset, i, j));
						all_pieces[i][j] = all_pieces[i][k];
						all_pieces[i][k] = null;
						make_current_pieces_fall();
						break;

func refill_columns():
	for i in width:
		for j in height:
			if(all_pieces[i][j] == null && !is_restricted_in_placement(Vector2(i, j), empty_spaces)):
				var rand = floor(rand_range(0, possible_pieces.size()));
				var piece = possible_pieces[rand].instance();
				add_child(piece);
				piece.position = grid_to_pixel(start, offset, i, j - piece_y_offset);
				piece.fall(grid_to_pixel(start, offset, i, j));
				all_pieces[i][j] = piece;
	after_refill();
	pass;

func after_refill():
	var combo_counter = 0;
	if(find_matches()): #weitere matches gefunden. werden verarbeitet
		score_timer.start(0.5);
	else: #keinen weiteren matches. score verarbeitung und dann next turn
		emit_signal("damage_enemy");
		state = move;
		combo = 1;
	pass;

func touch_input():
	var grid_coord = pixel_to_grid(start, offset, get_global_mouse_position()); ##if performace problems: check Input actions first instead of calcing this
	if(is_in_grid(grid_coord, width, height)):
		if(Input.is_action_just_pressed("ui_click")):
			if(turn_timer.is_stopped()):
				turn_timer.start();
				turns += 1;
				turn_counter.text = String(turns);
			start_touch = grid_coord;
			is_controlling_piece = true;
		if(Input.is_action_just_released("ui_click")):
			is_controlling_piece = false;
			end_touch = pixel_to_grid(start, offset, get_global_mouse_position());
			touch_difference(start_touch, end_touch);
	else:
		start_touch = null;
		end_touch = null;
	pass;
func touch_difference(start_grid, end_grid):
	var difference = end_grid - start_grid;
	if(abs(difference.x) > abs(difference.y)): # check if horizontal move 
		if(difference.x > 0): #move right
			swap_pieces(start_grid.x, start_grid.y, Vector2(1,0));
		elif(difference.x < 0): # move left
			swap_pieces(start_grid.x, start_grid.y, Vector2(-1,0));
	elif(abs(difference.y) > abs(difference.x)): #vertical move
		if(difference.y > 0): #move up
			swap_pieces(start_grid.x, start_grid.y, Vector2(0, 1));
		elif(difference.y < 0): #move down
			swap_pieces(start_grid.x, start_grid.y, Vector2(0, -1));
	pass;

func swap_pieces(column, row, direction):
	var target_column = column + direction.x;
	var target_row = row + direction.y;
	var selected_piece = all_pieces[column][row];
	var other_piece = all_pieces[target_column][target_row];
	if(selected_piece != null && other_piece != null):
		#change the stored data to be swapped
		all_pieces[column][row] = other_piece;
		all_pieces[target_column][target_row] = selected_piece;
		#change the visual representation
		selected_piece.move(grid_to_pixel(start, offset, target_column, target_row));
		other_piece.move(grid_to_pixel(start, offset, column, row));
		find_matches();
		break_matches();

func _on_TurnTimer_timeout():
	turn_timer.stop();
	state = wait;
	score_timer.start(0.3);
	#destroy_timer.start(0.1);
	pass;

func _on_ScoreTimer_timeout():
	if(cool_matches.size() >= 1 &&cool_matches[cool_matches.size()-1] != null):
		score_match();
	else:
		destroy_timer.start(0.1);
	pass # Replace with function body.

func _on_DestroyTimer_timeout(): #Turn is over
	find_long_matches();
	destroy_matched();
	fill_timer.start(0.5);
	pass;


func _on_FillTimer_timeout():
	make_current_pieces_fall();
	fall_timer.start(.5);
	pass;

func _on_FallTimer_timeout():
	refill_columns();
	pass;

func on_space():
	find_long_matches();
	destroy_matched();
	fill_timer.start(0.5);
	pass;


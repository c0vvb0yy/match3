extends "res://scripts/Util.gd"

#State Machine
enum{
	wait,
	move
}
var state;

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


#input variables
var start_touch = Vector2(0, 0);
var end_touch = Vector2(0, 0);
var is_controlling_piece = false;

#Timer
var turn_timer;
var fall_timer;
var fill_timer;
var destroy_timer;

#Utility class
var Util

# Called when the node enters the scene tree for the first time.
func _ready():
	state = move;
	#turn_timer = get_parent().get_node("TurnTimer");
	fall_timer = get_parent().get_node("FallTimer");
	fill_timer = get_parent().get_node("FillTimer");
	destroy_timer = get_parent().get_node("DestroyTimer");
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
				var piece = possible_pieces[rand].instance();
				var loops = 0;
				while(is_match_at_short(all_pieces, i, j, piece.color) && loops < 100):
					rand = floor(rand_range(0, possible_pieces.size()));
					piece = possible_pieces[rand].instance();
					loops +=1;
				#instance piece from array
				add_child(piece);
				piece.position = grid_to_pixel(start, offset, i, j);
				all_pieces[i][j] = piece;

func find_matches():
	var at_least_one_matched = false;
	for i in width:
		for j in height:
			if(is_piece_existing(all_pieces, i, j)):
				var current_piece = all_pieces[i][j];
				if( i > 0 && i < width - 1): #horizontal matching logic
					if(is_piece_existing_and_same(all_pieces, i - 1, j, current_piece) 
					&& is_piece_existing_and_same(all_pieces, i + 1, j, current_piece)):
						var left_piece = all_pieces[i - 1][j];
						var right_piece = all_pieces[i + 1][j];
						match_and_dim([left_piece, current_piece, right_piece,]);
						add_to_array([Vector2(i-1,j), Vector2(i,j), Vector2(i+1,j)], current_matches);
						if(!at_least_one_matched):
							at_least_one_matched = true;
				if(j > 0 && j < height - 1): #vertical matching logic
					if(is_piece_existing_and_same(all_pieces, i, j - 1, current_piece) 
					&& is_piece_existing_and_same(all_pieces, i, j + 1, current_piece)):
						var upper_piece = all_pieces[i][j - 1];
						var lower_piece = all_pieces[i][j + 1];
						match_and_dim([lower_piece, upper_piece, current_piece]);
						add_to_array([Vector2(i,j-1), Vector2(i,j), Vector2(i,j+1)], current_matches);
						if(!at_least_one_matched):
							at_least_one_matched = true;
	return at_least_one_matched;

func break_matches():
	for i in width:
		for j in height:
			if(is_piece_existing(all_pieces, i, j)):
				if(all_pieces[i][j].matched && !is_match_at(width, height, all_pieces, i, j)):
					unmatch([all_pieces[i][j]]);

func destroy_matched():
	for i in width:
		for j in height:
			var current_piece = all_pieces[i][j]
			if(current_piece != null):
				if(current_piece.matched):
					current_piece.queue_free();
					all_pieces[i][j] = null;
	print(current_matches)
	current_matches.clear();

func find_long_matches():
	var temp_matches = current_matches;
	for i in current_matches.size():
		var current_column = current_matches[i].x;
		var current_row = current_matches[i].y;
		var current_color = all_pieces[current_column][current_row].color;
		var matched = 0;
		var last_column = null;
		var last_row = null;
		#Iterate over the current matches to check for column, row, and color
		for j in current_matches.size():
			var this_column = current_matches[j].x;
			var this_row = current_matches[j].y;
			var this_color = all_pieces[this_column][this_row].color;
			if(current_color == this_color && this_column == current_column):
				if(last_row != null):
					if(this_row == last_row + 1):
						matched += 1;
					else:
						break;
				else:
					matched += 1;
			elif(this_row == current_row && this_color == current_color):
				if(last_column != null):
					if(this_column == last_column + 1):
						matched += 1;
					else:
						break;
				else:
					matched += 1;
			last_column = this_column;
			last_row = this_row;
		if(matched >= 4):
			print("got " , matched , " of ", current_color);

func look_right_of_piece(piece_col, piece_row, next_col):
	if(all_pieces[piece_col][piece_row].color == all_pieces[next_col][piece_row]):
		return true;
func make_current_pieces_fall():
	for i in width:
		for j in height:
			if(all_pieces[i][j] == null && !is_restricted_in_placement(Vector2(i, j), empty_spaces)):
				for k in range(j - 1, -1, -1):
					if(all_pieces[i][k] != null):
						all_pieces[i][k].move(grid_to_pixel(start, offset, i, j));
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
				piece.move(grid_to_pixel(start, offset, i, j));
				all_pieces[i][j] = piece;
	after_refill();
	pass;

func after_refill():
	if(find_matches()):
		destroy_timer.start(0.5);
	else:
		state = move;
	pass;

func touch_input():
	var grid_coord = pixel_to_grid(start, offset, get_global_mouse_position()); ##if performace problems: check Input actions first instead of calcing this
	if(is_in_grid(grid_coord, width, height)):
		if(Input.is_action_just_pressed("ui_click")):
			#if(turn_timer.is_stopped()):
				#turn_timer.start();
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
	destroy_timer.start(0.1);
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


#func _on_DestroyTimer_timeout(): #Turn is over
#	find_long_matches();
#	destroy_matched();
#	fill_timer.start(0.5);
#	pass;

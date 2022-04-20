extends Node2D

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
export (int) var piece_y_offset;

var pressed_grid_position;
var released_grid_position;

#piece variables
var all_pieces = []; #current pieces in the scene
var possible_pieces = [
	preload("res://scenes/ChaosPiece.tscn"),
	preload("res://scenes/MoonPiece.tscn"),
	preload("res://scenes/StarPiece.tscn"),
	preload("res://scenes/SunPiece.tscn"),
	preload("res://scenes/OrderPiece.tscn")
];

#input variables
var start_touch = Vector2(0, 0);
var end_touch = Vector2(0, 0);
var is_controlling_piece = false;

#Timer
var turn_timer;
var fall_timer;
var fill_timer;
var destroy_timer;

# Called when the node enters the scene tree for the first time.
func _ready():
	state = move;
	turn_timer = get_parent().get_node("TurnTimer");
	fall_timer = get_parent().get_node("FallTimer");
	fill_timer = get_parent().get_node("FillTimer");
	destroy_timer = get_parent().get_node("DestroyTimer");
	randomize();
	all_pieces = make_2d_array();
	fill_grid();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(state == move):
		touch_input();
	pass;

func make_2d_array():
	var array = [];
	for i in width:
		array.append([]);
		for j in height:
			array[i].append(null);
	return array;

func fill_grid(): #top to bottom then left to right
	for i in width:
		for j in height:
			#choose a random number and store it
			var rand = floor(rand_range(0, possible_pieces.size()));
			var piece = possible_pieces[rand].instance();
			var loops = 0;
			while(is_match_at(i, j, piece.color) && loops < 100):
				rand = floor(rand_range(0, possible_pieces.size()));
				piece = possible_pieces[rand].instance();
				loops +=1;
			#instance piece from array
			add_child(piece);
			piece.position = grid_to_pixel(i, j);
			all_pieces[i][j] = piece;

func is_match_at(column, row, color):
	if(column > 1): #then we look to the left of the piece
		var left_piece = all_pieces[column - 1][row];
		var left_most_piece = all_pieces[column - 2][row];
		if (left_piece != null && left_most_piece != null): #check if there's pieces at all next to the one we look at
			if (left_piece.color == color && left_most_piece.color == color):
				return true;
	if(row > 1): #then we look below the piece
		var lower_piece = all_pieces[column][row - 1];
		var lowest_piece = all_pieces[column][row - 2];
		if(lower_piece != null && lowest_piece != null):
			if(lower_piece.color == color && lowest_piece.color == color):
				return true;
	return false;

func find_matches():
	var at_least_one_matched = false;
	for i in width:
		for j in height:
			if(all_pieces[i][j] != null):
				var current_piece = all_pieces[i][j];
				if( i > 0 && i < width - 1): #horizontal matching logic
					var left_piece = all_pieces[i - 1][j];
					var right_piece = all_pieces[i + 1][j];
					if(left_piece != null 
					&& right_piece != null):
						if(left_piece.color == current_piece.color 
						&& right_piece.color == current_piece.color):
							right_piece.matched = true;
							right_piece.dim();
							left_piece.matched = true;
							left_piece.dim();
							current_piece.matched = true;
							current_piece.dim();
							if(!at_least_one_matched):
								at_least_one_matched = true;
				if( j > 0 && j < height - 1): #vertical matching logic
					var upper_piece = all_pieces[i][j - 1];
					var lower_piece = all_pieces[i][j + 1];
					if(upper_piece != null 
					&& lower_piece != null):
						if(upper_piece.color == current_piece.color 
						&& lower_piece.color == current_piece.color):
							lower_piece.matched = true;
							lower_piece.dim();
							upper_piece.matched = true;
							upper_piece.dim();
							current_piece.matched = true;
							current_piece.dim();
							if(!at_least_one_matched):
								at_least_one_matched = true;
	return at_least_one_matched;

func destroy_matched():
	for i in width:
		for j in height:
			var current_piece = all_pieces[i][j]
			if(current_piece != null):
				if(current_piece.matched):
					current_piece.queue_free();
					all_pieces[i][j] = null;

func make_current_pieces_fall():
	for i in width:
		for j in height:
			if(all_pieces[i][j] == null):
				for k in range(j - 1, -1, -1):
					if(all_pieces[i][k] != null):
						all_pieces[i][k].move(grid_to_pixel(i, j));
						all_pieces[i][j] = all_pieces[i][k];
						all_pieces[i][k] = null;
						make_current_pieces_fall();
						break;

func refill_columns():
	for i in width:
		for j in height:
			if(all_pieces[i][j] == null):
				var rand = floor(rand_range(0, possible_pieces.size()));
				var piece = possible_pieces[rand].instance();
				add_child(piece);
				piece.position = grid_to_pixel(i, j - piece_y_offset);
				piece.move(grid_to_pixel(i, j));
				all_pieces[i][j] = piece;
	after_refill();
	pass;

func after_refill():
	if(find_matches()):
		destroy_timer.start(0.5);
	else:
		state = move;
	pass;

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

func _on_DestroyTimer_timeout():
	destroy_matched();
	fill_timer.start(0.5);
	pass;


#func is_turn_timer_going():
#	if(turn_timer.is_stopped() && fill_timer.is_stopped() && fall_timer.is_stopped()):
#		turn_timer.start(5);
#		return true;
#	elif(!turn_timer.is_stopped() || !turn_timer.is_paused()):
#		return true;
#	return false;

func touch_input():
	var grid_coord = pixel_to_grid(get_global_mouse_position()); ##if performace problems: check Input actions first instead of calcing this
	if(is_in_grid(grid_coord)):
		if(Input.is_action_just_pressed("ui_click")):
			if(turn_timer.is_stopped()):
				turn_timer.start();
			start_touch = grid_coord;
			is_controlling_piece = true;
		if(Input.is_action_just_released("ui_click")):
			is_controlling_piece = false;
			end_touch = pixel_to_grid(get_global_mouse_position());
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
		selected_piece.move(grid_to_pixel(target_column, target_row));
		other_piece.move(grid_to_pixel(column, row));
		find_matches();


func grid_to_pixel(column, row):
	var new_x = start.x + offset * column;
	var new_y = start.y + offset * row;
	return Vector2(new_x, new_y);

func pixel_to_grid(coordinate):
	var new_x = round((coordinate.x - start.x) / offset);
	var new_y = round((coordinate.y - start.y) / offset);
	return Vector2(new_x, new_y);

func is_in_grid(coordinate):
	if(coordinate.x >= 0  && coordinate.x < width):
		if(coordinate.y >= 0 && coordinate.y < height):
			return true;
	return false;

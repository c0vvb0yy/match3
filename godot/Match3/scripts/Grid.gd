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
var turn_timer;
var fall_timer;
var fill_timer;
var destroy_timer;

#Utility class
var Util

# Called when the node enters the scene tree for the first time.
func _ready():
	state = move;
	turn_timer = get_parent().get_node("TurnTimer");
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
	find_long_matches();
	for tile in current_matches:
		match_and_dim([all_pieces[tile.x][tile.y]]);
	return current_matches.size() > 0;

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
	print(current_matches);
	current_matches.clear();

func find_long_matches():
	var last_color = null;
	var matched = 1;
	cool_matches.clear();
	for i in width:
		for j in height:
			var current_color;
			if(is_piece_existing(all_pieces, i, j)):
				current_color = all_pieces[i][j].color;
			if(current_color == last_color && current_color != null):
				matched += 1;
			else:
				store_match(i, j - 1, matched, vertical);
				matched = 1;
			last_color = current_color;
		store_match(i, height - 1, matched, vertical);
		matched = 1;
		last_color = null;
	for y in height:
		for x in width:
			var current_color;
			if(is_piece_existing(all_pieces, x, y)):
				current_color = all_pieces[x][y].color;
			if(current_color == last_color && current_color != null):
				matched += 1;
			else:
				store_match(x - 1, y, matched, horizontal);
				matched = 1;
			last_color = current_color;
		store_match(width- 1, y, matched, horizontal);
		matched = 1;
		last_color = null;
	if(cool_matches.size() > 0):
		print(cool_matches);

func store_match(x, y, amount : int, direction : int):
	if (amount < 3 ):
		return;
	cool_matches.append([x, y, amount, direction]);
	if(direction == vertical):
		for i in range(y-amount, y):
			 add_to_array([Vector2(x, i + 1)], current_matches);
	else:
		for i in range(x-amount, x):
			add_to_array([Vector2(i + 1, y)], current_matches);
	pass;

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
			if(turn_timer.is_stopped()):
				turn_timer.start();
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


func _on_DestroyTimer_timeout(): #Turn is over
	find_long_matches();
	destroy_matched();
	fill_timer.start(0.5);
	pass;

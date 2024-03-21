extends Node2D

enum grid_states {
	wait,
	move
}
var state

enum direction {
	vertical,
	horizontal
}

@export
var dimension : Vector2
@export
var empty_spaces : Array[Vector2]
@export
var cell_size := 128

var all_pieces : Array
var possible_pieces = [
	preload("res://Entities/Pieces/Divine_piece.tscn"),
	preload("res://Entities/Pieces/Flesh_piece.tscn"),
	preload("res://Entities/Pieces/Machine_piece.tscn"),
	preload("res://Entities/Pieces/Life_piece.tscn"),
	preload("res://Entities/Pieces/Void_piece.tscn"),
]
var matches : Array
#input control variables
var start_piece_move := Vector2.ZERO
var end_piece_move := Vector2.ZERO
var is_controlling_piece

func _ready():
	state = grid_states.move
	all_pieces = Util.make_2d_array(dimension.x, dimension.y)
	empty_spaces = Util.wrap_coordinates_around_grid(empty_spaces, dimension)
	fill_grid()

func _process(_delta):
	if(state == grid_states.move):
		check_for_input()
	pass

func fill_grid():
	for x in dimension.x:
		for y in dimension.y:
			if !Util.is_restricted_in_placement(Vector2(x,y), empty_spaces):
				var piece = instance_random_piece()
				var loops = 0
				while(Util.is_match_at_short(all_pieces, x, y, piece) and loops < 100):
					piece = instance_random_piece()
					loops += 1
				add_child(piece)
				piece.position = Util.grid_to_pixel(cell_size, Vector2(x,y))
				all_pieces[x][y] = piece

func instance_random_piece() -> Node:
	var rand = randi_range(0, possible_pieces.size()-1)
	return possible_pieces[rand].instantiate()

func check_for_input():
	var grid_coord = Util.pixel_to_grid(self.position, cell_size, get_global_mouse_position())
	
	if Util.is_in_grid(grid_coord, dimension.x, dimension.y):
		if(Input.is_action_just_pressed("mouse_click")):
			start_new_turn()
			start_piece_move = grid_coord
		if(Input.is_action_just_released("mouse_click")):
			end_piece_move = Util.pixel_to_grid(self.position, cell_size, get_global_mouse_position())
			var move_direction = Util.calc_move_direction(start_piece_move, end_piece_move)
			swap_pieces(start_piece_move, move_direction)

func swap_pieces(coord, direction):
	var target_coord = Vector2(coord.x + direction.x, coord.y + direction.y)
	var selected_piece = all_pieces[coord.x][coord.y]
	var target_piece = all_pieces[target_coord.x][target_coord.y]
	if selected_piece != null and target_piece != null:
		all_pieces[coord.x][coord.y] = target_piece
		all_pieces[target_coord.x][target_coord.y] = selected_piece
		selected_piece.move(Util.grid_to_pixel(cell_size, target_coord))
		target_piece.move(Util.grid_to_pixel(cell_size, coord))
		match_pieces()
		break_matches()

func match_pieces():
	find_matches()
	for current_match in matches:
		var amount = current_match[3]
		var x = current_match[0]
		var y = current_match[1]
		match current_match[2]:
			0: #vertical match
				for i in range(y, y-amount, -1):
					Util.match_and_dim(all_pieces[x][i])
			1: #horizontal match
				for i in range(x, x-amount, -1):
					Util.match_and_dim(all_pieces[i][y])

func find_matches():
	var last_color = null
	var matched = 1
	matches.clear()
	for x in dimension.x:
		for y in dimension.y:
			var current_color : Util.COLOR
			if(Util.is_piece_existing(all_pieces, x, y)):
				current_color = all_pieces[x][y].color
				if current_color == last_color and current_color != null:
					matched += 1
				else:
					store_match(x, y-1, matched, direction.vertical, last_color)
					matched = 1
				last_color = current_color
				
		store_match(x, dimension.y-1, matched, direction.vertical, last_color)
		matched = 1
		last_color = null
	for y in dimension.y:
		for x in dimension.x:
			var current_color : Util.COLOR
			if(Util.is_piece_existing(all_pieces, x, y)):
				current_color = all_pieces[x][y].color
				if current_color == last_color and current_color != null:
					matched += 1
				else:
					store_match(x-1, y, matched, direction.horizontal, last_color)
					matched = 1
				last_color = current_color
		store_match(dimension.x-1, y, matched, direction.horizontal, last_color)
		matched = 1
		last_color = null



func store_match(x,y, amount:int, dir:direction, color):
	if amount < 3:
		return
	matches.append([x,y, dir, amount, color])

func break_matches():
	for x in dimension.x:
		for y in dimension.y:
			if Util.is_piece_existing(all_pieces, x, y):
				if(all_pieces[x][y].matched and !Util.is_match_at(dimension, all_pieces, x,y)):
					Util.unmatch(all_pieces[x][y])



func start_new_turn():
	pass

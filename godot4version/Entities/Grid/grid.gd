extends Node2D

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
@export
var piece_y_offset := 5


var possible_pieces = [
	preload("res://Entities/Pieces/Divine_piece.tscn"),
	preload("res://Entities/Pieces/Flesh_piece.tscn"),
	preload("res://Entities/Pieces/Machine_piece.tscn"),
	preload("res://Entities/Pieces/Life_piece.tscn"),
	preload("res://Entities/Pieces/Void_piece.tscn"),
]
#input control variables
var start_piece_move := Vector2.ZERO
var end_piece_move := Vector2.ZERO
var is_controlling_piece

var combo : int = 0

@onready
var round_timer = $RoundTimer

func _ready():
	GameManager.score.connect(end_round)
	GameManager.refill.connect(manual_refill)
	GameManager.grid_state = GameManager.GRID_STATES.ready
	@warning_ignore("narrowing_conversion")
	GameManager.all_pieces = Util.make_2d_array(dimension.x, dimension.y)
	empty_spaces = Util.wrap_coordinates_around_grid(empty_spaces, dimension)
	fill_grid()

func fill_grid():
	for x in dimension.x:
		for y in dimension.y:
			if !Util.is_restricted_in_placement(Vector2(x,y), empty_spaces):
				var piece = instance_random_piece()
				var loops = 0
				while(GameManager.is_match_at_short(x, y, piece) and loops < 100):
					piece = instance_random_piece()
					loops += 1
				add_child(piece)
				piece.position = Util.grid_to_pixel(cell_size, Vector2(x,y))
				GameManager.all_pieces[x][y] = piece

func instance_random_piece() -> Node:
	var rand = randi_range(0, possible_pieces.size()-1)
	return possible_pieces[rand].instantiate()

func _process(_delta):
	if(GameManager.grid_state != GameManager.GRID_STATES.wait):
		check_for_input()
	pass

func start_new_turn():
	GameManager.grid_state = GameManager.GRID_STATES.move
	round_timer.start()

func check_for_input():
	var grid_coord = Util.pixel_to_grid(self.position, cell_size, get_global_mouse_position())
	if Util.is_in_grid(grid_coord, dimension.x, dimension.y):
		if(Input.is_action_just_pressed("mouse_click")):
			GameManager.all_pieces[grid_coord.x][grid_coord.y].appear_selected(1.1)
			start_piece_move = grid_coord
		if(Input.is_action_just_released("mouse_click")):
			GameManager.all_pieces[start_piece_move.x][start_piece_move.y].appear_selected()
			end_piece_move = Util.pixel_to_grid(self.position, cell_size, get_global_mouse_position())
			var move_direction = Util.calc_move_direction(start_piece_move, end_piece_move)
			if move_direction != Vector2.ZERO:
				swap_pieces(start_piece_move, move_direction)
				if(round_timer.is_stopped()):
					start_new_turn()

func swap_pieces(coord:Vector2, dir:Vector2):
	var target_coord = Vector2(coord.x + dir.x, coord.y + dir.y)
	var selected_piece = GameManager.all_pieces[coord.x][coord.y]
	var target_piece = GameManager.all_pieces[target_coord.x][target_coord.y]
	if selected_piece != null and target_piece != null:
		GameManager.all_pieces[coord.x][coord.y] = target_piece
		GameManager.all_pieces[target_coord.x][target_coord.y] = selected_piece
		selected_piece.move(Util.grid_to_pixel(cell_size, target_coord))
		await target_piece.move(Util.grid_to_pixel(cell_size, coord))
		match_pieces()
		break_matches()

func match_pieces():
	find_matches()
	for current_match in GameManager.matches:
		var amount = current_match[3]
		var x = current_match[0]
		var y = current_match[1]
		match current_match[2]:
			direction.vertical:
				for i in range(y, y-amount, -1):
					GameManager.match_and_dim(GameManager.all_pieces[x][i])
			direction.horizontal:
				for i in range(x, x-amount, -1):
					GameManager.match_and_dim(GameManager.all_pieces[i][y])
	return GameManager.matches.size() > 0

func find_matches():
	var last_color = null
	var matched = 1
	GameManager.matches.clear()
	for x in dimension.x:
		for y in dimension.y:
			var current_color = null
			if(GameManager.is_piece_existing(x, y)):
				current_color = GameManager.all_pieces[x][y].color
			if current_color == last_color and current_color != null:
				matched += 1
			else:
				store_match(x, y-1, matched, direction.vertical, last_color)
				matched = 1
			last_color = current_color
			
		if GameManager.is_piece_existing(x, dimension.y-1):
			store_match(x, dimension.y-1, matched, direction.vertical, last_color)
		matched = 1
		last_color = null
	for y in dimension.y:
		for x in dimension.x:
			var current_color = null
			if(GameManager.is_piece_existing(x, y)):
				current_color = GameManager.all_pieces[x][y].color
			if current_color == last_color and current_color != null:
				matched += 1
			else:
				store_match(x-1, y, matched, direction.horizontal, last_color)
				matched = 1
			last_color = current_color
		if GameManager.is_piece_existing(dimension.x-1, y):
			store_match(dimension.x-1, y, matched, direction.horizontal, last_color)
		matched = 1
		last_color = null



func store_match(x,y, amount:int, dir:direction, color):
	if amount < 3:
		return
	GameManager.matches.append([x,y, dir, amount, color])

func break_matches():
	for x in dimension.x:
		for y in dimension.y:
			if GameManager.is_piece_existing(x, y):
				if(GameManager.all_pieces[x][y].matched and !GameManager.is_match_at(dimension, x,y)):
					GameManager.unmatch(GameManager.all_pieces[x][y])

func _on_timer_timeout():
	round_timer.stop()
	GameManager.grid_state = GameManager.GRID_STATES.wait
	end_round()

func score_round():
	if(GameManager.matches.size() > 0 and GameManager.matches[GameManager.matches.size()-1] != null):
		for current_match in GameManager.matches:
			print(current_match)
			if current_match == null:
				continue
			combo += 1
			var x = current_match[0]
			var y = current_match[1]
			var amount = current_match[3]
			var color = current_match[4]
			var score_amount = amount * 11
			score_amount += (score_amount/4) * combo
			print(combo)
			print(score_amount)
			match current_match[2]:
				#TODO: combo label creation + position setting
				direction.vertical: 
					for i in range(y, y-amount, -1):
						GameManager.clear_piece(x, i)
						GameManager.emit_signal("collect_pieces", color, 1)
				direction.horizontal: 
					for i in range(x, x-amount, -1):
						GameManager.clear_piece(i, y)
						GameManager.emit_signal("collect_pieces", color, 1)
			current_match = null
			await get_tree().create_timer(0.5).timeout
	return true

func manual_refill():
	await get_tree().create_timer(0.1).timeout
	make_current_pieces_fall()
	await get_tree().create_timer(0.5).timeout
	refill_columns()

func end_round():
	await get_tree().create_timer(0.3).timeout
	await score_round()
	await get_tree().create_timer(0.1).timeout
	make_current_pieces_fall()
	await get_tree().create_timer(0.5).timeout
	refill_columns()

func make_current_pieces_fall():
	for x in dimension.x:
		for y in dimension.y:
			if(GameManager.all_pieces[x][y] == null 
			and !Util.is_restricted_in_placement(Vector2(x,y), empty_spaces)):
				for i in range(y - 1, -1, -1):
					if GameManager.all_pieces[x][i] == null:
						break
					GameManager.all_pieces[x][i].fall(Util.grid_to_pixel(cell_size,Vector2(x,y)))
					GameManager.all_pieces[x][y] = GameManager.all_pieces[x][i]
					GameManager.all_pieces[x][i] = null
					make_current_pieces_fall()
					break

func refill_columns():
	for x in dimension.x:
		for y in dimension.y:
			if(GameManager.all_pieces[x][y] == null 
			and !Util.is_restricted_in_placement(Vector2(x,y), empty_spaces)):
				var piece = instance_random_piece()
				add_child(piece)
				piece.position = Util.grid_to_pixel(cell_size, Vector2(x, y - piece_y_offset))
				piece.fall(Util.grid_to_pixel(cell_size, Vector2(x, y)))
				GameManager.all_pieces[x][y] = piece
	await get_tree().create_timer(0.3).timeout
	after_refill()

func after_refill():
	if (match_pieces()):
		await get_tree().create_timer(0.4).timeout
		end_round()
	else:
		#TODO: score verarbeitung/Enemy damage
		GameManager.grid_state = GameManager.GRID_STATES.move
		combo = 0

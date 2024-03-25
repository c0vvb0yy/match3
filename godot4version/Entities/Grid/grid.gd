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
var start_piece_pos := Vector2.ZERO
var is_controlling_piece := false

var quick_time_multiplier := 1.0

var combo : int = 0

@onready
var round_timer = $RoundTimer
@onready
var combo_label = $ComboLabel

func _ready():
	GameManager.score.connect(end_matching)
	GameManager.refill.connect(manual_refill)
	GameManager.round_over.connect(end_round)
	GameManager.grid_state = GameManager.GRID_STATES.ready
	@warning_ignore("narrowing_conversion")
	GameManager.all_pieces = Util.make_2d_array(dimension.x, dimension.y)
	empty_spaces = Util.wrap_coordinates_around_grid(empty_spaces, dimension)
	GameManager.grid_dimension = dimension
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
		if Input.is_action_just_pressed("ui_accept"):
			quick_time_multiplier = 1 + (round_timer.get_time_left() * (100 / round_timer.wait_time)) / 100;
			print(quick_time_multiplier)
			_on_timer_timeout()
	pass

func start_new_turn():
	GameManager.grid_state = GameManager.GRID_STATES.move
	round_timer.start()

func check_for_input():
	var mouse_coord = Util.pixel_to_grid(self.position, cell_size, get_global_mouse_position())
	var move_direction := Vector2.ZERO
	if Util.is_in_grid(mouse_coord, dimension.x, dimension.y) and GameManager.is_piece_existing(mouse_coord.x, mouse_coord.y):
		if Input.is_action_just_pressed("mouse_click"):
			start_piece_pos = mouse_coord
			GameManager.all_pieces[start_piece_pos.x][start_piece_pos.y].multiply_scale(1.1)
			is_controlling_piece = true
		if(!is_controlling_piece):
			return
		if Input.is_action_just_released("mouse_click"):
			is_controlling_piece = false
			var end_piece_pos = Util.pixel_to_grid(self.position, cell_size, get_global_mouse_position())
			move_direction = Util.calc_move_direction(start_piece_pos, end_piece_pos)
			GameManager.all_pieces[start_piece_pos.x][start_piece_pos.y].multiply_scale()
		if Input.is_action_just_pressed("down"):
			move_direction = Vector2.DOWN
		if Input.is_action_just_pressed("left"):
			move_direction = Vector2.LEFT
		if Input.is_action_just_pressed("right"):
			move_direction = Vector2.RIGHT
		if Input.is_action_just_pressed("up"):
			move_direction = Vector2.UP
		if (move_direction != Vector2.ZERO 
		and Util.is_direction_in_grid(start_piece_pos, move_direction, dimension)):
			is_controlling_piece = false
			GameManager.all_pieces[start_piece_pos.x][start_piece_pos.y].multiply_scale()
			swap_pieces(start_piece_pos, move_direction)
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
	if is_controlling_piece:
		GameManager.all_pieces[start_piece_pos.x][start_piece_pos.y].multiply_scale()
	end_matching()

var score = 0 
func score_round():
	if(GameManager.matches.size() > 0 and GameManager.matches[GameManager.matches.size()-1] != null):
		for current_match in GameManager.matches:
			if current_match == null:
				continue
			print(GameManager.matches)
			var x = current_match[0]
			var y = current_match[1]
			var dir = current_match[2]
			var amount = current_match[3]
			var color = current_match[4]
			combo += 1
			combo_label.text = str("[rainbow freq = 1.0][bgcolor=#00000088]",combo," combo")
			combo_label.set_label_position(cell_size, x, y, amount-2, dir)
			score += amount * 11
			PartyManager.emit_signal("register_match", color, score)
			#score_amount += (score_amount/4) * combo
			match dir:
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
			await get_tree().create_timer(0.7).timeout
	return true

func manual_refill():
	await get_tree().create_timer(0.1).timeout
	make_current_pieces_fall()
	await get_tree().create_timer(0.5).timeout
	refill_columns()
	GameManager.grid_state = GameManager.GRID_STATES.ready

func end_matching():
	await get_tree().create_timer(0.3).timeout
	await score_round()
	await get_tree().create_timer(0.1).timeout
	make_current_pieces_fall()
	await get_tree().create_timer(0.5).timeout
	refill_columns()
	after_refill()

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
	

func after_refill():
	if (match_pieces()):
		await get_tree().create_timer(0.4).timeout
		end_matching()
	else:
		await get_tree().create_timer(0.3).timeout
		#TODO: Enemy damage
		score *= quick_time_multiplier
		score *= max(1, combo/3)
		PartyManager.emit_signal("apply_combo", combo)
		print("final score: ", score)
		GameManager.disable_grid(true)

func end_round():
	GameManager.grid_state = GameManager.GRID_STATES.ready
	combo = 0
	combo_label.text = ""
	score = 0
	quick_time_multiplier = 1
	GameManager.disable_grid(false)

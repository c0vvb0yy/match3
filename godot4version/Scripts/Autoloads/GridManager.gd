extends Node

signal collect_pieces
signal score
signal refill
signal round_over

enum GRID_STATES {
	wait,
	move,
	ready
}
var grid_state

var all_pieces : Array #..of arrays [][]
var matches : Array #schema => [x,y, direction(V||H), amount, color]

var current_pieces = [0,0,0,0,0]

var grid_dimension : Vector2i

func is_piece_existing(column:int, row:int) -> bool:
	if all_pieces[column][row] == null:
		return false
	return true

func is_piece_same(column, row, piece):
	if all_pieces[column][row].color == piece.color:
		return true
	return false

func is_piece_existing_and_same(column, row, piece):
	if(is_piece_existing(column, row)):
		if(is_piece_same(column, row, piece)):
			return true
	return false

func match_and_dim(piece):
	piece.matched = true;
	piece.dim()

func unmatch(piece):
	piece.matched = false;
	piece.dim(1)

func is_match_at(grid, column, row):
	if all_pieces[column][row].matched:
		if column > 0 and column < grid.x-1:
			if (is_piece_existing_and_same(column-1, row, all_pieces[column][row])
			and is_piece_existing_and_same(column+1, row, all_pieces[column][row])):
				return true
		if row > 0 and row < grid.y-1:
			if (is_piece_existing_and_same(column, row-1, all_pieces[column][row])
			and is_piece_existing_and_same(column, row+1, all_pieces[column][row])):
				return true
		if(column > 1): #2 to the left of the piece
			if(is_piece_existing_and_same(column - 1, row, all_pieces[column][row]) 
			and is_piece_existing_and_same(column - 2, row, all_pieces[column][row])):
				return true;
		if(row > 1): #2 below the piece
			if(is_piece_existing_and_same(column, row - 1, all_pieces[column][row]) 
			and is_piece_existing_and_same(column, row - 2, all_pieces[column][row])):
				return true;
		if(column < grid.x - 2): #2 to the right of the piece
			if(is_piece_existing_and_same(column + 1, row, all_pieces[column][row]) 
			and is_piece_existing_and_same(column + 2, row, all_pieces[column][row])):
				return true;
		if(row < grid.y - 2): #2 above the piece
			if(is_piece_existing_and_same(column, row + 1, all_pieces[column][row]) 
			and is_piece_existing_and_same(column, row + 2, all_pieces[column][row])):
				return true;
	return false


func is_match_at_short(column, row, piece):
	#check to the left of the piece
	if column >= 2: 
		var left_piece = all_pieces[column - 1][row]
		var left_most_piece = all_pieces[column - 2][row]
		if left_piece != null and left_most_piece != null:
			if left_piece.color == piece.color && left_most_piece.color == piece.color:
				return true;
	if row >= 2:
		var right_piece = all_pieces[column][row - 1]
		var right_most_piece = all_pieces[column][row - 2]
		if right_piece != null and right_most_piece != null:
			if right_piece.color == piece.color && right_most_piece.color == piece.color:
				return true;
	return false

func try_get_piece(column, row):
	if is_piece_existing(column, row):
		return all_pieces[column][row]
	else:
		return null

func update_current_pieces(color: Util.COLOR, new_amount):
	current_pieces[color] = new_amount

func clear_piece(x, y):
	if GridManager.all_pieces[x][y] == null:
		return
	await GridManager.all_pieces[x][y].clear()
	GridManager.all_pieces[x][y] = null

func get_all_existing_pieces():
	var pieces = []
	for x in grid_dimension.x:
		for y in grid_dimension.y:
			if is_piece_existing(x,y):
				pieces.append(all_pieces[x][y])
	return pieces

var selector = load("res://Assets/Sprites/UI/MouseCursors/selector.png")
var cross = load("res://Assets/Sprites/UI/MouseCursors/cross.png")
var hotspot = Vector2(32, 32)
func pause_grid():
	grid_state = GRID_STATES.wait
	Input.set_custom_mouse_cursor(cross, 0, hotspot)

func disable_grid(state):
	if state == true:
		Input.set_custom_mouse_cursor(cross, 0, hotspot)
		grid_state = GRID_STATES.wait
		for piece in get_all_existing_pieces():
			piece.set_disabled(0.2)
	else:
		Input.set_custom_mouse_cursor(selector, 0, hotspot)
		grid_state = GRID_STATES.ready
		for piece in get_all_existing_pieces():
			piece.set_disabled(1.0)

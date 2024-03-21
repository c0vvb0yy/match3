class_name Util

enum COLOR {Flesh , Machine , Divine , Void , Life }

static func make_2d_array(width : int, height: int) -> Array:
	var array = []
	for x in width:
		array.append([])
		for y in height:
			array[x].append(null)
	return array

static func is_restricted_in_placement(grid_pos:Vector2, empty_spaces:Array[Vector2]):
	if grid_pos in empty_spaces:
		return true
	return false

static func wrap_coordinates_around_grid(coordinates:Array[Vector2], grid_dimension:Vector2) -> Array[Vector2]:
	for i in range(coordinates.size()):
		var coord = coordinates[i]
		if coord.x < 0:
			var new_coord = grid_dimension.x + coord.x
			coord.x = new_coord
		if coord.y < 0:
			var new_coord = grid_dimension.y + coord.y
			coord.y = new_coord
		coordinates[i] = coord
	return coordinates

static func is_match_at_short(all_pieces, column, row, piece):
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

static func grid_to_pixel(grid_cell_size, coordinate):
	var new_x = grid_cell_size * coordinate.x
	var new_y = grid_cell_size * coordinate.y
	return Vector2(new_x, new_y)

static func pixel_to_grid(start, grid_cell_size, coordinate):
	var new_x = floor((coordinate.x - start.x) / grid_cell_size)
	var new_y = floor((coordinate.y - start.y) / grid_cell_size)
	return Vector2(new_x, new_y)

static func is_in_grid(coord:Vector2, grid_width:float, grid_height:float) -> bool:
	if(coord.x >= 0.0 and coord.x < grid_width):
		if(coord.y >= 0.0 and coord.y < grid_height):
			return true
	return false

static func calc_move_direction(start_pos: Vector2, end_pos: Vector2):
	var difference := end_pos - start_pos
	if abs(difference.x) > abs(difference.y):
		if difference.x > 0:
			return Vector2.RIGHT
		elif difference.x < 0:
			return Vector2.LEFT
	elif abs(difference.y) > abs(difference.x):
		if difference.y > 0:
			return Vector2.DOWN
		elif difference.y < 0:
			return Vector2.UP
	return Vector2.ZERO

static func is_piece_existing(all_pieces, column, row):
	if all_pieces[column][row] == null:
		return false
	return true

static func is_piece_same(all_pieces, column, row, piece):
	if all_pieces[column][row].color == piece.color:
		return true
	return false

static func is_piece_existing_and_same(all_pieces, column, row, piece):
	if(is_piece_existing(all_pieces, column, row)):
		if(is_piece_same(all_pieces, column, row, piece)):
			return true
	return false

static func is_match_at(grid, all_pieces, column, row):
	if all_pieces[column][row].matched:
		if column > 0 and column < grid.x-1:
			if (is_piece_existing_and_same(all_pieces, column-1, row, all_pieces[column][row])
			and is_piece_existing_and_same(all_pieces, column+1, row, all_pieces[column][row])):
				return true
		if row > 0 and row < grid.y-1:
			if (is_piece_existing_and_same(all_pieces, column, row-1, all_pieces[column][row])
			and is_piece_existing_and_same(all_pieces, column, row+1, all_pieces[column][row])):
				return true
		if(column > 1): #2 to the left of the piece
			if(is_piece_existing_and_same(all_pieces, column - 1, row, all_pieces[column][row]) 
			and is_piece_existing_and_same(all_pieces, column - 2, row, all_pieces[column][row])):
				return true;
		if(row > 1): #2 below the piece
			if(is_piece_existing_and_same(all_pieces, column, row - 1, all_pieces[column][row]) 
			and is_piece_existing_and_same(all_pieces, column, row - 2, all_pieces[column][row])):
				return true;
		if(column < grid.x - 2): #2 to the right of the piece
			if(is_piece_existing_and_same(all_pieces, column + 1, row, all_pieces[column][row]) 
			and is_piece_existing_and_same(all_pieces, column + 2, row, all_pieces[column][row])):
				return true;
		if(row < grid.y - 2): #2 above the piece
			if(is_piece_existing_and_same(all_pieces, column, row + 1, all_pieces[column][row]) 
			and is_piece_existing_and_same(all_pieces, column, row + 2, all_pieces[column][row])):
				return true;
	return false

static func match_and_dim(piece):
	piece.matched = true;
	piece.dim()

static func unmatch(piece):
	piece.matched = false;
	piece.dim(1)

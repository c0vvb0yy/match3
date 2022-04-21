extends Node2D


func make_2d_array(grid_width, grid_height):
	var array = [];
	for i in grid_width:
		array.append([]);
		for j in grid_height:
			array[i].append(null);
	return array;

func grid_to_pixel(start, grid_size, column, row):
	var new_x = start.x + grid_size * column;
	var new_y = start.y + grid_size * row;
	return Vector2(new_x, new_y);

func pixel_to_grid(start, grid_size, coordinate):
	var new_x = round((coordinate.x - start.x) / grid_size);
	var new_y = round((coordinate.y - start.y) / grid_size);
	return Vector2(new_x, new_y);

func is_in_grid(coordinate, grid_width, grid_height):
	if(coordinate.x >= 0  && coordinate.x < grid_width):
		if(coordinate.y >= 0 && coordinate.y < grid_height):
			return true;
	return false;

func is_piece_existing(all_pieces, coloumn, row):
	if(all_pieces[coloumn][row] != null):
		return true;
	return false;

func is_piece_same(all_pieces, coloumn, row, piece):
	if(all_pieces[coloumn][row].color == piece.color):
		return true;
	return false;

func is_piece_existing_and_same(all_pieces, coloumn, row, piece):
	if(is_piece_existing(all_pieces, coloumn, row)):
		if(is_piece_same(all_pieces, coloumn, row, piece)):
			return true;
	return false;
	
func is_piece_existing_but_not_same(all_pieces, coloumn, row, piece):
	if(is_piece_existing(all_pieces, coloumn, row)):
		if(!is_piece_same(all_pieces, coloumn, row, piece)):
			return true;
	return false;


func is_restricted_in_placement(grid_pos, empty_spaces):
	if (grid_pos in empty_spaces):
		return true;
	return false;

func is_match_at(grid_width, grid_height, all_pieces, column, row):
	#remake this function to work for middle pieces (look 1 up and 1 down not just 2 up or 2 down)
	if(all_pieces[column][row].matched):
		if(column > 1): #then we look 2 to the left of the piece
			if(is_piece_existing_and_same(all_pieces, column - 1, row, all_pieces[column][row]) && is_piece_existing_and_same(all_pieces, column - 2, row, all_pieces[column][row])):
				return true;
		if(row > 1): #then we 2 look below the piece
			if(is_piece_existing_and_same(all_pieces, column, row - 1, all_pieces[column][row]) && is_piece_existing_and_same(all_pieces, column, row - 2, all_pieces[column][row])):
				return true;
		if(column < grid_width - 2): #then we 2 look to the right of the piece
			if(is_piece_existing_and_same(all_pieces, column + 1, row, all_pieces[column][row]) && is_piece_existing_and_same(all_pieces, column + 2, row, all_pieces[column][row])):
				return true;
		if(row < grid_height - 2): #we look 2 above the piece
			if(is_piece_existing_and_same(all_pieces, column, row + 1, all_pieces[column][row]) && is_piece_existing_and_same(all_pieces, column, row + 2, all_pieces[column][row])):
				return true;
		if(column >= 1 && column <= grid_width - 2):
			if(is_piece_existing_and_same(all_pieces, column - 1, row, all_pieces[column][row]) && is_piece_existing_and_same(all_pieces, column + 1, row, all_pieces[column][row])):
				return true;
		if(row >= 1 && row <= grid_height - 2):
			if(is_piece_existing_and_same(all_pieces, column, row - 1, all_pieces[column][row]) && is_piece_existing_and_same(all_pieces, column, row + 1, all_pieces[column][row])):
				return true;
	return false;

func is_match_at_short(all_pieces, column, row, color):
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

func match_and_dim(pieces):
	for piece in pieces:
		piece.matched = true;
		piece.dim();
	pass;

func unmatch(pieces):
	for piece in pieces:
		piece.un_dim();
		piece.matched = false;
	pass;

func add_to_array(values, array):
	for value in values:
		if(!array.has(value)):
			array.append(value);
	pass;

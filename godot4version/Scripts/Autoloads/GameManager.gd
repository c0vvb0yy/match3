extends Node

signal collect_pieces

var all_pieces

func is_piece_existing(column, row):
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

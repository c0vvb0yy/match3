extends Node
class_name Skills

static func get_all_pieces_of_color(color : Util.COLOR) -> Array:
	var wanted_pieces = []
	for x in GameManager.all_pieces.size():
		for y in GameManager.all_pieces[x].size():
			var current_piece = GameManager.try_get_piece(x, y)
			if current_piece and current_piece.color == color:
				wanted_pieces.append(current_piece)
	return wanted_pieces

static func turn_pieces_into_color(initial_color: Util.COLOR, wanted_color: Util.COLOR):
	var targeted_pieces = get_all_pieces_of_color(initial_color)
	for piece in targeted_pieces:
		piece.transform(wanted_color)

static func match_all_pieces_of_color(color: Util.COLOR):
	#do we want this to trigger multiple combos per piece? or count as 1 combo
	for x in GameManager.all_pieces.size():
		for y in GameManager.all_pieces[x].size():
			var current_piece = GameManager.try_get_piece(x, y)
			if current_piece and current_piece.color == color:
				GameManager.matches.append([x, y, 0, 1, color])
				GameManager.match_and_dim(current_piece)
	GameManager.emit_signal("score")
	print(GameManager.matches)

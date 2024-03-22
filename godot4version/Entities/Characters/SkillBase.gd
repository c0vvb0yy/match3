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

static func get_pieces_of_color_and_coords(color : Util.COLOR):
	var wanted_pieces = []
	for x in GameManager.all_pieces.size():
		for y in GameManager.all_pieces[x].size():
			var current_piece = GameManager.try_get_piece(x, y)
			if current_piece and current_piece.color == color:
				var element = [Vector2(x,y), current_piece]
				wanted_pieces.append(element)
	return wanted_pieces

static func turn_pieces_into_color(initial_color: Util.COLOR, wanted_color: Util.COLOR):
	var targeted_pieces = get_all_pieces_of_color(initial_color)
	for piece in targeted_pieces:
		piece.transform(wanted_color)

static func match_all_pieces_of_color(color: Util.COLOR):
	#do we want this to trigger multiple combos per piece? or count as 1 combo
	var target_pieces = get_pieces_of_color_and_coords(color)
	for piece in target_pieces:
		var x = piece[0].x
		var y = piece[0].y
		GameManager.matches.append([x, y, 0, 1, piece[1].color])
		GameManager.match_and_dim(piece[1])
	GameManager.emit_signal("score")

static func collect_all_pieces_of_color(color: Util.COLOR):
	var target_pieces = get_pieces_of_color_and_coords(color)
	for piece in target_pieces:
		var x = piece[0].x
		var y = piece[0].y
		#GameManager.matches.append([x, y, 0, 1, piece[1].color])
		#GameManager.match_and_dim(piece[1])
		GameManager.emit_signal("collect_pieces", color, 1)
		await GameManager.clear_piece(x, y)
	GameManager.emit_signal("refill")
	pass

static func change_all_pieces_to_random_color():
	pass

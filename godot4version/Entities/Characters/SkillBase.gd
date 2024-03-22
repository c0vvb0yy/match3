extends Node
class_name Skills

func get_all_pieces_of_color() -> Array:
	var wanted_pieces = []
	for x in GameManager.all_pieces.size():
		for y in GameManager.all_pieces[x].size():
			if Util.is_piece_existing()

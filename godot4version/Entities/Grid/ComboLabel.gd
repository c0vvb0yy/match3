extends RichTextLabel

func set_label_position(grid_cell_size, x, y, offset, dir):
	match dir:
		0:# vertical
			position = Util.grid_to_pixel(grid_cell_size, Vector2(x, y-offset))
		1:#horizontal
			position = Util.grid_to_pixel(grid_cell_size, Vector2(x-offset, y))
	position.y += grid_cell_size/4

class_name Util

enum COLOR {Flesh , Machine , Divine , Void , Life}

static var color_modulates = {
	COLOR.Flesh : Color(0.99, 0.77, 0.03),#Color(1, 1, 0.47),
	COLOR.Machine: Color(0.15, 0.35, 0.71),
	COLOR.Divine: Color(0.72, 0.96, 0.96),
	COLOR.Void: Color(0.41, 0.38, 0.49),
	COLOR.Life: Color(0.06, 0.53, 0.47) #try and think of how to rainbow freq it?
} 
##to be used in richtTextLabels with BBcode enabled
static var color_codes = {
	COLOR.Flesh : '[color = #fdc508]',#'[color = #ffff79]',
	COLOR.Machine: '[color = #2558b6]',
	COLOR.Divine: '[color = #b8f6f4]',
	COLOR.Void: '[color = #69627d]',
	COLOR.Life: '[color = #0f8877]'
}
static var piece_textures = {
	COLOR.Flesh : preload("res://Assets/Sprites/Pieces/piece_sun.png"),
	COLOR.Machine: preload("res://Assets/Sprites/Pieces/piece_moon.png"),
	COLOR.Divine: preload("res://Assets/Sprites/Pieces/piece_star.png"),
	COLOR.Void:preload("res://Assets/Sprites/Pieces/piece_anchor.png"),
	COLOR.Life:preload("res://Assets/Sprites/Pieces/piece_wave.png")
}

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

static func grid_to_pixel(grid_cell_size:int, coordinate: Vector2):
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

static func calc_move_direction(start_pos: Vector2, end_pos: Vector2) -> Vector2:
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

static func is_direction_in_grid(start_pos: Vector2, direction: Vector2, grid_size) -> bool:
	if (start_pos.x > 0 and start_pos.x < grid_size.x - 1
	and (direction == Vector2.LEFT or direction == Vector2.RIGHT)):
		return true
	if (start_pos.y > 0 and start_pos.y < grid_size.y - 1
	and (direction == Vector2.UP or direction == Vector2.DOWN)):
		return true
	if ((start_pos.x == 0 and direction == Vector2.LEFT)
	or (start_pos.x == grid_size.x - 1 and direction == Vector2.RIGHT)):
		return false
	if (start_pos.y == 0 and direction == Vector2.UP
	or (start_pos.y == grid_size.y - 1 and direction == Vector2.DOWN)):
		return false
	print(start_pos, direction)
	return true

extends Control
enum COLOR {sun = 0, moon = 1, star = 2, order = 3, chaos = 4}
onready var base = get_parent();
func skill():
	print("executed ZaavansSkill");
	base.turn_pieces_into_color(COLOR.order, COLOR.star);
	pass;

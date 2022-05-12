extends Control

enum COLOR {sun = 0, moon = 1, star = 2, order = 3, chaos = 4}
onready var base = get_parent();

func skill():
	print("Anthra skill");
	base.set_pieces_of_color_matched(COLOR.sun);
	pass;

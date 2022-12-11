extends Node

enum COLOR {sun = 0, moon = 1, star = 2, order = 3, chaos = 4}


const sun_color = Color(0.88, 0.35, 0.09, 1)
const moon_color = Color(0.92, 1, 1, 1)
const star_color = Color(0.55, 0.85, 0.96, 1)
const order_color = Color(0.98, 0.95, 0.57, 1)
const chaos_color = Color(0.55, 0.41, 1, 1)

const colors = [sun_color, moon_color, star_color, order_color, chaos_color]

const effective = 1.5;
const not_effective = 0.5;
const medium = 1;
const very_effective = 2;

const sun_dict = {
	COLOR.sun : medium,
	COLOR.moon : not_effective,
	COLOR.star : effective,
	COLOR.order : medium,
	COLOR.chaos: medium
}
const moon_dict = {
	COLOR.sun : effective,
	COLOR.moon : medium,
	COLOR.star : not_effective,
	COLOR.order : medium,
	COLOR.chaos: medium
}
const star_dict = {
	COLOR.sun : not_effective,
	COLOR.moon : effective,
	COLOR.star : medium,
	COLOR.order : medium,
	COLOR.chaos: medium
}
const order_dict = {
	COLOR.sun : medium,
	COLOR.moon : medium,
	COLOR.star : medium,
	COLOR.order : very_effective,
	COLOR.chaos: medium
}
const chaos_dict = {
	COLOR.sun : medium,
	COLOR.moon : medium,
	COLOR.star : medium,
	COLOR.order : medium,
	COLOR.chaos: very_effective
}

const dictionaries = [sun_dict, moon_dict, star_dict, order_dict, chaos_dict]

func select_color(alignment):
	match alignment:
		COLOR.sun:
			return sun_color
		COLOR.moon:
			return moon_color
		COLOR.star:
			return star_color
		COLOR.order:
			return order_color
		COLOR.chaos:
			return chaos_color

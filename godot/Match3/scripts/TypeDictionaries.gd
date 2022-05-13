extends Resource

class_name TypeDictionaries

#name of dictionary == Type of defender
#Key of dictionary == Type of attack(er)
#value of dictionary == effectiveness multiplier

enum {sun = 0, moon = 1, star = 2, order = 3, chaos = 4}

const effective = 1.5;
const not_effective = 0.5;
const medium = 1;
const very_effective = 2;

export var sun_dict = {
	sun : medium,
	moon : not_effective,
	star : effective,
	order : medium,
	chaos: medium
}
export var moon_dict = {
	sun : effective,
	moon : medium,
	star : not_effective,
	order : medium,
	chaos: medium
}
export var star_dict = {
	sun : not_effective,
	moon : effective,
	star : medium,
	order : medium,
	chaos: medium
}
export var order_dict = {
	sun : medium,
	moon : medium,
	star : medium,
	order : very_effective,
	chaos: medium
}
export var chaos_dict = {
	sun : medium,
	moon : medium,
	star : medium,
	order : medium,
	chaos: very_effective
}

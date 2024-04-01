extends Control

@onready
var party_container = $PartyContainer
@onready
var exp_container = $EXPContainer

var exp_bar = preload("res://Entities/UI/exp_bar.tscn")

var base_container_size

func _ready():
	GameManager.gain_exp.connect(get_exp)
	base_container_size = exp_container.size.x

func get_exp(received_exp):
	set_up()
	for chara in PartyManager.party:
		Characters.receive_exp(chara, received_exp, Characters.try_get_value(chara, Characters.data.LEVEL), Characters.try_get_value(chara, Characters.data.HP), Characters.try_get_value(chara, Characters.data.ATK))
	#for i in range(PartyManager.party.size()):
		#receive_exp(i, received_exp)
	EnemyManager.gathered_exp = 0

func set_up():
	PartyManager.spawn_party(party_container)
	var new_size = base_container_size + 495 * (PartyManager.party.size() -1)
	exp_container.size.x = new_size
	for hero in PartyManager.party:
		var xp_bar = exp_bar.instantiate()
		exp_container.add_child(xp_bar)
		xp_bar.init(hero)

func receive_exp(i, exp):
	var hero = PartyManager.party[i]
	await exp_container.get_child(i).set_up(hero)
	hero.receive_experience(exp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	GameManager.start_game()

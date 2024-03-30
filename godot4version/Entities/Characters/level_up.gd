extends Control

@onready
var party_container = $PartyContainer
@onready
var exp_container = $EXPContainer

var exp_bar = preload("res://Entities/UI/exp_bar.tscn")


func _ready():
	GameManager.gain_exp.connect(get_exp)

# Called when the node enters the scene tree for the first time.
func get_exp(received_exp):
	set_up()
	for i in range(PartyManager.party.size()):
		receive_exp(i, received_exp)
	EnemyManager.gathered_exp = 0
	pass # Replace with function body.

func set_up():
	for hero in PartyManager.party:
		hero.reparent(party_container)
		var xp_bar = exp_bar.instantiate()
		exp_container.add_child(xp_bar)
	pass

func receive_exp(i, exp):
	var hero = PartyManager.party[i]
	await exp_container.get_child(i).set_up(hero)
	hero.receive_experience(exp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	GameManager.start_game()

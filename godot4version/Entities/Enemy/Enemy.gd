extends Control

@export
var hp : int = 5
@export
var wait_rounds : int = 2
@export
var attack_damage : int = 10

var current_hp : int
var round_countdown : int
# Called when the node enters the scene tree for the first time.
func _ready():
	PartyManager.attack_over.connect(turn)
	current_hp = hp
	round_countdown = wait_rounds

func turn():
	round_countdown -= 1
	print("time till attack: ", round_countdown)
	if round_countdown == 0:
		attack()
	else:
		GridManager.emit_signal("round_over")

func attack():
	PartyManager.take_damage(attack_damage)
	GridManager.emit_signal("round_over")
	round_countdown = wait_rounds

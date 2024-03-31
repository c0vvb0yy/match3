extends Control

@onready
var container = $HBoxContainer
@onready
var health_bar = $HealthBar

func _ready():
	PartyManager.party_ready.connect(show_party)

func show_party():
	PartyManager.spawn_party(container)
	health_bar.set_hp()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

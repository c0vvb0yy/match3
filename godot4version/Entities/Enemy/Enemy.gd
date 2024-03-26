extends Control

@export
var color : Util.COLOR
@export
var hp : int = 5
@export
var wait_rounds : int = 2
@export
var attack_damage : int = 10

var current_hp : int
var round_countdown : int

@onready
var health_bar = $HealthBar
@onready 
var hp_label = $HealthLabel
@onready
var color_icon = $ColorIcon
# Called when the node enters the scene tree for the first time.
func _ready():
	PartyManager.attack_over.connect(turn)
	EnemyManager.take_damage.connect(take_damage)
	current_hp = hp
	round_countdown = wait_rounds
	set_up_ui()
	register_at_manager()

func set_up_ui():
	health_bar.max_value = hp
	health_bar.value = current_hp
	health_bar.modulate = Util.color_modulates[color]
	hp_label.text = str(current_hp)
	color_icon.texture = Util.piece_textures[color]

func register_at_manager():
	EnemyManager.hp = hp
	EnemyManager.color = color
	EnemyManager.enemy = self

func turn():
	round_countdown -= 1
	print("time till attack: ", round_countdown)
	if round_countdown == 0:
		attack()
	GridManager.emit_signal("round_over")

func attack():
	PartyManager.take_damage(attack_damage)
	round_countdown = wait_rounds

func take_damage(amount):
	current_hp -= amount
	if current_hp <= 0:
		current_hp = 0
		die()
	update_hp()

func update_hp():
	var tween = create_tween()
	tween.tween_property(health_bar, "value", current_hp, .4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	hp_label.text = str(current_hp)

func die():
	print("killed enemy")

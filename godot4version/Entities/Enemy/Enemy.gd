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
@onready
var countdown_label = $RoundCount
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
	countdown_label.text = str("[right]", round_countdown, " rounds until attack")

func register_at_manager():
	EnemyManager.hp = hp
	EnemyManager.color = color
	EnemyManager.enemy = self

func turn():
	round_countdown -= 1
	countdown_label.text = str("[right]", round_countdown, " rounds until attack")
	if round_countdown == 0:
		await get_tree().create_timer(0.3).timeout
		attack()
	GridManager.emit_signal("round_over")

func attack():
	var tween = create_tween()
	tween.tween_property(get_child(0), "position", Vector2(0, 0), .4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	await tween.finished
	var down_tween = create_tween()
	down_tween.tween_property(get_child(0), "position", Vector2(0, 189), .1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE)
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
	#tween.finished

func die():
	print("killed enemy")

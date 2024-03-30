extends Control

@export
var color : Util.COLOR
@export
var hp : int = 5
@export
var wait_rounds : int = 2
@export
var attack_damage : int = 10
@export
var experience : int = 5

var current_hp : int
var round_countdown : int
var is_dead := false
var total_damage :=0
var sprite_origin_pos

var damage_label = preload("res://Entities/Enemy/damage_label.tscn")
@onready
var damage_label_parent = $DamageLabelContainer
@onready
var health_bar = $HealthBar
@onready 
var hp_label = $HealthLabel
@onready
var color_icon = $ColorIcon
@onready
var countdown_label = $RoundCount
@onready
var sprite = $Sprite
# Called when the node enters the scene tree for the first time.
func _ready():
	PartyManager.attack_over.connect(turn)
	EnemyManager.take_damage.connect(prepare_damage)
	EnemyManager.damage_finished.connect(take_damage)
	current_hp = hp
	round_countdown = wait_rounds
	sprite_origin_pos = sprite.position
	set_up_ui()
	register_at_manager()
	spawn_animation()

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

func spawn_animation():
	var tween = create_tween()
	tween.tween_property(sprite, "position", Vector2(sprite_origin_pos.x, 172), .5). set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	await tween.finished
	GridManager.emit_signal("round_over")

func turn():
	if is_dead:
		GridManager.emit_signal("round_over")
		return
	round_countdown -= 1
	countdown_label.text = str("[right]", round_countdown, " rounds until attack")
	if round_countdown == 0:
		await get_tree().create_timer(1.5).timeout
		attack()
		await get_tree().create_timer(.5).timeout
	GridManager.emit_signal("round_over")

func attack():
	if is_dead:
		return
	await attack_animation()
	PartyManager.take_damage(attack_damage)
	round_countdown = wait_rounds
	countdown_label.text = str("[right]", round_countdown, " rounds until attack")

func attack_animation():
	flash_text(3)
	await get_tree().create_timer(.1).timeout
	var tween = create_tween()
	tween.tween_property(get_child(0), "position", Vector2(sprite_origin_pos.x, 0), .4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	await tween.finished
	var down_tween = create_tween()
	down_tween.tween_property(get_child(0), "position", Vector2(sprite_origin_pos.x, 189), .1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE)

func flash_text(loops:int):
	for i in range(loops + 1):
		if i % 2 == 0:
			countdown_label.modulate = Color(1,0,0)
		else:
			countdown_label.modulate = Color(1,1,1)
		await get_tree().create_timer(.1).timeout

func take_damage():
	current_hp -= total_damage
	PartyManager.attack_over.emit()
	total_damage = 0
	if current_hp <= 0:
		current_hp = 0
		die()
	update_hp()
	clean_up_damage()

func prepare_damage(init_amount, amount, attack_color):
	if is_dead:
		return
	var label = damage_label.instantiate()
	damage_label_parent.add_child(label)
	total_damage += amount
	await label.set_damage(init_amount, amount, attack_color)


func update_hp():
	var tween = create_tween()
	tween.tween_property(health_bar, "value", current_hp, .4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	hp_label.text = str(current_hp)
	await tween.finished

func die():
	GridManager.grid_state = GridManager.GRID_STATES.wait
	sprite.set_flip_v(true)
	is_dead = true
	EnemyManager.gathered_exp += experience
	print(EnemyManager.gathered_exp)
	var tween = create_tween()
	tween.tween_property(sprite, "position", Vector2(sprite_origin_pos.x, -450), 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await tween.finished
	EnemyManager.spawn_enemy()
	GridManager.grid_state = GridManager.GRID_STATES.ready
	queue_free()

func clean_up_damage():
	for label in damage_label_parent.get_children():
		label.queue_free()

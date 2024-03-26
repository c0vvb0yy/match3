extends Control


@export
var main_color : Util.COLOR
@export
var sec_color : Util.COLOR
@export
var skill_color : Util.COLOR
@export
var skill_cost : int
@export
var skill_name : String
@export
var base_hp : int
@export
var base_atk : int
@export
var hp_multiplier : float
@export
var atk_multiplier : float
@export
var level : int

var hp : int
var atk : int
var round_attack_damage : int
var experience : int

@onready
var bg = $Portrait/Background
@onready
var damage_label = $DamageLabel
@onready
var skill_texture = $Skill/Color
@onready
var skill_info = $Skill/Name

func _ready():
	PartyManager.register_match.connect(register_match)
	PartyManager.apply_combo.connect(apply_combo)
	GridManager.round_over.connect(reset)
	set_bg_color()
	set_up_skill()
	set_stats()

func _process(_delta):
	pass

func set_bg_color():
	bg.material.set_shader_parameter("color_up", Util.color_modulates[main_color])
	bg.material.set_shader_parameter("color_down", Util.color_modulates[sec_color])

func set_up_skill():
	skill_texture.texture = Util.piece_textures[skill_color]
	skill_info.text = str("[right]",skill_name," ", skill_cost)

func set_stats():
	hp = base_hp
	atk = base_atk
	PartyManager.party_hp += hp

func level_up():
	level += 1
	@warning_ignore("narrowing_conversion")
	hp = base_hp * hp_multiplier * level
	@warning_ignore("narrowing_conversion")
	atk = base_atk * atk_multiplier * level

func register_match(color, amount):
	if color != main_color and color != sec_color:
		return
	round_attack_damage += atk * amount/10 * (atk_multiplier * level)
	print(round_attack_damage)
	damage_label.target = round_attack_damage

func apply_combo(combo):
	round_attack_damage *= max(1, combo/3)
	damage_label.target = round_attack_damage
	await get_tree().create_timer(1.5).timeout
	attack()

func attack():
	await attack_animation()
	#something something....
		#emit signal?
		#EnemyManager.receive_damage(round_attack_damage)
		#EnemyManager.progress_turn
	PartyManager.register_attack(round_attack_damage, main_color, sec_color)
	#PartyManager.emit_signal("attack_over")

func attack_animation():
	var tween = create_tween()
	tween.tween_property(get_child(0), "position", Vector2(0, 80), .4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	await tween.finished
	var up_tween = create_tween()
	up_tween.tween_property(get_child(0), "position", Vector2(0, 0), .1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE)

func reset():
	round_attack_damage = 0
	damage_label.target = 0

func _on_skill_button_pressed():
	if GridManager.grid_state != GridManager.GRID_STATES.ready:
		return
	GridManager.grid_state = GridManager.GRID_STATES.wait
	if GridManager.current_pieces[skill_color] >= skill_cost:
		GridManager.emit_signal("collect_pieces", skill_color, -skill_cost)
		print("do skill")
		pass
	
	GridManager.grid_state = GridManager.GRID_STATES.ready

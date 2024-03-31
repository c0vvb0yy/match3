extends Control

##must equal the name of a stat dictionary in the Characters.gd autoload
@export
var character_name := 'default'

var hp : int
var atk : int
var round_attack_damage : int
var experience : int

var main_color : Util.COLOR
var sec_color : Util.COLOR

var skill_color : Util.COLOR
var skill_cost : int
var skill_name : String
var skill_desc : String

@onready
var bg = $Portrait/Background
@onready
var damage_label = $Portrait/DamageLabel
@onready
var skill_texture = $Portrait/SkillUI/Color
@onready
var skill_info = $Portrait/SkillUI/Name
@onready
var level_label = $Portrait/LevelBG/LevelLabel

func _ready():
	PartyManager.register_match.connect(register_match)
	PartyManager.apply_combo.connect(apply_combo)
	GridManager.round_over.connect(reset)
	Characters.level.connect(show_level_up)
	set_stats()
	set_bg_color()
	set_up_skill()
	#PartyManager.register_party_member(self)

func set_bg_color():
	bg.material.set_shader_parameter("color_up", Util.color_modulates[main_color])
	bg.material.set_shader_parameter("color_down", Util.color_modulates[sec_color])

func set_up_skill():
	skill_texture.texture = Util.piece_textures[skill_color]
	skill_info.text = str("[right]",skill_name, " ", skill_cost)

func set_stats():
	hp = Characters.try_get_value(character_name, Characters.data.HP)
	atk = Characters.try_get_value(character_name, Characters.data.ATK)
	main_color = Characters.try_get_value(character_name, Characters.data.MAINCOLOR)
	sec_color = Characters.try_get_value(character_name, Characters.data.SECCOLOR)
	skill_color = Characters.try_get_value(character_name, Characters.data.SKILL_COLOR)
	skill_cost = Characters.try_get_value(character_name, Characters.data.SKILL_COST)
	skill_name = Characters.try_get_value(character_name, Characters.data.SKILL_NAME)
	skill_desc = Characters.try_get_value(character_name, Characters.data.SKILL_DESC)
	level_label.text = str("[center]",Characters.try_get_value(character_name, Characters.data.LEVEL))

#func receive_experience(exp):
	#experience += exp
	#if experience >= experience_needed:
	#	level_up()

func show_level_up(chara):
	if chara == character_name:
		var current_level = int(level_label.text)
		current_level += 1
		level_label.text = str("[center]",current_level)

func register_match(color, amount):
	if color != main_color and color != sec_color:
		return
	round_attack_damage += atk * amount/10 
	damage_label.target = round_attack_damage

func apply_combo(combo):
	if round_attack_damage == 0:
		PartyManager.finished_party_member_count += 1
		return
	round_attack_damage *= max(1, ceil(combo/3))
	damage_label.target = round_attack_damage
	await get_tree().create_timer(1.5).timeout
	attack()

func attack():
	await attack_animation()
	#something something....
		#emit signal?
		#EnemyManager.receive_damage(round_attack_damage)
		#EnemyManager.progress_turn
	#PartyManager.emit_signal("attack_over")
	PartyManager.register_attack(round_attack_damage, main_color, sec_color)

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
		$Skill.do_skill()
		pass
	
	GridManager.grid_state = GridManager.GRID_STATES.ready

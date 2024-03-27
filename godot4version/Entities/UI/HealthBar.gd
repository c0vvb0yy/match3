extends TextureProgressBar

var prev_hp
var modulat

@onready
var label = $Amount
@onready
var dmg_label = $Damage
# Called when the node enters the scene tree for the first time.
func _ready():
	PartyManager.hp_change.connect(update_hp)
	set_hp()

func set_hp():
	self.max_value = PartyManager.party_hp
	self.value = PartyManager.party_hp
	label.text = str(PartyManager.party_hp, "/", PartyManager.party_hp)

func update_hp(new_hp:int):
	prev_hp = self.value
	var tween = create_tween()
	tween.tween_property(self, "value", new_hp, .4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	label.text = str(new_hp, "/", PartyManager.party_hp)
	if prev_hp > new_hp:
		show_damage(PartyManager.party_hp - new_hp)
	else:
		show_heal(new_hp - prev_hp)

func show_damage(amount):
	modulat = Color(1,0,0,1)
	dmg_label.modulate = modulat
	dmg_label.text = str("[center] -", amount)
	text_animation()

func show_heal(amount):
	modulat = Color(0,1,0,1)
	dmg_label.modulate = modulat
	dmg_label.text = str("[center] +", amount)
	text_animation()

func text_animation():
	dmg_label.position = Vector2(381, 0)
	var tween = create_tween()
	tween.tween_property(dmg_label, "position", Vector2(381, -60), .3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	var disappear = create_tween()
	modulat.a = 0.0
	disappear.tween_property(dmg_label, "modulate", modulat, .4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

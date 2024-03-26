extends TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	PartyManager.hp_change.connect(update_hp)
	self.max_value = PartyManager.party_hp
	self.value = PartyManager.party_hp

func update_hp(new_hp:int):
	var tween = create_tween()
	tween.tween_property(self, "value", new_hp, .4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	#self.value = new_hp

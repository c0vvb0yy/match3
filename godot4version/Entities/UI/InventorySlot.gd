extends Control

var current_amount = 0
var target_amount = 0

var max_amount = 40

@export
var own_color : Util.COLOR

@onready
var label = $Counter/Label
@onready
var heal_button = $Heal
@onready
var progress = $Counter/Amount

var button_inactive := true

var heal_textures = [
	preload("res://Assets/Sprites/UI/Inventory/small_slot.png"),
	preload("res://Assets/Sprites/UI/Inventory/small_slot_heal.png")
]

func _ready():
	GridManager.collect_pieces.connect(update_piece_count)
	progress.max_value = max_amount

func _process(delta):
	if current_amount != target_amount:
		current_amount = lerp(float(current_amount), float(target_amount), delta * 5)
		progress.value = current_amount
		label.text = str(round(current_amount))
	#if current_amount > 9 and button_inactive:
		#enable_healing(true)
	#else:
		#enable_healing(false)

func get_piece_amount(color):
	if color == own_color:
		return target_amount

func update_piece_count(color, amount):
	if color == own_color:
		target_amount += amount
		if target_amount > max_amount:
			target_amount = max_amount
		GridManager.update_current_pieces(color, target_amount)
		if target_amount > 2:
			heal_button.disabled = false
		else:
			heal_button.disabled = true

func _on_heal_pressed():
	GridManager.emit_signal("collect_pieces", own_color, -3)
	@warning_ignore("integer_division")
	var amount = (PartyManager.party_hp * 5)/100
	PartyManager.heal(amount)


func _on_heal_button_pressed():
	GridManager.emit_signal("collect_pieces", own_color, -10)
	@warning_ignore("integer_division")
	var amount = (PartyManager.party_hp * 5)/100
	PartyManager.heal(amount)


func _on_heal_button_button_down():
	GridManager.emit_signal("collect_pieces", own_color, -3)
	@warning_ignore("integer_division")
	var amount = (PartyManager.party_hp * 5)/100
	PartyManager.heal(amount)

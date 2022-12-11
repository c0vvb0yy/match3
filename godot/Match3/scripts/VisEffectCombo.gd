tool
extends TextureRect

func _ready():
	if !self.visible:
		self.visible = true

func calc_aspect_ratio():
	material.set_shader_param("aspect_ratio", rect_size.x / rect_size.y);

func _on_VisEffectCombo_item_rect_changed():
	calc_aspect_ratio();
	pass # Replace with function body.


func _on_VisEffectCombo_resized():
	calc_aspect_ratio();
	pass # Replace with function body.

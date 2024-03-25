extends RichTextLabel

var current : int
var target : int 
var prefix := "[center]"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target == 0:
		text = ""
	if current != target:
		current = lerp(int(current), int(target), delta * 10)
		scale = lerp(scale, Vector2(2,2), delta * 5) 
		text = str(prefix,round(current))
		if(current >= target-5):
			current = target
			text = str(prefix,round(current))
			await get_tree().create_timer(0.1).timeout
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2(1,1), .4)
			#scale = lerp(scale, Vector2(1,1), delta * 5)

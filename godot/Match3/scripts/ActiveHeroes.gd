extends VBoxContainer


func _ready():
	if(self.get_child_count() != 0):
		for child in self.get_children():
			child.queue_free()
	for hero in GameManager.heroes:
		var instance = hero.instance()
		self.add_child(instance);
	pass

extends HBoxContainer

const Action = preload("res://BattleAction.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey:
		if  event.pressed and event.keycode == 66: # Key B	
			var act = Action.instantiate()
			add_child(act)
			#exit.position = walker.get_end_room().position*32
			#exit.connect("leaving_level", Callable(self, "reload_level"))
			print(event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

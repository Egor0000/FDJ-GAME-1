extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event is InputEventKey:
		if event.keycode == 75:
			var TheRoot = get_node("/root")  #need this as get_node will stop work once you remove your self from the Tree
			var ThisScene = get_node("/root/Battle")

			TheRoot.remove_child(ThisScene)
			ThisScene.call_deferred("free")
			
			var NextScene = GlobalGameData.PreviousScene
			TheRoot.add_child(NextScene)

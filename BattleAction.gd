extends MarginContainer

@export var button_name = "Button"
@export var description = "ButtonDescription"
@export var button_stats = {};

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.text = button_name
	$Button.add_to_group("action_buttons")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_button_up():
	print_debug(button_stats)
	EventBus.player_actions.emit(button_stats)
	EventBus.changed_turn.emit()


func _on_button_gui_input(event):
	#if (event is InputEventMouseButton):
		#if ( event.button_index == 2 ):
			#var pos = $Popup.position
			#$Popup.set_position(Vector2(self.position.x, pos.y))
			#$Popup.popup()

	pass # Replace with function body.
